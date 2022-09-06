import 'date.dart';
import 'date_util.dart';

class NullableValidDate extends Date {
  /// Returns a [NullableValidDate] object if parameters are valid
  /// otherwise asserts an error.
  NullableValidDate({
    final int year,
    final int month,
    final int day,
    final int hour,
    final int minute,
  })  : assert(DateUtil.isNullableValidDate(
            year: year,
            month: month,
            day: DateUtil.fixDay(
              year: year,
              month: month,
              day: day,
            ),
            hour: hour,
            minute: minute)),
        super(
            year: year,
            month: month,
            day: DateUtil.fixDay(
              year: year,
              month: month,
              day: day,
            ),
            hour: hour,
            minute: minute);
}
