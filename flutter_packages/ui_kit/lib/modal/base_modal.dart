import 'package:flutter/material.dart';
import 'package:ui_kit/common/base_emergent_item.dart';
import 'package:ui_kit/modal/model/modal_model.dart';
import 'package:ui_kit/modal/ui/modal.dart';

class BaseModal<T> extends BaseEmergentItem<T, ModalModel<T>> {
  bool _isOpen = false;

  @override
  Future<void> hide(BuildContext context) async {
    if (_isOpen) {
      Navigator.of(context).pop();
      _isOpen = false;
    }
  }

  @override
  bool get isOpen => _isOpen;

  @override
  Future<T?> show(BuildContext context, ModalModel<T> model) {
    if (_isOpen) {
      throw Exception("Modal is already open");
    }
    _isOpen = true;

    return showDialog<T>(
      context: context,
      builder: (context) => ModalBody<T>(
        model: model,
      ),
    ).then((value) {
      _isOpen = false;
      return value;
    });
  }
}
