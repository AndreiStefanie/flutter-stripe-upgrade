import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:money2/money2.dart';
import 'package:stripe_upgrade/ui/app.dart';
import 'package:stripe_upgrade/locator.dart';

void main() async {
  await run(locatorInitializer: setupLocator);
}

typedef Future<void> LocatorInitializer();

Future<void> run({required LocatorInitializer locatorInitializer}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await locatorInitializer();
  await EasyLocalization.ensureInitialized();

  CommonCurrencies().registerAll();

  runApp(
    EasyLocalization(
      path: 'assets/i18n',
      supportedLocales: <Locale>[Locale('en', 'US')],
      child: StripeUpgradeApp(),
    ),
  );
}
