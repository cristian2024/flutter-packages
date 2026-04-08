// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ui_kit/models/button_model.dart';

abstract class EmergentModel<T> {
  final List<ButtonModel>? buttons;
  final String title;
  const EmergentModel({
    required this.title,
    this.buttons,
  });
}
