import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:stripe_upgrade/services/config.dart';
import 'package:stripe_upgrade/services/firebase/config.dart';
import 'package:stripe_upgrade/services/firebase/payments.dart';
import 'package:stripe_upgrade/services/payments.dart';

GetIt locator = GetIt.instance;

// This must match the region set in /server/functions/index.ts (more info there)
String region = 'europe-west2';

/**
 * Setup the services to use the real data
 */
Future<void> setupLocator() async {
  locator.registerLazySingleton<FirebaseFunctions>(
      () => FirebaseFunctions.instanceFor(region: region));

  return _registerServices();
}

/**
 * Setup the services to use the local emulators
 */
Future<void> setupLocalLocator() async {
  String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  await FirebaseAuth.instance.useEmulator('http://$host:9099');

  FirebaseFirestore.instance.settings = Settings(
    host: '$host:5051',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  locator.registerLazySingleton<FirebaseFunctions>(() =>
      FirebaseFunctions.instanceFor(region: region)
        ..useFunctionsEmulator(origin: 'http://$host:5001'));

  return _registerServices();
}

/**
 * Register the services with their actual implementations
 */
Future<void> _registerServices() async {
  locator.registerSingletonAsync<ConfigService>(
    () async => FirebaseConfigService()..initialize(),
  );

  locator.registerLazySingleton<PaymentsService>(
    () => FirebasePaymentsService(),
  );

  return locator.allReady();
}
