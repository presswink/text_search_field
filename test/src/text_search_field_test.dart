import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';
import '../my_widget_tester.dart';

void main() {
  group('TextSearchField Basic Tests', () {
    testWidgets("should render hint text", (WidgetTester tester) async {
      await tester.pumpWidget(const MyWidgetTester(
          widget: TextSearchField(
        hint: "Search here",
      )));
      expect(find.text("Search here"), findsOneWidget);
    });

    testWidgets("should display initial value", (WidgetTester tester) async {
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        initialValue: TextSearchFieldDataModel(key: "1", value: "Initial"),
      )));
      expect(find.text("Initial"), findsOneWidget);
    });
  });

  group('TextSearchField Local Filtering', () {
    testWidgets("should show suggestions when focused", (WidgetTester tester) async {
      final items = [
        TextSearchFieldDataModel(key: "1", value: "Apple"),
        TextSearchFieldDataModel(key: "2", value: "Banana"),
      ];
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        filterItems: items,
      )));

      // Tap to focus
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.text("Apple"), findsOneWidget);
      expect(find.text("Banana"), findsOneWidget);
    });

    testWidgets("should filter items locally", (WidgetTester tester) async {
      final items = [
        TextSearchFieldDataModel(key: "1", value: "Apple"),
        TextSearchFieldDataModel(key: "2", value: "Banana"),
      ];
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        filterItems: items,
      )));

      await tester.enterText(find.byType(TextField), "Ap");
      await tester.pump(const Duration(milliseconds: 300)); // debounce
      await tester.pumpAndSettle();

      expect(find.text("Apple"), findsOneWidget);
      expect(find.text("Banana"), findsNothing);
    });

    testWidgets("should respect caseSensitive", (WidgetTester tester) async {
      final items = [
        TextSearchFieldDataModel(key: "1", value: "Apple"),
      ];
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        filterItems: items,
        caseSensitive: true,
      )));

      await tester.enterText(find.byType(TextField), "ap");
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text("Apple"), findsNothing);
    });

    testWidgets("should respect fullTextSearch", (WidgetTester tester) async {
      final items = [
        TextSearchFieldDataModel(key: "1", value: "Pineapple"),
      ];
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        filterItems: items,
        fullTextSearch: true,
      )));

      await tester.enterText(find.byType(TextField), "apple");
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text("Pineapple"), findsOneWidget);
    });
  });

  group('TextSearchField Remote Search', () {
    testWidgets("should call onSearch with debouncing", (WidgetTester tester) async {
      int searchCount = 0;
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        onSearch: (query) async {
          searchCount++;
          return [TextSearchFieldDataModel(key: "1", value: "Result for $query")];
        },
      )));

      await tester.enterText(find.byType(TextField), "a");
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), "ab");
      await tester.pump(const Duration(milliseconds: 300)); // Trigger debounce

      expect(searchCount, 1);
      await tester.pumpAndSettle();
      expect(find.text("Result for ab"), findsOneWidget);
    });
  });

  group('TextSearchField Interactions', () {
    testWidgets("should select item and call onSelected", (WidgetTester tester) async {
      TextSearchFieldDataModel? selectedItem;
      final items = [TextSearchFieldDataModel(key: "1", value: "Apple")];
      
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        filterItems: items,
        onSelected: (index, item) async {
          selectedItem = item;
        },
      )));

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Suggestions are in the overlay
      await tester.tap(find.text("Apple").last);
      await tester.pumpAndSettle();

      expect(selectedItem?.value, "Apple");
      expect(find.text("Apple"), findsOneWidget); // Value in TextField
    });

    testWidgets("should clear text when clear button is pressed", (WidgetTester tester) async {
      await tester.pumpWidget(const MyWidgetTester(
          widget: TextSearchField(
        hint: "Search",
      )));

      await tester.enterText(find.byType(TextField), "Hello");
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text("Hello"), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text("Hello"), findsNothing);
    });
  });

  group('TextSearchField Advanced Features', () {
    testWidgets("should show emptyWidget when no items found", (WidgetTester tester) async {
      await tester.pumpWidget(const MyWidgetTester(
          widget: TextSearchField(
        filterItems: [],
        emptyWidget: Text("Nothing here"),
      )));

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(find.text("Nothing here"), findsOneWidget);
    });

    testWidgets("should respect waitDependency", (WidgetTester tester) async {
      final depController = TextSearchFieldController();
      
      await tester.pumpWidget(MyWidgetTester(
          widget: TextSearchField(
        dependency: depController,
        waitDependency: true,
      )));

      TextField textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);

      depController.selected?.call(TextSearchFieldDataModel(key: "1", value: "Selected"));
      await tester.pump(); // Start async work

      // We need to wait for the dependency fetch or just the state update
      await tester.pumpAndSettle();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isTrue);
    });
  });
}
