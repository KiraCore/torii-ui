import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:torii_client/torii_app.dart';
import 'package:torii_client/utils/exports.dart';

const kiraEthEnabled = bool.fromEnvironment('KIRA_ETH_ENABLED', defaultValue: false);
const isTestEnv = bool.fromEnvironment('IS_TEST_ENVIRONMENT', defaultValue: false);

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupDependencies();

      usePathUrlStrategy();

      runApp(const ToriiApp());
    },
    (final error, final stackTrace) {
      getIt<Logger>().e(error, stackTrace: stackTrace);
    },
  );
}

Future<void> setupDependencies({bool resetFirstly = false}) async {
  await setupLocators();
}
