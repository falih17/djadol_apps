import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension DatetimeExt on DateTime {
  String format(String pattern, [String locale = 'id_ID']) {
    initializeDateFormatting();
    return DateFormat(pattern, locale).format(this);
  }

  String toStringDate() {
    return format('y-MM-dd');
  }
}
