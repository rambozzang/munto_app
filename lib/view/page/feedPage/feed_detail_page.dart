import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/etcPage/tag_profile_page.dart';
import 'package:munto_app/view/page/userPage/user_profile_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../../util.dart';

class FeedDetailPage extends StatefulWidget {
  bool canReply;
  FeedData feedData;
  double scrollOffset = 0;
  FeedDetailPage(this.feedData, {this.scrollOffset = 0.0, this.canReply = true});
  @override
  _FeedDetailPageState createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  TextEditingController commentInputController = TextEditingController();
  double currentBannerIndex = 0;
  TextEditingController reCommentInputController = TextEditingController();
  FocusNode replyFocusNode;
  int replyId;
  ScrollController scrollController;

  // 수정여부
  bool isModify = false;

  @override
  void dispose() {
    scrollController.dispose();
    replyFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    print('feedId = ${widget.feedData.id}');
    print('scrollOffset = ${widget.scrollOffset}');
    scrollController = ScrollController();
    replyFocusNode = FocusNode();
    Future.delayed(Duration.zero, () {
      final feedDetailProvider = Provider.of<FeedDetailProvider>(context, listen: false);
      feedDetailProvider.fetchComments();
      feedDetailProvider.checkViewCount();
    });

    if (widget.scrollOffset != 0.0 && widget.scrollOffset != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
    getData();
  }

  Future<void> getData() async {
    widget.feedData = await Provider.of<FeedProvider>(context, listen: false).getFeedById(widget.feedData.id);
    setState(() {});
  }

  void _onTapFeedUser(userid) {
    if (!widget.canReply) return;

    //todo 내 프로필인 경우 마이프로필페이지로 이동해야함
    if (userid == UserInfo.myProfile.id)
      Navigator.of(context).pushNamed('UserProfilePage', arguments: userid);
    else
      Navigator.of(context).pushNamed('UserProfilePage', arguments: userid);

    // Navigator.of(context).push(CupertinoPageRoute(
    //     builder: (_) => ChangeNotifierProvider(
    //           create: (_) => OtherUserProfileProvider('${feedData.user.id}'),
    //           child: UserProfilePage(),
    //         )));
  }

  Widget _buildCommentItem(BuildContext context, CommentData commentItem) {
    final feedDetailProvider = Provider.of<FeedDetailProvider>(context);
    print('myId = ${UserInfo.myProfile.id}');
    print('commentItem.updatedAt = ${commentItem.updatedAt.toString()}');
    return Container(
      padding: EdgeInsets.only(left: commentItem.parentId != null ? 60 : 20, top: 16, right: 18),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () => _onTapFeedUser(commentItem.user.id),
                child: CircleAvatar(
                  radius: commentItem.parentId != null ? 12 : 15,
                  backgroundImage: NetworkImage(commentItem.user?.image ?? ''),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: () => _onTapFeedUser(commentItem.user.id),
                        child: Text(commentItem.user.name ?? '유저이름 처리해야함', style: MTextStyles.bold14Grey06)),
                    Text(
                      commentItem.content,
                      style: MTextStyles.regular14Grey06,
                      maxLines: 10,
                    ), // 피드제목
                    Row(
                      children: <Widget>[
                        // level copy 6
                        Text(Util.dateString(commentItem.updatedAt),
                            style: const TextStyle(
                                color: MColors.pinkish_grey,
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansKR",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0)),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        InkWell(
                          child: Text("좋아요 ${commentItem.likeCount}개",
                              style: const TextStyle(
                                  color: MColors.warm_grey,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0)),
                          onTap: () {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        Builder(
                          builder: (buildContext) => InkWell(
                            child: Text("답글 달기",
                                style: const TextStyle(
                                    color: MColors.warm_grey,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0)),
                            onTap: () {
                              if (widget.canReply) {
                                reCommentInputController.clear();
                                setState(() {
                                  FocusScope.of(buildContext).requestFocus(replyFocusNode);
                                  replyId = commentItem.id;
                                });
                              }
                            },
                          ),
                        ),
                        if (commentItem.user.id == UserInfo.myProfile.id)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('댓글 삭제하시겠어요?'),
                                        content: Text('삭제하시겠습니까?'),
                                        actions: [
                                          FlatButton(
                                            child: Text('확인'),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              final result = await feedDetailProvider.deleteComment(commentItem.id);
                                              if (result) {
                                                feedDetailProvider.fetchComments();
                                              }
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              '취소',
                                              style: TextStyle(color: MColors.tomato),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text("삭제 하기",
                                  style: const TextStyle(
                                      color: MColors.warm_grey,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10.0)),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        if ((commentItem.user?.id ?? -1) != UserInfo.myProfile.id)
                          SizedBox(
                            width: 30,
                            height: 20,
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.more_horiz,
                                color: MColors.white_three,
                                size: 18,
                              ),
                              onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (modalContext) {
                                        return CupertinoTheme(
                                          data: CupertinoThemeData(
                                              barBackgroundColor: CupertinoDynamicColor.withBrightness(
                                            color: Color.fromRGBO(0, 100, 100, 1.0),
                                            darkColor: Color.fromRGBO(100, 100, 0, 1.0),
                                          )),
                                          child: CupertinoActionSheet(
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: Text(
                                                  '댓글 신고하기',
                                                  style: MTextStyles.regular16Tomato,
                                                ),
                                                onPressed: () async {
                                                  Navigator.of(modalContext).pop();
                                                  final result = await feedDetailProvider.postFeedReport();
                                                  if (result) {
                                                    Scaffold.of(context).showSnackBar(SnackBar(
                                                      content: Text('신고가 접수되었습니다.'),
                                                    ));
                                                  }
                                                },
                                                isDestructiveAction: true,
                                              ),
                                            ],
                                            cancelButton: CupertinoActionSheetAction(
                                              child: Text('취소', style: MTextStyles.regular16Grey06),
                                              onPressed: () {
                                                Navigator.of(modalContext).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      });

                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (commentItem.user.id != UserInfo.myProfile.id)
                Padding(
                  padding: const EdgeInsets.only(top: 22.0),
                  child: InkWell(
                    child: SvgPicture.asset(
                      commentItem.isLike ? 'assets/icons/like.svg' : 'assets/icons/like_border.svg',
                      width: 18,
                      height: 18,
                    ),
                    onTap: () async {
                      if (!widget.canReply) return;
                      bool result = false;
                      if (commentItem.isLike)
                        result = await feedDetailProvider.deleteLike(commentItem);
                      else {
                        AppStateLog(context, CLICK_LIKE_BUTTON);
                        result = await feedDetailProvider.postLike(commentItem);
                      }
                    },
                  ),
                )
            ],
          ),
          if (commentItem.id == replyId)
            Container(
              padding: EdgeInsets.only(left: 20, right: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(UserInfo.myProfile.image),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                  ),
                  Expanded(
                    child: TextField(
                      controller: reCommentInputController,
                      textInputAction: TextInputAction.send,
                      focusNode: replyFocusNode,
                      onSubmitted: (val) async {
                        if (val.length > 0) {
                          final parentId = commentItem.parentId != null ? commentItem.parentId : commentItem.id;
                          final result = await feedDetailProvider.postRecomment(
                              widget.feedData.id, reCommentInputController.text, parentId);
                          if (result) {
                            replyId = null;
                            setState(() {
                              reCommentInputController.clear();
                            });
                            feedDetailProvider.fetchComments();
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "답글 달기...",
                        hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                        labelStyle: TextStyle(color: Colors.transparent),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ), // 피드제목,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final loginPro = Provider.of<LoginProvider>(context, listen: false);
    if (loginPro.guestYn == "Y" || loginPro.isGeneralUser) widget.canReply = false;

    final feedData = widget.feedData;
    final feedProvider = Provider.of<FeedProvider>(context);
    final feedDetailProvider = Provider.of<FeedDetailProvider>(context);
    final isFollow = feedData.isFollow ?? false;

    String content = feedData.content;
    if (content.length > 2200) {
      content = content.substring(0, 2200);
    }

    List<CommentData> totalCommentList = [];
    feedDetailProvider.commentList.forEach((comment) {
      totalCommentList.add(comment);
      if (comment.recomments != null) totalCommentList.addAll(comment.recomments);
    });

    final screenSize = MediaQuery.of(context).size;
    final _onTapFeedUser = () {
      if (!widget.canReply) return;

      Navigator.of(context).pushNamed('UserProfilePage', arguments: feedData.user.id);
    };

    //todo:피드하단 추가피드 리스트 가져오기
    final moreFeedList = [];

    final _scaffold =         Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop(feedData);
          },
        ),
        title: Text(feedData.user.name ?? ''),
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
        actions: feedData.user.id != UserInfo.myProfile.id
            ? <Widget>[
          FlatButton(
            child: Text(isFollow ? "팔로잉" : "팔로우",
                style: isFollow ? MTextStyles.bold14Grey06 : MTextStyles.bold14GrapeFruit,
                textAlign: TextAlign.right),
            onPressed: () async {
              if (!widget.canReply) return;
              FocusScope.of(context).requestFocus(replyFocusNode);
              bool result = false;
              if (isFollow)
                result = await feedDetailProvider.deleteFollow();
              else{
                AppStateLog(context, PAGEVIEW_PROFILE, properties: {
                  'sourceId':'${feedDetailProvider.feedData?.user?.id ?? ''}',
                });
                result = await feedDetailProvider.postFollow();
              }

              if (result)
                setState(() {
                  feedData.isFollow = !feedData.isFollow;
                });
            },
          ),
        ]
            : [],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: _onTapFeedUser,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(feedData.user?.image ?? ''),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                                onTap: _onTapFeedUser,
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
                    IconButton(
                      icon: Image.asset(
                        'assets/ico_more_grey.png',
                        width: 24,
                        height: 24,
                      ),
                      highlightColor: MColors.blackColor,
                      iconSize: 24,
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (modalContext) {
                              return CupertinoTheme(
                                data: CupertinoThemeData(
                                    primaryColor: Colors.blue, brightness: Brightness.light),
                                // data:CupertinoThemeData(barBackgroundColor: CupertinoDynamicColor
                                //     .withBrightness(
                                //   color: Color.fromRGBO(0, 100, 100, 1.0),
                                //   darkColor: Color.fromRGBO(100, 100, 0, 1.0),
                                // )),
                                child: CupertinoActionSheet(
                                  actions: feedData.user.id == UserInfo.myProfile.id
                                      ? <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text('수정하기', style: MTextStyles.regular16Grey06),
                                      onPressed: () async {
                                        Navigator.of(modalContext).pop();
                                        final result = await Navigator.pushNamed(
                                            context, 'FeedWritePage',
                                            arguments: {'feedData': feedData});
                                        print('result : $result');
                                        if (result) {
                                          // final feedProvider =
                                          //     Provider.of<FeedProvider>(context, listen: false);
                                          // await feedProvider.fetchPage(1);
                                          // final newFeedData = feedProvider.dataList.firstWhere(
                                          //     (element) => element.id == feedData.id,
                                          //     orElse: null);
                                          // if (newFeedData != null)
                                          //   setState(() {
                                          //     widget.feedData = newFeedData;
                                          //   });
                                          isModify = true;
                                          getData();
                                        }
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        '삭제하기',
                                        style: MTextStyles.regular16Tomato,
                                      ),
                                      onPressed: () async {
                                        Navigator.of(modalContext).pop();
                                        Util.showNegativeDialog(context, '피드를 삭제하시겠어요?', '삭제',
                                                () async {
                                              final feedProvider =
                                              Provider.of<FeedProvider>(context, listen: false);
                                              final result = await feedProvider.deleteFeed(feedData.id);
                                              if (result) {
                                                Navigator.of(context).pop();
                                                if(kReleaseMode)
                                                  feedProvider.fectchLoungPage(1);
                                              }
                                            });
                                      },
                                      isDestructiveAction: true,
                                    ),
                                  ]
                                      : <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text('팔로우', style: MTextStyles.regular16Grey06),
                                      onPressed: () {
                                        Navigator.of(modalContext).pop();
                                      },
                                    ),
                                    if (!widget.canReply)
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          '멤버 피드 숨기기',
                                          style: MTextStyles.regular16Tomato,
                                        ),
                                        onPressed: () async {
                                          Navigator.of(modalContext).pop();
                                          final feedProvider =
                                          Provider.of<FeedProvider>(context, listen: false);
                                          final result = await feedProvider.postFeedReport(feedData.id);
                                          if (result) {
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                              content: Text('유저가 차단되었습니다.'),
                                            ));
                                          }
                                        },
                                        isDestructiveAction: true,
                                      ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        '피드 신고하기',
                                        style: MTextStyles.regular16Tomato,
                                      ),
                                      onPressed: () async {
                                        Navigator.of(modalContext).pop();
                                        final feedProvider =
                                        Provider.of<FeedProvider>(context, listen: false);
                                        final result = await feedProvider.postFeedReport(feedData.id);
                                        if (result) {
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text('신고가 접수되었습니다.'),
                                          ));
                                        }
                                      },
                                      isDestructiveAction: true,
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text('취소', style: MTextStyles.regular16Grey06),
                                    onPressed: () {
                                      Navigator.of(modalContext).pop();
                                    },
                                  ),
                                ),
                              );
                            });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    content,
                    style: MTextStyles.cjkRegular14Grey06,
                    textScaleFactor: textScaleFactor,
                  ),
                ),
              ),
              feedData.photos?.length > 0
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
                      children: List.generate(
                          feedData.photos?.length ?? 0,
                              (index) => CachedNetworkImage(
                            imageUrl: feedData.photos[index] ?? '',
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                                decoration: new BoxDecoration(
                                  color: MColors.white_three,
                                  border: Border.all(width: 1, color: Colors.grey[100]),
                                ),
                                child: Icon(Icons.error)),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
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
                          spacing: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        ),
                      ),
                    )
                        : SizedBox.shrink()
                  ],
                ),
              )
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: List.generate(
                      feedData.tags.length,
                          (index) => // Rectangle
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => TagProfileProvider(feedData.tags[index]),
                                child: TagProfilePage(feedData.tags[index]),
                              )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: MColors.tomato, width: 1),
                                color: MColors.white),
                            child: // 행아웃
                            Center(
                              child: Text('#${feedData.tags[index].name}',
                                  style: MTextStyles.regular12Tomato, textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
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

                          final provider = Provider.of<FeedProvider>(context, listen: false);
                          bool result = false;
                          if (feedData.isLiked)
                            result = await provider.deleteLike(feedData);
                          else{
                            AppStateLog(context, CLICK_LIKE_BUTTON);
                            result = await provider.postLike(feedData);
                          }
                          if (result) {
                            isModify = true;
                            setState(() {
                              feedData.toggleLike();
                            });
                          }

                          print('result = $result');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: feedData.isLiked
                                  ? SvgPicture.asset('assets/icons/like.svg')
                                  : SvgPicture.asset('assets/icons/like_border.svg'),
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
                        onTap: () {
                          final scrollOffset = screenSize.width + 210;
                          scrollController.animateTo(scrollOffset,
                              duration: Duration(milliseconds: 300), curve: Curves.ease);
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'LikerPage', arguments: {'feedData': feedData});
                        },
                        child: Wrap(
                          children: List.generate(
                            feedData.likerImages.length,
                                (index) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(feedData.likerImages[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
              ),
            ] +

                //ListView 사용하지 않는 방식으로 변경
                List.generate(totalCommentList.length, (index) {
                  final commentItem = totalCommentList[index];
                  return _buildCommentItem(context, commentItem);
                }) +
                [
                  widget.canReply
                      ? Container(
                    padding: EdgeInsets.only(left: 20, right: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(UserInfo.myProfile?.image ?? ''),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                        ),
                        Expanded(
                          child: TextField(
                            controller: commentInputController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (val) async {
                              if (val.length > 0) {
                                AppStateLog(context, COMMENT);
                                final result = await feedDetailProvider.postComment(
                                  widget.feedData.id,
                                  commentInputController.text,
                                );

                                if (result) {
                                  isModify = true;

                                  setState(() {
                                    commentInputController.clear();
                                  });
                                  feedDetailProvider.fetchComments();
                                  // Data 리플레쉬
                                  getData();
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "댓글 달기...",
                              hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                              labelStyle: TextStyle(color: Colors.transparent),
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
                  // Container(
                  //   height: 54,
                  //   alignment: Alignment.centerLeft,
                  //   decoration: BoxDecoration(color: MColors.white_two),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 20),
                  //     child: Text("피드 더 보기",
                  //         style: const TextStyle(
                  //             color: MColors.blackColor,
                  //             fontWeight: FontWeight.w700,
                  //             fontFamily: "NotoSansKR",
                  //             fontStyle: FontStyle.normal,
                  //             fontSize: 14.0)),
                  //   ),
                  // )
                ] +
                List.generate(moreFeedList.length, (index) {
                  return FeedListItemWidget(context,
                    moreFeedList[index],
                    canReply: false,
                  );
                }) +
                [
                  Container(
                    height: 60,
                  )
                ]),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // Platform.isIOS
        //   ? _scaffold
        //   : WillPopScope(
        //       onWillPop: () {
        //         // Navigator.of(context).pop(feedData);
        //         print('onWillPop');
        //         return Future.value(false);
        //       },
        //       child: _scaffold,
        //     ),
        _scaffold,
        feedProvider.state == ViewState.Busy || feedDetailProvider.state == ViewState.Busy
            ? Container(
          // color: Color.fromRGBO(100, 100, 100, 0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : SizedBox.shrink()
      ],
    );


  }
}
