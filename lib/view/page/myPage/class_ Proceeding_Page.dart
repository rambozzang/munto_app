import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/class_Proceeding_TabBarView1.dart';
import 'package:munto_app/view/page/myPage/class_Proceeding_TabBarView2.dart';
import 'package:munto_app/view/page/myPage/class_Proceeding_TabBarView3.dart';
import 'package:munto_app/view/page/myPage/class_Proceeding_TabBarView4.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

// ignore: must_be_immutable
class ClassProceedingPage extends StatefulWidget {
  ClassProceedingPage({
    Key key,
    this.map,
  }) : super(key: key);

  Map<String, dynamic> map = Map();

  @override
  _ClassProceedingPageState createState() => _ClassProceedingPageState();
}

class _ClassProceedingPageState extends State<ClassProceedingPage> with TickerProviderStateMixin {
  TabController _tabController;

  ScrollController _scrollController;
  bool fixedScroll;
  // 1.모임.소셜링 기본 정보 가져오기

  final StreamController<Response<ClassData>> _socialingCtrl = StreamController();

  ClassProvider classProvider = ClassProvider();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 1);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    getData();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  getData() async {
    print('widget.map = ${widget.map.toString()}');
    String strClassType = widget.map['classType'].toString();
    String strId = widget.map['id'].toString();
    _socialingCtrl.sink.add(Response.loading());

    try {
      ClassData classData = await classProvider.getClassClasstypebyId(strClassType, strId);

      classData.classType = Util.getClassTypeName(strClassType);
      _socialingCtrl.sink.add(Response.completed(classData));
    } catch (e) {
      print('class_proceeding_page : ${e.toString()} ');
      _socialingCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _socialingCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.white,
      appBar: _appbar(),
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: StreamBuilder<Response<ClassData>>(
                    stream: _socialingCtrl.stream,
                    builder: (BuildContext context, AsyncSnapshot<Response<ClassData>> snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            print('Loading');
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: CircularProgressIndicator(),
                            ));
                            break;
                          case Status.COMPLETED:
                            ClassData item = snapshot.data.data;
                            return ClassMiddleBox(item);
                            break;
                          case Status.ERROR:
                            print('ERROR');
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
                    }),
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 16,
              ),
            ),
            SliverToBoxAdapter(
              child: _tabSection(context),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBarView(controller: _tabController, children: [
            Expanded(child: ClassProceedingTabBarView1(widget.map)), // _surveyPoint(1), // 명단/출석부
            // Expanded(child: ClassProceedingTabBarView2()), // _buildInformation(), // 안내사항
            // Expanded(child: ClassProceedingTabBarView3()), // _surveyPoint(2), // 만족도
            // Expanded(child: ClassProceedingTabBarView4()), //_budgetList(), // 정산내역
          ]),
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "진행중 모임 정보 관리",
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

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey[200], width: 1.0))),
              child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: MColors.tomato),
                    // insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)
                  ),
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(left: 5, right: 5),
                  indicatorColor: MColors.blackColor,
                  indicatorWeight: 0.5,
                  labelStyle: MTextStyles.bold14Tomato,
                  unselectedLabelStyle: MTextStyles.regular14PinkishGrey,
                  //   labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  controller: _tabController,
                  tabs: [
                    Expanded(flex: 1, child: Tab(text: "명단/출석부")),
                    //Expanded(flex: 1, child: Tab(text: "안내사항")),
                    // Expanded(flex: 1, child: Tab(text: "만족도")),
                    // Expanded(flex: 1, child: Tab(text: "정산내역")),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
