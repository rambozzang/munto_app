import 'date_format.dart';
import 'nullable_valid_date.dart';

var _instanceCounter = 0;

class _Date extends Date {
  _Date({int year, int month, int day})
      : super(year: year, month: month, day: day);
}

abstract class Date {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;

  /// The [id] of this date object.
  ///
  /// It's value equals with the number of [Date] objects created.
  final int id;

  /// Base class for date objects
  Date({this.year, this.month, this.day, this.hour, this.minute})
      : id = _instanceCounter++;

  @override
  bool operator ==(other) {
    return other is Date &&
        year == other.year &&
        month == other.month &&
        day == other.day;
  }

  @override
  int get hashCode => id;

  bool _greater(Date nonNullDate, Date other) {
    if (nonNullDate.year < other.year) return true;
    if (nonNullDate.year > other.year) return false;
    if (nonNullDate.month < other.month) return true;
    if (nonNullDate.month > other.month) return false;
    if (nonNullDate.day < other.day) return true;
    return false;
  }

  bool _smaller(Date nonNullDate, Date other) {
    if (nonNullDate.year > other.year) return true;
    if (nonNullDate.year < other.year) return false;
    if (nonNullDate.month > other.month) return true;
    if (nonNullDate.month < other.month) return false;
    if (nonNullDate.day > other.day) return true;
    return false;
  }

  Date _convertDateValuesToZeroIfNull(Date date) {
    return _Date(
      year: date.year == null ? 0 : date.year,
      month: date.month == null ? 0 : date.month,
      day: date.day == null ? 0 : date.day,
    );
  }

  /// Checks if [year], [month] or [day] is null
  bool hasNull() {
    return year == null || month == null || day == null;
  }

  bool operator <=(Date other) {
    var nonNullThisDate = _convertDateValuesToZeroIfNull(this);
    var nonNullOtherDate = _convertDateValuesToZeroIfNull(other);

    if (nonNullThisDate == nonNullOtherDate) return true;
    return _greater(nonNullThisDate, nonNullOtherDate);
  }

  bool operator <(Date other) {
    var nonNullThisDate = _convertDateValuesToZeroIfNull(this);
    var nonNullOtherDate = _convertDateValuesToZeroIfNull(other);

    if (nonNullThisDate == nonNullOtherDate) return false;
    return _greater(nonNullThisDate, nonNullOtherDate);
  }

  bool operator >=(Date other) {
    var nonNullThisDate = _convertDateValuesToZeroIfNull(this);
    var nonNullOtherDate = _convertDateValuesToZeroIfNull(other);

    if (nonNullThisDate == nonNullOtherDate) return true;
    return _smaller(nonNullThisDate, nonNullOtherDate);
  }

  bool operator >(Date other) {
    var nonNullThisDate = _convertDateValuesToZeroIfNull(this);
    var nonNullOtherDate = _convertDateValuesToZeroIfNull(other);

    if (nonNullThisDate == nonNullOtherDate) return false;
    return _smaller(nonNullThisDate, nonNullOtherDate);
  }

  /// Concatenates [year], [month] and [day] by [dateFormat] with [separator]
  @override
  String toString([
    DateFormat dateFormat = DateFormat.ymd,
    String separator = '-',
  ]) {
    var day = toStringWithLeadingZeroIfLengthIsOne(this.day);
    var month = toStringWithLeadingZeroIfLengthIsOne(this.month);
    var hour = toStringWithLeadingZeroIfLengthIsOne(this.hour);
    var minute = toStringWithLeadingZeroIfLengthIsOne(this.minute);

    String date;
    switch (dateFormat) {
      case DateFormat.ymd:
        date = '$year$separator$month$separator$day';
        break;
      case DateFormat.yyyy:
        date = '$year';
        break;
      case DateFormat.mm:
        date = '$month';
        break;
      case DateFormat.dd:
        date = '$day';
        break;
      case DateFormat.hh:
        date = '$hour';
        break;
      case DateFormat.min:
        date = '$minute';
        break;
    }
    return date;
  }

  /// If [number] length is 1 add a leading 0 character at concatenation.
  ///
  /// If length is not exactly 1 return normat toString()
  static String toStringWithLeadingZeroIfLengthIsOne(int number) {
    return number.toString().length == 1
        ? '0${number.toString()}'
        : number.toString();
  }

  /// Returns a new [NullableValidDate] object with either the current values,
  /// or replacing those values with the ones passed in.
  NullableValidDate copyWith({
    final int year,
    final int month,
    final int day,
    final int hour,
    final int minute,
    final DateFormat dateFormat,
  }) {
    return NullableValidDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}
