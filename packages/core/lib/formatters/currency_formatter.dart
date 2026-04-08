import 'package:intl/intl.dart';

final _formatCurrency =  NumberFormat.simpleCurrency(decimalDigits: 0);


extension CurrencyFormatterExt on num{
  String simpleCurrencyFormatting(){
    return _formatCurrency.format(this);
  }
}
