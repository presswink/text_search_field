import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';

void main() {
  group('TextSearchFieldController Tests', () {
    test("should initialize with default values", () {
      final controller = TextSearchFieldController();
      expect(controller.text, "");
      expect(controller.isLoading, false);
    });

    test("should support multiple listeners", () {
      final controller = TextSearchFieldController();
      int callCount1 = 0;
      int callCount2 = 0;
      
      final model = TextSearchFieldDataModel(key: "1", value: "A");
      
      void listener1(TextSearchFieldDataModel m) => callCount1++;
      void listener2(TextSearchFieldDataModel m) => callCount2++;
      
      controller.addListener(listener1);
      controller.addListener(listener2);
      
      controller.select(model);
      
      expect(callCount1, 1);
      expect(callCount2, 1);
      
      controller.removeListener(listener1);
      controller.select(model);
      
      expect(callCount1, 1);
      expect(callCount2, 2);
    });
  });
}
