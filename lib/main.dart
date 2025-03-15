import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:torii_client/torii_app.dart';
import 'package:torii_client/utils/exports.dart';

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
