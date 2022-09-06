import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/communityPage/community_detail.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';
import '../../../util.dart';
import '../feedPage/feed_detail_page.dart';
import 'follow_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController;
  TabController tabController;
  bool isGridStyle = true;
  bool isFollowing = false;

  double safeTopPadding = 0.0;
  final topMargin = 59.0;
  final backgroundHeight = 95.0;
  final tabHeight = 52.0;
  final profileRadius = 40.0;
  final feedHeaderHeight = 57.0;
  final profileHeight = 80.0;

  int selectedTabIndex = 0;
  String _selectedClassType = '활동중인 모임';

  double get _scrollOpacity {
    final expandedHeight = safeTopPadding +
        topMargin +
        backgroundHeight +
        240.0 +
        tabHeight +
        10.0;
    if (_scrollController.hasClients) {
      if (_scrollController.offset < 0) return 0.0;
      if (_scrollController.offset > expandedHeight) return 1.0;
      double opacity = (_scrollController.offset / expandedHeight);
      if (opacity < 0.7) return 0;
      return (opacity - 0.7) * 5;
    }
    return 0.0;
  }

  double get _scrollProgress {
    final expandedHeight = safeTopPadding +
        topMargin +
        backgroundHeight +
        240.0 +
        tabHeight +
        10.0;
    if (_scrollController.hasClients) {
      if (_scrollController.offset < 0) return 1.0;
      if (_scrollController.offset > expandedHeight) return 0.0;
      double progress = 1.0 - (_scrollController.offset / expandedHeight);
      progress = progress / 0.6;
      if (progress > 1.0) return 1.0;

      return progress;
    }
    return 1.0;
  }

  List<ClassData> classPlayingDataList = [];
  List<ClassData> classClosedDataList = [];
  bool foldPlayingList = false;
  bool foldClosedList = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
    Future.delayed(Duration.zero, () async {
      final userProfileProvider =
          Provider.of<OtherUserProfileProvider>(context, listen: false);
      userProfileProvider.fetchProfile();
      userProfileProvider.fetchUserFeeds();
      final classList = await userProfileProvider.getClassListForAdminstrator();
      classPlayingDataList = classList
          .where((classData) =>
              classData.status == 'CONFIRM_PLAYING' ||
              classData.status == 'PLAYING')
          .toList();
      classClosedDataList =
          classList.where((classData) => classData.status == 'CLOSED').toList();
    });
  }

  Future<void> getPullData() async {
    print('pull !!!!!!');
    final userProfileProvider =
        Provider.of<OtherUserProfileProvider>(context, listen: false);
    userProfileProvider.fetchProfile();
    userProfileProvider.fetchUserFeeds();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    safeTopPadding = MediaQuery.of(context).padding.top;

    final userProfileProvider = Provider.of<OtherUserProfileProvider>(context);
    final userProfileData = userProfileProvider.otherUserProfileData;
    final profileRadius = 40.0;
    final feedHeaderHeight = 57.0;
    final profileHeight = 80.0;
    final endOfBackground = safeTopPadding + topMargin + backgroundHeight;

    final List<FeedData> userFeedList =
        (userProfileProvider.userFeedList ?? []);
    //todo: 피드 없을때 처리

    final backgroundImage = userProfileData?.cover ?? '';
    //todo: 서버에 배경이미지가 없음

    String name = userProfileData?.name ?? '';
    if (name.length > 5) name = name.substring(0, 5);
    print('_scrollProgress = $_scrollProgress}');

    // print('userProfileData = ${userProfileData.instagramId}');

    return Stack(
      fit: StackFit.expand,
      children: [
        if (userProfileData != null)
          Scaffold(
            backgroundColor: MColors.white,
            body: RefreshIndicator(
              key: _refreshfeedIndicatorKey,
              onRefresh: getPullData,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  // Add the app bar to the CustomScrollView.
                  _buildProfile(context, backgroundImage, endOfBackground,
                      userProfileData, userProfileProvider, '', name),
                  if (selectedTabIndex == 0)
                    SliverAppBar(
                      // expandedHeight: endOfBackground + 240 + tabHeight + 10 + 40,
                      //todo:iPhone.se 에서 하단이 짤려서 길이 40 추가함. 왜 짤리는지 확인 필요
                      // flexibleSpace: _buildFlexibleSpace(),
                      pinned: true,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      // centerTitle: true,
                      // title: Opacity(
                      //     opacity: _scrollOpacity * 2.0 > 1.0 ? 1.0 : _scrollOpacity * 2.0,
                      //     child: Text(
                      //       name,
                      //       style: MTextStyles.bold18Black,
                      //     )),
                      title: _buildFeedBottom(userFeedList?.length),
                    ),
                  selectedTabIndex == 0
                      ? _buildFeedBody(userFeedList)
                      : _buildClassBody([]),
                ],
              ),
            ),
          )
        else
          SizedBox.shrink(),
      ],
    );
  }

  SliverMultiBoxAdaptorWidget _buildFeedBody(List<FeedData> userFeedList) {
    return (userFeedList?.length ?? 0) > 0
        ? isGridStyle
            ? SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final feedItem = userFeedList[index];
                    String content = feedItem.content;
                    if (content.contains('\n'))
                      content = content.split('\n')[0];
                    return InkWell(
                      child: feedItem.photos.length > 0
                          ? Image.network(
                              feedItem.photos[0],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              child: Center(
                                child: Text(
                                  content,
                                  maxLines: 4,
                                  style: MTextStyles.regular14Grey06,
                                ),
                              ),
                              color: Color.fromRGBO(248, 245, 241, 0.8),
                            ),
                      onTap: () {
                        Map<String, dynamic> _map = Map();
                        _map['feed'] = feedItem;
                        Navigator.of(context)
                            .pushNamed('FeedDetailPage', arguments: _map);
                      },
                    );
                  },
                  childCount: userFeedList.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final feedItem = userFeedList[index];
                    return FeedListItemWidget(context, feedItem);
                  },
                  childCount: userFeedList.length,
                ),
              )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 40),
                        ),
                        SvgPicture.asset(
                          'assets/icons/empty_feed.svg',
                          color: MColors.warm_grey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        Text(
                          '공유하는 피드가 없습니다.',
                          style: MTextStyles.regular16Warmgrey,
                        ),
                      ],
                    ));
              },
              childCount: 1,
            ),
          );
  }

  SliverMultiBoxAdaptorWidget _buildClassBody(List<MeetingItem> classList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return SizedBox.shrink();
          // if(index == 0)
          //   return _classGridView('진행중 모임', [], index);
          // else
          //   return _classGridView('완료된 모임', [], index);
        },
        childCount: 2,
      ),
    );
  }

  PreferredSize _buildFeedBottom(length) {
    return PreferredSize(
      preferredSize: Size.fromHeight(feedHeaderHeight),
      child: Container(
        color: MColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    style: const TextStyle(
                        color: MColors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    text: "${length ?? 0} "),
                TextSpan(
                    style: const TextStyle(
                        color: MColors.warm_grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    text: "피드")
              ])),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset('assets/icons/view_grid.svg',
                    color:
                        isGridStyle ? MColors.grey_06 : MColors.pinkish_grey),
                onPressed: () => setState(() => isGridStyle = true),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
            ),
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset('assets/icons/view_list.svg',
                    color:
                        !isGridStyle ? MColors.grey_06 : MColors.pinkish_grey),
                onPressed: () => setState(() => isGridStyle = false),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _classGridView(String _title, List<ClassData> list, int index) {
    // if (list == null || list.length == 0)
    //   return SizedBox.shrink();

    bool folded = (index == 0 && foldPlayingList) ||
        (index == 1 && foldClosedList) ||
        (list == null || list.length == 0);

    return Container(
      child: GestureDetector(
        onTap: () => setState(() {
          if (index == 0)
            foldPlayingList = !foldPlayingList;
          else
            foldClosedList = !foldClosedList;
        }),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DividerGrey12(),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      _title,
                      style: MTextStyles.bold16Black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "${list.length}건",
                        style: list.length == 0
                            ? MTextStyles.bold16PinkishGrey
                            : MTextStyles.bold16Tomato,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                )),
            if (!folded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  crossAxisCount: 2,
                  children: List.generate(list.length, (index) {
                    ClassData item = list[index];
                    SocialingData socialingData = SocialingData();
                    socialingData.id = item.id;
                    return InkWell(
                        onTap: () {
                          if (index == 0)
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => CommunityDetailPage(
                                    item.classType, item.id, item.name)));
                        },
                        child: ClassManageBox(
                          item,
                          hideManageButton: true,
                        ));
                  }),
                ),
              ),
            if (index == 1) DividerGrey12(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleSpace(
      BuildContext context,
      String backgroundImage,
      double endOfBackground,
      OtherUserProfileData userProfileData,
      OtherUserProfileProvider userProfileProvider,
      String userGrade,
      String name) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                icon: Icon(
                  Icons.more_horiz,
                ),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            top: safeTopPadding + topMargin,
            left: 0,
            right: 0,
            height: backgroundHeight,
            child: Image.network(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            top: endOfBackground - (profileHeight / 2) + 10,
            child: Container(
              width: double.infinity,
              height: profileHeight,
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(userProfileData?.image ?? ''),
                    radius: profileRadius,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 9),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '\n',
                        style: MTextStyles.bold18Black,
                      ),
                      TextSpan(
                        text: userGrade,
                        style: MTextStyles.regular10WarmGrey,
                      )
                    ]),
                  )),
                  if (userProfileData.facebookId != null &&
                      userProfileData.facebookId.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: 14, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child: Image.asset('assets/ico_profile_facebook.png'),
                          onTap: () async {
                            await launch(
                                'http://facebook.com/${userProfileData.facebookId}');
                          },
                        ),
                      ),
                    ),
                  if (userProfileData.instagramId != null &&
                      userProfileData.instagramId.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(right: 14, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child:
                              Image.asset('assets/ico_profile_instagram.png'),
                          onTap: () async {
                            await launch(
                                'http://instagram.com/${userProfileData.instagramId}');
                          },
                        ),
                      ),
                    ),
                  if (userProfileData.snsId != null &&
                      userProfileData.snsId.isNotEmpty &&
                      isURL(userProfileData.snsId))
                    Padding(
                      padding: EdgeInsets.only(right: 0, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child: Image.asset('assets/ico_profile_url.png'),
                          onTap: () async {
                            await launch(userProfileData.snsId);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // (1-_scrollProgress)*40 +
          Positioned(
            left: 20 + profileHeight + 9,
            top: (endOfBackground + 10),
            child: Opacity(
                opacity: _scrollProgress < 0.5
                    ? _scrollProgress * 0.05
                    : _scrollProgress,
                child: Text(name, style: MTextStyles.bold18Black)),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: endOfBackground + 70,
            child: Text(
              userProfileData.introduce ?? '소개가 없습니다.',
              style: MTextStyles.regular14Grey06,
              maxLines: 2,
            ),
          ),
          Positioned(
              left: 20,
              right: 20,
              top: endOfBackground + 130,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: List.generate(
                    userProfileData.interestList.length,
                    (index) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 1.0),
                          height: 22,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              color: MColors.white_two),
                          child: Text(
                            userProfileData.interestList[index],
                            style: MTextStyles.regular12Grey06,
                          ),
                        )),
              )),
          Positioned(
            left: 20,
            right: 20,
            top: endOfBackground + 186,
            height: 36,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FollowPage(
                            userProfileProvider.otherUserProfileData)));
                  },
                  child: Column(
                    children: <Widget>[
                      Text('팔로워', style: MTextStyles.regular10Grey06),
                      Text('${userProfileData.followerCount}',
                          style: MTextStyles.medium14Grey06)
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FollowPage(
                            userProfileProvider.otherUserProfileData,
                            index: 1)));
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        '팔로잉',
                        style: MTextStyles.regular10Grey06,
                      ),
                      Text('${userProfileData.followingCount}',
                          style: MTextStyles.medium14Grey06)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 25),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('피드', style: MTextStyles.regular10Grey06),
                      Text(
                        '${userProfileData.feedCount}',
                        style: MTextStyles.medium14Grey06,
                      )
                    ],
                  ),
                ),
                // Oval
                InkWell(
                  child: SvgPicture.asset(
                    'assets/icons/message_profile.svg',
                    color: MColors.warm_grey,
                  ),
                  onTap: () {
                    if (userProfileData.id == UserInfo.myProfile.id) {
                      Navigator.of(context).pushNamed('MessageListPage');
                      print('my page');
                    } else {
                      Navigator.of(context).pushNamed(
                        'MessageDetailPage',
                        arguments: userProfileData,
                      );
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                ),
                InkWell(
                  child: Container(
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                        color: userProfileData.isFollow
                            ? MColors.white
                            : MColors.tomato,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        border: Border.all(color: MColors.tomato, width: 1)),
                    child: // 팔로우
                        Center(
                      child: Text(userProfileData.isFollow ? '팔로잉' : '팔로우',
                          style: userProfileData.isFollow
                              ? MTextStyles.regular14Tomato
                              : MTextStyles.regular14White,
                          textAlign: TextAlign.center),
                    ),
                  ),
                  onTap: () async {
                    final loginPro =
                        Provider.of<LoginProvider>(context, listen: false);
                    if (loginPro.isGeneralUser) {
                      Util.showGeneralUserDialog(context);
                      return;
                    }
                    print('loginPro.isGeneralUser ${loginPro.isGeneralUser}');

                    return;

                    bool result = false;
                    if (userProfileData.isFollow)
                      result = await userProfileProvider.deleteFollow();
                    else
                      result = await userProfileProvider.postFollow();

                    if (result)
                      setState(() {
                        userProfileProvider.fetchProfile();
                      });
                  },
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: endOfBackground + 240,
            height: feedHeaderHeight,
            child: Container(
              color: MColors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: tabHeight,
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: MColors.blackColor,
                      indicatorWeight: 2.0,
                      labelStyle: MTextStyles.bold14Grey06,
                      unselectedLabelStyle: MTextStyles.regular14PinkishGrey,
                      onTap: (index) {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      tabs: [
                        Tab(text: "피드"),
                        Tab(text: "모임"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverList _buildProfile(
      BuildContext context,
      String backgroundImage,
      double endOfBackground,
      OtherUserProfileData userProfileData,
      OtherUserProfileProvider userProfileProvider,
      String userGrade,
      String name) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        switch (index) {
          case 0:
            return SafeArea(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ]),
            );
          case 1:
            // return Image.network(backgroundImage, fit: BoxFit.cover, height: 139,);
            return Container(
              width: double.infinity,
              height: backgroundHeight + profileHeight * 0.5 + 10,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: backgroundHeight,
                      child: Image.network(
                        backgroundImage,
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    bottom: 0,
                    left: 20.0,
                    right: 20.0,
                    height: profileHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          child: SizedBox(
                            width: profileRadius * 2.0,
                            height: profileRadius * 2.0,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userProfileData?.image ?? ''),
                                  radius: profileRadius,
                                ),
                                // SvgPicture.asset('assets/icons/profile_edit.svg', width: 24, height: 24,),
                              ],
                            ),
                          ),
                          onTap: () async {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 9),
                        ),
                        Expanded(
                            child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '$name\n',
                              style: MTextStyles.bold18Black,
                            ),
                            TextSpan(
                              text: userGrade,
                              style: MTextStyles.regular10WarmGrey,
                            )
                          ]),
                        )),
                        if (userProfileData.facebookId != null &&
                            userProfileData.facebookId.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 14, bottom: 4),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                child: Image.asset(
                                    'assets/ico_profile_facebook.png'),
                                onTap: () async {
                                  await launch(
                                      'http://facebook.com/${userProfileData.facebookId}');
                                },
                              ),
                            ),
                          ),
                        if (userProfileData.instagramId != null &&
                            userProfileData.instagramId.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 14, bottom: 4),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                child: Image.asset(
                                    'assets/ico_profile_instagram.png'),
                                onTap: () async {
                                  await launch(
                                      'http://instagram.com/${userProfileData.instagramId}');
                                },
                              ),
                            ),
                          ),
                        if (userProfileData.snsId != null &&
                            userProfileData.snsId.isNotEmpty &&
                            isURL(userProfileData.snsId))
                          Padding(
                            padding: EdgeInsets.only(right: 0, bottom: 4),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: InkWell(
                                child:
                                    Image.asset('assets/ico_profile_url.png'),
                                onTap: () async {
                                  await launch(userProfileData.snsId);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );

          case 2:
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 24.0, bottom: 16.0),
              child: Text(
                userProfileData.introduce ?? '소개가 없습니다.',
                style: MTextStyles.regular14Grey06,
                maxLines: 2,
              ),
            );
          case 3:
            return userProfileData.interestList.length == 0
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: List.generate(
                          userProfileData.interestList.length,
                          (index) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 1.0),
                                height: 22,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    color: MColors.white_two),
                                child: Text(
                                  Interest.getNameByValue(
                                      userProfileData.interestList[index]),
                                  style: MTextStyles.regular12Grey06,
                                ),
                              )),
                    ),
                  );

          case 4:
            return Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 38.0, bottom: 24.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FollowPage(
                              userProfileProvider.otherUserProfileData)));
                    },
                    child: Column(
                      children: <Widget>[
                        Text('팔로워', style: MTextStyles.regular10Grey06),
                        Text('${userProfileData.followerCount}',
                            style: MTextStyles.medium14Grey06)
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 25),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FollowPage(
                              userProfileProvider.otherUserProfileData,
                              index: 1)));
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          '팔로잉',
                          style: MTextStyles.regular10Grey06,
                        ),
                        Text('${userProfileData.followingCount}',
                            style: MTextStyles.medium14Grey06)
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 25),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('피드', style: MTextStyles.regular10Grey06),
                        Text(
                          '${userProfileData.feedCount}',
                          style: MTextStyles.medium14Grey06,
                        )
                      ],
                    ),
                  ),
                  // Oval
                  InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/message_profile.svg',
                      color: MColors.warm_grey,
                    ),
                    onTap: () {
                      if (userProfileData.id == UserInfo.myProfile.id) {
                        Navigator.of(context).pushNamed('MessageListPage');
                        print('my page');
                      } else {
                        Navigator.of(context).pushNamed(
                          'MessageDetailPage',
                          arguments: userProfileData,
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                  ),
                  InkWell(
                    child: Container(
                      width: 80,
                      height: 36,
                      decoration: BoxDecoration(
                          color: userProfileData.isFollow
                              ? MColors.white
                              : MColors.tomato,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: MColors.tomato, width: 1)),
                      child: // 팔로우
                          Center(
                        child: Text(userProfileData.isFollow ? '팔로잉' : '팔로우',
                            style: userProfileData.isFollow
                                ? MTextStyles.regular14Tomato
                                : MTextStyles.regular14White,
                            textAlign: TextAlign.center),
                      ),
                    ),
                    onTap: () async {
                      final loginPro =
                          Provider.of<LoginProvider>(context, listen: false);
                      if (loginPro.isGeneralUser || loginPro.guestYn == 'Y') {
                        return;
                      }
                      bool result = false;
                      if (userProfileData.isFollow)
                        result = await userProfileProvider.deleteFollow();
                      else {
                        AppStateLog(context, FOLLOW_MEMBER, properties: {
                          'sourceId': '${userProfileData?.id ?? ''}',
                        });
                        result = await userProfileProvider.postFollow();
                      }

                      if (result)
                        setState(() {
                          userProfileProvider.fetchProfile();
                        });
                    },
                  )
                ],
              ),
            );

          case 5:
            return SizedBox.shrink();
          // return Container(
          //   height: tabHeight,
          //   margin: EdgeInsets.only(top: 16.0, right: 20.0, left: 20.0),
          //   child: TabBar(
          //     controller: tabController,
          //     indicatorColor: MColors.blackColor,
          //     indicatorWeight: 2.0,
          //     labelStyle: MTextStyles.bold14Grey06,
          //     unselectedLabelStyle: MTextStyles.regular14PinkishGrey,
          //     onTap: (index) {
          //       setState(() => selectedTabIndex = index);
          //     },
          //     tabs: [
          //       Tab(text: "피드"),
          //       Tab(text: "모임"),
          //     ],
          //   ),
          // );
        }
        return SizedBox.shrink();
      }, childCount: 7),
    );
  }
}
