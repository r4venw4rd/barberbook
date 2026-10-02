import 'package:flutter/material.dart';
import 'package:hair_dryer_app/src/core/theme/app_colors.dart';
import 'package:hair_dryer_app/src/core/theme/app_theme.dart';

class ProfileMenuTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    super.key,
    this.trailing,
    this.onTap,
    this.danger = false,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final fg = danger ? context.dangerText : null;
    return Semantics(
      selected: selected,
      child: Material(
        color: AppColors.clear,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          leading: Icon(icon, color: fg),
          title: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: fg),
          ),
          trailing: trailing ??
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
