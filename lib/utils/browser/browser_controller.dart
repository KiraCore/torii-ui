import 'package:web/web.dart';

class BrowserController {
  static void replaceUrl(Uri newUrl) {
    String decodedUri = Uri.decodeComponent(newUrl.toString());
    window.history.replaceState(null, '', decodedUri);
  }

  static void openUrl(String url) {
    window.open(url, 'new tab');
  }
}
