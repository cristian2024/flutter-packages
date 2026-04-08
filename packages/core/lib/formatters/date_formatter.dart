

import 'package:intl/intl.dart';

final _basicDateFormatter = DateFormat('dd/MM/yyyy');

extension DateFormatterExt on DateTime{
  String simpleDateFormatting(){
    return _basicDateFormatter.format(this);
  }
}