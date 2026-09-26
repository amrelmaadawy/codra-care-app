import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'adaptive_sidebar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.surfaceColor,
      elevation: 0,
      child: const AdaptiveSidebar(isDrawer: true),
    );
  }
}
