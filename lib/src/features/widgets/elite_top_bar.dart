import 'package:flutter/material.dart';

/// AppBar used across all Elite screens.
/// Mirrors the TopBar component from waslship-elite web app.
class EliteTopBar extends StatelessWidget implements PreferredSizeWidget {
  const EliteTopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showMenu = false,
    this.onBack,
    this.onMenu,
    this.actions,
  });

  final String title;
  final bool showBack;
  final bool showMenu;
  final VoidCallback? onBack;
  final VoidCallback? onMenu;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: colors.onSurface,
                size: 20,
              ),
              onPressed: onBack ?? () => Navigator.maybePop(context),
            )
          : null,
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.secondary,
        ),
      ),
      actions: [
        if (showMenu)
          IconButton(
            icon: Icon(Icons.tune_rounded, color: colors.onSurface),
            onPressed: onMenu,
          ),
        ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: colors.outlineVariant),
      ),
    );
  }
}
