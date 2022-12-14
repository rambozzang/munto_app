import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/follow_provider.dart';
import 'package:munto_app/model/provider/question_provider.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:munto_app/view/widget/error_page.dart';

import '../../../app_state.dart';

class TagWritersPage extends StatefulWidget {
  final String tagName;
  final int tagId;

  TagWritersPage(this.tagName, this.tagId);
  @override
  _TagWritersPageState createState() => _TagWritersPageState();
}

class _TagWritersPageState extends State<TagWritersPage>
    with TickerProviderStateMixin {
  FollowProvider followProvider = FollowProvider();
  List<UserData> writerList = [];

  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();

  QuestionProvider questionProvider = QuestionProvider();

  @override
  void initState() {
    super.initState();
    _getMemebers();
  }

  Future<void> _getMemebers() async {
    try {
      _memberListCtrl.sink.add(Response.loading());
      Map<String, dynamic> _map = Map();
      List<UserData> memberList =
          await questionProvider.getWriters(widget.tagId);

      if (memberList.length == 0) {
        _memberListCtrl.sink.add(Response.completed([]));
      } else {
        _memberListCtrl.sink.add(Response.completed(memberList));
      }
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
            '${widget.tagName}',
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
//                         '?????? ?????????',
//                       )),
//                 ],
//               ),
//             ),
//           ),
        ),
        body: StreamBuilder<Response<List<UserData>>>(
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
                    return list.length > 0 ? _userList(list) : _noDataWidget();
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
            }));
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
                if (UserInfo.myProfile.id == list[index].id) {
                  final provider = Provider.of<BottomNavigationProvider>(
                      context,
                      listen: false);
                  AppStateLog(context, PAGEVIEW_MY_PROFILE);
                  provider.setIndex(4);
                } else {
                  // ???????????? ???????????????
                  Navigator.of(context).pushNamed('UserProfilePage',
                      arguments: list[index].id.toString());
                }
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
                                ? Text("????????? ",
                                    style: MTextStyles.regular14Tomato)
                                : Text(
                                    "?????????",
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

  // ?????? ????????? ?????? ??????
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
              child: Text('?????? ?????????????????????.\n????????? ??? ?????? ????????? ????????? ?????????!',
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
                  Text("????????????", style: MTextStyles.medium14White),
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
