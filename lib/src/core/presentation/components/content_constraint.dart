import 'package:barberbook/src/core/theme/breakpoints.dart';
import 'package:flutter/material.dart';

class ContentConstraint extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Breakpoints.contentMaxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
