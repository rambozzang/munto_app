import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/eventbus/feed_upload_finished.dart';
import 'package:munto_app/model/eventbus/profile_updated_event.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/item_reviews_data.dart';
import 'package:munto_app/model/item_subject_data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/item_impended_provider.dart';
import 'package:munto_app/model/provider/item_popular_provider.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/item_playing_provider.dart';
import 'package:munto_app/model/provider/item_reviews_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/provider/socialing_impended_provider.dart';
import 'package:munto_app/model/provider/socialing_popular_subject_provider.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/model/question_data.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/myPage/user_Modify_Page.dart';
import 'package:munto_app/view/page/userPage/profile_edit_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/MCirclePainter.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:munto_app/view/widget/meeting_impended_pager.dart';
import 'package:munto_app/view/widget/meeting_popular_pager.dart';
import 'package:munto_app/view/widget/meeting_realtime_review_pager.dart';
import 'package:munto_app/view/widget/meeting_recommend_pager.dart';
import 'package:munto_app/view/widget/meeting_search_widget.dart';
import 'package:munto_app/view/widget/popular_question_widget.dart';
import 'package:munto_app/view/widget/popular_subject_widget.dart';
import 'package:munto_app/view/widget/hot_tag_widget.dart';
import 'package:munto_app/view/widget/sociaing_impended_pager.dart';
import 'package:munto_app/view/widget/socialing_grid_widget.dart';
import 'package:munto_app/view/widget/socialing_open_widget.dart';
import 'package:munto_app/view/widget/hot_user_widget.dart';
import 'package:munto_app/view/widget/text_overflow_demo.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_state.dart';
import '../../main.dart';
import '../../model/enum/viewstate.dart';
import '../../util.dart';
import '../widget/feed_list_item.dart';

const meetingImageUrl1 =
    'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1600423581514_2500.jpg';
const meetingImageUrl2 =
    'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1579698395918_2500.png';
const meetingImageUrl3 =
    'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1555920909114_2500.jpg';

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with AutomaticKeepAliveClientMixin<LoungePage>, TickerProviderStateMixin {
  bool get wantKeepAlive => true;

  TabController tabController;
  ScrollController _scrollController = ScrollController();
  ScrollController _socialingPageScrollController = ScrollController();
  ScrollController _meetingPageScrollController = ScrollController();
  TextEditingController _searchMeetingEditController = TextEditingController();
  double currentBannerIndex = 0;
//  List<TagData> mainTagList;

  // ?????? ????????? & ????????????
  SocialingPopularSubjectProvider popularSubjectProvider;
  List<SocialingPopularSubjectData> popularSubjectList =
      new List<SocialingPopularSubjectData>();
  List<TagData> popularTagList = List();

  // ?????? ?????? ?????????
  SocialingImpendedProvider impendedSocialingProvider;
  List<SocialingData> impendedSocialingList = new List<SocialingData>();

  // ????????? ??????(mpass)
  PlayingItemProvider playingItemProvider;
  List<ItemData> playingItemDataList = new List<ItemData>();

  // ?????? ?????? ??????
  ImpendedItemProvider impendedItemProvider;
  List<ItemData> impendedItemDataList = new List<ItemData>();

  // ?????? ??????
  PopularItemProvider popularItemProvider;
  List<ItemData> popularItemDataList = new List<ItemData>();

  // ??????
  ItemReviewsProvider itemReviewsProvider;
  List<ItemReviewsData> itemReivewsDataList = new List<ItemReviewsData>();

  // ?????? ?????????
  ItemProvider itemProvider;
  List<ItemData> itemDataList = new List<ItemData>();

  static int socialingPageSkip;
  static int socialingPageTake; // 30?????? ?????????

  static int reviewsSkip;
  static int reviewsTake; // 10?????? ?????????

  static int itemSkip;
  static int itemTake;

  bool hasMoreData = true;
  bool hasMoreItemReviews = true;
  bool hasMoreMeetingData = true;
  bool hasMoreFeedData = true;

  int meetingChoiceChipSelectedIndex = 0;

  // feed page ?????? ??????
  int feedloungPage = 1;
  List<FeedData> feedDataList;
  bool dataLoungPageListisMoreBool;
  List<OtherUserProfileData> popularUserList = [];

  // pull refresh key
  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshsocialingIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshItemIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final Key mainkey = PageStorageKey('mainkey');
  final Key listKeyA = PageStorageKey('listA'); // ????????? tab key 
  final Key listKeyB = PageStorageKey('listB');// ????????? tab key 
  final Key listKeyC = PageStorageKey('listC');// ????????? tab key 

  @override
  void initState() {
    super.initState();

    socialingPageSkip = 0;
    socialingPageTake = 30;

    reviewsSkip = 0;
    reviewsTake = 10;

    itemSkip = 0;
    itemTake = 10;

    final loginPro = Provider.of<LoginProvider>(context, listen: false);
    // if (loginPro.needsProfileEdit) {
    //   goProfileEdit();
    // } else {
    //   print(
    //       'loginPro.needsProfileEdit ${loginPro.needsProfileEdit.toString()}');
    // }

    checkAgreementConfirmed().then((result) {
      if (result) {
        showAgreement();
      }
    });

    // api ?????? ??????
    fetchSocialingData(); // ????????? ??? api ??????
    fetchMeetingData(); // ?????? ??? api ??????

    tabController = TabController(vsync: this, length: 3);

    // TODO: stream ????????? ??? ???????????? ?????? ?????? (test ???)
    // tabController.addListener(() {
    //   if (tabController.indexIsChanging) {
    //     if(tabController.index == 1) fetchSocialingData(); // ????????? ??? api ??????
    //     if (tabController.index == 2) fetchMeetingData();
    //   }
    // });
    _socialingPageScrollController.addListener(() {
      if (_socialingPageScrollController.position.pixels ==
          _socialingPageScrollController.position.maxScrollExtent) {
        print(
            '_socialingPageScrollController ????????? ??? : $dataLoungPageListisMoreBool');
        if (hasMoreData) {
          getSocialingDatas();
        }
      }
    });

    _meetingPageScrollController.addListener(() {
      if (_meetingPageScrollController.position.pixels ==
          _meetingPageScrollController.position.maxScrollExtent) {
        if (hasMoreMeetingData) {
          String subject =
              itemSubjectData[meetingChoiceChipSelectedIndex]['label'];
          getItem(subject);
        }
      }
    });
    // feed page ??????
    getFeedDatas();
    getPopularUser();
    getPopularTag();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        dataLoungPageListisMoreBool =
            Provider.of<FeedProvider>(context, listen: false)
                .dataLoungPageListisMoreBool;
        print('_scrollController ????????? ??? : $dataLoungPageListisMoreBool');
        if (dataLoungPageListisMoreBool) {
          getFeedDatas();
        }
      }
    });
    //    mainTagList = [];

    eventBus.on<FeedUploadFinished>().listen((event) {
      getPullFeedData();
    });
  }

  getFeedDatas() {
    print('?????? ????????????!!! ');
    Provider.of<FeedProvider>(context, listen: false)
        .fectchLoungPage(feedloungPage);
    feedloungPage++;
  }

  Future<void> getPopularUser() async {
    final resultList = await Provider.of<FeedProvider>(context, listen: false)
        .getPopularUsers();
    if (resultList != null) popularUserList = resultList;
  }

  // ????????? pull refresh ??????
  Future<void> getPullFeedData() async {
    print('?????? ????????????!!! ');
    Provider.of<FeedProvider>(context, listen: false).fectchLoungPage(1);
    feedloungPage = 2;
  }

// ?????????  pull refresh ??????
  Future<void> getPullSocialingData() async {
    final socialingProvider =
        Provider.of<SocialingProvider>(context, listen: false);
    await socialingProvider.fetch(0, 30).then((value) {
      if (socialingPageSkip == socialingProvider.dataList.length)
        hasMoreData = false;
      else
        hasMoreData = true;
      socialingPageSkip = socialingProvider.dataList.length;
    });
  }

  // ?????? Item  pull refresh ??????
  Future<void> getPullItemData() async {
    if (playingItemProvider == null)
      playingItemProvider = new PlayingItemProvider();
    playingItemDataList = await playingItemProvider.getPlayingItems();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    _scrollController.dispose();
    _socialingPageScrollController.dispose();
    _searchMeetingEditController.dispose();
    _meetingPageScrollController.dispose();
    // recommendItemDataList.close();
  }

  Future<void> fetchSocialingData() async {
    await Future.wait([
      getPopularSubject(),
      getImpendedSocialing(),
    ]);
    Future.delayed(Duration.zero, () async {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);

      feedProvider.fetchPage(1);
      getSocialingDatas();
    });
  }

  Future<void> fetchMeetingData() async {
    await Future.wait([
      getPlayingItem(),
      getImpendedItem(),
      getPopularItem(),
      getItemReviewsItem(),

      getItem(itemSubjectData[meetingChoiceChipSelectedIndex]
          ['label']), // ?????? '??????' ??? ????????? ????????????
    ]);
  }

  getSocialingDatas() async {
    final socialingProvider =
        Provider.of<SocialingProvider>(context, listen: false);
    await socialingProvider
        .fetch(socialingPageSkip, socialingPageTake)
        .then((value) {
      if (socialingPageSkip == socialingProvider.dataList.length)
        hasMoreData = false;
      else
        hasMoreData = true;
      socialingPageSkip = socialingProvider.dataList.length;
    });
  } // ID ??? target????????

  Future<void> getPopularSubject() async {
    if (popularSubjectProvider == null)
      popularSubjectProvider = new SocialingPopularSubjectProvider();
    popularSubjectList = await popularSubjectProvider.getPopularSubject();
  }

  Future<void> getPopularTag() async {
    if (popularSubjectProvider == null)
      popularSubjectProvider = new SocialingPopularSubjectProvider();
    popularTagList = await popularSubjectProvider.getPopularTag();
  }

  Future<void> getImpendedSocialing() async {
    if (impendedSocialingProvider == null)
      impendedSocialingProvider = new SocialingImpendedProvider();
    impendedSocialingList =
        await impendedSocialingProvider.getImpendedSocialing();
  }

  Future<void> getImpendedItem() async {
    if (impendedItemProvider == null)
      impendedItemProvider = new ImpendedItemProvider();
    impendedItemDataList = await impendedItemProvider.getImpendedItems();
    print('impendedItemDataList ${impendedItemDataList.length}');
  }

  Future<void> getPlayingItem() async {
    if (playingItemProvider == null)
      playingItemProvider = new PlayingItemProvider();
    playingItemDataList = await playingItemProvider.getPlayingItems();
    // await recommendItemProvider.getRecommendItems().then((value) {
    //   print('@@@@@@@@@@@@@@@@@@@@ getRecommendItem ?????? getRecommendItem');
    //   recommendItemDataList.sink.add(value);
    // });
  }

  Future<void> getPopularItem() async {
    if (popularItemProvider == null)
      popularItemProvider = new PopularItemProvider();
    popularItemDataList = await popularItemProvider.getPopularItems();
  }

  // ?????? ??? ?????? ?????????
  Future<void> getItemReviewsItem() async {
    if (itemReviewsProvider == null)
      itemReviewsProvider = new ItemReviewsProvider();

    await itemReviewsProvider
        .getItemReviewsData(reviewsSkip, reviewsTake)
        .then((value) {
      itemReivewsDataList = value;
      if (reviewsSkip == itemReviewsProvider.dataList.length)
        hasMoreItemReviews = false;
      else
        hasMoreItemReviews = true;
      reviewsSkip = itemReviewsProvider.dataList.length;
    });
    setState(() {});
  }

  // ?????? ??? ???????????????
  Future<void> getItem(String subject) async {
    if (itemProvider == null) itemProvider = new ItemProvider();
    await itemProvider.getData(itemSkip, itemTake, subject).then(
      (value) {
        itemDataList = value;
        if (itemSkip == value.length)
          hasMoreMeetingData = false;
        else
          hasMoreMeetingData = true;
        itemSkip = value.length;

        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build Lounge');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    print('loginProvider.guestYn = ${loginProvider.guestYn}');
    print('UserInfo.myProfile.id =  ${UserInfo.myProfile?.id}');

    SizeConfig().init(context);
    // final tagProvider =  Provider.of<TagProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);

    if (feedProvider.hasNewPost) {
      feedProvider.hasNewPost = false;
      _scrollController.animateTo(330,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }

    return Scaffold(
      backgroundColor: MColors.white,
      appBar: AppBar(
        shape:
            Border(bottom: BorderSide(color: MColors.white_three, width: 0.5)),
        backgroundColor: MColors.white_two,
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () async {
            if (!kReleaseMode) {
              // final loginProvider = Provider.of<LoginProvider>(context, listen: false);
              // loginProvider.logout();

              // Navigator.of(context).push(MaterialPageRoute(builder:(_)=>InteractionTest()));

              // showAgreement();

              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => TextOverflowDemo()));

              // analytics.logEvent('testEvent',eventProperties: {
              //   'test1': 'testValue1',
              //   'test2': 'testValue2',
              // });
              // await analytics.uploadEvents();
              // print('uploadFinished');
              // AppState.of(context)
              //   ..analytics.logEvent('test logging event')
              //   ..setMessage('Event sent.');

              // Provider.of<BottomNavigationProvider>(context, listen: false).refreshLoungeFeed();

              // final feedProvider =
              //     Provider.of<FeedProvider>(context, listen: false);
              // feedProvider.fectchLoungPage(1);
              eventBus.fire(ProfileUpdatedEvent());
            }
          },
          child: SvgPicture.asset(
            'assets/icons/main_logo.svg',
            height: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(43),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: TabBar(
                labelPadding: EdgeInsets.only(left: 10, right: 10),
                labelStyle: MTextStyles.bold16Tomato,
                unselectedLabelStyle: MTextStyles.bold16PinkishGrey,
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: MColors.tomato),
                  insets: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: MColors.tomato,
                unselectedLabelColor: MColors.pinkish_grey,
//                      isScrollable: true,
                tabs: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 11.0),
                      child: Text(
                        '?????????',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 11.0),
                      child: Text(
                        '?????????',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 11.0),
                      child: Text(
                        '??????',
                      )),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: IconButton(
              icon: SvgPicture.asset('assets/icons/notification.svg'),
              onPressed: () {
                Navigator.of(context).pushNamed('NotificationPage');
              },
            ),
          )
        ],
      ),
      body: TabBarView(key: mainkey, controller: tabController, children: [
        _buildPullLounge(listKeyA, context),
        _buildPullSocialingPage(listKeyB),
        _buildPullItemPage(listKeyC),
        // Center(child:Text('????????? ?????????.')),
      ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildPullLounge(key, context) {
    final bottomProvider = Provider.of<BottomNavigationProvider>(context);
    print('1111 => ${bottomProvider.loungeFeedRefresh} ');
    if (bottomProvider.loungeFeedRefresh) {
      Future.delayed(Duration(milliseconds: 500), () {
        bottomProvider.loungeFeedFinished();
        getPullFeedData();
      });
    }
    return RefreshIndicator(
        key: _refreshfeedIndicatorKey,
        onRefresh: getPullFeedData,
        child: _buildLoungePage(key));
  }

  Widget _buildPullSocialingPage(key) {
    print('????????? 1');
    return RefreshIndicator(
        key: _refreshsocialingIndicatorKey,
        onRefresh: getPullSocialingData,
        child: _buildSocialingPage(key));
  }

  Widget _buildPullItemPage(key) {
    return RefreshIndicator(
        key: _refreshItemIndicatorKey,
        onRefresh: getPullItemData,
        child: _buildItemPage(key));
  }

  bool isShuffled = false;
  Widget _buildLoungePage(key) {
    // final tagProvider = Provider.of<TagProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);

    print('========================================');
    print('building Lounge tab in loungePage');
    print('========================================');
    print('feedProvider.dataList.length ${feedProvider.dataList.length}');

    if (!isShuffled) {
      isShuffled = true;
      QuestionList.shuffle();
    }
    return feedProvider.dataList.length == 0
        ? Container(
            //  color: Color.fromRGBO(100, 100, 100, 0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            //todo:????????? Feed????????? 0????????? 3???????????? ??????, 6???????????? ?????? ?????? ?????? ?????? ?????????
            //todo:???????????? ????????? ??? ??? ?????? ????????? ???????????? ?????????????????? ?????????
            key: key, //ValueKey('feedLoungeList'),
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
                children: <Widget>[
                      _buildLoungeTempBanner(0),
                      //          HotTagWidget(mainTagList),
                      // PopularTagWidget(popularTagList ?? []),

                      PopularQuestionWidget(QuestionList),
                      Padding(
                        padding: EdgeInsets.only(bottom: 18.0),
                      )
                    ] +
                    // List.generate(3, (index) => FeedListItemWidget(feedProvider.dataList[index])) +
                    // [
                    //   HotUserWidget([]),
                    // ] +
                    // List.generate(
                    //   feedProvider.dataLoungPageList.length , (index) => FeedListItemWidget(feedProvider.dataLoungPageList[index + 3])
                    // )
                    [
                      ListView.builder(
                        //+1 for progressbar
                        key: key,
                        itemCount: feedProvider.dataList.length + 1,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == feedProvider.dataList.length) {
                            if (feedProvider.dataLoungPageListisMoreBool) {
                              return _buildProgressIndicator();
                            } else {
                              return SizedBox.shrink();
                            }
                          } else {
                            // id??? 9999999999 ????????? ?????? feed_provider.dart ?????? insert
                            if (feedProvider.dataList[index].id == 9999999999) {
                              print(
                                  'popularUserList lenght : ${popularUserList.length}');
                              if (popularUserList != null) {
                                return HotUserWidget(popularUserList);
                              } else {
                                return SizedBox.shrink();
                              }
                            } else {
                              return FeedListItemWidget(
                                context,
                                feedProvider.dataList[index],
                                needsRefresh: (feedData) {
                                  print('needsRefresh');
                                  var item = feedProvider.dataList[index];
                                  item.likeCount = feedData.likeCount;
                                  item.commentCount = feedData.commentCount;
                                  item.commentContent = feedData.commentContent;
                                  item.commentUserId = feedData.commentUserId;
                                  item.commentUserImage =
                                      feedData.commentUserImage;
                                },
                              );
                            }
                          }
                        },
                      )
                    ]),
          );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
        padding: const EdgeInsets.all(38.0),
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }

  Widget _buildLoungeTempBanner(index) {
    return Container(
      width: double.infinity,
      height: 145,
      child: GestureDetector(
        child: Image.asset(
          index == 0 ? 'assets/banner_welcome.png' : 'assets/banner_guide.png',
          fit: BoxFit.cover,
        ),
        onTap: () async {
          await launch(index == 0
              ? 'https://munto.kr'
              : 'https://www.notion.so/munto/a2633a6295f740e7ba74fac0d7f34dde');
        },
      ),
    );
  }

  Widget _buildLoungeBanner() {
    return Container(
      width: double.infinity,
      height: 145,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: 3,
            itemBuilder: _buildBannerItem,
            onPageChanged: (page) {
              setState(() {
                currentBannerIndex = page.toDouble();
              });
            },
          ),
          Positioned(
            bottom: 8,
            right: 10,
            left: 10,
            child: DotsIndicator(
              dotsCount: 3,
              position: currentBannerIndex,
              decorator: DotsDecorator(
                size: Size(6, 6),
                activeSize: Size(6, 6),
                color: Color.fromRGBO(200, 200, 200, 0.3),
                activeColor: Colors.white,
                spacing: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBannerItem(BuildContext context, int index) {
    return Container(
        height: 145,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0.5, 0),
                end: Alignment(0.5, 1),
                colors: [const Color(0xffff2e2e), const Color(0xfff26313)])),
        child: Padding(
          padding: EdgeInsets.only(
            top: 21,
            left: 20,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '????????????',
                      style: MTextStyles.regular14White,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                    ),
                    Text(
                      '???????????????\n???????????????\n??????3?????????',
                      style: MTextStyles.bold18White,
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: Size(139, 126),
                painter: MCirclePainter(MColors.white_two08),
              ),
            ],
          ),
        ));
  }

  Widget _buildSocialingPage(key) {
    final socialingProvider = Provider.of<SocialingProvider>(context);
    print('========================================');
    print('building Socialing tab in loungePage');
    print('========================================');

    return SingleChildScrollView(
      key: key,
      controller: _socialingPageScrollController,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          // RecommendWidget(recommendDummyData),
          _buildLoungeTempBanner(1),
          PopularSubjectWidget(popularSubjectList), // ????????????
          //   SocialingOpenWidget(context: context), // ????????? ?????? ??????
          //    SocialingImpendedPager(impendedSocialingList), // ?????? ?????? ?????????
          SizedBox(height: 48),
          SocialingGridWidget(key, socialingProvider.dataList), // ????????? ?????????
        ],
      ),
    );
  }

  _getValue(aa) {
    String vvv = '';
    itemSubjectData.forEach((element) {
      if (element['label'] == aa) {
        vvv = element['text'];
      }
    });
    return vvv;
  }

  //?????? TAB
  final aa = PageStorageKey('MeetingPopularPager');
  _buildItemPage(key) {
    print('========================================');
    print('building Meeting tab in loungePage');
    print('========================================');

    return SingleChildScrollView(
      key: key,
      controller: _meetingPageScrollController,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          // MeetingSearchWidget(
          //     searchMeetingEditController: _searchMeetingEditController, imageUrl: meetingImageUrl1), // ?????? ????????????
          //     SizedBox(height: 19),
          MeetingPlayingPager(
              playingItemDataList), // ?????? ?????? ?????? (streambuilder ??? ?????? ??????)
          SizedBox(height: 39),
          MeetingPopularPager(aa, popularItemDataList), // ?????? ??????
          SizedBox(height: 20),
          MeetingImpendedPager(impendedItemDataList), // ?????? ?????? ??????
          SizedBox(height: 41),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   height: 144,
          //   child: Image.network(
          //     '',
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // MeetingRealtimeReviewPager(
          //     getItemReviewsItem, itemReivewsDataList, hasMoreItemReviews, meetingImageUrl2), // ????????? ?????? ??????
          //  SizedBox(height: 41),

          // choice chip ??????
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('?????? ?????? ????????????', style: MTextStyles.bold18Black),
                SizedBox(height: 16),
                SingleChildScrollView(
                  key: key,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: itemSubjectData.asMap().entries.map(
                      (entry) {
                        int idx = entry.key;
                        return buildChoiceChip(idx, entry);
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              key: key,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              childAspectRatio: 153 / 220,
              crossAxisCount: 2,
              children: List.generate(itemDataList.length, (index) {
                ItemData item = itemDataList[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('MeetingDetailPage',
                        arguments: [item.id, item.name, false]);
                  },
                  child: Ink(
                    width: 152,
                    // height: 171,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: MColors.very_light_pink, width: 1.0),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: item.cover != null
                              ? CachedNetworkImage(
                                  imageUrl: item.cover,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          decoration: new BoxDecoration(
                                              // color: Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: MColors.white_three08),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: SvgPicture.asset(
                                            'assets/mypage/no_img.svg',
                                            // width: 24,
                                            // height: 24,
                                            fit: BoxFit.scaleDown,
                                          )),
                                  width: double.infinity,
                                  height:
                                      (83 * MediaQuery.of(context).size.width) /
                                          360,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Container(
                                      width: double.infinity,
                                      height: 87,
                                      decoration: new BoxDecoration(
                                          // color: Colors.white,
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey[100]),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: SvgPicture.asset(
                                        'assets/mypage/no_img.svg',
                                        // width: 24,
                                        // height: 24,
                                        fit: BoxFit.scaleDown,
                                      )),
                                ),
                        ),
                        Container(
                          // width: 152,
                          //  height: 86,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  if (item.itemSubject1 != null)
                                    buildChip(Util.getCategoryName1(
                                        item.itemSubject1)),
                                  if (item.itemSubject2 != null)
                                    buildChip(Util.getCategoryName2(
                                        item.itemSubject2)),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(item.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: MTextStyles.bold14Grey06),
                              SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                height: 40.0,
                                child: Text(item.summary ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: MTextStyles.regular12Grey06),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 8.0,
                                    backgroundImage: NetworkImage(
                                        '${item.itemLeader?.profileUrl ?? ''}'),
                                  ),
                                  SizedBox(width: 3),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: item?.locationString ?? '',
                                        style: MTextStyles.regular10WarmGrey_44,
                                      ),
                                      TextSpan(
                                        text: "??? ",
                                        style: MTextStyles.regular10WarmGrey_44,
                                      ),
                                      TextSpan(
                                        text: item.startDateTime != null
                                            ? '${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                                '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}???'
                                            : '',
                                        style: MTextStyles.regular10WarmGrey_44,
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          //MeetingGridWidget(itemDataList), // ????????? ?????????

          // MeetingPagerWidget(group2),
          //MeetingGridWidget2(group4),
          Padding(padding: EdgeInsets.all(10.0)),
          Padding(padding: EdgeInsets.all(30.0)),
        ],
      ),
    );
  }

  String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '???';
      case 'Tuesday':
        return '???';
      case 'Wednesday':
        return '???';
      case 'Thursday':
        return '???';
      case 'Friday':
        return '???';
      case 'Saturday':
        return '???';
      case 'Sunday':
        return '???';
      default:
        return '-';
    }
  }

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '?????? ' : '?????? ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  Widget buildChoiceChip(int index, MapEntry<int, Map<String, String>> entry) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          entry.value['text'],
          style: meetingChoiceChipSelectedIndex == index
              ? MTextStyles.bold14White
              : MTextStyles.regular14Grey06,
        ),
        backgroundColor: MColors.white_two,
        selected: index == meetingChoiceChipSelectedIndex,
        selectedColor: MColors.tomato,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              // chip ????????? ????????? skip take ?????????
              itemSkip = 0;
              itemTake = 10;
              meetingChoiceChipSelectedIndex = index;
              getItem(entry.value['label']);
            } else {
              meetingChoiceChipSelectedIndex = null;
            }
          });
        },
      ),
    );
  }

  Widget buildChip(String chip) {
    return Padding(
      padding: EdgeInsets.only(right: 6),
      child: SizedBox(
        height: 22,
        child: Chip(
          padding: EdgeInsets.only(bottom: 10.0, left: 2.0, right: 2.0),
          label: Text(
            chip,
            style: MTextStyles.regular10WarmGrey,
          ),
          backgroundColor: MColors.white_two,
        ),
      ),
    );
  }

  Future<bool> checkAgreementConfirmed() async {
    final permissionInfoShown =
        await Util.getSharedString(KEY_AGREEMENT_CONFIRMED);
    if (permissionInfoShown != null && permissionInfoShown == 'true')
      return false;
    return true;
  }

  goProfileEdit() async {
    Future.delayed(Duration(milliseconds: 300), () async {
      await Navigator.of(context).push(CupertinoPageRoute(
          builder: (_) => ProfileEditPage(
                isFirstEdit: true,
              )));
      eventBus.fire(ProfileUpdatedEvent());
      if (UserInfo.needsUserInfoEdit) goUserInfoEdit();
    });
  }

  goUserInfoEdit() async {
    Future.delayed(Duration.zero, () async {
      await Navigator.of(context).pushNamed('CustomerModifyPage');
    });
  }

  showAgreement() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)), //this right here
          child: Container(
            // height: 501.0 + 10.0,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 301,
                        height: 139,
                        color: MColors.grey_06,
                        child: Image.asset(
                          'assets/agreement_image.jpg',
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 24.0,
                        left: 26.0,
                        right: 26.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          '????????? ?????? ??????!\n??????????????? ??????????????? ?????????',
                          style: MTextStyles.bold16Grey06_36,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16.0, left: 24.0, right: 24.0, bottom: 0.0),
                      child: Text(
                        '''
??????????????? ????????? ???????????? ?????? ?????? ?????? ?????? ????????? ????????? ???????????? ???????????? ????????? ?????? ????????? ?????? ??? ?????? ?????? ????????? ????????? ?????????.

?????? ????????? ???????????? ????????? ????????? ?????? ?????? ????????? ???????????? ?????????????????? ????????? ?????? ??? ????????????.  

?????? ???????????? ?????????????????? ???????????? ??? ??????????????? ?????? ???????????? ???????????????!
                       ''',
                        style: MTextStyles.regular14Grey06_40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Util.setSharedString(KEY_AGREEMENT_CONFIRMED, 'true');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(38)),
                            color: MColors.tomato,
                          ),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                              ),
                              Text('???????????? ?????? ????????????',
                                  style: MTextStyles.bold14White,
                                  textAlign: TextAlign.center),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final group1 = MeetingGroup(
    MeetingHeader('?????????', '????????? ????????? ????????? ?????????', HeaderStyle.STYLE2),
    null,
    meetingGroupAll);
final group2 = MeetingGroup(
    MeetingHeader('?????? ?????? ?????? >', '#????????? #???????????????', HeaderStyle.STYLE2),
    null,
    meetingGroupAll);
final group3 = MeetingGroup(
    MeetingHeader('????????? ????????? ???????????? ????????????', '', HeaderStyle.STYLE2),
    null,
    meetingGroupAll);
final group4 = MeetingGroup(
    MeetingHeader('????????????', '', HeaderStyle.STYLE2), null, meetingGroupAll);
