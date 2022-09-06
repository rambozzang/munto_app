import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/class_List_Forcommunity_Data.dart';
import 'package:munto_app/model/class_communtiy_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import 'community_detail.dart';

import 'package:munto_app/view/widget/error_page.dart';

class CommunityListPage extends StatefulWidget {
  // final MeetingGroup group;
  // CommunityListPage(this.group);
  @override
  _CommunityListPageState createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  ClassProvider classService = ClassProvider();

  ClassListForCommuntiyData classListForCommuntiyData = ClassListForCommuntiyData();
  List<CommuntiyData> playingClassList = []; // 진행중인 모임
  List<CommuntiyData> managingClassList = []; //활동중인 모임

  final StreamController<Response<List<CommuntiyData>>> _CommuntiyDataCtrl = StreamController();
  final StreamController<Response<List<CommuntiyData>>> _managingClassListCtrl = StreamController();
  final StreamController<Response<ClassListForCommuntiyData>> _commonCtrl = StreamController();

  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    print('communityPageInitState');

    getData();
  }

  getData() async {
    try {
      _commonCtrl.sink.add(Response.loading());
      classListForCommuntiyData = await classService.getClassListForcommunity();

      _commonCtrl.sink.add(Response.completed(classListForCommuntiyData));
    } catch (e) {
      print(e.toString());
      _commonCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getPullFeedData() async {
    try {
      _commonCtrl.sink.add(Response.loading());
      classListForCommuntiyData = await classService.getClassListForcommunity();

      _commonCtrl.sink.add(Response.completed(classListForCommuntiyData));
    } catch (e) {
      print(e.toString());
      _commonCtrl.sink.add(Response.error(e.toString()));
    }
  }
  @override
  void dispose() {
    super.dispose();
    _CommuntiyDataCtrl.close();
    _managingClassListCtrl.close();
    _commonCtrl.close();

  }

  @override
  void didChangeDependencies() {
    print('CommunityListPage didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bottomProvider = Provider.of<BottomNavigationProvider>(context);
    print('communityLIstPage = ${bottomProvider.communityRefresh.toString()}');
    if(bottomProvider.communityRefresh){
      Future.delayed(Duration(milliseconds: 500),(){
        bottomProvider.communityFinished();
        getPullFeedData();
      });
    }
    return Scaffold(
//      backgroundColor: whiteThree,
        backgroundColor: MColors.white,
        appBar: _appBar(),
        body: _buildBody());
  }

  // 진행중인 모임
  Widget _buildBody() {
    return StreamBuilder<Response<ClassListForCommuntiyData>>(
        stream: _commonCtrl.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Container(
                  width: MediaQuery.of(context).size.width,
                  //  height: MediaQuery.of(context).size.height,
                  //   padding: const EdgeInsets.only(68.0),
                  child: Center(child: CircularProgressIndicator()),
                );
                break;
              case Status.COMPLETED:
                ClassListForCommuntiyData classListForCommuntiyData = snapshot.data.data;
                List<CommuntiyData> list1 = classListForCommuntiyData.managingClassList;
                List<CommuntiyData> list2 = classListForCommuntiyData.playingClassList;
                return list1.length > 0 || list2.length > 0 ? _getStreamBuild(list1, list2) : _noDataWidget();
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => null,
                );
                break;
            }
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            //  height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.all(68.0),
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget _getStreamBuild(List<CommuntiyData> list1, List<CommuntiyData> list2) {
    return RefreshIndicator(
      key: _refreshfeedIndicatorKey,
      onRefresh: getPullFeedData,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 32),
                child: Text(
                  '진행중인 모임',
                  style: MTextStyles.bold16Black,
                )),
            _buildList(list1),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 32),
                child: Text(
                  '내가 만든 모임',
                  style: MTextStyles.bold16Black,
                )),
            _buildList(list2),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    border: Border.all(color: MColors.pinkish_grey, width: 1),
                    color: const Color(0xffffffff)),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed('ClassListPage');
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                        child: Icon(
                          Icons.people,
                          size: 20,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        '모임내역 보기',
                        style: MTextStyles.medium16Grey06,
                      )),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.black,
                        ),
                        // onPressed: () {
                        // },
                      )
                    ],
                  ),
                ),

              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<CommuntiyData> list) {
    return ListView.builder(
      itemCount: list.length, // < 5 ? list.length : 5, //+1 for progressbar
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final item = list[index];
        var period = '';
        try {
          period = Util.getDateYmd(item.startDate);
              // + '~' +
              // Util.getDateYmd(item.finishDate).substring(5, Util.getDateYmd(item.finishDate).length);
        } catch (e) {
          period = Util.getDateYmd(item.startDate);
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              height: 159,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      item.cover,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 58,
                    child: Container(
                      color: MColors.white_two08,
                      padding: EdgeInsets.only(left: 20, right: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item.name,
                                  style: MTextStyles.bold16Black,
                                  maxLines: 1,
                                ),
                                Text(
                                  '모임일정 :  $period',
                                  style: MTextStyles.regular12Grey06,
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 4.0,),
                          Text(
                            '${item.statusForDisplay}',
                            style: MTextStyles.bold12Black,
                          ),
                          // Padding(
                          //     padding: EdgeInsets.only(left: 12, right: 2),
                          //     child: Icon(
                          //       Icons.people,
                          //       size: 18,
                          //     )),
                          // Text(
                          //   '${item.totalMember}',
                          //   style: MTextStyles.bold12Black,
                          // )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      width: 60,
                      height: 28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          border: Border.all(color: MColors.white_three, width: 0.5),
                          color: Colors.white),
                      child: Center(
                          child: Text(
                        '${Util.getClassTypeName(item.classType)}',
                        style: MTextStyles.medium14Grey06,
                      )),
                    ),
                  ),
                  Positioned.fill(child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => CommunityDetailPage(item.classType, item.id, item.name)));
                    },
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        '커뮤니티',
        style: MTextStyles.bold16Black,
      ),
      // leading: IconButton(
      //   icon: Image.asset('assets/notification.png'),
      //   onPressed: () {},
      // ),
      // actions: [
      //   IconButton(
      //     icon: Image.asset('assets/calendar.png'),
      //     onPressed: () {},
      //   )
      // ],
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
    );
  }

  // 전체 데이타 없을 경우
  Widget _noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_orderhistory_60_px.svg'),
          Center(child: Text('커뮤니티  내용이없습니다.\n취향에 꼭 맞는 모임에 참여해 보세요!', style: MTextStyles.medium16WarmGrey)),
          const SizedBox(height: 15),
          FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              height: 42,
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
    );
  }
}
