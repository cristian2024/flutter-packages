import 'package:flutter/material.dart';
import 'package:ui_kit/models/button_model.dart';

class BasicButton extends StatelessWidget {
  const BasicButton({
    super.key,
    this.semantics,
    this.label,
    this.onPressed,
    this.isEnabled = true,
    required this.isLoading,
  });

  final String? semantics;
  final String? label;
  final bool isEnabled;
  final bool isLoading;

  factory BasicButton.fromModel(ButtonModel buttonModel) {
    final ButtonModel(
      :onPressed,
      :isLoading,
      :isEnabled,
      :label,
      :semantics,
    ) = buttonModel;
    return BasicButton(
      isEnabled: isEnabled,
      isLoading: isLoading,
      onPressed: onPressed,
      label: label,
      semantics: semantics,
    );
  }

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: isLoading ? CircularProgressIndicator() : Text(label ?? ' '),
    );
  }
}
