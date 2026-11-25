import 'package:flutter/material.dart';
import '../../core/extension/extension_helper.dart';
import '../../core/style/app_colors.dart';
import '../../l10n/l10n.dart';
import 'main_text.dart';
import 'main_text_field.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<DropdownItem<T>> items;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final bool isDense;
  final bool isSearchable;
  final bool showFirstItemByDefault;
  final Function(T?)? onChanged;
  final T? value;

  const CustomDropDown({
    super.key,
    required this.items,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.prefixIconConstraints,
    this.contentPadding,
    this.isDense = false,
    this.isSearchable = false,
    this.showFirstItemByDefault = false,
    this.onChanged,
    this.value,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _displayController = TextEditingController();

  bool _isDropdownOpen = false;
  bool _isFocused = false;
  OverlayEntry? _overlayEntry;
  T? _selectedValue;
  String _searchText = '';
  List<DropdownItem<T>> _filteredItems = [];
  bool _initialized = false;
  bool _keepSearchFocused = false; // إضافة متغير للحفاظ على التركيز أثناء البحث

  @override
  void initState() {
    super.initState();
    _initializeDropdown();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      if (_focusNode.hasFocus) {
        _openDropdown();
      } else {
        // تحقق من حالة التركيز على حقل البحث قبل إغلاق القائمة
        if (!_searchFocusNode.hasFocus && !_keepSearchFocused) {
          _closeDropdown();
        }
      }
    });

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _keepSearchFocused = true;
      } else {
        // تأخير صغير قبل تغيير حالة _keepSearchFocused
        // للسماح للتطبيق بالاستمرار في التركيز عند تحديث الواجهة
        Future.delayed(Duration(milliseconds: 100), () {
          if (!_searchFocusNode.hasFocus && !_focusNode.hasFocus) {
            setState(() {
              _keepSearchFocused = false;
            });
            _closeDropdown();
          }
        });
      }
    });
  }

  void _initializeDropdown() {
    // Prioritize explicit value if provided
    if (widget.value != null) {
      _selectedValue = widget.value;
      _updateDisplayText();
    }
    // Otherwise use first item if configured and items exist
    else if (widget.showFirstItemByDefault && widget.items.isNotEmpty) {
      _selectedValue = widget.items.first.value;
      // Notify parent about this initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.onChanged != null && !_initialized) {
          widget.onChanged!(_selectedValue);
          _initialized = true;
        }
      });
    }

    _filteredItems = List.from(widget.items);
    _updateDisplayText();
  }

  @override
  void didUpdateWidget(CustomDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update selection if value changed externally
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
      _updateDisplayText();
    }

    // Check if first item selection setting changed
    if (widget.showFirstItemByDefault != oldWidget.showFirstItemByDefault) {
      // Apply first item selection if it's now enabled and we don't have a selection
      if (widget.showFirstItemByDefault &&
          _selectedValue == null &&
          widget.items.isNotEmpty) {
        _selectedValue = widget.items.first.value;
        if (widget.onChanged != null) {
          widget.onChanged!(_selectedValue);
        }
        _updateDisplayText();
      }
    }

    // Update filtered items when items change
    if (widget.items != oldWidget.items) {
      _filteredItems = List.from(widget.items);
      _filterItems();

      // If first item should be selected and no current selection, update it
      if (widget.showFirstItemByDefault &&
          _selectedValue == null &&
          widget.items.isNotEmpty) {
        _selectedValue = widget.items.first.value;
        if (widget.onChanged != null) {
          widget.onChanged!(_selectedValue);
        }
        _updateDisplayText();
      }
    }
  }

  @override
  void dispose() {
    //_closeDropdown();
    _focusNode.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _displayController.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    final selectedItem = _getSelectedItem();
    final displayText = selectedItem?.label ?? '';
    _displayController.text = displayText;
  }

  void _openDropdown() {
    if (_overlayEntry != null || widget.items.isEmpty) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
            child: StatefulBuilder(
              // استخدام StatefulBuilder لتجنب إعادة بناء القائمة بالكامل
              builder: (context, setState) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: 250,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isSearchable)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainTextField(
                            controller: _searchController,
                            currentFocusNode: _searchFocusNode,
                            autofocus: widget.isSearchable,
                            hint: context.l10n.search,
                            isDense: true,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            onChanged: (value) {
                              // تحديث حالة البحث محلياً بدون إعادة بناء القائمة بالكامل
                              _searchText = value;
                              _filterItems();

                              // فقط تحديث قائمة العناصر المعروضة وليس الواجهة بالكامل
                              setState(() {});
                            },
                          ),
                        ),
                      Flexible(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final bool isSelected =
                                item.value == _selectedValue;
                            return InkWell(
                              onTap: () {
                                _selectItem(item.value);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                color: isSelected
                                    ? MyColors.primaryColor.shade100
                                    : null,
                                child: Row(
                                  children: [
                                    if (item.icon != null) ...[
                                      item.icon!,
                                      8.pw,
                                    ],
                                    Expanded(
                                      child: MainText(
                                        item.label,
                                        color: isSelected
                                            ? MyColors.primaryColor
                                            : null,
                                        fontWeight:
                                            isSelected ? FontWeight.bold : null,
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: MyColors.primaryColor,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });

    // إذا كان البحث ممكناً، ركز على حقل البحث تلقائياً
    if (widget.isSearchable) {
      // استخدام تأخير صغير لضمان ظهور الواجهة قبل التركيز
      Future.delayed(Duration(milliseconds: 50), () {
        _searchFocusNode.requestFocus();
      });
    }
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    setState(() {
      _isDropdownOpen = false;
      _keepSearchFocused = false; // إعادة تعيين متغير الحفاظ على التركيز
      _searchText = '';
      _searchController.clear();
      _filteredItems = List.from(widget.items);
    });
  }

  void _filterItems() {
    if (_searchText.isEmpty) {
      _filteredItems = List.from(widget.items);
    } else {
      _filteredItems = widget.items
          .where((item) =>
              item.label.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  void _selectItem(T? value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }

    setState(() {
      _selectedValue = value;
      _updateDisplayText();
    });

    _closeDropdown();
    _focusNode.unfocus();
    _searchFocusNode.unfocus();
  }

  // This helps rebuild the overlay when state changes
  // void _updateOverlay() {
  //   if (_isDropdownOpen) {
  //     _overlayEntry?.remove();
  //     _overlayEntry = null;
  //     _openDropdown();

  //     // إذا كان البحث ممكناً، أعد التركيز على حقل البحث
  //     if (widget.isSearchable && _keepSearchFocused) {
  //       Future.delayed(Duration(milliseconds: 50), () {
  //         _searchFocusNode.requestFocus();
  //       });
  //     }
  //   }
  // }

  // Find the selected item based on value
  DropdownItem<T>? _getSelectedItem() {
    if (_selectedValue == null) return null;

    try {
      return widget.items.firstWhere((item) => item.value == _selectedValue);
    } catch (e) {
      return null;
    }
  }

  Widget _buildSuffixIcon() {
    return InkWell(
      onTap: () {
        if (_isDropdownOpen) {
          _closeDropdown();
          _focusNode.unfocus();
          _searchFocusNode.unfocus();
          setState(() {
            _keepSearchFocused = false;
          });
        } else {
          _focusNode.requestFocus();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedValue != null )// && widget.isSearchable)
              // InkWell(
              //   onTap: () {
              //     _selectItem(null);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Icon(
              //       Icons.close,
              //       size: 16,
              //       color: AppColors.grey,
              //     ),
              //   ),
              // ),
              Icon(
                _isDropdownOpen
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: _isFocused ? MyColors.primaryColor : MyColors.grey,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (_isDropdownOpen) {
                _closeDropdown();
                _focusNode.unfocus();
                _searchFocusNode.unfocus();
                setState(() {
                  _keepSearchFocused = false;
                });
              } else {
                _focusNode.requestFocus();
              }
            },
            child: AbsorbPointer(
              child: TextField(
                focusNode: _focusNode,
                controller: _displayController,
                readOnly: true,
                decoration: InputDecoration(
                  label: widget.label != null
                      ? MainText(
                          widget.label!,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        )
                      : null,
                  helperText: widget.helperText,
                  errorText: widget.errorText,
                  prefixIconConstraints: widget.prefixIconConstraints,
                  isDense: widget.isDense,
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: widget.prefixIcon,
                        )
                      : _getSelectedItem()?.icon != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: _getSelectedItem()!.icon,
                            )
                          : null,
                  suffixIcon: _buildSuffixIcon(),
                  suffix: widget.suffix,
                  hintText: _selectedValue == null ? widget.hint : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? MyColors.error
                          : _isFocused
                              ? MyColors.primaryColor
                              : MyColors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? MyColors.error
                          : MyColors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? MyColors.error
                          : MyColors.primaryColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MyColors.error),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: MyColors.error),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Class to hold dropdown items data
class DropdownItem<T> {
  final String label;
  final T value;
  final Widget? icon;

  const DropdownItem({
    required this.label,
    required this.value,
    this.icon,
  });
}
