import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/provider/socialing_create_provider.dart';
import 'package:munto_app/utils/date_format.dart';
import 'package:munto_app/utils/dropdown_date_picker.dart';
import 'package:munto_app/utils/valid_date.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ScheduleDialog extends StatelessWidget {
  ScheduleDialog({
    @required locationFieldController,
    @required function,
    @required snackBarFunc,
    Key key,
  })  : _locationFieldController = locationFieldController,
        _function = function,
        _snackBarFunc = snackBarFunc,
        super(key: key);

  final TextEditingController _locationFieldController;
  final Function _function;
  final Function _snackBarFunc;

  String typeOfStartTime;
  String typeOfEndTime;
  List<String> _typeOfTime = ['오전', '오후'];

  final datePicker = new DropdownDatePicker(
    firstDate: _getFirstDate(),
    lastDate: _getLastDate(),
    dateFormat: DateFormat.ymd,
  );

  final startHourPicker = new DropdownDatePicker(
    firstDate: _getFirstDate(),
    lastDate: _getLastDate(),
    dateFormat: DateFormat.hh,
  );

  final startMinutePicker = new DropdownDatePicker(
    firstDate: _getFirstDate(),
    lastDate: _getLastDate(),
    dateFormat: DateFormat.min,

  );

  final endHourPicker = new DropdownDatePicker(
    firstDate: _getFirstDate(),
    lastDate: _getLastDate(),
    dateFormat: DateFormat.hh,
  );

  final endMinutePicker = new DropdownDatePicker(
    firstDate: _getFirstDate(),
    lastDate: _getLastDate(),
    dateFormat: DateFormat.min,
  );

  //시작날, 끝날 range 지정
  static ValidDate _getFirstDate() {
    return new ValidDate(
        year: DateTime.now().year, month: 1, day: 1, hour: 1, minute: 1);
  }

  static ValidDate _getLastDate() {
    return new ValidDate(
      year: DateTime.now().year + 2,
      month: DateTime.now().month,
      day: DateTime.now().day,
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/calendar.svg'),
                      SizedBox(height: 8),
                      Text('일정', style: MTextStyles.bold16Black),
                    ],
                  ),
                  SizedBox(height: 21),
                  Row(
                    children: [
                      datePicker,
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 35,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '시간',
                      style: MTextStyles.regular14BlackColor,
                    ),
                  ),
                  Row(
                    children: [
                      // 오전, 오후 dropdownbutton
                      getStartDropDownButton(setState),
                      SizedBox(
                        width: 10,
                      ),
                      startHourPicker,
                      SizedBox(
                        width: 10,
                      ),
                      startMinutePicker,
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      getFinishDropDownButton(setState),
                      SizedBox(
                        width: 10,
                      ),
                      endHourPicker,
                      SizedBox(
                        width: 10,
                      ),
                      endMinutePicker,
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/location_24_px.svg'),
                      SizedBox(width: 8),
                      Text(
                        '장소',
                        style: MTextStyles.bold16Black,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '상세위치',
                        style: MTextStyles.regular16Grey06,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: _locationFieldController,
                          decoration: InputDecoration(
                            hintText: "ex.합정/강남/미정 등",
                            hintStyle: MTextStyles.regular16Pinkish_grey,
                            labelStyle: TextStyle(color: Colors.transparent),
                            // border: UnderlineInputBorder(
                            //   borderSide: BorderSide.none,
                            // ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Divider(),
                  Container(
                    height: 51,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '취소',
                              style: MTextStyles.medium14WarmGrey,
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              // 시작시간, 끝시간, 장소 담아서 전달한 후에 닫기
                              summaryReturnDate(context);
                            },
                            child: Text(
                              '설정',
                              style: MTextStyles.bold14Black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getStartDropDownButton(StateSetter setState) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: MColors.pinkish_grey, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: typeOfStartTime,
            hint: Text('오전'),
            items: _typeOfTime.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                typeOfStartTime = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget getFinishDropDownButton(StateSetter setState) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: MColors.pinkish_grey, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: typeOfEndTime,
            hint: Text('오전'),
            items: _typeOfTime.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                typeOfEndTime = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  summaryReturnDate(BuildContext context) {
    int startHour = startHourPicker.hour;
    if (typeOfStartTime == '오후') startHour = startHourPicker.hour + 12;
    String startDate = datePicker.year.toString() +
        datePicker.month.toString().padLeft(2, '0') +
        datePicker.day.toString().padLeft(2, '0') +
        'T' +
        startHour.toString().padLeft(2, '0') +
        startMinutePicker.minute.toString().padLeft(2, '0');
    DateTime startDt = DateTime.parse(startDate);
    String isoStartDate = startDt.toIso8601String();
    int finishHour = endHourPicker.hour;
    if (typeOfEndTime == '오후') finishHour = endHourPicker.hour + 12;
    String finishDate = datePicker.year.toString() +
        datePicker.month.toString().padLeft(2, '0') +
        datePicker.day.toString().padLeft(2, '0') +
        'T' +
        finishHour.toString().padLeft(2, '0') +
        endMinutePicker.minute.toString().padLeft(2, '0');
    DateTime finsihDt = DateTime.parse(finishDate);
    String isoFinishDate = finsihDt.toIso8601String();

    String location = _locationFieldController.text;
    if (DateTime.parse(isoStartDate).compareTo(DateTime.parse(isoFinishDate)) ==
        1) // 시작날이 끝날보다 크면 에러 때려야함
    {
      // showAlertDialog(context, '종료 시간이 시작 시간보다 더 빠릅니다.');
      _snackBarFunc('종료 시간이 시작 시간보다 더 빠릅니다.');
    }
    // 지정 날짜가 오늘날짜보다 빠르면 에러
    else if (DateTime.now().compareTo(DateTime.parse(isoStartDate)) == 1) {
      // showAlertDialog(context, '과거 날짜를 지정하셨습니다.');

      _snackBarFunc('과거 날짜를 지정하셨습니다.');
    } else {
      _function(isoStartDate, isoFinishDate, location);
      Navigator.pop(context);
    }
  }
}
