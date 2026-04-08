import 'package:flutter/widgets.dart' show Widget;
import 'package:ui_kit/common/models/emergent_model.dart';

class ModalModel<T> extends EmergentModel<T> {
  const ModalModel({
    super.buttons,
    required super.title,
    this.description,
    this.content,
  });

  final String? description;
  final Widget? content;
}
