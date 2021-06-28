import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_upgrade/locator.dart';
import 'package:stripe_upgrade/services/config.dart';
import 'package:stripe_upgrade/services/payments.dart';
import 'package:stripe_upgrade/util/money.dart';

class AddFundsScreen extends StatelessWidget {
  AddFundsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currency = locator<ConfigService>().getDefaultCurrency();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('home.addFundsTitle')),
        automaticallyImplyLeading: true,
      ),
      body: AddFunds(
        minAmount: MoneyHelper.convertToMoney(
          locator<ConfigService>().getMinimumTopup(currency),
          currency,
        ),
      ),
    );
  }
}

class AddFunds extends StatefulWidget {
  AddFunds({Key? key, required this.minAmount}) : super(key: key);

  final Money minAmount;

  @override
  _AddFundsState createState() => _AddFundsState(
        currencyCode: minAmount.currency.code,
      );
}

class _AddFundsState extends State<AddFunds> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _enableButton = false;
  bool _isPaymentProcessing = false;
  bool _paymentSuccessful = false;

  final String currencyCode;

  _AddFundsState({required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              padding: EdgeInsets.only(top: 20),
              width: 200,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.caption,
                    suffixText: currencyCode,
                  ),
                  enabled: true,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.characters,
                  style: Theme.of(context).textTheme.headline2,
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      if (_enableButton == true) {
                        _setButtonState(false);
                      }
                      return null;
                    }

                    try {
                      double.parse(value);
                    } catch (e) {
                      if (_enableButton == true) {
                        _setButtonState(false);
                      }
                      return tr('wallet.onlyNumbers');
                    }

                    Money money = MoneyHelper.convertUserInput(
                      value,
                      currencyCode,
                    );

                    if (widget.minAmount.compareTo(money) > 0) {
                      if (_enableButton == true) {
                        _setButtonState(false);
                      }
                      return tr(
                        'wallet.minimum',
                        args: [widget.minAmount.toString(), 'RON'],
                      );
                    }

                    if (_enableButton == false) {
                      _setButtonState(true);
                    }

                    return null;
                  },
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Powered by',
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/icons/stripe.png',
                height: 70,
                width: 70,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              width: 300,
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                minWidth: 300,
                height: 50,
                child: _buildFundsButtonChild(),
                onPressed: _enableButton ? () => _addFunds() : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _addFunds() async {
    final stripeInfo = await locator<ConfigService>().getStripeInfo();
    print(stripeInfo.accountId);
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: stripeInfo.apiKey,
        androidPayMode: stripeInfo.payMode,
        merchantId: stripeInfo.merchantId,
      ),
    );

    setState(() {
      _isPaymentProcessing = true;
    });

    Money money = MoneyHelper.convertUserInput(
      _amountController.text,
      currencyCode,
    );

    bool nativePayment =
        (await StripePayment.canMakeNativePayPayments([])) == true;

    try {
      PaymentMethod paymentMethod;
      if (nativePayment) {
        final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest(
            currencyCode: currencyCode,
            totalPrice: _amountController.text,
            lineItems: [
              LineItem(description: tr('wallet.topupFunds')),
            ],
          ),
          applePayOptions: ApplePayPaymentOptions(
            countryCode: 'RO',
            currencyCode: currencyCode,
            items: [
              ApplePayItem(
                label: tr('wallet.topupFunds'),
                amount: _amountController.text,
                type: 'final',
              ),
            ],
          ),
        );

        paymentMethod = await locator<PaymentsService>().createPaymentMethod(
          token,
        );
      } else {
        paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest(),
        );
      }

      var intent = await locator<PaymentsService>().createPaymentIntent(
        money.minorUnits.toInt(),
        currencyCode,
        paymentMethod.id as String,
      );

      if (intent.status == 'requires_action') {
        final confirmResult = await StripePayment.confirmPaymentIntent(
          PaymentIntent(
            clientSecret: intent.clientSecret,
            paymentMethodId: paymentMethod.id,
          ),
        );
        intent.status = confirmResult.status as String;
      }

      if (intent.status == 'succeeded') {
        if (nativePayment) {
          await StripePayment.completeNativePayRequest();
        }

        setState(() {
          _isPaymentProcessing = false;
          _paymentSuccessful = true;
        });

        Fluttertoast.showToast(
          msg: tr('wallet.fundsAdded'),
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        if (nativePayment) {
          await StripePayment.cancelNativePayRequest();
        }

        setState(() {
          _isPaymentProcessing = false;
          _paymentSuccessful = false;
        });

        Fluttertoast.showToast(
          msg: '${tr('wallet.error')}.',
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      print(e);

      Fluttertoast.showToast(
        msg: '${tr('wallet.error')}.',
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_LONG,
      );

      if (nativePayment) {
        await StripePayment.cancelNativePayRequest();
      }

      setState(() {
        _isPaymentProcessing = false;
        _paymentSuccessful = false;
      });
    }
  }

  void _setButtonState(bool enabled) {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => setState(() {
        _enableButton = enabled;
      }),
    );
  }

  Widget _buildFundsButtonChild() {
    if (!_isPaymentProcessing && !_paymentSuccessful) {
      return Text(tr('wallet.continueToPaymentMethod').toUpperCase());
    }

    if (_isPaymentProcessing) {
      return Container(
        height: 25,
        width: 25,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: 1.0,
      child: Icon(
        Icons.check,
        size: 25,
      ),
    );
  }
}
