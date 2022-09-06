import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';

import 'date.dart';
import 'date_format.dart';
import 'date_util.dart';
import 'nullable_valid_date.dart';
import 'valid_date.dart';

class DropdownDatePicker extends StatefulWidget {
  final DateFormat _dateFormat;
  final ValidDate _firstDate;
  final ValidDate _lastDate;
  final TextStyle _textStyle;
  final Widget _underLine;
  final MainAxisAlignment _mainAxisAlignment;

  Date _currentDate = NullableValidDate();

  /// Stores the date format how [DropdownButton] widgets should be build.
  DateFormat get dateFormat => _dateFormat;

  /// Mimimum date value that [DropdownButton] widgets can have.
  Date get firstDate => _firstDate;

  /// Maximum date value that [DropdownButton] widgets can have.
  Date get lastDate => _lastDate;

  /// Holds the currently selected date
  Date get currentDate => _currentDate;

  TextStyle get textStyle => _textStyle;
  Widget get underLine => _underLine;

  /// Returns currently selected day
  int get day {
    return _currentDate?.day;
  }

  /// Returns currently selected month
  int get month {
    return _currentDate?.month;
  }

  /// Returns currently selected year
  int get year {
    return _currentDate?.year;
  }

  int get hour {
    return _currentDate?.hour;
  }

  int get minute {
    return _currentDate?.minute;
  }

  /// Returns date as String by a [separator] (defualt: '-')
  /// based on [_dateFormat]
  String getDate([String separator = '-']) {
    String date;
    var year = _currentDate?.year;
    var month = Date.toStringWithLeadingZeroIfLengthIsOne(_currentDate?.month);
    var day = Date.toStringWithLeadingZeroIfLengthIsOne(_currentDate?.day);
    var hour = Date.toStringWithLeadingZeroIfLengthIsOne(_currentDate?.hour);
    var minute =
        Date.toStringWithLeadingZeroIfLengthIsOne(_currentDate?.minute);

    switch (_dateFormat) {
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

  /// Creates an instance of [DropdownDatePicker].
  ///
  /// [firstDate] must be smaller than [lastDate]
  ///  and [initialDate] must be in their range
  ///
  /// [initialDate] is optional, if not provided a hintText
  /// will be shown in their [DropDownButton]'s
  ///
  /// [dateFormat] is by default uses ymd format,
  ///  use [DateFormat] enum to override
  DropdownDatePicker({
    @required final ValidDate firstDate,
    @required final ValidDate lastDate,
    final Date initialDate,
    final DateFormat dateFormat = DateFormat.ymd,
    final TextStyle textStyle,
    final Widget underLine,
    final Key key,
    final MainAxisAlignment mainAxisAlignment,
  })  : _firstDate = firstDate,
        _lastDate = lastDate,
        _dateFormat = dateFormat,
        _textStyle = textStyle,
        _underLine = underLine,
        _mainAxisAlignment = mainAxisAlignment ?? MainAxisAlignment.center,
        super(key: key) {
    _currentDate = initialDate == null ? NullableValidDate() : initialDate;
    assert(
        firstDate < lastDate, 'First date must not be greater than last date.');
    assert(_isValidInitialDate(initialDate),
        'Initial date must be between first and last date.');
  }

  bool _isValidInitialDate(Date date) {
    if (date?.year == null) return true;
    if (date.year < _firstDate.year) return false;
    if (date.year > _lastDate.year) return false;
    if (date?.month == null) return true;
    if (date.month < _firstDate.month) return false;
    if (date.month > _lastDate.month) return false;
    if (date?.day == null) return true;
    if (date.day < _firstDate.day) return false;
    if (date.day > _lastDate.day) return false;

    return true;
  }

  @override
  _DropdownDatePickerState createState() => _DropdownDatePickerState();
}

class _DropdownDatePickerState extends State<DropdownDatePicker> {
  List<DropdownMenuItem<int>> _buildDropdownMenuItemList(List<int> valueList) {
    return valueList.map(_buildDropdownMenuItem).toList();
  }

  DropdownMenuItem<int> _buildDropdownMenuItem(int value) {
    return DropdownMenuItem<int>(
      value: value,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          Date.toStringWithLeadingZeroIfLengthIsOne(value),
          style: null,
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    @required final int initialValue,
    @required final String placeHolder,
    @required final Function onChanged,
    @required final List<DropdownMenuItem<int>> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MColors.pinkish_grey, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Center(
          child: DropdownButton<int>(
            underline: widget.underLine ??
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 2,
                ),
            value: initialValue,
            hint: Text(
              placeHolder, // dd, mm, yyyy
              style: widget.textStyle,
            ),
            onChanged: (val) => Function.apply(onChanged, [val]),
            items: items,
          ),
        ),
      ),
    );
  }

  Widget _buildYearDropdownButton() {
    final yearRange = [
      for (int i = widget._firstDate.year; i <= widget._lastDate.year; i++) i
    ];

    return _buildDropdownButton(
      items: _buildDropdownMenuItemList(yearRange),
      initialValue: widget._currentDate?.year,
      placeHolder: '연도',
      onChanged: (final year) => setState(
          () => widget._currentDate = widget._currentDate.copyWith(year: year)),
    );
  }

  Widget _buildMonthDropdownButton() {
    var minMonth = 1;
    var maxMonth = 12;

    if (widget._currentDate?.year != null) {
      if (widget._firstDate.year == widget._currentDate?.year) {
        minMonth = widget._firstDate.month;
        if (widget._currentDate?.month != null &&
            widget._currentDate.month < widget._firstDate.month) {
          widget._currentDate = widget._currentDate.copyWith(month: minMonth);
        }
      }
      if (widget._lastDate.year == widget._currentDate?.year) {
        maxMonth = widget._lastDate.month;
        if (widget._currentDate?.month != null &&
            widget._currentDate.month > widget._lastDate.month) {
          widget._currentDate = widget._currentDate.copyWith(month: maxMonth);
        }
      }
    } else {
      widget._currentDate =
          widget._currentDate.copyWith(month: widget._currentDate?.month);
    }
    return _buildDropdownButton(
      items: _buildDropdownMenuItemList(
          [for (int i = minMonth; i <= maxMonth; i++) i]),
      initialValue: widget._currentDate?.month,
      placeHolder: '월',
      onChanged: (final month) => setState(() =>
          widget._currentDate = widget._currentDate.copyWith(month: month)),
    );
  }

  Widget _buildDayDropdownButton() {
    var minDay = 1;
    var maxDay = 31;
    maxDay = DateUtil.getMaxDayByDate(
        month: widget._currentDate?.month, year: widget._currentDate?.year);

    if (widget._currentDate?.month != null) {
      maxDay = DateUtil.getMaxDayByDate(
          month: widget._currentDate?.month, year: widget._currentDate?.year);
      if (widget._currentDate?.year != null) {
        if (widget._firstDate.year == widget._currentDate?.year &&
            widget._firstDate.month >= widget._currentDate?.month) {
          minDay = widget._firstDate.day;
          if (widget._currentDate.day != null &&
              widget._firstDate.day >= widget._currentDate?.day) {
            widget._currentDate = widget._currentDate.copyWith(day: minDay);
          }
        }
        if (widget._lastDate.year == widget._currentDate?.year &&
            widget._lastDate.month <= widget._currentDate?.month) {
          maxDay = widget._lastDate.day;
          if (widget._currentDate.day != null &&
              widget._lastDate.day <= widget._currentDate?.day) {
            widget._currentDate = widget._currentDate.copyWith(day: maxDay);
          }
        }
      }
    }

    return _buildDropdownButton(
      items: _buildDropdownMenuItemList(
          [for (int i = minDay; i <= maxDay; i += 1) i]),
      initialValue: widget._currentDate?.day,
      placeHolder: '일',
      onChanged: (final day) => setState(
          () => widget._currentDate = widget._currentDate.copyWith(day: day)),
    );
  }

  Widget _buildHourDropdownButton() {
    final hourRange = [for (int i = 1; i <= 12; i++) i];

    return _buildDropdownButton(
      items: _buildDropdownMenuItemList(hourRange),
      initialValue: widget._currentDate?.hour,
      placeHolder: '시',
      onChanged: (final hour) => setState(
          () => widget._currentDate = widget._currentDate.copyWith(hour: hour)),
    );
  }

  Widget _buildMinuteDropdownButton() {
    final minuteRange = [for (int i = 0; i < 60; i= i+5) i];

    return _buildDropdownButton(
      items: _buildDropdownMenuItemList(minuteRange),
      initialValue: widget._currentDate?.minute,
      placeHolder: '분',
      onChanged: (final minute) => setState(() =>
          widget._currentDate = widget._currentDate.copyWith(minute: minute)),
    );
  }

  List<Widget> _buildDropdownButtonsByDateFormat() {
    final dropdownButtonList = <Widget>[];

    switch (widget._dateFormat) {
      case DateFormat.ymd:
        dropdownButtonList
          ..add(_buildYearDropdownButton())
          ..add(SizedBox(
            width: 10,
          ))
          ..add(_buildMonthDropdownButton())
          ..add(SizedBox(
            width: 10,
          ))
          ..add(_buildDayDropdownButton());
        break;
      case DateFormat.yyyy:
        dropdownButtonList..add(_buildYearDropdownButton());

        break;
      case DateFormat.mm:
        dropdownButtonList..add(_buildMonthDropdownButton());

        break;
      case DateFormat.dd:
        dropdownButtonList..add(_buildDayDropdownButton());

        break;

      case DateFormat.hh:
        dropdownButtonList..add(_buildHourDropdownButton());

        break;

      case DateFormat.min:
        dropdownButtonList..add(_buildMinuteDropdownButton());

        break;
    }
    return dropdownButtonList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget._mainAxisAlignment,
      children: _buildDropdownButtonsByDateFormat(),
    );
  }
}
