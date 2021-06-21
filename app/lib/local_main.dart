import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stripe_upgrade/app.dart';
import 'package:stripe_upgrade/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocalLocator();

  // Feel free to initialize other packages or services here
  // For example, easy_localization which I highly recommend
  // https://pub.dev/packages/easy_localization
  // await EasyLocalization.ensureInitialized();

  runApp(StripeUpgradeApp());
}
