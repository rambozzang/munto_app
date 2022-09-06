import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/follow_provider.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import '../../../app_state.dart';

class FollowPage extends StatefulWidget {
  final int index;
  final OtherUserProfileData profileData;
  FollowPage(this.profileData, {this.index = 0});
  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> with TickerProviderStateMixin {
  FollowProvider followProvider = FollowProvider();
  TabController tabController;
  List<UserData> followerList = [];
  List<UserData> followingList = [];
  OtherUserProfileData profileData;
  @override
  void initState() {
    super.initState();
    profileData = widget.profileData;
    tabController = TabController(vsync: this, length: 2);
    tabController.index = widget.index;

    Future.delayed(Duration.zero, () async {
      followerList = await followProvider.getFollowerList(profileData.id);
      followingList = await followProvider.getFollowingList(profileData.id);
      setState(() {
        followerList
            .removeWhere((element) => element.id == UserInfo.myProfile?.id);
        followingList
            .removeWhere((element) => element.id == UserInfo.myProfile?.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('followingList ${followingList.length}');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MColors.white_two,
          centerTitle: true,
          title: Text(
            profileData.name,
            style: MTextStyles.bold16Black,
          ),
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelPadding: EdgeInsets.only(left: 10, right: 10),
                labelStyle: MTextStyles.bold14Grey06,
                unselectedLabelStyle: MTextStyles.medium14PinkishGrey,
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: MColors.black),
                  insets: EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: MColors.pinkish_grey,
//                      isScrollable: true,
                tabs: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        '팔로워 ${profileData.followerCount}',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        '팔로잉 ${profileData.followingCount}',
                      )),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _userList(followerList),
            _userList(followingList),
          ],
        ));
  }

  Widget _userList(List<UserData> list) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final item = list[index];
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
                item.introduce ?? '',
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
                            color:
                                item.isFollow ? MColors.white : MColors.tomato,
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: item.isFollow
                                ? Text("팔로잉",
                                    style: MTextStyles.regular14Tomato)
                                : Text(
                                    "팔로우",
                                    style: MTextStyles.medium14White,
                                  ),
                            onPressed: () async {
                              bool result = false;
                              if (item.isFollow)
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
}
