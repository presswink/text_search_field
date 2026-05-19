import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';

void main() {
  test("TextSearchFieldDataModel should hold values correctly", () {
    final model = TextSearchFieldDataModel(
      key: "k1",
      value: "V1",
      data: {"id": 123},
    );
    
    expect(model.key, "k1");
    expect(model.value, "V1");
    expect(model.data["id"], 123);
    expect(model.toString(), "V1");
  });
}
