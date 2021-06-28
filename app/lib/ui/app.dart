import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_upgrade/ui/add_funds.dart';
import 'package:stripe_upgrade/ui/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class StripeUpgradeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = buildTheme();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.primaryColor,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Stripe Upgrade',
      theme: theme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: AddFundsScreen(),
    );
  }
}
