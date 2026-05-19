/// A data model representing an item in the [TextSearchField].
class TextSearchFieldDataModel {
  /// Unique identifier for the item.
  final String key;

  /// The text to be displayed in the suggestion list and the search field.
  final String value;

  /// Optional custom data associated with this item.
  /// 
  /// This can be used to carry extra metadata (like a full object or a Map)
  /// that can be accessed in callbacks like `onSelected`.
  final dynamic data;

  /// Creates a [TextSearchFieldDataModel].
  /// 
  /// Both [key] and [value] are required.
  TextSearchFieldDataModel({
    required this.key,
    required this.value,
    this.data,
  });

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextSearchFieldDataModel &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
