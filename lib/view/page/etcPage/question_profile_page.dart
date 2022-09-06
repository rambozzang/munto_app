import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/feed_image_list_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/provider/question_provider.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';
import 'package:munto_app/model/question_data.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/etcPage/tag_writers_list.dart';
import 'package:munto_app/view/page/feedPage/feed_detail_page.dart';
import 'package:munto_app/view/page/myPage/myMain_Page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:munto_app/view/widget/error_page.dart';

import '../../../app_state.dart';
import '../../../util.dart';

class QuestionProfilePage extends StatefulWidget {
  final QuestionData questionData;
  QuestionProfilePage(this.questionData);
  @override
  _QuestionProfilePageState createState() => _QuestionProfilePageState();
}

class _QuestionProfilePageState extends State<QuestionProfilePage>
    with TickerProviderStateMixin {
  TabController tabController;
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollCtrl = new ScrollController();
  ScrollController _scrollviewCtrl = new ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshPictureIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  FeedProvider feedProvider = FeedProvider();
  QuestionProvider questionProvider = QuestionProvider();

  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();
  final StreamController<Response<List<FeedData>>> _feedCtrl =
      BehaviorSubject();

  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  int page = 1;
  int picturePage = 1;
  bool dataPageListisMoreBool = true;
  List<FeedData> feedList = [];

  // Gallery
  final StreamController<Response<List<Map<String, dynamic>>>> _galleryCtrl =
      BehaviorSubject();
  List<FeedImageListData> picturelist = [];
  List<Map<String, dynamic>> imageList = [];
  bool dataPicturePageListisMoreBool = true;

  bool isGridStyle = true;

  final topMargin = 59.0;
  final backgroundHeight = 95.0;
  final tabHeight = 52.0;
  final profileRadius = 40.0;
  final feedHeaderHeight = 57.0;
  final profileHeight = 80.0;

  int selectedTabIndex = 0;

  double get _scrollOpacity {
    final expandedHeight =
        topMargin + backgroundHeight + 240.0 + tabHeight + 10.0;
    if (_scrollController.hasClients) {
      if (_scrollController.offset < 0) return 0.0;
      if (_scrollController.offset > expandedHeight) return 1.0;
      // return (_scrollController.offset / expandedHeight);
      double opacity = (_scrollController.offset / expandedHeight);
      if (opacity < 0.9) return 0;
      return (opacity - 0.9) * 10;
    }
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
    _notifier.value = true;
    _getMemebers();
    _getMoreFeeds();
    AppStateLog(context, PAGEVIEW_QUESTION_DETAIL);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          backgroundColor: MColors.white_two,
          body: RefreshIndicator(
            backgroundColor: MColors.white,
            key: _refreshfeedIndicatorKey,
            onRefresh: _getMemebers,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                // Add the app bar to the CustomScrollView.
                _buildProfile(context, widget.questionData),
                if (selectedTabIndex == 0)
                  SliverAppBar(
                    expandedHeight: 10.0,
                    pinned: true,
                    title: _buildFeedBottom(feedList?.length, '123'),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(barBorderWidth),
                      child: Container(
                        height: barBorderWidth,
                        color: MColors.barBorderColor,
                      ),
                    ),
                  ),
                _buildFeedBody(feedList)
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(context).pushNamed(
                      'FeedWritePage',
                      arguments: {'tags': widget.questionData.tagList});
                  print(result ? '피드쓰기 성공' : '피드쓰기 실패');

                  if (result) {
                    page = 1;
                    _getMoreFeeds();
                    _getMemebers();
                    Provider.of<BottomNavigationProvider>(context,
                            listen: false)
                        .refreshLoungeFeed();
                    AppStateLog(context, UPLOAD_FEED);
                  }
                },
                child: Container(
                  width: 220,
                  height: 52,
                  color: MColors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          '내 이야기 쓰기',
                          style: MTextStyles.medium12Grey06_04,
                        )),
                        CircleAvatar(
                          backgroundColor: MColors.grey_06,
                          child: Icon(
                            Icons.edit_outlined,
                            color: MColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }

  SliverList _buildProfile(BuildContext context, QuestionData data) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        switch (index) {
          case 0:
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    color: MColors.white_two,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  PreferredSize(
                    preferredSize: Size.fromHeight(barBorderWidth),
                    child: Container(
                      height: barBorderWidth,
                      color: MColors.barBorderColor,
                    ),
                  )
                ],
              ),
            );
          case 1:
            return Container(
              color: MColors.white,
              height: 134,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    widget.questionData.imagePath,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/icons/quotes.svg',
                      color: MColors.white,
                    ),
                  ),
                ],
              ),
            );
          case 2:
            return Column(
              children: [
                Container(
                    // width: 50,
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: StreamBuilder<Response<List<UserData>>>(
                        stream: _memberListCtrl.stream,
                        builder: (context, snapshot) {
                          return _getStreamBuild(snapshot);
                        }))
              ],
            );
        }
        return SizedBox.shrink();
      }, childCount: 3),
    );
  }

  PreferredSize _buildFeedBottom(length, name) {
    return PreferredSize(
      preferredSize: Size.fromHeight(feedHeaderHeight),
      child: Stack(
        children: [
          Container(
            color: MColors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
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
                        color: isGridStyle
                            ? MColors.grey_06
                            : MColors.pinkish_grey),
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
                        color: !isGridStyle
                            ? MColors.grey_06
                            : MColors.pinkish_grey),
                    onPressed: () => setState(() => isGridStyle = false),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16.0,
            child: IgnorePointer(
              child: Opacity(
                  opacity:
                      _scrollOpacity * 2.0 > 1.0 ? 1.0 : _scrollOpacity * 2.0,
                  child: Text(
                    name,
                    style: MTextStyles.bold18Black,
                    textAlign: TextAlign.center,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  _buildFeedBody(List<FeedData> userFeedList) {
    // return StreamBuilder<Response<List<FeedData>>>(
    //     stream: _feedCtrl.stream,
    //     builder: (BuildContext context,
    //         AsyncSnapshot<Response<List<FeedData>>> snapshot) {
    //       if (snapshot.hasData) {
    //         switch (snapshot.data.status) {
    //           case Status.LOADING:
    //             return Center(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(68.0),
    //                   child: CircularProgressIndicator(),
    //                 ));
    //             break;
    //           case Status.ERROR:
    //             return Error(
    //               errorMessage: snapshot.data.message,
    //               onRetryPressed: () => null, // getPullFeedData(),
    //             );
    //             break;
    //           case Status.COMPLETED:
    //             return _buildFeedList(snapshot.data.data);
    //             break;
    //         }
    //       }
    //       return Center(
    //           child: Padding(
    //             padding: const EdgeInsets.all(48.0),
    //             child: CircularProgressIndicator(),
    //           ));
    //     });

    return (userFeedList?.length ?? 0) > 0
        ? isGridStyle
            ? _buildGrid(userFeedList)
            : _buildListStyle(userFeedList)
        : _buildNoFeeds();
  }

  SliverGrid _buildGrid(userFeedList) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feedItem = userFeedList[index];
          String content = feedItem.content;
          if (content.contains('\n')) content = content.split('\n')[0];
          return Container(
            color: MColors.white,
            padding: const EdgeInsets.all(0.0),
            child: InkWell(
              child: feedItem.photos.length > 0
                  ? CachedNetworkImage(
                      imageUrl: feedItem.photos[0],
                      fit: BoxFit.cover,
                    )
                  : Container(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          content,
                          maxLines: 4,
                          style: MTextStyles.regular14Grey06,
                        ),
                      ),
                      color: Color.fromRGBO(248, 245, 241, 0.8),
                    ),
              onTap: () async {
                await Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                          create: (_) => FeedDetailProvider(feedItem),
                          child: FeedDetailPage(feedItem),
                        )));

                page = 1;
                _getMoreFeeds();
                _getMemebers();
                print('_getMemebers');
                print('_getMoreFeeds');
              },
            ),
          );
        },
        childCount: feedList.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
      ),
    );
  }

  SliverList _buildListStyle(userFeedList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final feedItem = userFeedList[index];
          return FeedListItemWidget(
            context,
            feedItem,
            needsRefresh: (feedData) {
              final userProfileProvider =
                  Provider.of<OtherUserProfileProvider>(context, listen: false);
              userProfileProvider.fetchProfile();
              userProfileProvider.fetchUserFeeds();
            },
          );
        },
        childCount: userFeedList.length,
      ),
    );
  }

  SliverList _buildNoFeeds() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                  ),
                  SvgPicture.asset(
                    'assets/icons/empty_feed.svg',
                    color: MColors.warm_grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  Text(
                    '피드가 없습니다.',
                    style: MTextStyles.regular16Warmgrey,
                  ),
                ],
              ));
        },
        childCount: 1,
      ),
    );
  }

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
                  height: 134,
                  child: Center(
                      child: Text(
                    '함께하는 멤버가 없습니다.',
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

  Widget _buildattendeeList(List<UserData> list) {
    return Container(
      height: 136.0,
      color: MColors.white_two,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 16.0, top: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('함께하는 멤버들', style: MTextStyles.bold16Black2),
                Padding(
                  padding: const EdgeInsets.only(left: 7, right: 4),
                  child: Icon(
                    Icons.people,
                    color: MColors.warm_grey08,
                    size: 16.0,
                  ),
                ),
                Expanded(
                    child: Text('${list.length ?? 0}',
                        style: MTextStyles.regular12WarmGrey08)),
                GestureDetector(
                  child: Text(
                    "모두 보기",
                    style: MTextStyles.bold12Grey06,
                  ),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => TagWritersPage(
                            widget.questionData.mainTag,
                            widget.questionData.id)));
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (UserInfo.myProfile.id == list[index].id) {
                      final provider = Provider.of<BottomNavigationProvider>(
                          context,
                          listen: false);
                      AppStateLog(context, PAGEVIEW_MY_PROFILE);
                      provider.setIndex(4);
                    } else {
                      // 다른이면 유저프로필
                      Navigator.of(context).pushNamed('UserProfilePage',
                          arguments: list[index].id.toString());
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(10, 0),
                    child: Container(
                      width: 48.0 + 16.0,
                      height: 60,
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(list[index].image),
                            radius: 24.0,
                          ),
                          Text(
                            '${list[index].name}',
                            softWrap: false,
                            overflow: TextOverflow.clip,
                            style: MTextStyles.medium10Grey06,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void getDataList(tabindex) {
    print('getDataList : $tabindex');
    if (tabindex == 0) {
      // feedLIst 가져오기
      if (dataPageListisMoreBool) {
        _getMoreFeeds();
      }
    } else if (tabindex == 1) {
      // // 픽쳐 가져오기.
      // if (dataPicturePageListisMoreBool) {
      //   getGalleyData();
      // }
      // print('picture !@@@@@@');
    }
  }

  Future<void> _getMoreFeeds() async {
    if (page == 1) {
      _feedCtrl.sink.add(Response.loading());
      feedList = [];
    }

    try {
      print(
          '==== feed 가져오기 시작 _getMoreData() ====================================');

      List<FeedData> list = await questionProvider.getTagFeeds(
          widget.questionData.id.toString(), page);
      // 임시용
      //  List<FeedData> list = await Provider.of<FeedProvider>(context, listen: false).fectchPage(page);
      print(
          '==== feed 가져오기 완료 _getMoreData() ==================================+=');

      dataPageListisMoreBool = list.length == 10 ? true : false;

      feedList.addAll(list);
      if (!kReleaseMode) {
        // feedList.addAll(list);
        // feedList.addAll(list);
        // feedList.addAll(list);
        // feedList.addAll(list);
        // feedList.addAll(list);
        // feedList.addAll(list);
      }
      // _feedCtrl.sink.add(Response.completed(list));
      setState(() {});
      page++;
    } catch (e) {
      print('error : ${e.toString()}');
      _feedCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> _getMemebers() async {
    try {
      _memberListCtrl.sink.add(Response.loading());
      Map<String, dynamic> _map = Map();

      print('==== 맴버 가져오기 시작 ====================================');
      List<UserData> writers =
          await questionProvider.getWriters(widget.questionData.id);
      print('==== 맴버 가져오기 완료 ==================================+=');

      if (writers == null || writers.length == 0) {
        _notifier.value = false;
        _memberListCtrl.sink.add(Response.completed([]));
      } else {
        _notifier.value = true;
        // final list = kReleaseMode? writers : (writers + writers + writers);
        final list = writers;
        _memberListCtrl.sink.add(Response.completed(list));
      }
    } catch (e) {
      print(e.toString());
      _memberListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _memberListCtrl.close();
    _feedCtrl.close();
    // _itemInfoCtrl.close();
    _scrollviewCtrl.dispose();
    _scrollCtrl.dispose();
    _galleryCtrl.close();
    super.dispose();
  }
}
