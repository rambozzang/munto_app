import 'package:flutter/material.dart';

class DateUtil {
  /// Returns `true` if [year] is leap year `false` if not.
  static bool isLeapYear(final int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Returns the number of days in a given month based on [year] and [month]
  ///
  /// [year] can be null but [month] must not be null
  static int getMaxDayByDate({@required int month, int year}) {
    if (month == 2) {
      if (year == null || isLeapYear(year)) {
        return 29;
      } else {
        return 28;
      }
    }

    if ((month == 4 || month == 6 || month == 9 || month == 11)) {
      return 30;
    }

    return 31;
  }

  /// Fix [day] if it's greater than the days in the given [month] and [year]
  ///
  /// Example: (year: 2011, month: 2, day: 29)
  /// will be fixed to (year: 2010, month: 2, day: 28)
  static int fixDay({
    final int year,
    final int month,
    final int day,
    final int hour,
    final int minute,
  }) {
    if (day == null) {
      return null;
    }

    if (month == null) {
      return day;
    } else {
      // month and day not null
      if (day >= 29 && month == 2 && year != null && isLeapYear(year)) {
        return 29;
      }
      // month and day not null
      // at this point year does not matter
      else if (day > 30 &&
          (month == 4 || month == 6 || month == 9 || month == 11)) {
        return 30;
      } else if (day > 28 && month == 2) {
        return 28;
      }
    }
    return day;
  }

  /// Checks if [year], [month] and [day] makes a valid date.
  /// Returns true if it does false if doesn't.
  static bool isValidDate(
      {int year, int month, int day, int hour, int minute}) {
    if (year == null || month == null || day == null) {
      return false;
    }

    if (month < 1 || month > 12) {
      return false;
    }
    if (day < 1 || day > 31) {
      return false;
    }

    if (hour < 1 || hour > 24) {
      return false;
    }

    if (minute < 1 || minute > 60) {
      return false;
    }

    if (month == 2) {
      if (isLeapYear(year)) {
        return (day <= 29);
      } else {
        return (day <= 28);
      }
    }

    if (month == 4 || month == 6 || month == 9 || month == 11) {
      return (day <= 30);
    }

    return true;
  }

  /// Checks if [year], [month] and [day] makes a valid date.
  /// Returns `true` if it does `false` if doesn't.
  ///
  /// Null [year], [month] or [day] are valid as well.
  static bool isNullableValidDate(
      {int year, int month, int day, int hour, int minute}) {
    if (month != null && (month < 1 || month > 12)) {
      return false;
    }

    if (day != null && (day < 1 || day > 31)) {
      return false;
    }

    if (month != null && month == 2) {
      if (year == null || isLeapYear(year)) {
        return (day == null || day <= 29);
      } else {
        return (day == null || day <= 28);
      }
    }

    if (month != null &&
        (month == 4 || month == 6 || month == 9 || month == 11)) {
      return (day == null || day <= 30);
    }

    return true;
  }
}
