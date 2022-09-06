import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/feedPage/feed_detail_page.dart';
import 'package:munto_app/view/page/userPage/user_profile_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../util.dart';

class FeedListItemWidget extends StatefulWidget {
  final FeedData feedData;
  final ValueChanged<FeedData> needsRefresh;
  final BuildContext parentContext;

  bool canReply;
  FeedListItemWidget(this.parentContext, this.feedData,
      {this.canReply = true, this.needsRefresh});
  @override
  _FeedListItemWidgetState createState() => _FeedListItemWidgetState();
}

class _FeedListItemWidgetState extends State<FeedListItemWidget>
    with AutomaticKeepAliveClientMixin<FeedListItemWidget> {
  bool get wantKeepAlive => true;

  double currentBannerIndex = 0;
  TextEditingController commentInputController = TextEditingController();

  void _onTapFeedUser(userid) {
    if (!widget.canReply) return;

    //todo 내 프로필인 경우 마이프로필페이지로 이동해야함
    if (userid == UserInfo.myProfile.id)
      Navigator.of(widget.parentContext)
          .pushNamed('UserProfilePage', arguments: userid);
    else
      Navigator.of(widget.parentContext)
          .pushNamed('UserProfilePage', arguments: userid);

    // Navigator.of(context).push(CupertinoPageRoute(
    //     builder: (_) => ChangeNotifierProvider(
    //           create: (_) => OtherUserProfileProvider('${feedData.user.id}'),
    //           child: UserProfilePage(),
    //         )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    commentInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext internalContext) {
    final textScaleFactor = MediaQuery.of(internalContext).textScaleFactor;

    final loginPro = Provider.of<LoginProvider>(internalContext, listen: false);
    if (loginPro.guestYn == "Y" || loginPro.isGeneralUser)
      widget.canReply = false;

    final screenSize = MediaQuery.of(internalContext).size;
    final feedData = widget.feedData;
    final myProfile = Member.dummy(11);
    final dateFormat = DateFormat('yyyy-MM-dd');

    String content = feedData.content;
    // String content = 'final maxLines = feedData.photos.length > 0 ? 3 : 5final maxLines = feedData.photos.length > 0 ? 3 : 5;final maxLines = feedData.photos.length > 0 ? 3 : 5;final maxLines = feedData.photos.length > 0 ? 3 : 5;;';
    final maxLines = feedData.photos.length > 0 ? 3 : 5;
    final maxLength = feedData.photos.length > 0 ? 70 : 180;

    bool isExeed = false;
    var tempSplit = content.split('\n');
    if (tempSplit.length > maxLines) {
      isExeed = true;
      content = '';
      tempSplit = tempSplit.getRange(0, maxLines).toList();
      tempSplit.forEach((e) {
        if (tempSplit.last != e)
          content = '$content$e\n';
        else
          content = '$content$e...';
      });
    } else if (content.length > maxLength) {
      isExeed = true;
      content = content.substring(0, maxLength);
    }

    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      color: MColors.white,
      child: InkWell(
        onTap: () async {
          Map<String, dynamic> _map = Map();
          _map['feed'] = feedData;
          var result = await Navigator.of(widget.parentContext)
              .pushNamed('FeedDetailPage', arguments: _map);
          if (result != null) {
            print('호출 !!@@@@@');
            handleUpdatedData(result);
            widget.needsRefresh(feedData);
          }
          // Navigator.of(context).push(CupertinoPageRoute(
          //     builder: (_) => ChangeNotifierProvider(
          //           create: (_) => FeedDetailProvider(feedData),
          //           child: FeedDetailPage(feedData),
          //         )));
        },
        child: Ink(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () => _onTapFeedUser(feedData.user.id),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(feedData.user.image),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                onTap: () => _onTapFeedUser(feedData.user.id),
                                child: Text(
                                  feedData.user.name,
                                  style: MTextStyles.bold14BlackColor,
                                )),
                            Padding(
                              padding: EdgeInsets.only(right: 6),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 1.0),
                            ),
                            Text(
                              Util.dateString(feedData.createdAt),
                              style: MTextStyles.cjkMedium11PinkishGrey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 48,
                    ),
                    // IconButton(
                    //   icon: Image.asset(
                    //     'assets/ico_more_grey.png',
                    //     width: 24,
                    //     height: 24,
                    //   ),
                    //   highlightColor: MColors.blackColor,
                    //   iconSize: 24,
                    //   onPressed: () {
                    //     if (widget.canReply)
                    //       showCupertinoModalPopup(
                    //           context: context,
                    //           builder: (modalContext) {
                    //             return CupertinoTheme(
                    //               data: CupertinoThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
                    //               // data:CupertinoThemeData(barBackgroundColor: CupertinoDynamicColor
                    //               //     .withBrightness(
                    //               //   color: Color.fromRGBO(0, 100, 100, 1.0),
                    //               //   darkColor: Color.fromRGBO(100, 100, 0, 1.0),
                    //               // )),
                    //               child: CupertinoActionSheet(
                    //                 actions: feedData.user.id == UserInfo.myProfile.id
                    //                     ? <Widget>[
                    //                         CupertinoActionSheetAction(
                    //                           child: Text('수정하기', style: MTextStyles.regular16Grey06),
                    //                           onPressed: () async {
                    //                             Navigator.of(modalContext).pop();
                    //                             final result = await Navigator.pushNamed(context, 'FeedWritePage',
                    //                                 arguments: {'feedData': feedData});
                    //                             if (result) {
                    //                               final feedProvider =
                    //                                   Provider.of<FeedProvider>(context, listen: false);
                    //                               feedProvider.fectchLoungPage(1);
                    //                             }
                    //                           },
                    //                         ),
                    //                         CupertinoActionSheetAction(
                    //                           child: Text(
                    //                             '삭제하기',
                    //                             style: MTextStyles.regular16Tomato,
                    //                           ),
                    //                           onPressed: () async {
                    //                             Navigator.of(modalContext).pop();
                    //                             Util.showNegativeDialog(context, '피드를 삭제하시겠어요?', '삭제', () async {
                    //                               final feedProvider =
                    //                                   Provider.of<FeedProvider>(context, listen: false);
                    //                               final result = await feedProvider.deleteFeed(feedData.id);
                    //                               if (result) {
                    //                                 feedProvider.fectchLoungPage(1);
                    //                                 if (widget.needsRefresh != null) widget.needsRefresh();
                    //                               }
                    //                             });
                    //                           },
                    //                           isDestructiveAction: true,
                    //                         ),
                    //                       ]
                    //                     : <Widget>[
                    //                         CupertinoActionSheetAction(
                    //                           child: Text('팔로우', style: MTextStyles.regular16Grey06),
                    //                           onPressed: () {
                    //                             Navigator.of(modalContext).pop();
                    //                           },
                    //                         ),
                    //                         CupertinoActionSheetAction(
                    //                           child: Text(
                    //                             '멤버 피드 숨기기',
                    //                             style: MTextStyles.regular16Tomato,
                    //                           ),
                    //                           onPressed: () async {
                    //                             Navigator.of(modalContext).pop();
                    //                             final feedProvider = Provider.of<FeedProvider>(context, listen: false);
                    //                             final result = await feedProvider.postFeedReport(feedData.id);
                    //                             if (result) {
                    //                               Scaffold.of(context).showSnackBar(SnackBar(
                    //                                 content: Text('유저가 차단되었습니다.'),
                    //                               ));
                    //                             }
                    //                           },
                    //                           isDestructiveAction: true,
                    //                         ),
                    //                         CupertinoActionSheetAction(
                    //                           child: Text(
                    //                             '피드 신고하기',
                    //                             style: MTextStyles.regular16Tomato,
                    //                           ),
                    //                           onPressed: () async {
                    //                             Navigator.of(modalContext).pop();
                    //                             final feedProvider = Provider.of<FeedProvider>(context, listen: false);
                    //                             final result = await feedProvider.postFeedReport(feedData.id);
                    //                             if (result) {
                    //                               Scaffold.of(context).showSnackBar(SnackBar(
                    //                                 content: Text('신고가 접수되었습니다.'),
                    //                               ));
                    //                             }
                    //                           },
                    //                           isDestructiveAction: true,
                    //                         )
                    //                       ],
                    //                 cancelButton: CupertinoActionSheetAction(
                    //                   child: Text('취소', style: MTextStyles.regular16Grey06),
                    //                   onPressed: () {
                    //                     Navigator.of(modalContext).pop();
                    //                   },
                    //                 ),
                    //               ),
                    //             );
                    //           });
                    //   },
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 8.0, bottom: 10.0),
                child: // 와인 한병, 첫번째 와인은 화이트,
                    GestureDetector(
                  child: RichText(
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: textScaleFactor,
                      text: TextSpan(children: [
                        TextSpan(
                          style: MTextStyles.cjkRegular14Grey06,
                          text: content,
                        ),
                        // if (feedData.content.length > 20)
                        if (isExeed)
                          TextSpan(
                              style: MTextStyles.cjkRegular14WarmGrey,
                              text: " 더 보기")
                      ])),
                  onTap: () async {
                    Map<String, dynamic> _map = Map();
                    _map['feed'] = feedData;
                    var result = await Navigator.of(widget.parentContext)
                        .pushNamed('FeedDetailPage', arguments: _map);
                    if (result == true) {
                      print('호출 !!@@@@@');
                      widget.needsRefresh(feedData);
                    }

                    // Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>
                    //     ChangeNotifierProvider(
                    //       create: (_)=>FeedDetailProvider(feedData),
                    //       child: FeedDetailPage(feedData),
                    //     )));
                  },
                ),
              ),
              feedData.photos.length > 0
                  ? SizedBox(
                      width: screenSize.width,
                      height: screenSize.width,
                      child: Stack(
                        children: <Widget>[
                          PageView(
                            onPageChanged: (page) {
                              setState(() {
                                currentBannerIndex = page.toDouble();
                              });
                            },
                            //todo: photo 없을때 처리 해야함
                            children: List.generate(
                                feedData.photos.length,
                                (index) => GestureDetector(
                                      child: CachedNetworkImage(
                                        imageUrl: feedData.photos[index],
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                decoration: new BoxDecoration(
                                                  color: MColors.white_three,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey[100]),
                                                ),
                                                child: Icon(Icons.error)),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      onTap: () async {
                                        print('adfasdf');
                                        Map<String, dynamic> _map = Map();
                                        _map['feed'] = feedData;
                                        var result = await Navigator.of(
                                                widget.parentContext)
                                            .pushNamed('FeedDetailPage',
                                                arguments: _map);
                                        if (result != null) {
                                          print('호출 !!@@@@@');
                                          handleUpdatedData(result);
                                          widget.needsRefresh(feedData);
                                        }

                                        // Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>
                                        //     ChangeNotifierProvider(
                                        //       create: (_)=>FeedDetailProvider(feedData),
                                        //       child: FeedDetailPage(feedData),
                                        //     )));
                                      },
                                    )),
                          ),
                          feedData.photos.length > 1
                              ? Positioned(
                                  bottom: 8,
                                  right: 10,
                                  left: 10,
                                  child: DotsIndicator(
                                    dotsCount: feedData.photos.length,
                                    position: currentBannerIndex,
                                    decorator: DotsDecorator(
                                      size: Size(6, 6),
                                      activeSize: Size(6, 6),
                                      color: Color.fromRGBO(200, 200, 200, 0.3),
                                      activeColor: Colors.white,
                                      spacing: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 3),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              feedData.tags.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                              feedData.tags.length,
                              (index) => // Rectangle
                                  Padding(
                                    padding: const EdgeInsets.only(right: 7),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      height: 24,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          border: Border.all(
                                              color: MColors.tomato, width: 1),
                                          color: MColors.white),
                                      child: Center(
                                        child: Text(
                                            '#${feedData.tags[index].name}',
                                            style: const TextStyle(
                                                color: MColors.tomato,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "NotoSansKR",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 54,
                      height: 30,
                      child: InkWell(
                        onTap: () async {
                          if (!widget.canReply) return;

                          final provider = Provider.of<FeedProvider>(
                              internalContext,
                              listen: false);
                          bool result = false;
                          if (feedData.isLiked)
                            result = await provider.deleteLike(feedData);
                          else {
                            AppStateLog(context, CLICK_LIKE_BUTTON);
                            result = await provider.postLike(feedData);
                          }
                          if (result)
                            setState(() {
                              feedData.toggleLike();
                            });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: feedData.isLiked
                                  ? SvgPicture.asset('assets/icons/like.svg')
                                  : SvgPicture.asset(
                                      'assets/icons/like_border.svg'),
                            ),
//                    Padding(padding: EdgeInsets.only(right: 4),),
                            Text(
                              '${feedData.likeCount}',
                              style: MTextStyles.bold14Grey06,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 30,
                      child: InkWell(
                        onTap: () async {
                          final scrollOffset = screenSize.width + 210;
                          Map<String, dynamic> _map = Map();
                          _map['feed'] = feedData;
                          _map['scrollOffset'] = scrollOffset;
                          var result = await Navigator.of(widget.parentContext)
                              .pushNamed('FeedDetailPage', arguments: _map);
                          if (result != null) {
                            print('호출 !!@@@@@');
                            handleUpdatedData(result);
                            widget.needsRefresh(feedData);
                          }

                          // Navigator.of(context).push(CupertinoPageRoute(
                          //     builder: (_) => ChangeNotifierProvider(
                          //           create: (_) => FeedDetailProvider(feedData),
                          //           child: FeedDetailPage(
                          //             feedData,
                          //             scrollOffset: scrollOffset,
                          //           ),
                          //         )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                'assets/icons/bubble_border.svg',
                              ),
                            ),
//                    Padding(padding: EdgeInsets.only(right: 4),),
                            Text(
                              '${feedData.commentCount}',
                              overflow: TextOverflow.ellipsis,
                              style: MTextStyles.bold14Grey06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        children: List.generate(
                          feedData.likerImages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  NetworkImage(feedData.likerImages[index]),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                child: feedData.commentUserId != null
                    ? Container(
                        padding: EdgeInsets.only(left: 20, top: 13, right: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 12,
                              backgroundImage:
                                  NetworkImage(feedData.commentUserImage),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                            ),
                            Expanded(
                              child: Text(
                                feedData.commentContent,
                                style: MTextStyles.regular14Grey06,
                                maxLines: 2,
                              ), // 피드제목,
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                onTap: () async {
                  final scrollOffset = screenSize.width + 210;
                  Map<String, dynamic> _map = Map();
                  _map['feed'] = feedData;
                  _map['scrollOffset'] = scrollOffset;
                  var result = await Navigator.of(widget.parentContext)
                      .pushNamed('FeedDetailPage', arguments: _map);
                  if (result != null) {
                    print('호출 !!@@@@@');
                    handleUpdatedData(result);
                    widget.needsRefresh(feedData);
                  }

                  // Navigator.of(context).push(CupertinoPageRoute(
                  //     builder: (_) => ChangeNotifierProvider(
                  //           create: (_) => FeedDetailProvider(feedData),
                  //           child: FeedDetailPage(
                  //             feedData,
                  //             scrollOffset: scrollOffset,
                  //           ),
                  //         )));
                },
              ),
              // 댓글 모두 보기
//          Padding(
//            padding: const EdgeInsets.only(left: 19, top: 10),
//            child: InkWell(
//              onTap: (){
//                Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>FeedDetailPage(feedItem)));
//              },
//              child: Text(
//                  "댓글 모두 보기",
//                  style: const TextStyle(
//                      color:  MColors.pinkish_grey,
//                      fontWeight: FontWeight.w500,
//                      fontFamily: "NotoSansCJKkr",
//                      fontStyle:  FontStyle.normal,
//                      fontSize: 12.0
//                  )
//              ),
//            ),
//          ),
              widget.canReply
                  ? Container(
                      padding: EdgeInsets.only(left: 20, right: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 12,
                            backgroundImage:
                                NetworkImage(UserInfo.myProfile?.image ?? ''),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: TextField(
                              controller: commentInputController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (content) async {
                                AppStateLog(context, COMMENT);

                                final provider = Provider.of<FeedProvider>(
                                    internalContext,
                                    listen: false);
                                final result = await provider.postComment(
                                    feedData.id, content);
                                if (result) {
                                  commentInputController.clear();
                                  final scrollOffset = screenSize.width + 210;
                                  Map<String, dynamic> _map = Map();
                                  _map['feed'] = feedData;
                                  _map['scrollOffset'] = scrollOffset;
                                  var result =
                                      await Navigator.of(widget.parentContext)
                                          .pushNamed('FeedDetailPage',
                                              arguments: _map);
                                  if (result != null) {
                                    print('호출 !!@@@@@');
                                    handleUpdatedData(result);
                                    widget.needsRefresh(result);
                                  }
                                  // Navigator.of(context).push(CupertinoPageRoute(
                                  //     builder: (_) => ChangeNotifierProvider(
                                  //           create: (_) => FeedDetailProvider(feedData),
                                  //           child: FeedDetailPage(
                                  //             feedData,
                                  //             scrollOffset: scrollOffset,
                                  //           ),
                                  //         )));
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "댓글 달기...",
                                hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                                labelStyle:
                                    TextStyle(color: Colors.transparent),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ), // 피드제목,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.only(bottom: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleUpdatedData(FeedData feedData) {
    print('handleUpdatedData likeCount = ${feedData.likeCount}');
    setState(() {
      widget.feedData.isLiked = feedData.isLiked;
      widget.feedData.likeCount = feedData.likeCount;
      widget.feedData.commentCount = feedData.commentCount;
      widget.feedData.commentContent = feedData.commentContent;
      widget.feedData.commentUserId = feedData.commentUserId;
      widget.feedData.commentUserImage = feedData.commentUserImage;
    });
  }
}
