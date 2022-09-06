import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/class_members_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/model/meeting_data.dart';

import 'package:munto_app/view/widget/error_page.dart';

class ClassRecruitingPage extends StatefulWidget {
  Map<String, dynamic> map = Map();

  ClassRecruitingPage(this.map);

  @override
  _ClassRecruitingPageState createState() => _ClassRecruitingPageState();
}

class _ClassRecruitingPageState extends State<ClassRecruitingPage> with TickerProviderStateMixin {
  ClassProvider classService = ClassProvider();
  SocialingProvider socialingProvider = SocialingProvider();

  ItemProvider itemProvider = ItemProvider();
  List<ClassMembersData> membersList = [];
  List list = meetingGroupAll[0].applicantList;
  final StreamController<Response<List<ClassMembersData>>> _classRecrutingListCtrl =
      StreamController<Response<List<ClassMembersData>>>();

  final StreamController<Response<ClassData>> _socialingCtrl = StreamController();

  ClassProvider classProvider = ClassProvider();

  TabController _tabController;

  @override
  void dispose() {
    _classRecrutingListCtrl.close();
    _socialingCtrl.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 1);
    getMiddleBox();
    _getData();
  }

  Future<void> _getData() async {
    // 소셜링인경우 /api​/socialing​/members​/ordered
    // 모임인 경우 ​/api​/item​/members​/ordered
    String _itemId = widget.map['itemId'];

    try {
      _classRecrutingListCtrl.sink.add(Response.loading());
      // followingList = await itemProvider.getItemMemberOrdered(_itemId);
      membersList = await socialingProvider.getSocialingMemberOrdered(_itemId);
      _classRecrutingListCtrl.sink.add(Response.completed(membersList));
    } catch (e) {
      print(e.toString());
      _classRecrutingListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getMiddleBox() async {
    String strClassType = widget.map['classType'].toString();
    String strId = widget.map['itemId'].toString();
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

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "모집중 모임 정보 관리",
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
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: Colors.grey[300], width: 1.0))),
                  child: TabBar(
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 4, color: MColors.tomato),
                        // insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)
                      ),
                      isScrollable: true,
                      // labelPadding: EdgeInsets.only(left: 0, right: 0),
                      indicatorColor: MColors.blackColor,
                      indicatorWeight: 2.0,
                      labelStyle: MTextStyles.bold14Tomato,
                      unselectedLabelStyle: MTextStyles.regular14PinkishGrey,
                      controller: _tabController,
                      tabs: [
                        Tab(text: "모집명단"),
                     //   Tab(text: "안내사항"),
                      ]),
                ),
                Positioned(bottom: 2, child: DividerGrey12()),
              ],
            ),
            StreamBuilder<Response<List<ClassMembersData>>>(
                stream: _classRecrutingListCtrl.stream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Center(child: CircularProgressIndicator());
                        break;
                      case Status.COMPLETED:
                        return _getTabbarViews(snapshot.data.data, null);
                        break;
                      case Status.ERROR:
                        return _getTabbarViews(
                            snapshot.data.data,
                            Error(
                              errorMessage: snapshot.data.message,
                              onRetryPressed: () => _getData(),
                            ));
                        break;
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget _getTabbarViews(List<ClassMembersData> list, Widget widget) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      //Add this to give height
      color: MColors.white,
      height: MediaQuery.of(context).size.height * 1.1,
      child: TabBarView(controller: _tabController, children: [
        Container(
            alignment: Alignment.topCenter,
            child: widget == null
                ? _buildMemberList(list)
                : Column(
                    children: [
                      widget,
                    ],
                  )),
        // Container(
        //   child: _buildInformation(),
        // ),
      ]),
    );
  }

  // 모집 명단 리스트
  Widget _buildMemberList(List<ClassMembersData> list) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: list == null ? 1 : list.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          // return the header
          return new Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  '번호',
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium12BrownGrey,
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  '회원분류',
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium12BrownGrey,
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  '이름',
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium12BrownGrey,
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  '연락처정보',
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium12BrownGrey,
                ),
              ),
              // Expanded(
              //   flex: 20,
              //   child: Center(
              //     child: Text(
              //       ' 결과보기',
              //       style: MTextStyles.medium12BrownGrey,
              //     ),
              //   ),
              // ),
            ],
          );
        }
        index -= 1;
        // return row
        var row = list[index];
        return Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  '$index',
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium14Grey06,
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  Util.getGradeName(row.grade.toString()),
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium14Grey06,
                ),
              ),
              Expanded(
                flex: 20,
                child: Text(
                  row.name,
                  textAlign: TextAlign.center,
                  style: MTextStyles.bold14Black,
                ),
              ),
              Expanded(
                flex: 30,
                child: Text(
                  row.phoneNumber,
                   textAlign: TextAlign.center,
                  style: MTextStyles.medium12BrownGrey,
                ),
              ),
              // Expanded(
              //   flex: 20,
              //   child: InkWell(
              //     onTap: () {},
              //     child: Container(
              //       height: 30,
              //       child: RaisedButton(
              //         color: MColors.white_two,
              //         elevation: 0.2,
              //         padding: EdgeInsets.all(0.0),
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              //         onPressed: () => Navigator.of(context).pushNamed('SurveyResultPage'),
              //         child: Text('결과보기', textAlign: TextAlign.center, style: MTextStyles.medium12BrownGrey),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  // 안내 사항
  Widget _buildInformation() {
    return Container(
      //  padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TitleBold16BlackView('1. 1회차 모임 전 타임라인', ''),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(20),
              color: MColors.white_two08,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('각 회차 모임이후', style: MTextStyles.medium13Black_three),
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  )
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('2. 문토 파트너 가이드북', ''),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('가이드북을 꼭 확인해주세요.', style: MTextStyles.medium14Grey06),
                ),
                Container(
                  child: Text('가이드북 보기 >', style: MTextStyles.bold14Tomato),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('3. 모임 진행 기준', ''),
          Container(
            child: Text('문토 모임은 첫 모임일 기준 5일 전까지 최소 진행인원이 충족되어야 진행됩니다.', style: MTextStyles.medium14Grey06),
          ),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('4. 발제문 가이드', ''),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('문토가 첫 번째 진행과 발제에 대해 확인하고 피드백을 드립니다.', style: MTextStyles.medium14Grey06),
                ),
                Container(
                  child: Text('PPT 템플릿 다운받기 >', style: MTextStyles.bold14Tomato),
                ),
                Container(
                  child: Text('PPT 폰트 다운받기 >', style: MTextStyles.bold14Tomato),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
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
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              //  _cardListBox(),
              const SizedBox(
                height: 16,
              ),
              _tabSection(context),
            ],
          ),
        ));
  }
}
