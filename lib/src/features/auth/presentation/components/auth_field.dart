import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Labeled text field with an optional obscuring toggle.
class AuthField extends HookConsumerWidget {
  const new({
    required this.label,
    required this.controller,
    super.key,
    this.keyboardType,
    this.obscure = false,
    this.autofillHints,
  });

  /// Visible field label.
  final String label;

  /// Controller owned by the parent form.
  final TextEditingController controller;

  /// Optional keyboard type for the field.
  final TextInputType? keyboardType;

  /// Whether the field hides its content and offers a visibility toggle.
  final bool obscure;

  /// Autofill hints advertised to the platform.
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = useState(obscure);
    return TextField(
      controller: controller,
      obscureText: hidden.value,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: obscure
            ? IconButton(
                onPressed: () => hidden.value = !hidden.value,
                icon: Icon(
                  hidden.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
      ),
    );
  }
}
