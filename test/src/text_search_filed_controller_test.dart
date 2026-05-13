import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';

void main() {
  group('TextSearchFieldController Tests', () {
    test("should initialize with default values", () {
      final controller = TextSearchFieldController();
      expect(controller.text, "");
      expect(controller.isLoading, false);
      expect(controller.selected, isNull);
    });

    test("should initialize with provided values", () {
      final model = TextSearchFieldDataModel(key: "1", value: "A");
      TextSearchFieldDataModel? captured;
      
      final controller = TextSearchFieldController(
        text: "test",
        isLoading: true,
        selected: (m) => captured = m,
      );
      
      expect(controller.text, "test");
      expect(controller.isLoading, true);
      
      controller.selected?.call(model);
      expect(captured, model);
    });
  });
}
