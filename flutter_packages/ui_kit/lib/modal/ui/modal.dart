import 'package:flutter/material.dart';
import 'package:ui_kit/modal/model/modal_model.dart';

class ModalBody<T> extends AlertDialog {
  const ModalBody({
    super.key,
    required this.model,
  });

  final ModalModel<T> model;

  @override
  Widget build(BuildContext context) {
    final ModalModel(:description, :content) = model;
    return AlertDialog(
      title: Text(model.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null) Text(description),
          if (content != null) content,
        ],
      ),
      actions: actions,
    );
  }

  @override
  List<Widget>? get actions {
    final buttons = model.buttons;
    if (buttons == null) {
      return null;
    }
    
    return [
      ...buttons.map((button) {
        return Semantics(
          label: button.semantics,
          button: true,
          enabled: button.isEnabled,
          child: TextButton(
            onPressed: button.isEnabled ? button.onPressed : null,
            child: button.isLoading
                ? CircularProgressIndicator()
                : Text(button.label ?? ''),
          ),
        );
      }),
    ];
  }
}
