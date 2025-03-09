import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torii_client/torii_app.dart';
import 'package:torii_client/utils/exports.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupDependencies();

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
