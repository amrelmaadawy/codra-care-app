import 'package:flutter/material.dart';

class AppShellScope extends InheritedWidget {
  final VoidCallback openDrawer;

  const AppShellScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  static AppShellScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope oldWidget) => false;
}
