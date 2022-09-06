import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:munto_app/model/class_Member_data.dart';
import 'package:munto_app/model/class_Proceeding_Attendee_data.dart';
import 'package:munto_app/model/class_Proceeding_Rounds_Data.dart';
import 'package:munto_app/model/class_Proceeding_State_Data.dart';
import 'package:munto_app/model/item_attendee_data.dart';
import 'package:munto_app/model/item_save_data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/socialing_attendee_data.dart';
import 'package:munto_app/model/socialing_save_data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassProceedingTabBarView1 extends StatefulWidget {
  ClassProceedingTabBarView1(this.map){
    // if(!kReleaseMode)
    //   map['id'] = '3816';
  }

  Map<String, dynamic> map = Map();

  @override
  _ClassProceedingTabBarView1State createState() => _ClassProceedingTabBarView1State();
}

class _ClassProceedingTabBarView1State extends State<ClassProceedingTabBarView1> {
  ClassProvider classService = ClassProvider();
  ItemProvider itemProvider = ItemProvider();

  ClassProceedingAttendeeData classProceedingAttendeeData;
  List<ClassProceedingRoundsData> classProceedingRoundsList;
  ClassProceedingStateData classProceedingStateData;

  final StreamController<Response<Map<dynamic, dynamic>>> _dataCtrl = StreamController();



  int _value = 1;
  String _selectedValue = "[1회차] 2020.03.12(수) 오후20시 합정";

  @override
  void initState() {
    print('applicantList map= ${widget.map.toString()}');

    super.initState();
    getData();
  }

// 소셜링 가져오기
  void getData() async {
    String _classType = widget.map['classType'].toString();
    String _id = widget.map['id'].toString();

    print('class_Proceeding_TabBarView1 : classType : ${_classType} , id : ${_id} ');

    _dataCtrl.sink.add(Response.loading());
    // 출석 정보 가져오기
    try {
      classProceedingStateData = await itemProvider.getItemStats(_classType, _id);
    } catch (e) {
      print('_classStateDataCtrl : ${e.toString()}');
      _dataCtrl.sink.add(Response.error(e.toString()));
      return;
    }
    // 회차 가져오기
    // socialing 인경우는 회차가 없음
    if (_classType.toLowerCase() == 'item') {
      try {
        classProceedingRoundsList = await itemProvider.getItemRounds(_id);
        print('classProceedingRoundsList : ${classProceedingRoundsList.length}');
      } catch (e) {
        print('_classRoundListCtrl : ${e.toString()}');
        _dataCtrl.sink.add(Response.error(e.toString()));
        return;
      }
    } else {
      // 소셜링인경우 빈 array
      classProceedingRoundsList = [];
    }

    // 출석률 리스트
    try {

      classProceedingAttendeeData = await itemProvider.getAttendee(_classType, widget.map['id'], round: classProceedingRoundsList[0]);

    } catch (e) {
      print('_classAttendListCtrl : ${e.toString()}');
      _dataCtrl.sink.add(Response.error(e.toString()));
      return;
    }

    Map<dynamic, dynamic> _map = Map<dynamic, dynamic>();
    _map['classProceedingStateData'] = classProceedingStateData;
    _map['classProceedingRoundsList'] = classProceedingRoundsList;
    _map['classProceedingAttendeeData'] = classProceedingAttendeeData;

    _dataCtrl.sink.add(Response.completed(_map));
  }

  // 출석 저장
  saveAttend() async {
    String _classType = widget.map['classType'].toString();
    String _id = widget.map['id'].toString();
    _classType = _classType.toLowerCase();
    SocialingSaveData _socialingSaveData = SocialingSaveData();
    _socialingSaveData.attendeeList = [];

    classProceedingAttendeeData.list.forEach((val) {
      SocialingAttendeeData _data = SocialingAttendeeData();
      _data.userId = val.userId.toString();
      _data.isAttendance = val.isAttendance.toString();
      _data.reason = val.reason;
      _socialingSaveData.attendeeList.add(_data);
    });
    if (_classType == 'socialing') {
      // 소셜링 데이타
      _socialingSaveData.socialingId = _id;
      _socialingSaveData.attendeeList.forEach((element) {
        print('${element.isAttendance}');
      });
    } else {
      // 모임 데이타
      // ItemSaveData _data = ItemSaveData();
      // ItemAttendeeData itemAttendeeData = ItemAttendeeData();
      // List<ItemAttendeeData> _attendList = [];
    }
    try {
      bool result = await itemProvider.saveItemAttendList(_classType.toLowerCase(), _socialingSaveData);
      print('result : $result');
      Util.showCenterFlash(
          context: context, position: FlashPosition.bottom, style: FlashStyle.floating, text: '정상적으로 처리되었습니다. $result');
    } catch (e) {
      print('result : ${e.toString()}');
      Util.showCenterFlash(
          context: context, position: FlashPosition.bottom, style: FlashStyle.floating, text: '${e.toString()}');
    }
  }

  @override
  void dispose() {
    _dataCtrl.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.white,
      body: StreamBuilder<Response<Map<dynamic, dynamic>>>(
        stream: _dataCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ),
                ));
                break;
              case Status.COMPLETED:
                Map<dynamic, dynamic> item = snapshot.data.data;
                return _buildBody(item);
                break;
              case Status.ERROR:
                return _noDatawritableReview(snapshot.data.message);
                break;
            }
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(Map<dynamic, dynamic> item) {
    return Container(
      color: MColors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            color: MColors.white_two08,
            child: _buildStateInfo(item['classProceedingStateData'] as ClassProceedingStateData),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildDropBox(),
          const SizedBox(
            height: 10,
          ),
          _buildMemeberState(item['classProceedingAttendeeData'] as ClassProceedingAttendeeData),
          _memberList(item['classProceedingAttendeeData'] as ClassProceedingAttendeeData),
          // Container(
          //   height: 47,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 20.0,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //         child: SizedBox(
          //           height: 44,
          //           child: FlatButton(
          //               child: new Text("취소하기", style: MTextStyles.regular14BlackColor),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(29.0),
          //               ),
          //               color: MColors.white_three,
          //               onPressed: () {}),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 15,
          //       ),
          //       Expanded(
          //         child: SizedBox(
          //           height: 44,
          //           child: FlatButton(
          //               child: new Text("저장하기", style: MTextStyles.bold14White),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(29.0),
          //               ),
          //               color: MColors.tomato,
          //               onPressed: () => saveAttend()),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildDropBox() {
    return classProceedingRoundsList!= null && classProceedingRoundsList.length > 0
        ? Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '회차 선택',
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
                        items: List.generate(classProceedingRoundsList.length,(index) {
                          final round = classProceedingRoundsList[index];
                          return DropdownMenuItem(
                              child: new Text(
                                '[${round.round}회차] ${Util.getDateYmdE(round.startDate)} ${Util.getLocalizedHour(round.startDate)}',
                                style: MTextStyles.bold13Black,
                              ),
                              value: round.round);
                        }) ,
                        hint: new Text(_selectedValue),
                        onChanged: (val) async {
                          setState(()  {
                            _value = val;
                          });

                          String _classType = widget.map['classType'].toString();
                          classProceedingAttendeeData = await itemProvider.getAttendee(_classType, widget.map['id'], round: classProceedingRoundsList[_value-1]);
                          }),
                  )),
            ],
          )
        : SizedBox.shrink();
  }

  Widget _buildMemeberState(ClassProceedingAttendeeData data) {
    if(data == null)
      return Text('no data');

    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            color: MColors.white_two08,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _getExpandedTitle('유효멤버', '${data.totalMember} 명', MTextStyles.bold13Tomato),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('|'),
                    ),
                    _getExpandedTitle('출석', '${data.attendanceMembers} 명', MTextStyles.bold13Tomato),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _getExpandedTitle('출석률', '${data.attendanceRate} %', MTextStyles.bold13Tomato),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('|'),
                    ),
                    _getExpandedTitle('', '', MTextStyles.transparent),
                  ],
                ),
              ],
            )),
        const SizedBox(
          height: 10,
        ),
        //   _memberList(data.list),
      ],
    );
  }

  // 출석 정보 가져오기
  Widget _buildStateInfo(ClassProceedingStateData item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getExpandedTitle('총 신청', '${item.totalOrderCount} 명', MTextStyles.bold13Black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('|'),
            ),
            _getExpandedTitle('환불', '${item.refundCount} 명', MTextStyles.bold13Black),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getExpandedTitle('유효 신청', '${item?.validOrderCount ?? 0} 명', MTextStyles.bold13Black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('|'),
            ),
            _getExpandedTitle('평균 출석자', '${(item?.averageAttendor ?? 0)} 명', MTextStyles.bold13Black),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getExpandedTitle('평균 출석률', '${item?.averageAttendanceRate ?? 0} %', MTextStyles.bold13Black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('|'),
            ),
            _getExpandedTitle('', '', MTextStyles.bold13Black),
          ],
        ),
      ],
    );
  }

  Widget _memberList(ClassProceedingAttendeeData item) {
    return Expanded(
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: _memberList1(item)),
    );
  }

  Widget _dataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('A')),
        DataColumn(label: Text('B')),
        DataColumn(label: Text('B')),
        DataColumn(label: Text('B')),
        DataColumn(label: Text('B')),
        DataColumn(label: Text('B')),
        DataColumn(label: Text('B')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('A1')),
          DataCell(Text('B1')),
          DataCell(Text('B1')),
          DataCell(Text('B1')),
          DataCell(Text('B1')),
          DataCell(Text('B1')),
          DataCell(Text('B1')),
        ]),
        DataRow(cells: [
          DataCell(Text('A2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
        ]),
        DataRow(cells: [
          DataCell(Text('A2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
        ]),
        DataRow(cells: [
          DataCell(Text('A2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
        ]),
        DataRow(cells: [
          DataCell(Text('A2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
        ]),
        DataRow(cells: [
          DataCell(Text('A2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
          DataCell(Text('B2')),
        ]),
      ],
    );
  }

  Widget _memberList1(ClassProceedingAttendeeData item) {
    if(item == null)
      return Text('list null');
    return Stack(
      children: [
        Container(
          height: 500, // (40.0 * item.list.length) + 40,
          width: 400,
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 30,
            rightHandSideColumnWidth: 430,
            isFixedHeader: true,
            headerWidgets: _getMemberListTitleWidget(),
            leftSideItemBuilder: _getMemberListFirstColumnRow,
            rightSideItemBuilder: _getMemberListRightHandSideColumnRow,
            itemCount: item.list.length,
            rowSeparatorWidget: const Divider(
              color: Color(0xffd6d6d6), //Colors.grey ,//
              height: 1.0,
              thickness: 0.0,
            ),
          ),
        ),
        Positioned(
          top: -3,
          right: -4,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 11,
            ),
            onPressed: () => null,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _noDatawritableReview(String text) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 16, bottom: 20.0),
        //   child: TitleBold16BlackView('작성 가능한 후기', '0건'),
        // ),
        const SizedBox(height: 120),
        NodataImage(wid: 60.0, hei: 60.0),
        const SizedBox(height: 6),
        Text(text, style: MTextStyles.medium16WarmGrey),
        //  const SizedBox(height: 15),
      ]),
    );
  }

  Widget _getExpandedTitle(String title, String subTitle, TextStyle textstyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(width: 72, child: Text(title, textAlign: TextAlign.start, style: MTextStyles.regular13Grey06)),
        Container(
          width: 42,
          child: Text(subTitle, textAlign: TextAlign.end, style: textstyle),
        )
      ],
    );
  }

  Widget _getMemberListRightHandSideColumnRow(BuildContext context, int index) {
    var row = classProceedingAttendeeData.list[index];

    return Container(
      height: 40,
      child: Row(
        children: [
          Container(
            width: 40,
            child: Checkbox(
              value: row.isAttendance,
              onChanged: (bool value) {
                setState(() {
                  if (value) {
                    classProceedingAttendeeData.list[index].isAttendance = true;
                  } else {
                    classProceedingAttendeeData.list[index].isAttendance = false;
                  }
                });
              },
            ),
          ),
          Container(
            width: 40,
            child: Text(
              Util.getGradeName(row.grade),
              textAlign: TextAlign.center,
              style: MTextStyles.medium14Grey06,
            ),
          ),
          Container(
            width: 80,
            child: Text(
              row.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: MTextStyles.bold14Black,
            ),
          ),
          Container(
            width: 90,
            child: Text(
              row.phoneNumber,
              textAlign: TextAlign.center,
              style: MTextStyles.medium12BrownGrey,
            ),
          ),
          Container(
            width: 150,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 25,
                child: Text('${row.reason == null ? '-' : row.reason}',
                    textAlign: TextAlign.center, style: MTextStyles.medium12BrownGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getMemberListTitleWidget() {
    return [
      _getTitleItemWidget('번호', 30),
      _getTitleItemWidget('출석', 40),
      _getTitleItemWidget('분류', 40),
      _getTitleItemWidget('이름', 80),
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
}
