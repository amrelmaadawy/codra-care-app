import 'package:flutter/foundation.dart';

class NavigationBadgeService {
  final Map<String, ValueNotifier<int>> _notifiers = {};

  ValueNotifier<int> getNotifier(String key) {
    return _notifiers.putIfAbsent(key, () => ValueNotifier<int>(0));
  }

  void updateBadge(String key, int count) {
    final notifier = getNotifier(key);
    if (notifier.value != count) {
      notifier.value = count;
    }
  }

  int getBadge(String key) => _notifiers[key]?.value ?? 0;

  void clearBadge(String key) => updateBadge(key, 0);

  void clearAll() {
    for (final notifier in _notifiers.values) {
      notifier.value = 0;
    }
  }
}
