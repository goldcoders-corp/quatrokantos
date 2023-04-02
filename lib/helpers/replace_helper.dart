// ignore_for_file: unnecessary_getters_setters

class ReplaceHelper {
  /// #### Use for Text and Replace
  /// #### Good for renaming files ie:
  ///
  /// ```
  ///    String folder = dotenv.env['APP_NAME']!.toLowerCase();
  ///    // Example: APP_NAME="Goldcoders App"
  ///    // ignore: unnecessary_string_escapes
  ///    final TextHelper text = TextHelper(text: folder, regex: '\\s+');
  ///    folder = text.replace();
  ///    // result: goldcoders_app
  /// ```
  ///
  ReplaceHelper({
    required String text,
    String str = '_',
    // ignore: unnecessary_string_escapes
    String regex = r"'\s+'",
  })  : _text = text,
        _str = str,
        _regex = regex;
  late final String _text;
  late final String _str;
  late final String _regex;

  String replace() {
    // ignore: prefer_single_quotes
    final pattern = RegExp(regex);

    return text.replaceAll(pattern, str);
  }

  String get text => _text;

  set text(String str) => _text = str;

  String get str => _str;

  set str(String str) => _str = str;

  String get regex => _regex;

  set regex(String str) => _regex = str;
}
