extension StringExtension on String {
  String? findFirstDelimiter() {
    RegExpMatch? regExpMatch = StringRegExp.nonAlphabeticalCharacters.firstMatch(this);
    return regExpMatch?.group(0);
  } 

  String toShortenedAddress() {
    return '${substring(0, 8)}...${substring(length - 6)}';
  }
}

class StringRegExp {
  static RegExp basicCharacters = RegExp('[a-zA-Z0-9 !"#\$%\'()*+,-./<>:;=?@\\[\\\\\\]^_`{|}~]');
  static RegExp nonAlphabeticalCharacters = RegExp('[^a-zA-Z]+');
  static RegExp irKey = RegExp('[a-zA-Z0-9_]');
  static RegExp irValue = RegExp(r'(\p{Alpha})|([0-9 \n\t\s!"#$%()*+,\-./<>:;=?@[\]^_{|\}~`])', unicode: true);
  static RegExp irUsername = RegExp('[a-zA-Z0-9_ ]');
  static RegExp hexadecimal = RegExp('[a-fA-F0-9]');
  static RegExp whitespaces = RegExp(r'\s');
}
