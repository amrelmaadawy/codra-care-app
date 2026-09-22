import 'package:easy_localization/easy_localization.dart';

extension SafeTrExtension on String {
  /// Returns the translated string if [this] is a valid localization key.
  /// If [this] is already localized (contains spaces, Arabic characters, newlines)
  /// or does not look like a key, returns [this] directly without calling `tr()`,
  /// preventing Easy Localization "key not found" console warnings.
  String trOrSelf() {
    final lower = toLowerCase().trim();
    if (lower.contains('this action is unauthorized') || lower == 'unauthorized' || lower == 'forbidden') {
      return tr('errors.forbidden');
    }
    if (isEmpty ||
        contains(' ') ||
        contains('\n') ||
        contains(':') ||
        contains('[') ||
        contains(']') ||
        RegExp(r'[\u0600-\u06FF]').hasMatch(this)) {
      return this;
    }
    final isKeyLike = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)*$').hasMatch(this);
    if (!isKeyLike) return this;
    return tr(this);
  }
}
