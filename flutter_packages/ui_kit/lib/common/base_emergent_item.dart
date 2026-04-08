import 'package:flutter/widgets.dart';
import 'package:ui_kit/common/models/emergent_model.dart';

abstract class BaseEmergentItem<T, M extends EmergentModel<T>> {
  bool get isOpen;

  Future<T?> show(BuildContext context, M model);

  Future<void> hide(BuildContext context);
}
