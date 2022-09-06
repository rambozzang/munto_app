import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/enum/class_Enum.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

import 'class_item_widget.dart';

final group4 = MeetingGroup(MeetingHeader('모임목록', '', HeaderStyle.STYLE2), null, meetingGroupAll);

class ClassManagePage extends StatefulWidget {
  @override
  _ClassManagePageState createState() => _ClassManagePageState();
}

class _ClassManagePageState extends State<ClassManagePage> {
  List<ClassData> classDataListforAdmin = []; // 시작전 모임

  ClassProvider classService = ClassProvider();

  List<ClassData> classRecrutingDataList = []; // 모집중 모임
  List<ClassData> classPlayingDataList = []; //진행중 모임
  List<ClassData> classPrestartDataList = []; // 기획중인 모임
  List<ClassData> classClosedDataList = []; // 기획중인 모임

  final StreamController<Response<List<ClassData>>> _classDataListCtrl = StreamController();

  final StreamController<Response<List<ClassData>>> _classRecrutingListCtrl = StreamController();
  final StreamController<Response<List<ClassData>>> _classPlayingListCtrl = StreamController();
  final StreamController<Response<List<ClassData>>> _classPrestartListCtrl = StreamController();
  final StreamController<Response<List<ClassData>>> _classClosedListCtrl = StreamController();
  final StreamController<int> _countCtrl = StreamController();

  @override
  void initState() {
    super.initState();
    _getDataList();
  }

  _getDataList() async {
    // PLANNING, RECRUITING, PLAYING, CONFIRM_PLAYING, CLOSE, COMPLETE, PRESTART
    try {
      _classPrestartListCtrl.sink.add(Response.loading());
      _classRecrutingListCtrl.sink.add(Response.loading());
      _classPlayingListCtrl.sink.add(Response.loading());
      _classClosedListCtrl.sink.add(Response.loading());

      //classRecrutingDataList = await classService.getClassListForAdminstrator();

      //
      //List<ClassData> list = await classService.getClassList(ClassEnum.PRESTART);
      // todo 아래로 대체 필요
      List<ClassData> list = await classService.getClassListForAdminstrator();
      // planning은 기획중,   -> 소셜링 상세
      // recruiting은 모집중,   -> 모집중
      // playing과 confirm_playing은 진행중,   -> 진행중
      // complete는 완료 -> null
      list.asMap().forEach((index, value) {
        if (value.status == 'PLANNING') {
          classPrestartDataList.add(list[index]);
        } else if (value.status == 'RECRUITING') {
          classRecrutingDataList.add(list[index]);
        } else if (value.status == 'PLAYING' || value.status == 'CONFIRM_PLAYING') {
          classPlayingDataList.add(list[index]);
        } else if (value.status == 'COMPLETE') {
          classClosedDataList.add(list[index]);
        }
      });

      // classPrestartDataList.addAll(list);
      // classPrestartDataList.add(ClassData());

      if (classPrestartDataList.length > 0) {
      } else {
        //classPrestartDataList.add(ClassData());
      }

      // classPlayingDataList = await classService.getClassList(ClassEnum.PLAYING);
      // classRecrutingDataList = await classService.getClassList(ClassEnum.RECRUITING);
      // classClosedDataList = await classService.getClassList(ClassEnum.CLOSE);

      // [필수]기획중인 모임은 기본적인 소설링 추가 아이템

      _classPrestartListCtrl.sink.add(Response.completed(classPrestartDataList));
      _classRecrutingListCtrl.sink.add(Response.completed(classRecrutingDataList));
      _classPlayingListCtrl.sink.add(Response.completed(classPlayingDataList));
      _classClosedListCtrl.sink.add(Response.completed(classClosedDataList));
    } catch (e) {
      _classPrestartListCtrl.sink.add(Response.error(e.toString()));
      _classRecrutingListCtrl.sink.add(Response.error(e.toString()));
      _classPlayingListCtrl.sink.add(Response.error(e.toString()));
      _classClosedListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _classDataListCtrl.close();
    _classRecrutingListCtrl.close();
    _classPlayingListCtrl.close();
    _classPrestartListCtrl.close();
    _classClosedListCtrl.close();
    _countCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: MColors.white,
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              //_classGridView(dummyMeetings3),
              StreamBuilder<Response<List<ClassData>>>(
                  stream: _classPrestartListCtrl.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return _getStreamBuild('기획중 모임', snapshot);
                  }),
              DividerGrey12(),
              const SizedBox(
                height: 40,
              ),

              // _classGridView(dummyMeetings2),
              StreamBuilder<Response<List<ClassData>>>(
                  stream: _classRecrutingListCtrl.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return _getStreamBuild('모집중 모임', snapshot);
                  }),
              DividerGrey12(),
              const SizedBox(
                height: 40,
              ),

              //  _classGridView(meetingGroupAll),
              StreamBuilder<Response<List<ClassData>>>(
                  stream: _classPlayingListCtrl.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return _getStreamBuild('진행중 모임', snapshot);
                  }),

              DividerGrey12(),
              const SizedBox(
                height: 40,
              ),

              //classGridView(meetingGroupAll),
              StreamBuilder<Response<List<ClassData>>>(
                  stream: _classClosedListCtrl.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return _getStreamBuild('완료된 모임', snapshot);
                  }),
              //  _cardListBox(),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "모임 관리",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // actions: [
      //   Badge(
      //     badgeColor: Colors.red, // Colors.deepPurple,
      //     shape: BadgeShape.circle,
      //     borderRadius: 5,
      //     position: BadgePosition.topEnd(top: 3.0, end: 3.0),
      //     animationDuration: Duration(milliseconds: 300),
      //     animationType: BadgeAnimationType.slide,
      //     padding: EdgeInsets.all(5),
      //     //padding: EdgeInsets.all(6),
      //     toAnimate: true,
      //     badgeContent: Text('2', style: TextStyle(color: Colors.white)),
      //     child: IconButton(
      //       icon: Image.asset('assets/mypage/basket.png'),
      //       onPressed: () {},
      //     ),
      //   )
      // ],
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(
          height: barBorderWidth,
          color: MColors.barBorderColor,
        ),
      ),
    );
  }

  Widget _getStreamBuild(String _title, snapshot) {
    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case Status.LOADING:
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(68.0),
            child: CircularProgressIndicator(),
          ));
          break;
        case Status.COMPLETED:
          List<ClassData> list = snapshot.data.data;
          return list.length > 0 ? _classGridView(_title, list) : _classNoDataWidget(_title);
          break;
        case Status.ERROR:
          return Error(
            errorMessage: snapshot.data.message,
            onRetryPressed: () => null,
          );
          break;
      }
    }
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: CircularProgressIndicator(),
    ));
  }

  Widget _classGridView(String _title, List<ClassData> list) {
    // list.add(
    //   MeetingItem(true, '', '', '', '소셜링 추가 윗젯을 위한 더미 데이타 ', '', '', []),
    // );

    int cnt = _title == '기획중 모임' ? list.length - 1 : list.length;

    final size = MediaQuery.of(context).size;
    // final double itemHeight = 210;
    final double itemWidth = (size.width / 2) - 20 - 8;
    final double itemHeight = itemWidth * (210.0 / 152.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TitleBold16BlackView(_title, "$cnt건"),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 24,
            childAspectRatio: (itemWidth / itemHeight),
            crossAxisCount: 2,
            children: List.generate(list.length, (index) {
              if ((cnt) == index && _title == '기획중 모임') {
                // 마지막에 소셜링 추가 위젯 보여주기
                return _plusSocialing();
              } else {
                return InkWell(
                    onTap: () {
                      SocialingData socialingData = SocialingData();
                      socialingData.id = list[index].id;
                      print('click => ${list[index].id}');
                      Navigator.of(context).pushNamed('SocialingDetailPage', arguments: socialingData);
                    },
                    child: ClassManageItemWidget(list[index]));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _plusSocialing() {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('OpenSocialingPage'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Container(
          width: 154,
          decoration: new BoxDecoration(
              color: MColors.white_two,
              border: Border.all(width: 1, color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 소셜링
              Text("소셜링", style: MTextStyles.bold20Grey06, textAlign: TextAlign.center),
              // 나와 꼭 맞는 취향을 가진 사람들을
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, bottom: 20),
                child: Text("나와 꼭 맞는 취향을\n가진 사람들을 만날 기회,\n직접 만들어볼까요?",
                    style: MTextStyles.regular14Grey06, textAlign: TextAlign.center),
              ),
              CircleAvatar(
                radius: 27,
                backgroundColor: MColors.white,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: MColors.blackColor,
                    size: 44,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleBold16BlackView(title, "0건"),
            const SizedBox(
              height: 38,
            ),
            NodataImage(
              wid: 80.0,
              hei: 80.0,
              path: 'assets/mypage/empty_community_60_px.svg',
            ),
            Text(title + '이 없습니다.', style: MTextStyles.medium16WarmGrey),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
