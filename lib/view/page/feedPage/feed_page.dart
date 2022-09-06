import 'dart:async';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:provider/provider.dart';

import '../../widget/feed_list_item.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // 페이징에 필요한 스크롤 컨트롤러
  ScrollController _scrollCtrl = new ScrollController();
  int page = 1;

  List<FeedData> feedDataList;
  bool dataPageListisMoreBool;

  final GlobalKey<RefreshIndicatorState> _refreshfeedIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final StreamController<Response<List<FeedData>>> _feedCtrl = StreamController();

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   print('최초 가져오기!!! ');
    //   Provider.of<FeedProvider>(context, listen: false).fectchPage(page);
    //   page++;
    // });
    _getMoreData();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        dataPageListisMoreBool = Provider.of<FeedProvider>(context, listen: false).dataPageListisMoreBool;

        if (dataPageListisMoreBool) {
          _getMoreData();
        }
      }
    });
  }

  getData(feedData) {
    print(' getData() 호출됨!@@@@ ');
    page = 1;
    _getMoreData();
  }

  void _getMoreData() async {
    if (page == 1) _feedCtrl.sink.add(Response.loading());

    try {
      List<FeedData> list = await Provider.of<FeedProvider>(context, listen: false).fetchPage(page, isFeedPage: true);
      _feedCtrl.sink.add(Response.completed(list));
      page++;
    } catch (e) {
      _feedCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getPullFeedData() async {
    _feedCtrl.sink.add(Response.loading());
    try {
      List<FeedData> list = await Provider.of<FeedProvider>(context, listen: false).fetchPage(1, isFeedPage: true);
      _feedCtrl.sink.add(Response.completed(list));
      page = 2;
    } catch (e) {
      _feedCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _feedCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MColors.white,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: MColors.barBackgroundColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(barBorderWidth),
            child: Container(
              height: barBorderWidth,
              color: MColors.barBorderColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            '피드',
            style: MTextStyles.bold16Black,
          ),
        ),
        body: StreamBuilder<Response<List<FeedData>>>(
            stream: _feedCtrl.stream,
            builder: (BuildContext context, AsyncSnapshot<Response<List<FeedData>>> snapshot) {
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
                    List<FeedData> list = snapshot.data.data;
                    return list.length > 0 ? _buildPullRefresh(list) : _noDataWidget();
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => getPullFeedData(),
                    );
                    break;
                }
              }
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ));
            }));
  }

  Widget _buildPullRefresh(List<FeedData> list) {
    return RefreshIndicator(
        key: _refreshfeedIndicatorKey,
        onRefresh: getPullFeedData,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollCtrl,
            child: Column(children: [
              ListView.builder(
                itemCount: list.length + 1, //+1 for progressbar
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  //   print(' ======== >  13 ');
                  if (index == list.length) {
                    //   print(' ======== >  14 ');
                    if (Provider.of<FeedProvider>(context, listen: false).dataPageListisMoreBool) {
                      return _buildProgressIndicator();
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    // print(' ======== >  15 ');
                    return FeedListItemWidget(context, list[index], needsRefresh: getData);
                  }
                },
                // controller: _scrollCtrl,
              )
            ])));
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // 전체 데이타 없을 경우
  Widget _noDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_orderhistory_60_px.svg'),
          Center(child: Text('피드 내용이없습니다.\n취향에 꼭 맞는 모임에 참여해 보세요!', style: MTextStyles.medium16WarmGrey)),
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
                  Text("모임보기", style: MTextStyles.medium14White),
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
