import 'dart:ui';
import 'dart:async';

class Throttler {
  Throttler({this.durationInMillisec = 500});

  final int durationInMillisec;

  int? lastActionTime;

  void run(VoidCallback action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      if (DateTime.now().millisecondsSinceEpoch - lastActionTime! >
          durationInMillisec) {
        action();
        lastActionTime = DateTime.now().millisecondsSinceEpoch;
      }
    }
  }
}

class Debouncer {
  Debouncer({this.delayInMillisec = 500});

  final int delayInMillisec;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delayInMillisec), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
