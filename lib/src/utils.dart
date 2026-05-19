class Utils {
  /// this function is going to build and return key from [text]
  static String buildKey(String text) {
    return text.replaceAll(" ", "").toLowerCase();
  }
}
