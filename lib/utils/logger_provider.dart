import 'package:flutter/foundation.dart';
import 'package:torii_client/utils/exports.dart';

class LoggerProvider {
  /// Memory logs output, used to collect and show logs on the [DebugMenuPage]
  //Should be a singleton
  static final MemoryOutput logOutput = MemoryOutput(bufferSize: 60, secondOutput: ConsoleOutput());

  late final logger = _createLogger(output: logOutput);

  Logger _createLogger({required LogOutput output}) {
    //Errors displayed as red-colored boxed lines
    LogPrinter errorPrinter() => PrettyPrinter(
      errorMethodCount: 2,
      //Should be small enough to not mess debug log and console
      lineLength: 10,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    );
    return Logger(
      printer: HybridPrinter(
        SimplePrinter(printTime: true, colors: true),
        error: errorPrinter(),
        fatal: errorPrinter(),
      ),
      filter: _LogFilter(),
      output: output,
    );
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return event.level.index >= level!.index;
    } else {
      // for production builds show only error and wtf levels.
      return event.level.index >= Level.error.index;
    }
  }
}
