import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/etcPage/tag_writers_list.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/error_page.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:munto_app/view/widget/hot_tag_widget.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app_state.dart';
import '../feedPage/feed_detail_page.dart';

class TagProfilePage extends StatefulWidget {
  final TagData tagData;
  TagProfilePage(this.tagData);
  @override
  _TagProfilePageState createState() => _TagProfilePageState();
}

class _TagProfilePageState extends State<TagProfilePage>
    with TickerProviderStateMixin {
  TabController tabController;
  bool isGridStyle = true;
  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();
  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
    Future.delayed(Duration.zero, () {
      final tagProfileProvider =
          Provider.of<TagProfileProvider>(context, listen: false);
      tagProfileProvider.fetchTagFeeds();
      _getMemebers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagProfileProvider = Provider.of<TagProfileProvider>(context);
    final tagItem = widget.tagData;
    final titleMargin = 44.0;
    final headerHeight = 0;
    final memberWidgetHeight = 150.0;
    final List<FeedData> tagFeedList = tagProfileProvider.tagFeedList ?? [];
    final followerData = tagProfileProvider.tagFollowerData;
    bool isFollowing = followerData?.followers
            ?.map((e) => e.id)
            ?.toList()
            ?.contains(UserInfo.myProfile.id) ??
        false;
    //todo: 피드 없을때 처리
    return Stack(
      children: [
        Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: true,
                title: Text('#${tagItem.name}',
                    style: MTextStyles.bold14Black,
                    textAlign: TextAlign.center),
                expandedHeight: 12.0 + memberWidgetHeight + titleMargin + 1,
                floating: true,
                actions: [
                  FlatButton(
                      onPressed: () async {
                        final loginPro =
                            Provider.of<LoginProvider>(context, listen: false);
                        if (loginPro.guestYn == "Y" || loginPro.isGeneralUser)
                          return;

                        bool result = false;
                        if (isFollowing)
                          result = await tagProfileProvider.deleteFollow();
                        else
                          result = await tagProfileProvider.postFollow();
                      },
                      child: Text(isFollowing ? '팔로잉' : '팔로우',
                          style: isFollowing
                              ? MTextStyles.medium14Grey06
                              : MTextStyles.medium14Tomato))
                  // FlatButton(padding: EdgeInsets.zero,child: Text(
                  //     isFollowing ? '팔로잉' : '팔로우',
                  //     style: isFollowing ? MTextStyles.medium14Tomato : MTextStyles.medium14White, textAlign: TextAlign.center), onPressed: () async {
                  //   final loginPro = Provider.of<LoginProvider>(context, listen: false);
                  //   if (loginPro.guestYn == "Y" || loginPro.isGeneralUser)
                  //     return;
                  //
                  //   bool result = false;
                  //   if (isFollowing)
                  //     result = await tagProfileProvider.deleteFollow();
                  //   else
                  //     result = await tagProfileProvider.postFollow();
                  //
                  // },),
                ],
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: titleMargin),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          // Positioned(
                          //   top: 0,left: 20, right: 20, height: headerHeight,
                          //   child: Row(children: <Widget>[
                          //     // Rectangle
                          //     ClipRRect(
                          //         borderRadius: BorderRadius.all(Radius.circular(8)),
                          //         child: Image.network(tagItem?.image ?? '',
                          //           fit: BoxFit.cover, width: 103, height: 103,)
                          //     ),
                          //     Expanded(child: Padding(padding: EdgeInsets.only(right: 1),)),
                          //     RichText(
                          //         text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                   style: MTextStyles.bold14Black,
                          //                   text: "${tagFeedList?.length ?? 0} "),
                          //               TextSpan(
                          //                   style: MTextStyles.medium14WarmGrey,
                          //                   text: "피드")
                          //             ]
                          //         )
                          //     ),
                          //     Padding(padding: EdgeInsets.only(right: 10),),
                          //     Container(
                          //       width: 60, height: 36,
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.all(Radius.circular(18)),
                          //           border: Border.all(color: MColors.tomato, width: 1),
                          //           color: isFollowing ? MColors.white : MColors.tomato,
                          //       ),
                          //       child: // 팔로우
                          //       FlatButton(padding: EdgeInsets.zero,child: Text(
                          //           isFollowing ? '팔로잉' : '팔로우',
                          //           style: isFollowing ? MTextStyles.medium14Tomato : MTextStyles.medium14White, textAlign: TextAlign.center), onPressed: () async {
                          //         final loginPro = Provider.of<LoginProvider>(context, listen: false);
                          //         if (loginPro.guestYn == "Y" || loginPro.isGeneralUser)
                          //           return;
                          //
                          //         bool result = false;
                          //         if (isFollowing)
                          //           result = await tagProfileProvider.deleteFollow();
                          //         else
                          //           result = await tagProfileProvider.postFollow();
                          //
                          //       },),
                          //     ),
                          //     // Rectangle
                          //   ],),
                          // ),
                          // Positioned(
                          //   top: headerHeight, left: 0, right: 0,
                          //   child: Container(
                          //       width: double.infinity, height: 1,
                          //       decoration: BoxDecoration(
                          //           color: MColors.white_three
                          //       )
                          //   ),
                          // ),
                          Container(
                              // width: 50,
                              padding: EdgeInsets.only(top: 25, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: StreamBuilder<Response<List<UserData>>>(
                                  stream: _memberListCtrl.stream,
                                  builder: (context, snapshot) {
                                    return _getStreamBuild(snapshot);
                                  })),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              tagFeedList.length > 0
                  ? SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final feedItem = tagFeedList[index];
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
                            onTap: () {
                              print('feedItem = ${feedItem.toString()}');
                              Map<String, dynamic> _map = Map();
                              _map['feed'] = feedItem;
                              Navigator.of(context)
                                  .pushNamed('FeedDetailPage', arguments: _map);

                              // Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>
                              //     ChangeNotifierProvider(
                              //       create: (_)=> FeedDetailProvider(feedItem),
                              //       child: FeedDetailPage(feedItem),
                              //     )
                              // ));
                            },
                          );
                        },
                        childCount: tagFeedList.length,
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
                          return Container(
                              height: 200,
                              child: Center(child: Text('피드가 없습니다.')));
                        },
                        childCount: 1,
                      ),
                    ),
            ],
          ),
        ),
        tagProfileProvider.state == ViewState.Busy
            ? Container(
                color: Color.fromRGBO(100, 100, 100, 0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }

  Future<void> _getMemebers() async {
    final tagProfileProvider =
        Provider.of<TagProfileProvider>(context, listen: false);

    try {
      _memberListCtrl.sink.add(Response.loading());
      Map<String, dynamic> _map = Map();

      print('==== 맴버 가져오기 시작 ====================================');
      List<UserData> writers = await tagProfileProvider.getWriters();
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

  Widget _getStreamBuild(snapshot) {
    print('snapshot = ${snapshot.toString()}');
    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case Status.LOADING:
          return Container();
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
    return Center(child: CircularProgressIndicator());
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
                            widget.tagData.name, widget.tagData.id)));
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
}
