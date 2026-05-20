# text_search_field

a dependency search text field package for flutter

## Support Platforms

- Android
- iOS
- Web
- macOS
- Windows
- Linux

## Getting Started

1) add below line in your `pubspec.yaml`


```cmd
text_search_field: ^1.1.1
```

2) call below given command


```cmd
flutter pub get

```


For a complete, interactive example, check out the [example/lib/main.dart](https://github.com/presswink/text_search_field/blob/main/example/lib/main.dart) file.

## Example

### 1) Simple Example

Basic usage with a local list of items.

```dart
import 'package:text_search_field/text_search_field.dart';

// ... inside your build method
TextSearchField(
  hint: "Search friends",
  filterItems: [
    TextSearchFieldDataModel(key: "1", value: "Aditya"),
    TextSearchFieldDataModel(key: "2", value: "Panther"),
    TextSearchFieldDataModel(key: "3", value: "Presswink"),
  ],
  onSelected: (index, item) async {
    print("Selected: ${item.value}");
  },
)
```

### 2) Advanced Example

Using remote search, custom styling, and a controller.

```dart
import 'package:text_search_field/text_search_field.dart';

final _controller = TextSearchFieldController();

TextSearchField(
  controller: _controller,
  hint: "Search from server...",
  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.blue),
  ),
  suggestionBackgroundColor: Colors.blueGrey[50],
  suggestionBorderRadius: BorderRadius.circular(12),
  maxSuggestionsHeight: 300,
  onSearch: (query) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return [
      TextSearchFieldDataModel(key: "res_1", value: "Result for $query"),
    ];
  },
  loadingWidget: Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  ),
  emptyWidget: Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("No results found"),
    ),
  ),
  onSelected: (index, item) async {
    print("Selected item: ${item.value}");
  },
)
```

## Parameters

| Field Name | Required | Description |
| :--- | :---: | :--- |
| `hint` | No | A string to show as a hint in the text search field. |
| `border` | No | Change the text search field border colors and style. |
| `style` | No | Change the input text style of the search field. |
| `hintStyle` | No | Change the hint text style. |
| `initialValue` | No | Add a default or initial value to the search field. |
| `filterItems` | No | A predefined list for filtering in the search field. |
| `fullTextSearch` | No | Enable full-text search on the default filter (default: `false`). |
| `textInputAction` | No | Change the keyboard input type or submit button action. |
| `onSearch` | No | Handle filtering or searching from a server or network. |
| `onQuery` | No | Add custom filter logic for the predefined `filterItems`. |
| `rippleColor` | No | Change the touch ripple color of suggestion items. |
| `onSelected` | No | Triggered when a suggestion item is touched or the field is submitted. |
| `controller` | No | Handle the search field widget programmatically. |
| `dependency` | No | Declare a dependency on another `TextSearchField`. |
| `dependencyFetch` | No | Triggered to fetch items when a dependency changes. |
| `suggestionTextStyle` | No | Change the text style of the suggestion items. |
| `suggestionItemDecoration` | No | Style the decoration of each suggestion item container. |
| `itemHeight`| No | Define the height of each suggestion item (default: `50`). |
| `suggestionTextAlignment` | No | Set the alignment of text within suggestion items. |
| `maxSuggestionsHeight` | No | Define the maximum height of the suggestion box (default: `250`). |
| `caseSensitive` | No | Enable or disable case sensitivity for the default filter (default: `false`). |
| `suggestionBackgroundColor` | No | Change the background color of the suggestion container. |
| `suggestionBorderRadius` | No | Change the suggestion container border radius. |
| `suggestionBoxShadow` | No | Change the suggestion container box shadow. |
| `emptyWidget` | No | Show custom widget when no items found. |
| `loadingWidget` | No | Show custom widget when loading items. |
| `suggestionOffset` | No | Add offset to suggestion container (default: `Offset.zero`). |
| `keyboardType` | No | Change the keyboard input type (e.g., numeric, email). |
| `debounceDuration` | No | Duration to wait before triggering `onSearch` (default: `300ms`). |
| `enabled` | No | Whether the search field is enabled (default: `true`). |
| `waitDependency` | No | Whether to disable the search field until its `dependency` is selected (default: `false`). |
| `suggestionPrefixIcon` | No | A prefix widget (usually an icon) to show before the text in each suggestion item. |
| `prefixIcon` | No | A prefix widget (usually an icon) for the search field. |
| `suffixIcon` | No | A suffix widget for the search field (defaults to a clear button). |
| `fillColor` | No | Background color for the search field (defaults to light grey). |
| `filled` | No | Whether the search field should be filled (defaults to `true`). |
| `contentPadding` | No | Padding for the search field content. |
| `showSearchIcon` | No | Whether to show the default search icon (default: `true`). |

## Migration Guide (v0.0.6+)

If you are upgrading from a version prior to **0.0.6**, please note that several parameters have been renamed for better consistency with Flutter's naming conventions.

| Old Parameter Name | New Parameter Name |
| :--- | :--- |
| `searchFieldTextStyle` | `style` |
| `searchFieldHintTextStyle` | `hintStyle` |
| `inputBorder` | `border` |
| `suggestionItemContainerHeight` | `itemHeight` |
| `suggestionContainerHeight` | `maxSuggestionsHeight` |
| `fetch` | `onSearch` |
| `query` | `onQuery` |

## demo
<img src="https://github.com/presswink/text_search_field/blob/main/screenshots/sc_1.gif" width="360" height="756" alt="SearchField screenshot">


## contributor

[@Aditya panther](https://github.com/Adityapanther/)


