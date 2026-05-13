## 1.0.0
* **Breaking Changes**: Refactored parameter names for Flutter idiomatic consistency:
    * `inputBorder` -> `border`
    * `searchFieldTextStyle` -> `style`
    * `searchFieldHintTextStyle` -> `hintStyle`
    * `suggestionItemContainerHeight` -> `itemHeight`
    * `suggestionContainerHeight` -> `maxSuggestionsHeight`
    * `fetch` -> `onSearch`
    * `query` -> `onQuery`
* **Breaking Changes**: Removed `isPrimary` parameter from `onSelected` callback.
* **UI Modernization**:
    * New default rounded and filled design for `TextField`.
    * Modernized suggestion list with subtle dividers and better typography.
    * Integrated a default search icon and a clear-all button.
* **New Features**:
    * Added search debouncing with configurable `debounceDuration`.
    * Added `enabled` and `waitDependency` properties for better field control.
    * Added `loadingWidget` and `emptyWidget` for custom search states.
    * Extensive suggestion overlay styling: `suggestionBackgroundColor`, `suggestionBorderRadius`, `suggestionBoxShadow`, `suggestionOffset`.
    * Added `suggestionPrefixIcon` to show icons in the suggestion list.
    * Added `keyboardType`, `fillColor`, `filled`, and `contentPadding` for text field customization.
* **Fixes & Improvements**:
    * Resolved race conditions in async searches using session IDs.
    * Fixed suggestion overlay positioning and white-space issues.
    * Added comprehensive test suite.
    * Improved documentation and examples.

## 0.0.6
* converted from plugins to packages
* some bug fixed

## 0.0.5
* packages upgraded

## 0.0.4
* we are sanitizing space completely

## 0.0.3
* exported Utils class
* key should be always lowercase
* is first item selected bug fixed

## 0.0.2
* null pointer exception issue fixed for dependencyFetch
* added more description & improved pub points
* case sensitive toggle field added for default filter

## 0.0.1
* predefined list search/ filter
* network search query and show suggestion
* other searchFiled dependency
* fetch content on dependency search resolved
* select item from suggestion
