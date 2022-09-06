import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:munto_app/model/provider/socialing_create_provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/utils/date_format.dart';
import 'package:munto_app/utils/dropdown_date_picker.dart';
import 'package:munto_app/utils/valid_date.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ScheduleDialog2 extends StatelessWidget {
  ScheduleDialog2({
    @required locationFieldController,
    @required function,
    @required snackBarFunc,
    Key key,
    DateTime selectedDate,
  })  : _locationFieldController = locationFieldController,
        _function = function,
        _snackBarFunc = snackBarFunc,
        selectedDate = selectedDate,
        selectedTime = selectedDate,
        super(key: key);

  final TextEditingController _locationFieldController;
  final Function _function;
  final Function _snackBarFunc;


  String typeOfStartTime;
  String typeOfEndTime;
  List<String> _typeOfTime = ['오전', '오후'];

  DateTime selectedDate;
  DateTime selectedTime;

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
              left: 24.0, right: 24.0
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
                  Container(
                      width: double.infinity,
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
                          color: Colors.white
                      ),
                      child:GestureDetector(
                        onTap: () async {
                          // showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime(2000),
                          //   lastDate: DateTime(2025),
                          //
                          // );
                          final initialDate = DateTime.now().add(Duration(days: 3));
                          final lastDate = DateTime.now().add(Duration(days: 365));
                          final format = intl.DateFormat.MMMMEEEEd();
                          selectedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: initialDate,
                            lastDate: lastDate,
                            // locale: Locale.fromSubtags(''),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: MColors.blackColor,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: MColors.blackColor,
                                  ),
                                  dialogBackgroundColor:Colors.white,
                                ),
                                child: child,
                              );
                            },

                          );
                          setState((){});
                        },
                        child: Row(children: [
                          Expanded(child: // 날짜를 선택해주세요
                          Text(selectedDate == null ? "날짜를 선택해주세요" : getFormattedDate(selectedDate),
                              style: selectedDate == null ? MTextStyles.regular14WarmGrey : MTextStyles.bold14Grey06)),
                          Icon(Icons.keyboard_arrow_down_sharp)
                        ],),
                      )
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
                  Container(
                      width: double.infinity,
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
                          color: Colors.white
                      ),
                      child:GestureDetector(
                        onTap: () async {
                          if(selectedTime == null)
                            selectedTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, (DateTime.now().hour+1), 0);
                          await showDialog(context: context, builder: (context){
                            return
                              Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 150.0),
                                  child: Container(
                                  width: 300,height: 400,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
                                      color: Colors.white
                                  ),
                                  child:Column(children: [
                                    Expanded(
                                      child: CupertinoDatePicker(
                                        minuteInterval: 10,
                                        initialDateTime: selectedTime,
                                        maximumDate: DateTime.now().add(Duration(days: 1)),
                                        onDateTimeChanged: (time){
                                          selectedTime = time;
                                          print('selectedTime = ${getFormattedTime(selectedTime)}');
                                        },
                                        mode: CupertinoDatePickerMode.time,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        print('onTap()');
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(width: double.infinity, height: 40,
                                        child: Center(child: Text('설정',style: MTextStyles.bold14Black,),),
                                      ),
                                    )
                                  ],)
                                    ,
                            ),
                                ),
                              );
                          });

                          setState((){});
                        },
                        child: Row(children: [
                          Expanded(child: // 날짜를 선택해주세요
                          Text(selectedTime == null ? "시간을 선택해주세요" : getFormattedTime(selectedTime),
                              style: selectedTime == null ? MTextStyles.regular14WarmGrey : MTextStyles.bold14Grey06)),
                          Icon(Icons.keyboard_arrow_down_sharp)
                        ],),
                      )
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
    if(selectedDate == null){
      _snackBarFunc('날짜를 선택해 주세요.');
      return;
    }
    if(selectedTime == null){
      _snackBarFunc('시간을 선택해 주세요.');
      return;
    }

    int startHour = startHourPicker.hour;
    if (typeOfStartTime == '오후') startHour = startHourPicker.hour + 12;

    DateTime startDt = selectedDate.add(Duration(hours: selectedTime.hour, minutes: selectedTime.minute));

    String isoStartDate = startDt.toIso8601String();
    String location = _locationFieldController.text;

    _function(isoStartDate, location);
    Navigator.pop(context);

  }

  String getFormattedDate(DateTime selectedDate) {
    if(selectedDate != null){
      return '${selectedDate.month}.${selectedDate.day}(${Util.getWeekDay(intl.DateFormat('EEEE').format(selectedDate))})' ;
    }
    return '';
  }

  String getFormattedTime(DateTime selectedTime) {
    int time = selectedTime.hour == 12 ? 12 :selectedTime.hour%12;
    if(selectedTime != null){
      return '${Util.getTypeOfTime(selectedTime)}${time}시 ${selectedTime.minute}분' ;
    }
    return '';
  }
}
