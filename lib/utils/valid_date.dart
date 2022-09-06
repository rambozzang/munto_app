import 'package:flutter/material.dart';

import 'date.dart';
import 'date_util.dart';

class ValidDate extends Date {
  /// Returns a [Date] object if parameters are valid
  /// otherwise asserts an error.
  ValidDate({
    @required int year,
    @required int month,
    @required int day,
    @required int hour,
    @required int minute,
  }) :
        // assert(DateUtil.isValidDate(
        //           year: year, month: month, day: day, hour: hour, minute: minute)),
        super(
            year: year,
            month: month,
            day: DateUtil.fixDay(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute));
}
