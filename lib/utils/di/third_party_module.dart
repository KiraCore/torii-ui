import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torii_client/utils/exports.dart';
import 'package:torii_client/utils/logger_provider.dart';

/// For generating third-party dependencies only
@module
abstract class ThirdPartyModule {
  final loggerProvider = LoggerProvider();

  Logger getLogger(LoggerProvider provider) => provider.logger;

  @preResolve
  Future<SharedPreferences> getSharedPrefs() async => SharedPreferences.getInstance();
}
