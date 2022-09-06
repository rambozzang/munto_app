import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/fcm_message_main_data.dart';
import 'package:munto_app/model/message_Push_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/message_Provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  MessageProvider messageProvider = MessageProvider();

  final StreamController<Response<List<MessagePushData>>> _messangeCtrl = StreamController();
  List<MessagePushData> list = [];

  ScrollController _scrollCtrl = new ScrollController();
  bool isMoreData = true;
  int page = 1;

  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getData();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (isMoreData) getData();
      }
    });
  }

  Future<void> getData() async {
    try {
      if (page == 1) {
        list = [];
      }
      _messangeCtrl.sink.add(Response.loading());
      List<MessagePushData> response = await messageProvider.getPushMessageList(page);
      if (response.length != 0) {
        list.addAll(response);
        // 10ㄱㅐ보다 적으면 더이상 데이타가 없다고 판단한다.
        // Provider.of<MessageProvider>(context, listen: false).addUnReadCnt(3);
        int unreadCnt = 0;
        for (MessagePushData item in list) {
          if (item.status == 'YET_NOT_SENT') {
            unreadCnt++;
          }
        }
        Provider.of<MessageProvider>(context, listen: false).addUnReadCnt(unreadCnt);
        if (response.length < 11) {
          isMoreData = false;
        }

        page++;
      }

      print('list : $list');
      _messangeCtrl.sink.add(Response.completed(list));
    } catch (e) {
      _messangeCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getPullFeedData() async {
    list = [];
    page = 1;
    try {
      _messangeCtrl.sink.add(Response.loading());
      List<MessagePushData> response = await messageProvider.getPushMessageList(page);
      if (response.length != 0) {
        list.addAll(response);
        // 10ㄱㅐ보다 적으면 더이상 데이타가 없다고 판단한다.
        // Provider.of<MessageProvider>(context, listen: false).addUnReadCnt(3);
        int unreadCnt = 0;
        for (MessagePushData item in list) {
          if (item.status == 'YET_NOT_SENT') {
            unreadCnt++;
          }
        }
        Provider.of<MessageProvider>(context, listen: false).addUnReadCnt(unreadCnt);
        if (response.length < 10) {
          isMoreData = false;
        }

        page++;
      }

      print('list : $list');
      _messangeCtrl.sink.add(Response.completed(list));
    } catch (e) {
      _messangeCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _messangeCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MColors.white_two,
        appBar: _appBar(),
        // body:Center(child: Text('why'))
        body: StreamBuilder<Response<List<MessagePushData>>>(
            stream: _messangeCtrl.stream,
            builder: (BuildContext context, AsyncSnapshot<Response<List<MessagePushData>>> snapshot) {
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
                    List<MessagePushData> list = snapshot.data.data;

                    return list.length != 0 ? _buildPullRefresh(list) : _noDataWidget();
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => getData(),
                    );
                    break;
                }
              }

              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ));
            })
        );
  }

  Widget _noDataWidget() {
    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        NodataImage(path: 'assets/icons/notification.svg', wid: 60.0, hei: 60.0),
        const SizedBox(height: 16),
        Text('도착한 알림이 없습니다.', style: MTextStyles.medium16WarmGrey),
        //  const SizedBox(height: 15),
      ]),
    );
  }

  Widget _buildPullRefresh(List<MessagePushData> list) {
    // return RefreshIndicator(
    //   key: _refreshfeedIndicatorKey,
    //   onRefresh: getPullFeedData,
    //   child: SingleChildScrollView(
    //     physics: BouncingScrollPhysics(),
    //     controller: _scrollCtrl,
    //     child: Expanded(
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [_buildList(list)])),
    //   ),
    // );

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _scrollCtrl,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildList(list)]),
    );
  }

  Widget _buildList(List<MessagePushData> list) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          MessagePushData item = list[index];
          print(item.toString());
          final date = DateTime.parse(item.createdAt).toLocal();
          return // Rectangle
              GestureDetector(
                onTap: () {
                  _navigateToItemDetail(FcmMessageMainData.fromMap(item.toMap()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 14, right: 18, bottom: 10),
                  decoration: BoxDecoration(
                    color: MColors.white,
                    border: Border.all(color: MColors.white_three, width: 0.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              // backgroundImage: NetworkImage(item?.PushSender?.image ?? ''),
                              // backgroundColor: MColors.white_two,
                              backgroundImage: NetworkImage(item?.pushSenderImage ?? ''),
                            ),
                            item.status == 'YET_NOT_SENT '
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.red,
                                      size: 8,
                                    ))
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.title, style: MTextStyles.regular14Grey06, maxLines: 2,),
                            // 피드제목
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(item.content, style: MTextStyles.regular12Grey06),
                            ),
                            // 2020.07.24
                            Text(
                              Util.dateString(date),
                              style: MTextStyles.regular12WarmGrey_underline,
                            ),

                            // Text(item.createdAt, style: MTextStyles.regular12WarmGrey_underline)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
        });
  }

  Widget _appBar() {
    return AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "알림",
            style: MTextStyles.bold16Black,
          ),
        ),
        centerTitle: false,
        backgroundColor: MColors.barBackgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(barBorderWidth),
          child: Container(
            height: barBorderWidth,
            color: MColors.barBorderColor,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.black,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ]);
  }

  void _navigateToItemDetail(FcmMessageMainData fcmMessageMainData) async {
    // 0.라우터 셋팅
    final _kind = fcmMessageMainData.data.kind;
    final _feedId = fcmMessageMainData.data.feedId;
    final _userId = fcmMessageMainData.data.userId;

    // 1. route dlfma 가져오기
    String routeName = Util.getNavibyFirebaseKind(_kind);
    // 2. Navigator parameter 존재여부
    bool isArguments = false;
    dynamic arguments;
    Map<dynamic, dynamic> argumentsMap = Map();
    // 2.페이지별 파라메터가 생성
    // 2.1 GO_TO_FEED 인경우 feedData Data 가 필요.
    if (_kind == 'GO_TO_FEED') {
      isArguments = true;
      FeedData feed = await Provider.of<FeedProvider>(context, listen: false).getFeedById(_feedId);
      argumentsMap['feed'] = feed;
    }

    if (_kind == 'GO_TO_FEED_COMMENT') {
      isArguments = true;
      FeedData feed = await Provider.of<FeedProvider>(context, listen: false).getFeedById(_feedId);
      // final scrollOffset = MediaQuery.of(context).size.width + 210;
      argumentsMap['feed'] = feed;
      // argumentsMap['scrollOffset'] = scrollOffset;
    }

    if(routeName== null || routeName.isEmpty){
      return;
    }
    print('routeName : $routeName');

    // 2.2
    if (_kind == 'GO_TO_PROFILE') {
      isArguments = true;
      arguments = _userId;
    }


    if (isArguments && arguments != null) {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    } else if (isArguments && argumentsMap != null) {
      Navigator.of(context).pushNamed(routeName, arguments: argumentsMap);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }
}
