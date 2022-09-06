import 'dart:async';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/enum/class_Enum.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/view/page/myPage/class_item_widget.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  List<ClassData> classClosedDataList = []; // 참여했던 모임
  List<ClassData> classPlayingDataList = []; //활동중인 모임
  List<ClassData> classPrestartDataList = []; // 시작전 모임

  ClassProvider classService = ClassProvider();

  final StreamController<Response<List<ClassData>>> _classClosedDataListCtrl =
      StreamController();
  final StreamController<Response<List<ClassData>>> _classPlayingDataListCtrl =
      StreamController();
  final StreamController<Response<List<ClassData>>> _classPrestartDataListCtrl =
      StreamController();
  final StreamController<int> _countCtrl = StreamController();

  @override
  void dispose() {
    _classPrestartDataListCtrl.close();
    _classPlayingDataListCtrl.close();
    _classClosedDataListCtrl.close();
    _countCtrl.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getAllCalssList();
  }

  void _getAllCalssList() async {
    List<ClassData> _classDataList;
    _classPrestartDataListCtrl.sink.add(Response.loading());
    _classPlayingDataListCtrl.sink.add(Response.loading());
    _classClosedDataListCtrl.sink.add(Response.loading());
    try {
      // _classDataList = await classService.getAllCalssList();
      // _countCtrl.sink.add(_classDataList.length);
      // 개발용 임시
      _classDataList = await classService.getClassList(ClassEnum.PRESTART);
      _countCtrl.sink.add(_classDataList.length); // 임시용

      print('@@ ==>>  ${_classDataList.length}');
      _classDataList.forEach((value) {
        if (value.status == 'PRESTART') {
          classPrestartDataList.add(value);
        } else if (value.status == 'RECRUITING') {
          classPlayingDataList.add(value);
        } else if (value.status == 'CLOSED') {
          classClosedDataList.add(value);
        } else if (value.status == 'ITEM') {
          // 개발용 임시
          classPrestartDataList.add(value);
          classClosedDataList.add(value);
          classPlayingDataList.add(value);
        }
      });

      _classPrestartDataListCtrl.sink
          .add(Response.completed(classPrestartDataList));
      _classPlayingDataListCtrl.sink
          .add(Response.completed(classPlayingDataList));
      _classClosedDataListCtrl.sink
          .add(Response.completed(classClosedDataList));
    } catch (e) {
      _classPlayingDataListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: StreamBuilder<int>(
          stream: _countCtrl.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget returnWidget;
            if (snapshot.hasError) {
              returnWidget = Error(
                errorMessage: snapshot.error.toString(),
                onRetryPressed: () => null,
              );
            } else {
              if (snapshot.hasData) {
                returnWidget =
                    snapshot.data > 0 ? _getbody() : _classNoDataWidget();
              } else {
                returnWidget = Center(child: CircularProgressIndicator());
              }
            }
            return returnWidget;
          }),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "모임내역",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(
          height: barBorderWidth,
          color: MColors.barBorderColor,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        // Badge(
        //   badgeColor: Colors.red, // Colors.deepPurple,
        //   shape: BadgeShape.circle,
        //   borderRadius: BorderRadius.circular(5.0),
        //   // position: BadgePosition.topEnd(top: 3.0, end: 3.0),
        //   animationDuration: Duration(milliseconds: 300),
        //   animationType: BadgeAnimationType.slide,
        //   padding: EdgeInsets.all(5),
        //   //padding: EdgeInsets.all(6),
        //   toAnimate: true,
        //   badgeContent: Text('2', style: TextStyle(color: Colors.white)),
        //   child: IconButton(
        //     icon: Image.asset('assets/mypage/basket.png'),
        //     onPressed: () {},
        //   ),
        // )
      ],
    );
  }

  Widget _getbody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          StreamBuilder<Response<List<ClassData>>>(
              stream: _classPrestartDataListCtrl.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return _getStreamBuild('시작전 모임', snapshot);
              }),
          StreamBuilder<Response<List<ClassData>>>(
              stream: _classPlayingDataListCtrl.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return _getStreamBuild('활동중인 모임', snapshot);
              }),
          StreamBuilder<Response<List<ClassData>>>(
              stream: _classClosedDataListCtrl.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return _getStreamBuild('참여했던 모임', snapshot);
              }),
          //  _cardListBox(),
        ],
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
          return _classGridView(_title, snapshot.data.data);
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
      padding: const EdgeInsets.all(68.0),
      child: CircularProgressIndicator(),
    ));
  }

  // 그리드 리스트
  Widget _classGridView(String _title, List<ClassData> list) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = 172;
    final double itemWidth = (size.width / 2) - 20 - 6;

    if (list == null || list.length == 0) {
      // 데이타가 없는 경우
      return SizedBox.shrink();
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TitleBold16BlackView(_title, "${list.length}건"),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 2,
              children: List.generate(list.length, (index) {
                ClassData item = list[index];
                SocialingData socialingData = SocialingData();
                socialingData.id = item.id;
                print('item.cover = ${item.cover}');
                return InkWell(
                    onTap: () {
                      print('click: ${item.classType}');
                      if (item.classType == 'SOCIALING') {
                        Navigator.of(context).pushNamed('SocialingDetailPage',
                            arguments: socialingData);
                      } else {
                        Navigator.of(context).pushNamed('MeetingDetailPage',
                            arguments: [item.id, item.name, false]);
                      }
                    },
                    child: ClassBigItemWidget(item));
              }),
            ),
          ),
          DividerGrey12(),
          const SizedBox(
            height: 40,
          ),
        ],
      );
    }
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NodataImage(wid: 80.0, hei: 80.0),
            Text('아직 참여한 모임이 없습니다.\n문토의 다양한 모임에 참여해 보세요!',
                style: MTextStyles.medium16WarmGrey),
            const SizedBox(height: 15),
            FlatButton(
              padding: EdgeInsets.zero,
              child: Container(
                height: 43,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                  border: Border.all(color: MColors.tomato, width: 1),
                  color: MColors.tomato,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("모임보기", style: MTextStyles.medium14White),
                    Icon(Icons.check, size: 20, color: MColors.white),
                  ],
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
