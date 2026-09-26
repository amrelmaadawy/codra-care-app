import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';
import 'app_dropdown_field.dart';
import 'app_dropdown_sheet.dart';

enum AppDropdownMode { bottomSheet, popupMenu }

class AppDropdown<T> extends FormField<T> {
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final Widget Function(T item)? itemLeading;
  final ValueChanged<T>? onChanged;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final bool isSearchable;
  final String? searchHint;
  final String? sheetTitle;
  final AppDropdownMode mode;

  AppDropdown({
    super.key,
    this.value,
    T? initialValue,
    required this.items,
    required this.itemLabel,
    this.itemSubtitle,
    this.itemLeading,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.isSearchable = true,
    this.searchHint,
    this.sheetTitle,
    this.mode = AppDropdownMode.bottomSheet,
    super.validator,
    super.enabled = true,
  }) : super(
          initialValue: value ?? initialValue,
          builder: (field) {
            final state = field as _AppDropdownState<T>;
            return state.buildField();
          },
        );

  @override
  FormFieldState<T> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends FormFieldState<T> {
  bool _isOpen = false;

  AppDropdown<T> get _widget => widget as AppDropdown<T>;

  T? get effectiveValue => _widget.value ?? value;

  @override
  void didUpdateWidget(AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_widget.value != oldWidget.value) {
      setValue(_widget.value);
    } else if (widget.initialValue != oldWidget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  Future<void> _handleTap(BuildContext context) async {
    if (!_widget.enabled) return;

    setState(() => _isOpen = true);

    T? selected;
    if (_widget.mode == AppDropdownMode.bottomSheet) {
      selected = await AppDropdownSheet.show<T>(
        context: context,
        title: _widget.sheetTitle ?? _widget.labelText ?? 'common.select'.tr(),
        items: _widget.items,
        selectedItem: effectiveValue,
        itemLabel: _widget.itemLabel,
        itemSubtitle: _widget.itemSubtitle,
        itemLeading: _widget.itemLeading,
        isSearchable: _widget.isSearchable,
        searchHint: _widget.searchHint,
      );
    } else {
      selected = await _showPopupMenu(context);
    }

    if (mounted) {
      setState(() => _isOpen = false);
      if (selected != null) {
        didChange(selected);
        _widget.onChanged?.call(selected);
      }
    }
  }

  Future<T?> _showPopupMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final position = box.localToGlobal(Offset.zero);
    final rect = RelativeRect.fromLTRB(
      position.dx,
      position.dy + box.size.height + 4,
      position.dx + box.size.width,
      position.dy + box.size.height + 280,
    );

    final currentVal = effectiveValue;
    return showMenu<T>(
      context: context,
      position: rect,
      elevation: 8,
      color: context.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: _widget.items.map((item) {
        final isSelected = currentVal == item;
        return PopupMenuItem<T>(
          value: item,
          child: Row(
            children: [
              if (_widget.itemLeading != null) ...[
                _widget.itemLeading!(item),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  _widget.itemLabel(item),
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? context.primaryColor : context.textPrimaryColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, color: context.primaryColor, size: 18),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildField() {
    final val = effectiveValue;
    final hasValue = val != null;
    final displayText = hasValue
        ? _widget.itemLabel(val as T)
        : (_widget.hintText ?? 'common.select'.tr());

    return AppDropdownField(
      labelText: _widget.labelText,
      displayText: displayText,
      hasValue: hasValue,
      isOpen: _isOpen,
      hasError: hasError,
      errorText: errorText,
      enabled: _widget.enabled,
      onTap: () => _handleTap(context),
      prefixIcon: _widget.prefixIcon,
      prefixWidget: _widget.prefixWidget,
    );
  }
}
