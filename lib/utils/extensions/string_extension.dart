extension StringExtension on String {
  String? findFirstDelimiter() {
    RegExpMatch? regExpMatch = StringUtils.nonAlphabeticalCharactersRegexp.firstMatch(this);
    return regExpMatch?.group(0);
  }
}

// TODO: move somewhere
class StringUtils {
  static RegExp basicCharactersRegExp = RegExp('[a-zA-Z0-9 !"#\$%\'()*+,-./<>:;=?@\\[\\\\\\]^_`{|}~]');
  static RegExp nonAlphabeticalCharactersRegexp = RegExp('[^a-zA-Z]+');
  static RegExp irKeyRegExp = RegExp('[a-zA-Z0-9_]');
  static RegExp irValueRegExp = RegExp(r'(\p{Alpha})|([0-9 \n\t\s!"#$%()*+,\-./<>:;=?@[\]^_{|\}~`])', unicode: true);
  static RegExp irUsernameRegExp = RegExp('[a-zA-Z0-9_ ]');
  static RegExp hexadecimalRegExp = RegExp('[a-fA-F0-9]');
  static RegExp whitespacesRegExp = RegExp(r'\s');

  static String? findFirstDelimiter(String text) {
    RegExpMatch? regExpMatch = nonAlphabeticalCharactersRegexp.firstMatch(text);
    return regExpMatch?.group(0);
  }

  static String parseUnicodeToString(String text) {
    String parsedText = text.replaceAllMapped(RegExp(r'\\u[0-9a-fA-F]{4}'), (Match match) {
      final String hex = match.group(0)!.replaceAll(r'\u', '');
      final int code = int.parse(hex, radix: 16);
      return String.fromCharCode(code);
    });
    return parsedText;
  }

  static bool compareStrings(String text, String pattern) {
    String formattedText = _unifyString(text);
    String formattedPattern = _unifyString(pattern);

    return _containsPattern(formattedText, formattedPattern);
  }

  static String _unifyString(String text) {
    return _removeDiacritics(text.toLowerCase()).replaceAll(' ', '');
  }

  static bool _containsPattern(String text, String pattern) {
    return text.contains(RegExp(pattern, caseSensitive: false));
  }

  static String _removeDiacritics(String text) {
    String actualText = text;
    String withDia =
        'ĀĄÀÁÂÃÄÅàáâãäåāąÇĆČçćčĎĐÐđďÈÉÊËĚĒĘèéêëěēęðÌÍÎÏĪìíîïīŁłŇŃÑñňńÒÓÔÕÕÖØŌòóôõöøōŘřŠŚšśŤťŮŪÙÚÛÜùúûüůūŸÝÿýŽŻŹžżź';
    String withoutDia =
        'AAAAAAAAaaaaaaaaCCCcccDDDddEEEEEEEeeeeeeeeIIIIIiiiiiLlNNNnnnOOOOOOOOoooooooRrSSssTtUUUUUUuuuuuuYYyyZZZzzz';

    for (int i = 0; i < withDia.length; i++) {
      actualText = actualText.replaceAll(withDia[i], withoutDia[i]);
    }

    return actualText;
  }
}
