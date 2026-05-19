import 'package:text_search_field/src/text_search_field_data_model.dart';

/// A controller for [TextSearchField] to manage its text, loading state, and selection listeners.
/// 
/// This controller supports a many-to-one dependency model, allowing multiple
/// [TextSearchField] widgets to listen to a single controller.
class TextSearchFieldController {
  /// The current text in the search field.
  String text;

  /// Whether the search field is currently in a loading state.
  bool isLoading;
  
  /// Internal list of listeners notified when an item is selected.
  final List<void Function(TextSearchFieldDataModel model)> _listeners = [];

  /// Creates a [TextSearchFieldController].
  /// 
  /// [text] defaults to an empty string.
  /// [isLoading] defaults to false.
  TextSearchFieldController({this.text = "", this.isLoading = false});

  /// Adds a listener to be notified when [select] is called.
  void addListener(void Function(TextSearchFieldDataModel model) listener) {
    _listeners.add(listener);
  }

  /// Removes a previously registered listener.
  void removeListener(void Function(TextSearchFieldDataModel model) listener) {
    _listeners.remove(listener);
  }

  /// Notifies all registered listeners that a [model] has been selected.
  /// 
  /// This is typically called by the [TextSearchField] widget when a user
  /// taps a suggestion or by the developer to programmatically trigger a selection.
  void select(TextSearchFieldDataModel model) {
    for (var listener in _listeners) {
      listener(model);
    }
  }
}
