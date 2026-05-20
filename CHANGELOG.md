## 1.1.1
* **Maintenance**: Updated environment constraints (Flutter >= 3.24.0, SDK >= 3.5.0) to support modern `Color` APIs.
* **Documentation**: Updated README with "Support Platforms" section.

## 1.1.0
* **Feature**: Added support for many-to-one dependency. Multiple `TextSearchField` widgets can now depend on a single `TextSearchFieldController`.
* **Behavior Change**: When a dependency's selection changes, the dependent search field is now automatically cleared.

## 1.0.0
* **Refactor**: Restored and improved `TextSearchFieldDataModel` with `key`, `value`, and `data` fields.
* **Modernized UI**: Finalized the modern default look for both the `TextField` and the suggestion dropdown.
* **Robustness**: Complete test coverage and bug fixes for async search race conditions and positioning.
* **Breaking Changes**: Refactored parameter names for Flutter idiomatic consistency (see README Migration Guide).
* **Breaking Changes**: Removed `isPrimary` parameter from `onSelected` callback.
* **New Features**: Added search debouncing, custom loading/empty widgets, and extensive styling options.

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
