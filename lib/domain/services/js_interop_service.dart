import 'dart:js_interop';

// Define the JavaScript functions directly
@JS('window._showLocalNotification')
external void _showLocalNotification(JSString message, JSString id, [JSString? title]);

@JS('window._requestNotificationPermission')
external JSPromise _requestNotificationPermission();

@JS('window._testNotification')
external void _testNotification();

class JsInteropService {
  static Future<bool> requestNotificationPermission() async {
    try {
      final JSPromise promise = _requestNotificationPermission();
      // Convert JSPromise to Dart Future and ensure it's a boolean
      final JSAny? jsResult = await promise.toDart;
      final bool result = jsResult == true;
      return result;
    } catch (e) {
      return false;
    }
  }

  static void showLocalNotification(String message, {required String hash, String title = 'Notification'}) {
    // Call the JavaScript function with converted strings
    _showLocalNotification(message.toJS, hash.toJS, title.toJS);
  }

  static void testNotification() {
    _testNotification();
  }
}
