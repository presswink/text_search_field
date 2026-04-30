import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/src/Utils.dart';

void main() {
  test("buildKey method Testing ", () {
    final res = Utils.buildKey("hello Bro");
    expect(res, "hellobro");
  });
}
