import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/class_Proceeding_Rounds_Data.dart';
import 'package:munto_app/model/feed_image_list_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/photos_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/model/socialing_Detail_data.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/communityPage/community_userList.dart';
import 'package:munto_app/view/page/galleryPage/gallery_detail.dart';
import 'package:munto_app/view/page/galleryPage/gallery_list.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/error_page.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app_state.dart';
import '../../../util.dart';

const _tabs = [
  '게시판',
  '사진',
  '정보',
];

class CommunityDetailPage extends StatefulWidget {
  final String classType;
  final int itemId;
  final String className;

  CommunityDetailPage(this.classType, this.itemId, this.className);

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage>
    with TickerProviderStateMixin {
  TabController tabController;
  ScrollController _scrollCtrl = new ScrollController();
  ScrollController _scrollviewCtrl = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshPictureIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // 서비스 정의 소셜링
  SocialingProvider socialingProvider = SocialingProvider();
  ItemProvider itemProvider = ItemProvider();
  ClassProvider classProvider = ClassProvider();
  FeedProvider feedProvider = FeedProvider();

  // 소셜링 기본 정보 가져오기
  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();
  // final StreamController<Response<List<ClassProceedingRoundsData>>> _itemInfoCtrl = StreamController();
  final StreamController<Response<SocialingDetailData>> _itemInfoCtrl =
      BehaviorSubject();
  final StreamController<Response<List<FeedData>>> _feedCtrl =
      BehaviorSubject();

  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  // 게시판(피드리스트 ) 관련 변수
  int page = 1;
  int picturePage = 1;
  bool dataPageListisMoreBool = true;
  List<FeedData> feeList = [];

  // TabbarView common 스트림
  List<dynamic> commonData = [];
  List<ClassProceedingRoundsData> classProceedingRoundsData = [];

  // Gallery
  final StreamController<Response<List<Map<String, dynamic>>>> _galleryCtrl =
      BehaviorSubject();
  List<FeedImageListData> picturelist = [];
  List<Map<String, dynamic>> imageList = [];
  bool dataPicturePageListisMoreBool = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 3,
    );
    _notifier.value = true;

    // 상단 맴버리스트 가져오기
    _getItemMemebers();

    // tab 1 feed 리스트 가져오기
    _getMoreData();

    // tab 2 정보 가져오기
    getGalleyData();

    // tab 3 정보 가져오기
    _getItemInfo();
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

      if (memberList.length == 0) {
        _notifier.value = false;
        _memberListCtrl.sink.add(Response.completed([]));
      } else {
        _notifier.value = true;
        _memberListCtrl.sink.add(Response.completed(memberList));
      }
    } catch (e) {
      print(e.toString());
      _memberListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  // 정보 가져오기 임시 소셜링 상세 api 로 대체
  Future<void> _getItemInfo() async {
    // try {
    //   _itemInfoCtrl.sink.add(Response.loading());
    //   String itemId = widget.itemId.toString();
    //   String classType = widget.classType.toString();
    //   print('==== _getItemInfo 가져오기 시작 ====================================');
    //   classProceedingRoundsData = await itemProvider.getItemRoundInfo(classType, itemId);
    //   print('==== _getItemInfo 가져오기 완료 ==================================+=');

    //   _itemInfoCtrl.sink.add(Response.completed(classProceedingRoundsData));
    // } catch (e) {
    //   print('_itemInfoCtrl : ${e.toString()}');
    //   _itemInfoCtrl.sink.add(Response.error(e.toString()));
    // }

    try {
      _itemInfoCtrl.sink.add(Response.loading());
      int randomNumber = Random().nextInt(70);
      String socialId = widget.itemId.toString();
      if (socialId == null || socialId == '') {
        socialId = randomNumber.toString();
      }

      SocialingDetailData socialingData =
          await socialingProvider.detailData(socialId);
      _itemInfoCtrl.sink.add(Response.completed(socialingData));
    } catch (e) {
      _itemInfoCtrl.sink.add(Response.error(e.toString()));
    }
  }

  // tab 1 게시판  feed list 가져오기
  Future<void> _getMoreData() async {
    if (page == 1) {
      _feedCtrl.sink.add(Response.loading());
      feeList = [];
    }

    try {
      String socialId = widget.itemId.toString();
      String classType = widget.classType.toString();
      print(
          '==== feed 가져오기 시작 _getMoreData() ====================================');

      List<FeedData> list =
          await Provider.of<FeedProvider>(context, listen: false)
              .getFeedClassTypeClassIdSkipTake(classType, socialId, page);
      // 임시용
      //  List<FeedData> list = await Provider.of<FeedProvider>(context, listen: false).fectchPage(page);
      print(
          '==== feed 가져오기 완료 _getMoreData() ==================================+=');

      dataPageListisMoreBool = list.length == 10 ? true : false;

      feeList.addAll(list);
      _feedCtrl.sink.add(Response.completed(list));
      page++;
    } catch (e) {
      print('error : ${e.toString()}');
      _feedCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getPullFeedData() async {
    page = 1;
    await _getMoreData();
  }

  // Tab scrolll 시 발생하는 이벤트 제어
  void getDataList(tabindex) {
    print('getDataList : $tabindex');
    if (tabindex == 0) {
      // feedLIst 가져오기
      if (dataPageListisMoreBool) {
        _getMoreData();
      }
    } else if (tabindex == 1) {
      // 픽쳐 가져오기.
      if (dataPicturePageListisMoreBool) {
        getGalleyData();
      }

      print('picture !@@@@@@');
    } else if (tabindex == 2) {
      _getItemInfo();
    }
  }

  Future<void> getPullPcitureData() async {
    picturePage = 1;
    await getGalleyData();
  }

  Future<void> getGalleyData() async {
    try {
      if (picturePage == 1) {
        imageList = [];
      }
      _galleryCtrl.sink.add(Response.loading());

      List<FeedImageListData> currentlist =
          await feedProvider.getCommunitiPictureList(
              widget.classType, widget.itemId, picturePage);

      currentlist.asMap().forEach((index, value) {
        currentlist[index].photos.forEach((val) {
          Map<String, dynamic> _item = Map();
          _item['item'] = currentlist[index];
          _item['photos'] = val;
          imageList.add(_item);
        });
      });

      dataPicturePageListisMoreBool = currentlist.length == 10 ? true : false;

      _galleryCtrl.sink.add(Response.completed(imageList));
      picturePage++;
    } catch (e) {
      print(e.toString());
      _galleryCtrl.sink
          .add(Response.error('gallery_list.dart 77 line : ${e.toString()}'));
    }
  }

  @override
  void dispose() {
    _memberListCtrl.close();
    _feedCtrl.close();
    _itemInfoCtrl.close();
    _scrollviewCtrl.dispose();
    _scrollCtrl.dispose();
    _galleryCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: ValueListenableBuilder<bool>(
            valueListenable: _notifier,
            builder: (context, value, _) {
              return _buildBody(value);
            }));
  }

  Widget _appBar() {
    return AppBar(
        title: Text(
          widget.className ?? '-',
          style: MTextStyles.bold18Black,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: MColors.barBackgroundColor,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(barBorderWidth),
            child: Container(
              height: barBorderWidth,
              color: MColors.barBorderColor,
            )));
  }

  Widget _buildBody(hasMember) {
    return DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
            controller: _scrollCtrl,
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                          height: 130,
                          // width: 50,
                          padding: EdgeInsets.only(
                              left: 15, right: 25, top: 25, bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: StreamBuilder<Response<List<UserData>>>(
                              stream: _memberListCtrl.stream,
                              builder: (context, snapshot) {
                                return _getStreamBuild(snapshot);
                              })),
                      //    }),
                      Divider(height: 1, color: MColors.grey_05),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    TabBar(
                      //  controller: tabController,
                      labelStyle: MTextStyles.bold14BlackColor,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      unselectedLabelStyle: MTextStyles.regular14Warmgrey,

                      indicatorColor: MColors.blackColor,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0),
                          insets: EdgeInsets.symmetric(horizontal: 16.0)),
                      tabs: _tabs
                          .map((String name) => SizedBox(
                                height: 52.0,
                                child: Center(child: Text('$name')),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ];
            },
            body: Builder(builder: (BuildContext context) {
              final innerScrollController1 =
                  PrimaryScrollController.of(context);
              innerScrollController1.addListener(() {
                if (innerScrollController1.position.pixels ==
                        innerScrollController1.position.maxScrollExtent &&
                    DefaultTabController.of(context).index == 0) {
                  getDataList(DefaultTabController.of(context).index);
                }
              });
              return _buildTabbar(context);
            })));
  }

  // 상단 맴버리스트 구성
  Widget _getStreamBuild(snapshot) {
    print('snapshot = ${snapshot.toString()}');
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
              ? _buildattendeeList(list)
              : Container(
                  height: 130,
                  child: Center(
                      child: Text(
                    '참여중인 멤버가 없습니다.',
                    style: MTextStyles.regular14WarmGrey,
                  )));
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

  // tabbarview 구성하기
  Widget _buildTabbar(BuildContext context) {
    return TabBarView(
      // controller: tabController,
      children: <Widget>[
        SafeArea(child: _buildTabbar1()),
        SafeArea(child: buildSingleChildScrollView()),
        // SafeArea(
        //     child: GalleryList(
        //   classType: widget.classType,
        //   itemId: widget.itemId,
        // )),
        SafeArea(child: _buildCurriculum()),
        // _buildMemberList(),
      ],
    );
  }

  Widget _buildTabbar1() {
    return StreamBuilder<Response<List<FeedData>>>(
        stream: _feedCtrl.stream,
        builder: (BuildContext context,
            AsyncSnapshot<Response<List<FeedData>>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(68.0),
                  child: CircularProgressIndicator(),
                ));
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => null, // getPullFeedData(),
                );
                break;
              case Status.COMPLETED:
                return _buildFeedList(snapshot.data.data);
                break;
            }
          }
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: CircularProgressIndicator(),
          ));
        });
  }

  // tab 1 : 피드 리스트 가져오기
  Widget _buildFeedList(list) {
    return RefreshIndicator(
      key: _refreshfeedIndicatorKey,
      onRefresh: getPullFeedData,
      child: SingleChildScrollView(
          // controller: controller,
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            Container(
              color: MColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: <Widget>[
                  // CircleAvatar(
                  //   //  backgroundImage: NetworkImage(item.user.image),
                  //   radius: 15,
                  // ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 34.0),
                    child: Text(
                      "${UserInfo.myProfile.name}님, 모임을 더욱 풍성하게 해줄 이야기를 들려주세요!",
                      style: MTextStyles.regular12Grey06,
                      maxLines: 2,
                    ),
                  )),
                  // Rectangle Copy
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        border:
                            Border.all(color: MColors.white_three, width: 1)),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/ico_wrtite.png',
                            width: 18,
                            height: 18,
                          ),
                          Text("글쓰기", style: MTextStyles.regular12Grey06),
                        ],
                      ),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, 'FeedWritePage',
                            arguments: widget.classType.toLowerCase() == 'item'
                                ? {
                                    'classId': widget.itemId.toString(),
                                    'itemId': widget.itemId.toString()
                                  }
                                : {
                                    'classId': widget.itemId.toString(),
                                    'socialingId': widget.itemId.toString()
                                  });
                        if (result) {
                          getPullFeedData();
                          getPullPcitureData();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            list == null || list.length == 0
                ? Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: _noDataWidgetBig(),
                  )
                : ListView.builder(
                    itemCount: list.length + 1, //+1 for progressbar
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == list.length) {
                        if (dataPageListisMoreBool) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      } else {
                        return FeedListItemWidget(context, list[index]);
                      }
                    },
                  )
          ])),
    );
  }

  // 상단 맴버 리스트
  Widget _buildattendeeList(List<UserData> list) {
    print('list = ${list.length}');

    int len = list.length;
    int displayLen = 0;
    len = len > 6 ? 6 : len;
    displayLen = len - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(len, (index) {
        if (index == displayLen && index > 4) {
          return Flexible(child: _buildAvatarMore(list[index], list));
        } else {
          return Flexible(child: _buildAvatar(list[index]));
        }
      }),
    );
  }

  // 상단 맴버 아바타
  Widget _buildAvatar(UserData item) {
    return InkWell(
      onTap: () {
        // 본인이면 마이프로필
        if (UserInfo.myProfile.id == item.id) {
          final provider =
              Provider.of<BottomNavigationProvider>(context, listen: false);
          AppStateLog(context, PAGEVIEW_MY_PROFILE);
          provider.setIndex(4);
        } else {
          // 다른이면 유저프로필
          Navigator.of(context)
              .pushNamed('UserProfilePage', arguments: item.id.toString());
        }
      },
      child: Ink(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            item.image != '' || item.image != null
                ? CircleAvatar(
                    //     backgroundColor: MColors.white_three,
                    backgroundImage: NetworkImage(item.image),
                    radius: 30,
                  )
                : CircleAvatar(
                    backgroundColor: MColors.white_three,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: MColors.white,
                      size: 50,
                    ),
                  ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                '${item.name}',
                softWrap: false,
                overflow: TextOverflow.clip,
                style: MTextStyles.medium10Grey06,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarMore(UserData item, List<UserData> list) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) => CommunityUserList(
                widget.classType, widget.className, widget.itemId)));
      },
      child: Ink(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: MColors.white_three,
              radius: 30,
              child: SvgPicture.asset(
                'assets/groups-24px.svg',
                width: 35,
                height: 35,
                color: Colors.black,
                //fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(height: 6),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '모두보기',
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: MTextStyles.medium10Grey06,
                )),
          ],
        ),
      ),
    );
  }

  // 3.정보 Tab
  Widget _buildCurriculum() {
    return SingleChildScrollView(
      key: PageStorageKey('3'),
      physics: BouncingScrollPhysics(),
      child: StreamBuilder<Response<SocialingDetailData>>(
          stream: _itemInfoCtrl.stream,
          builder:
              (context, AsyncSnapshot<Response<SocialingDetailData>> snapshot) {
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
                  SocialingDetailData item = snapshot.data.data;
                  return Column(
                    children: [
                      Container(
                        color: MColors.whiteColor,
                        margin: EdgeInsets.only(top: 0.5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Text("모임 시작 전",
                                  style: MTextStyles.bold20Black36),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 24,
                                          color: MColors.warm_grey,
                                        ),
                                        SizedBox(width: 4),
                                        Text('${item.location}',
                                            style: MTextStyles.regular16Grey06)
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/calendar.svg',
                                            color: MColors.warm_grey),
                                        SizedBox(width: 4),
                                        Text(
                                            item.startDateTime != null
                                                ? '${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                                    '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}시'
                                                : '',
                                            style: MTextStyles.regular16Grey06)
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Divider1(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Text("준비사항",
                                  style: MTextStyles.bold20Black36),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                child: Text('• ${item.preparation}',
                                    style: MTextStyles.regular16Grey06)),
                            // Padding(
                            //     padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            //     child: Text('• 페스티벌을 즐길 수 있는 여유로운 마음', style: MTextStyles.regular16Grey06)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Divider1(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: Text("모임 소개",
                                  style: MTextStyles.bold20Black36),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13.0),
                                child: Image.network('${item.cover}'),
                              ),
                            ),
                            // 처음 모인 멤버들을 보며 글을 써봅시
                            Text("${item.introduce}",
                                style: MTextStyles.medium14Grey06),
                            SizedBox(height: 20),
                            // Text(
                            //     "글쓰기를 좀 더 대수롭지 않게 생각해보는 모임입니다. 무언가를 쓰고 싶은데 뭘 써야할 지 모를 때, 쓰고 싶은 것이 있는데  어떻게 써야 할 지 모를 때, 조금은 의지해 볼 수 있는 모임입니다.",
                            //     style: MTextStyles.medium14Grey06),
                          ],
                        ),
                      ),
                    ],
                  );
                  break;
                case Status.ERROR:
                  return Center(
                    child: Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: null,
                    ),
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
    );
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
          Center(child: Text('피드가 없습니다.', style: MTextStyles.medium16WarmGrey)),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // 전체 데이타 없을 경우
  Widget _noDataWidgetBig() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NodataImage(
                wid: 80.0,
                hei: 80.0,
                path: 'assets/mypage/empty_orderhistory_60_px.svg'),
            Center(
                child: Text('피드가 없습니다.', style: MTextStyles.medium16WarmGrey)),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '-';
    }
  }

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  Widget buildChip(String chip) {
    return Chip(
      label: Text(
        chip,
        style: MTextStyles.regular10Grey06,
      ),
      backgroundColor: MColors.white_two,
    );
  }

  Widget buildSingleChildScrollView() {
    return StreamBuilder<Response<List<Map<String, dynamic>>>>(
        stream: _galleryCtrl.stream,
        builder: (BuildContext context,
            AsyncSnapshot<Response<List<Map<String, dynamic>>>> snapshot) {
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
                List<Map<String, dynamic>> list = snapshot.data.data;
                return list.length > 0
                    ? _buildGradView(list)
                    : _noDataWidgetBig();
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => getGalleyData(),
                );
                break;
            }
          }
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: CircularProgressIndicator(),
          ));
        });
  }

  Widget _buildGradView(map) {
    return RefreshIndicator(
      key: _refreshPictureIndicatorKey,
      onRefresh: getPullPcitureData,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
            itemCount: map.length,
            itemBuilder: (context, index) {
              FeedImageListData item = map[index]['item'];
              PhotosData photo = map[index]['photos'];

              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => GalleryDetail(item, index)));
                  },
                  child: _getImage(photo.photo));
            }),
      ),
    );
  }

  _getImage(String photo) {
    return CachedNetworkImage(
      imageUrl: photo,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
          decoration: new BoxDecoration(
              // color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(8)),
          child: SvgPicture.asset(
            'assets/mypage/no_img.svg',
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          )),
      width: double.infinity,
      //  height: 83 * sizeWidth360,
      fit: BoxFit.cover,
    );
  }
  // _getChild(String img) {
  //   if (item.photos[0].isNotEmpty)
  //     return Image.network(
  //       item.photos[0],
  //       fit: BoxFit.cover,
  //     );
  //   else
  //     return Container();
  // }

}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => 52; // tabbar 높이

  @override
  double get maxExtent => 52; // tabbar 높이

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: MColors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
