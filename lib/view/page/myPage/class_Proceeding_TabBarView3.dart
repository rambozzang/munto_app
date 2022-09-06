import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:munto_app/model/class_Proceeding_Attendee_data.dart';
import 'package:munto_app/model/class_Proceeding_Rounds_Data.dart';
import 'package:munto_app/model/class_Proceeding_State_Data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassProceedingTabBarView3 extends StatefulWidget {
  @override
  _ClassProceedingTabBarView3State createState() => _ClassProceedingTabBarView3State();
}

class _ClassProceedingTabBarView3State extends State<ClassProceedingTabBarView3> {
  ClassProvider classService = ClassProvider();

  ItemProvider itemProvider = ItemProvider();
  ClassProceedingAttendeeData classProceedingAttendeeData;
  List<ClassProceedingRoundsData> classProceedingRoundsList;
  ClassProceedingStateData classProceedingStateData;

  List<Applicant> followingList = [];
  List list = meetingGroupAll[0].applicantList;

  final StreamController<Response<dynamic>> _attendListCtrl = StreamController();
  final StreamController<Response<List<dynamic>>> _roundListCtrl = StreamController();
  final StreamController<Response<List<dynamic>>> _saveAttendCtrl = StreamController();
  final StreamController<Response<ClassProceedingStateData>> _stateDataCtrl = StreamController();

  List<String> _typeOfMeetingList = [
    '[1회차] 2020.03.12(수) 오후18시 합정',
    '[2회차] 2020.07.22(수) 오후19시 시청',
    '[3회차] 2020.08.12(수) 오후21시 홍대'
  ];

  int _value = 1;
  String _selectedValue = "[1회차] 2020.03.12(수) 오후20시 합정";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    _stateDataCtrl.sink.add(Response.loading());
    _roundListCtrl.sink.add(Response.loading());
    _attendListCtrl.sink.add(Response.loading());
    _attendListCtrl.sink.add(Response.loading());
    // 출석 정보 가져오기
    try {
      classProceedingStateData = await itemProvider.getItemStats('item' , '1508');
      _stateDataCtrl.sink.add(Response.completed(classProceedingStateData));
    } catch (e) {
      _stateDataCtrl.sink.add(Response.error(e.toString()));
    }
    // 회차 가져오기
    try {
      classProceedingRoundsList = await itemProvider.getItemRounds('1505');
      _roundListCtrl.sink.add(Response.completed(classProceedingRoundsList));
    } catch (e) {
      _roundListCtrl.sink.add(Response.error(e.toString()));
    }

    // 출석률 리스트
    try {
      Map<String, dynamic> map = Map();
      map['itemId'] = '1';
      map['itemRoundId'] = '1';
      // classProceedingAttendeeData = await itemProvider.getItemMembersAttendee('item' ,  '22');
      _attendListCtrl.sink.add(Response.completed(classProceedingAttendeeData));
    } catch (e) {
      _attendListCtrl.sink.add(Response.error(e.toString()));
    }

    // 만족도 리스트 가져오기
    // 모임 ​/api​/item​/members​/attendee
    // 소셜링 /api​/socialing/members​/attendee
    try {} catch (e) {}
    try {} catch (e) {}
  }

  @override
  void dispose() {
    _saveAttendCtrl.close();
    _attendListCtrl.close();
    _roundListCtrl.close();
    _stateDataCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(18),
            color: MColors.white_two08,
            child: StreamBuilder<Response<ClassProceedingStateData>>(
                stream: _stateDataCtrl.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        ));
                        break;
                      case Status.COMPLETED:
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _getExpandedTitle('총 신청', '11 명', MTextStyles.bold13Black),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text('|'),
                                ),
                                _getExpandedTitle('환불', '13 명', MTextStyles.bold13Black),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _getExpandedTitle('유효 신청', '11 명', MTextStyles.bold13Black),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text('|'),
                                ),
                                _getExpandedTitle('평균 출석자', '12 명', MTextStyles.bold13Black),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _getExpandedTitle('평균 출석률', '180 %', MTextStyles.bold13Black),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text('|'),
                                ),
                                Expanded(
                                  child: SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        );
                        break;
                      case Status.ERROR:
                        return Column(
                          children: [
                            Text('${snapshot.data.message}'),
                          ],
                        );
                        break;
                    }
                  }
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ));
                })),
        const SizedBox(
          height: 20,
        ),
        //TitleBold16BlackView('회차 선택', ''),
          Container(
          alignment: Alignment.centerLeft,
          child: Text('회차 선택',
                style: MTextStyles.bold13Black,
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            //  width: 100,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: MColors.pinkish_grey, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: DropdownButtonHideUnderline(
              child: new DropdownButton(
                  isExpanded: true,
                  value: _value,
                  items: [
                     new DropdownMenuItem(child: new Text(_typeOfMeetingList[0], style: MTextStyles.bold13Black,), value: 0),
                    new DropdownMenuItem(child: new Text(_typeOfMeetingList[1], style: MTextStyles.bold13Black), value: 1),
                    new DropdownMenuItem(child: new Text(_typeOfMeetingList[2], style: MTextStyles.bold13Black), value: 2),
                  ],
                  hint: new Text(_selectedValue),
                  onChanged: (val) {
                    setState(() {
                      _value = val;
                    });
                  }),
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.all(18),
            color: MColors.white_two08,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _getExpandedTitle('유효멤버', '11 명', MTextStyles.bold13Tomato),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('|'),
                    ),
                    _getExpandedTitle('출석', '11 명', MTextStyles.bold13Tomato),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _getExpandedTitle('출석률', '190 %', MTextStyles.bold13Tomato),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('|'),
                    ),
                    Expanded(
                      child: SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        _surveyList(list),
      ],
    ));
  }

  Widget _getExpandedTitle(String title, String subTitle, TextStyle textstyle) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 72, child: Text(title, textAlign: TextAlign.start, style: MTextStyles.regular13Grey06)),
          Container(
            width: 42,
            child: Text(subTitle, textAlign: TextAlign.end, style: textstyle),
          )
        ],
      ),
    );
  }

  Widget _surveyList(List<Applicant> list) {
    return Expanded(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 50,
        rightHandSideColumnWidth: 350,
        isFixedHeader: true,
        headerWidgets: _getSurveyListTitleWidget(),
        leftSideItemBuilder: _getSurveyListFirstColumnRow,
        rightSideItemBuilder: _getSurveyListRightHandSideColumnRow,
        itemCount: list.length,
        rowSeparatorWidget: const Divider(
          color: Color(0xffd6d6d6), //Colors.grey ,//
          height: 1.0,
          thickness: 0.0,
        ),
      ),
    );
  }

  List<Widget> _getSurveyListTitleWidget() {
    return [
      _getTitleItemWidget('번호', 50),
      _getTitleItemWidget('이름', 100),
      _getTitleItemWidget('만족도 설문', 200),
    ];
  }

  Widget _getSurveyListFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text('$index'),
      width: 50,
      height: 40,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  List<Widget> _getMemberListTitleWidget() {
    return [
      _getTitleItemWidget('번호', 30),
      _getTitleItemWidget('출석여부', 50),
      _getTitleItemWidget('회원분류', 50),
      _getTitleItemWidget('이름', 60),
      _getTitleItemWidget('연락처정보', 90),
      _getTitleItemWidget('메모', 150),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: MTextStyles.medium12BrownGrey,
      ),
      width: width,
      height: 40,
      // padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _getMemberListFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text('$index'),
      width: 30,
      height: 40,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getSurveyListRightHandSideColumnRow(BuildContext context, int index) {
    var row = list[index];
    return Container(
      height: 40,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 100,
            child: Text(
              row.name,
              style: MTextStyles.medium14Grey06,
            ),
          ),
          Container(
            width: 200,
            child: Container(
              height: 30,
              child: RaisedButton(
                //  textColor: Colors.grey[200],
                color: MColors.white_two,
                elevation: 0.2,
                splashColor: Colors.white,
                // padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                onPressed: () => Navigator.of(context).pushNamed('SurveyResultPage'),
                child: Text('결과 보기', textAlign: TextAlign.center, style: MTextStyles.medium12BrownGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
