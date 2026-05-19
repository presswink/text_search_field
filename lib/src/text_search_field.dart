import 'dart:async';
import 'package:flutter/material.dart';
import 'package:text_search_field/src/text_search_field_controller.dart';
import 'package:text_search_field/src/text_search_field_data_model.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'global_key.dart';

/// A search field widget for searching or filtering items from a list, server, or network.
///
/// Features include custom styling, remote searching with debouncing, dependency handling,
/// and customizable suggestion overlays.
class TextSearchField extends StatefulWidget {
  /// Hint text to show in the search field.
  final String? hint;

  /// Border decoration for the search field. Defaults to [OutlineInputBorder].
  final InputBorder? border;

  /// Input text style.
  final TextStyle? style;

  /// Hint text style.
  final TextStyle? hintStyle;

  /// Initial value to be displayed in the search field.
  final TextSearchFieldDataModel? initialValue;

  /// A predefined list of items to filter locally.
  final List<TextSearchFieldDataModel>? filterItems;

  /// Whether to perform a full-text search (contains) or prefix-only search.
  final bool fullTextSearch;

  /// The keyboard submit button action.
  final TextInputAction? textInputAction;

  /// Callback for remote searching. Triggers as the user types (with debouncing).
  final Future<List<TextSearchFieldDataModel>?> Function(String query)? onSearch;

  /// Custom filtering logic for the [filterItems] list.
  final List<TextSearchFieldDataModel>? Function(
      List<TextSearchFieldDataModel>? filterItems, String query)? onQuery;

  /// Color of the ripple effect when a suggestion is tapped.
  final Color? rippleColor;

  /// Callback triggered when a suggestion is selected.
  final Future<void> Function(int index, TextSearchFieldDataModel selectedItem)?
      onSelected;

  /// Controller to handle the search field programmatically.
  final TextSearchFieldController? controller;

  /// Dependency on another [TextSearchFieldController].
  final TextSearchFieldController? dependency;

  /// Logic to fetch new items when the [dependency] value changes.
  final Future<List<TextSearchFieldDataModel>> Function(
      TextSearchFieldDataModel modelItem)? dependencyFetch;

  /// Text style for items in the suggestion list.
  final TextStyle? suggestionTextStyle;

  /// Decoration for the individual suggestion item container.
  final BoxDecoration? suggestionItemDecoration;

  /// Height of each individual suggestion item.
  final double itemHeight;

  /// Alignment of text within suggestion items.
  final Alignment? suggestionTextAlignment;

  /// Maximum height of the suggestion overlay box.
  final double maxSuggestionsHeight;

  /// Whether the default local filtering is case-sensitive.
  final bool caseSensitive;

  /// Background color of the suggestion overlay.
  final Color? suggestionBackgroundColor;

  /// Border radius of the suggestion overlay.
  final BorderRadius? suggestionBorderRadius;

  /// Shadow for the suggestion overlay.
  final List<BoxShadow>? suggestionBoxShadow;

  /// Widget to display when no items match the query.
  final Widget? emptyWidget;

  /// Widget to display while [onSearch] is fetching data.
  final Widget? loadingWidget;

  /// Offset to adjust the position of the suggestion overlay.
  final Offset suggestionOffset;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// Duration to wait before triggering [onSearch] after user stops typing.
  final Duration debounceDuration;

  /// Whether the search field is enabled.
  final bool enabled;

  /// Whether to disable the search field until a value is selected in its [dependency].
  final bool waitDependency;

  /// A prefix widget (usually an icon) to show before the text in each suggestion item.
  final Widget? suggestionPrefixIcon;

  /// A prefix widget for the search field.
  final Widget? prefixIcon;

  /// A suffix widget for the search field.
  final Widget? suffixIcon;

  /// Background color for the search field.
  final Color? fillColor;

  /// Whether the search field should be filled.
  final bool? filled;

  /// Padding for the search field content.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether to show the default search icon when [prefixIcon] is null.
  final bool showSearchIcon;

  const TextSearchField({
    super.key,
    this.hint,
    this.border,
    this.hintStyle,
    this.initialValue,
    this.filterItems,
    this.onSearch,
    this.onQuery,
    this.fullTextSearch = false,
    this.rippleColor,
    this.onSelected,
    this.controller,
    this.dependency,
    this.textInputAction,
    this.dependencyFetch,
    this.style,
    this.suggestionTextStyle,
    this.suggestionItemDecoration,
    this.itemHeight = 50,
    this.suggestionTextAlignment,
    this.maxSuggestionsHeight = 250,
    this.caseSensitive = false,
    this.suggestionBackgroundColor,
    this.suggestionBorderRadius,
    this.suggestionBoxShadow,
    this.emptyWidget,
    this.loadingWidget,
    this.suggestionOffset = Offset.zero,
    this.keyboardType,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.enabled = true,
    this.waitDependency = false,
    this.suggestionPrefixIcon,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.filled,
    this.contentPadding,
    this.showSearchIcon = true,
  });

  @override
  State<TextSearchField> createState() => _TextSearchFieldState();
}

class _TextSearchFieldState extends State<TextSearchField> {
  late FocusNode _focusNode;
  bool _isLoading = false;
  bool _isDependencySelected = false;
  List<TextSearchFieldDataModel>? _items;

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  final _textController = TextEditingController();
  final _globalKey = GlobalKey();
  final _scrollController = ScrollController();

  Timer? _debounce;
  int _searchSessionId = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _items = widget.filterItems;

    if (widget.initialValue != null) {
      _isDependencySelected = true;
      setCurrentValue(widget.initialValue!);
    }

    _focusNode.addListener(_onFocusChanged);
    _setupDependencyListener();
  }

  @override
  void didUpdateWidget(covariant TextSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependency != widget.dependency) {
      oldWidget.dependency?.removeListener(_onDependencySelected);
      _setupDependencyListener();
    }
    if (oldWidget.filterItems != widget.filterItems &&
        _textController.text.isEmpty) {
      _items = widget.filterItems;
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _overlayPortalController.show();
    } else {
      _overlayPortalController.hide();
    }
  }

  void _onDependencySelected(TextSearchFieldDataModel item) async {
    if (!mounted) return;

    // Clear current selection and text when dependency changes
    setState(() {
      _textController.clear();
      _items = [];
      _isDependencySelected = true;
      _isLoading = true;
    });

    try {
      if (widget.dependencyFetch != null) {
        final newItems = await widget.dependencyFetch!(item);
        if (mounted) {
          setState(() {
            _items = newItems;
          });
        }
      }
    } catch (e) {
      debugPrint("TextSearchField: Error in dependencyFetch: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setupDependencyListener() {
    widget.dependency?.addListener(_onDependencySelected);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    widget.dependency?.removeListener(_onDependencySelected);
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void setCurrentValue(TextSearchFieldDataModel value) {
    _textController.text = value.value;
    widget.controller?.select(value);
  }

  Future<void> _onSearchChanged(String value) async {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () async {
      final sessionId = ++_searchSessionId;

      setState(() {
        _isLoading = true;
      });

      try {
        List<TextSearchFieldDataModel>? results;

        if (widget.onSearch != null) {
          results = await widget.onSearch!(value);
        } else if (widget.onQuery != null) {
          results = widget.onQuery!(widget.filterItems, value);
        } else {
          if (value.isEmpty) {
            results = widget.filterItems;
          } else {
            results = widget.filterItems?.where((element) {
              final itemValue = element.value;
              final val =
                  widget.caseSensitive ? itemValue : itemValue.toLowerCase();
              final search = widget.caseSensitive ? value : value.toLowerCase();

              return widget.fullTextSearch
                  ? val.contains(search)
                  : val.startsWith(search);
            }).toList();
          }
        }

        // Only update if this is still the most recent search session
        if (mounted && sessionId == _searchSessionId) {
          setState(() {
            _items = results;
          });
        }
      } catch (e) {
        debugPrint("TextSearchField: Error during search: $e");
      } finally {
        if (mounted && sessionId == _searchSessionId) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: _buildOverlayContent,
      child: TextField(
        key: _globalKey,
        controller: _textController,
        focusNode: _focusNode,
        enabled: widget.enabled &&
            (!widget.waitDependency ||
                widget.dependency == null ||
                _isDependencySelected),
        style: widget.style ??
            const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: Colors.grey.withValues(alpha: 0.6),
                fontSize: 16,
              ),
          prefixIcon: widget.prefixIcon ??
              (widget.showSearchIcon
                  ? const Icon(Icons.search, color: Colors.grey, size: 22)
                  : null),
          suffixIcon: widget.suffixIcon ??
              (_textController.text.isNotEmpty
                  ? IconButton(
                      icon:
                          const Icon(Icons.clear, color: Colors.grey, size: 20),
                      onPressed: () {
                        _textController.clear();
                        _onSearchChanged("");
                      },
                    )
                  : null),
          filled: widget.filled ?? true,
          fillColor: widget.fillColor ?? Colors.grey.withValues(alpha: 0.1),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
          focusedBorder: widget.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    final borderRadius = widget.suggestionBorderRadius ??
        const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        );

    final bounds = _globalKey.globalPaintBounds;
    if (bounds == null) return const SizedBox.shrink();

    return Positioned(
      width: bounds.width,
      top: bounds.bottom + widget.suggestionOffset.dy,
      left: bounds.left + widget.suggestionOffset.dx,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.maxSuggestionsHeight),
        decoration: BoxDecoration(
          color: widget.suggestionBackgroundColor ?? Colors.white,
          borderRadius: borderRadius,
          boxShadow: widget.suggestionBoxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                )
              ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: _buildSuggestionList(),
        ),
      ),
    );
  }

  Widget _buildSuggestionList() {
    if (_isLoading) {
      return widget.loadingWidget ??
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
    }

    if (_items == null || _items!.isEmpty) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _items!.length,
        itemBuilder: (context, index) {
          final item = _items![index];
          return _buildSuggestionItem(item, index);
        },
      ),
    );
  }

  Widget _buildSuggestionItem(TextSearchFieldDataModel item, int index) {
    return TouchRippleEffect(
      rippleColor: widget.rippleColor ?? Colors.grey.withValues(alpha: 0.1),
      onTap: () {
        _focusNode.unfocus();
        setCurrentValue(item);
        widget.onSelected?.call(
          index,
          item,
        );
      },
      child: Container(
        key: ValueKey(item.key),
        alignment: widget.suggestionTextAlignment ?? Alignment.centerLeft,
        height: widget.itemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: widget.suggestionItemDecoration ??
            BoxDecoration(
              color: widget.suggestionBackgroundColor ?? Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
        child: Row(
          children: [
            if (widget.suggestionPrefixIcon != null) ...[
              widget.suggestionPrefixIcon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.value,
                style: widget.suggestionTextStyle ??
                    const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
