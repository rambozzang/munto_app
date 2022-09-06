import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/follow_provider.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:rxdart/rxdart.dart';

import 'package:munto_app/view/widget/error_page.dart';

import '../../../app_state.dart';

class CommunityUserList extends StatefulWidget {
  final String classType;
  final String className;
  final int itemId;

  CommunityUserList(this.classType, this.className, this.itemId);
  @override
  _CommunityUserListState createState() => _CommunityUserListState();
}

class _CommunityUserListState extends State<CommunityUserList>
    with TickerProviderStateMixin {
  FollowProvider followProvider = FollowProvider();
  TabController tabController;
  List<UserData> followerList = [];

  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();

  ClassProvider classProvider = ClassProvider();

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 1);
    _getItemMemebers();
  }

  // 상단 맴버 리스트 가져오기
  Future<void> _getItemMemebers() async {
    try {
      _memberListCtrl.sink.add(Response.loading());
      Map<String, dynamic> _map = Map();
      String socialId = widget.itemId.toString();
      String classType = widget.classType.toString();
      _map['classType'] = classType;
      _map['itemId'] = socialId;
      print('==== 맴버 가져오기 시작 ====================================');
      List<UserData> memberList = await classProvider.getClassmembers(_map);
      print('==== 맴버 가져오기 완료 ==================================+=');
      _memberListCtrl.sink.add(Response.completed(memberList));
    } catch (e) {
      print(e.toString());
      _memberListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _memberListCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${widget.className}',
            style: MTextStyles.bold16Black,
          ),
          elevation: 0.0,
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(52),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: TabBar(
//                 labelPadding: EdgeInsets.only(left: 10, right: 10),
//                 labelStyle: MTextStyles.bold14Grey06,
//                 unselectedLabelStyle: MTextStyles.medium14PinkishGrey,
//                 controller: tabController,
//                 indicator: UnderlineTabIndicator(
//                   borderSide: BorderSide(width: 2.0, color: MColors.black),
//                   insets: EdgeInsets.only(
//                     left: 24,
//                     right: 24,
//                   ),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 unselectedLabelColor: MColors.pinkish_grey,
// //                      isScrollable: true,
//                 tabs: [
//                   Container(
//                       alignment: Alignment.bottomLeft,
//                       padding: EdgeInsets.only(bottom: 15.0, left: 20),
//                       child: Text(
//                         '회원 리스트',
//                       )),
//                 ],
//               ),
//             ),
//           ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            StreamBuilder<Response<List<UserData>>>(
                stream: _memberListCtrl.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        List<UserData> list = snapshot.data.data;
                        return list.length > 0
                            ? _userList(list)
                            : _noDataWidget();
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
                }),
          ],
        ));
  }

  Widget _userList(List<UserData> list) {
    print('${list.length}');

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          UserData item = list[index];
          print('item : $item');
          print('item : ${item.isFollow}');
          return Container(
            color: MColors.whiteColor,
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('UserProfilePage', arguments: item.id);
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.image),
              ),
              title: Text(
                item.name,
                style: MTextStyles.bold14Black,
              ),
              subtitle: Text(
                item.introduce ?? ' ',
                style: MTextStyles.cjkMedium12PinkishGrey,
              ),
              trailing: // Rectangle Copy
                  item.id != UserInfo.myProfile.id
                      ? Container(
                          width: 60,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: MColors.tomato, width: 1),
                            color: item.isFollow == true
                                ? MColors.white
                                : MColors.tomato,
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: item.isFollow == true
                                ? Text("팔로잉 ",
                                    style: MTextStyles.regular14Tomato)
                                : Text(
                                    "팔로우",
                                    style: MTextStyles.medium14White,
                                  ),
                            onPressed: () async {
                              bool result = false;
                              if (item.isFollow == true)
                                result =
                                    await followProvider.deleteFollow(item.id);
                              else {
                                AppStateLog(context, FOLLOW_MEMBER,
                                    properties: {
                                      'sourceId': '${item.id}',
                                    });

                                result =
                                    await followProvider.postFollow(item.id);
                              }
                              if (result)
                                setState(() {
                                  item.isFollow = !item.isFollow;
                                });
                            },
                          ),
                        )
                      : SizedBox.shrink(),
            ),
          );
        });
  }

  // 전체 데이타 없을 경우
  Widget _noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NodataImage(
              wid: 80.0,
              hei: 80.0,
              path: 'assets/mypage/empty_orderhistory_60_px.svg'),
          Center(
              child: Text('피드 내용이없습니다.\n취향에 꼭 맞는 모임에 참여해 보세요!',
                  style: MTextStyles.medium16WarmGrey)),
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
