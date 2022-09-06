import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/review_Data.dart';
import 'package:munto_app/model/reviews_Data.dart';
import 'package:munto_app/model/writableReviews_Data.dart';
import 'package:munto_app/model/writtenReviews_Data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  ClassProvider classService = ClassProvider();

  final StreamController<Response<List<WritableReviewsData>>> _reviewsAbleListCtrl = StreamController();
  final StreamController<Response<List<WrittenReviewsData>>> _reviewsWritenListCtrl = StreamController();

  List<WritableReviewsData> writableReviewsData;
  List<WrittenReviewsData> writtenReviewsData;

  @override
  void dispose() {
    _reviewsAbleListCtrl.close();
    _reviewsWritenListCtrl.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getReviewsAbleList();
  }

  void _getReviewsAbleList() async {
    try {
      _reviewsAbleListCtrl.sink.add(Response.loading());
      _reviewsWritenListCtrl.sink.add(Response.loading());

      ReviewsData _reviewsData;
      _reviewsData = await classService.getClassReviews();

      _reviewsAbleListCtrl.sink.add(Response.completed(_reviewsData.writableReviews));
      _reviewsWritenListCtrl.sink.add(Response.completed(_reviewsData.writtenReviews));

      // 임시용
      List<WritableReviewsData> itemlist = [];
      // WritableReviewsData item = WritableReviewsData();
      // item.id = 22;
      // item.cover = 'https://specials-images.forbesimg.com/imageserve/1184016689/960x0.jpg?fit=scale';
      // item.finishDate = '2020.11.03';
      // item.startDate = '2020.01.03';
      // item.classType = '승인중';
      // item.name = '와인 살롱';
      // itemlist.add(item);
      // itemlist.add(item);
      //
      // itemlist.add(item);
      // itemlist.add(item);
      // itemlist.add(item);
      // itemlist.add(item);
      // itemlist.add(item);
      // itemlist.add(item);
      // itemlist.add(item);
      // _reviewsAbleListCtrl.sink.add(Response.completed(itemlist));
    } catch (e) {
      _reviewsAbleListCtrl.sink.add(Response.error(e.toString()));
      _reviewsWritenListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  // 페이지 닫기
  closePage() => Navigator.of(context).pop();

  // 후기 삭젝하기
  deleteReview(int reviewId, String classType) async {
    try {
      Map<String, dynamic> map = Map();
      map['reviewId'] = reviewId.toString();
      map['classType'] = "ITEM";
      final returnVal = await classService.deleteClassReview(map);
      print('deleteReview() 오류 1: ${returnVal}');
    } catch (e) {
      print('deleteReview() 오류 2: ${e.toString()}');
      print('deleteReview() 오류 3: ${Response.error(e.toString()).message}');

      // _showCenterFlash(
      //     position: FlashPosition.bottom,
      //     style: FlashStyle.floating,
      //     text: '오류가 발생했습니다. (${Response.error(e.toString()).message})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _reviewListView(),
              const SizedBox(
                height: 24,
              ),
              DividerGrey12(),
              const SizedBox(
                height: 40,
              ),
              _writtenBoxListView(),
              DividerWhite12(),
              const SizedBox(
                height: 9,
              ),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "후기",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor ,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
      ),
    );
  }

  // 상당 리스트
  Widget _reviewListView() {
    return Container(
      height: 171 + 93.0,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<Response<List<WritableReviewsData>>>(
          stream: _reviewsAbleListCtrl.stream,
          builder: (BuildContext context, AsyncSnapshot<Response<List<WritableReviewsData>>> snapshot) {
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
                  List<WritableReviewsData> item = snapshot.data.data;

                  return item.length > 0 ? _reviewListViewDetail(item) : _noDatawritableReview();
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
          }),
    );
  }

  Widget _reviewListViewDetail(List<WritableReviewsData> list) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 20.0),
          child: TitleBold16BlackView('작성 가능한 후기', '${list.length}건'),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 0),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                WritableReviewsData item = list[index];
                ClassData classData = ClassData.fromMap(item.toMap());

                return Container(
                    width: 171,
                    // height: 181,
                    padding: EdgeInsets.only(right: 10),
                    //  color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          await Navigator.of(context).pushNamed('ReviewsWritePage', arguments: [item, null, false]);
                          _getReviewsAbleList();
                        } ,

                        child: ClassBigBox(classData)));
              }),
        ),
      ],
    );
  }

  Widget _writtenBoxListView() {
    return Container(
      //  height: 172,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<Response<List<WrittenReviewsData>>>(
          stream: _reviewsWritenListCtrl.stream,
          builder: (BuildContext context, AsyncSnapshot<Response<List<WrittenReviewsData>>> snapshot) {
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
                  List<WrittenReviewsData> item = snapshot.data.data;

                  return item.length > 0 ? _writtenBoxListViewDetail(item) : _noDataWrittenReview();
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
          }),
    );
  }

  Widget _writtenBoxListViewDetail(List<WrittenReviewsData> list) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 20.0),
          child: TitleBold16BlackView('내가 작성한 후기', '${list.length}건'),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 0),
            scrollDirection: Axis.vertical,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              WrittenReviewsData item = list[index];

              return Container(
                  width: 168,
                  padding: EdgeInsets.only(right: 12),
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        print('click');
                      },
                      child: Column(
                        children: [
                          _writtenBox(item),
                          DividerWhite12(),
                        ],
                      )));
            }),
      ],
    );
  }

  Widget _writtenBox(WrittenReviewsData item) {
    ReviewData reviewData = ReviewData.fromJson(item.review.toJson());

    print(item.review.content);
    print(reviewData.content);

    return new Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        //   color: Colors.red,
        color: MColors.white_four,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge(
            //   badgeColor: Colors.white,
            //   padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            //   shape: BadgeShape.square,
            //  //     borderRadius: BorderRadius.circular(10.0),
            //   toAnimate: false,
            //   badgeContent: Text('승인중', style: MTextStyles.medium12BrownGrey),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 55,
                  height: 24,
                  decoration: BoxDecoration(
                      color: MColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border.all(color: MColors.very_light_pink, width: 1)),
                  child: // 팔로우
                  Center(
                    child: Text('승인중', style: MTextStyles.regular12WarmGrey,
                        textAlign: TextAlign.center),
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(child: Text(item.name, style: MTextStyles.bold14Black)),
                SizedBox(width: 8,),
                SizedBox(
                  width: 40,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      '삭제',
                      style: MTextStyles.medium14PinkishGrey,
                    ),
                    onPressed: () => _showCancelDialog(context, item.review.id, item.classType),
                  ),
                ),
                if(!kReleaseMode)
                  SizedBox(
                    width: 40,
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        '수정',
                        style: MTextStyles.medium14BlackColor,
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushNamed('ReviewsWritePage', arguments: [WritableReviewsData.fromWritten(item), reviewData, null]),
                      }
                    ),
                  ),
              ],
            ),
            Container(
              //  padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('모임기간 : ${Util.getDateYmd(item.startDate)} ~ ${Util.getDateYmd(item.finishDate)}', style: MTextStyles.regular12Black,),
            ),
            SizedBox(
              height: 10,
            ),
            item.review.photo != null
                ? Container(
                    height: 180,
                    width: double.infinity,
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    child: CachedNetworkImage(
                      imageUrl: item.review.photo,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        decoration: new BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        child: NodataImage(wid: 80.0, hei: 80.0),
                        // child: SvgPicture.asset(
                        //   'assets/mypage/no_img.svg',
                        //   // width: 24,
                        //   // height: 24,
                        //   fit: BoxFit.scaleDown,
                        // )
                      ),
                      width: double.infinity,
                      height: 83,
                      fit: BoxFit.cover,
                    ),
                    // child: Image.asset(item.imageUrl, fit: BoxFit.fitWidth),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                  ),
            Container(
                padding: EdgeInsets.only(top: 10),
                child: new Text(
                  item.review.content,
                  style: MTextStyles.regular14BlackColor,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                //     padding: EdgeInsets.symmetric(vertical: 2),
                child: Align(
              alignment: Alignment.centerRight,
              child: new Text(
                _finalEditedDate(item.review.createdAt, item.review.updatedAt),
                style: MTextStyles.regular10WarmGrey,
              ),
            )),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _showCancelDialog(context, int id, String classType) async {
    print('item.review.id = ${id}');
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
            child: Container(
              height: 150,
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          '삭제한 후기는 복구할 수 없습니다. \n정말 삭제하시겠습니까?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansCJKkr",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(height: 0),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소'),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: FlatButton(
                            onPressed: () async {
                              await deleteReview(id, classType);
                              _getReviewsAbleList();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '삭제',
                              style: MTextStyles.bold16Tomato,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _noDatawritableReview() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 20.0),
        child: TitleBold16BlackView('작성 가능한 후기', '0건'),
      ),
      const SizedBox(height: 25),
      NodataImage(wid: 60.0, hei: 60.0),
      const SizedBox(height: 6),
      Text('작성 가능한 후기가 없습니다.', style: MTextStyles.medium16WarmGrey),
      //  const SizedBox(height: 15),
    ]);
  }

  Widget _noDataWrittenReview() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 20.0),
        child: TitleBold16BlackView('내가 작성한 후기', '0건'),
      ),
      const SizedBox(height: 25),
      NodataImage(wid: 60.0, hei: 60.0, path: 'assets/mypage/empty_review_60_px.svg'),
      const SizedBox(height: 6),
      Text('내가 작성한 후기가 아직 없습니다.', style: MTextStyles.medium16WarmGrey),
      const SizedBox(height: 95),
    ]);
  }

  void _showCenterFlash({
    FlashPosition position,
    FlashStyle style,
    Alignment alignment,
    String text,
  }) {
    showFlash(
      context: context,
      duration: Duration(seconds: 5),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.grey,
          position: position,
          style: style,
          alignment: alignment,
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                text,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        _showMessage(_.toString());
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            style: FlashStyle.grounded,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              message: Text(message),
            ),
          );
        });
  }

  String _finalEditedDate(String createdAt, String updatedAt) {
    try{
      DateTime date;
      if(updatedAt != null){
        date = DateTime.parse(updatedAt).toLocal();
        return '${Util.getDateYmd(updatedAt)} ${date.hour}:${date.minute} 수정';
      } else if( createdAt != null ){
        date = DateTime.parse(createdAt).toLocal();
        return '${Util.getDateYmd(createdAt)} ${date.hour}:${date.minute} 작성';
      }



    }catch (e){}
    return '';
  }
}
