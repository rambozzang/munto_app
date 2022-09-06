import 'package:flutter/material.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/item_popular_data.dart';
import 'package:munto_app/view/page/meetingPage/meetingDetailPage.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

const pagerItemRatio = 0.55;

class MeetingPopularPager extends StatefulWidget {
  List<ItemData> dataList;
  MeetingPopularPager(Key key, this.dataList) : super(key: key);

  @override
  _MeetingPopularPagerState createState() => _MeetingPopularPagerState();
}

class _MeetingPopularPagerState extends State<MeetingPopularPager> {
  final magazinePageController =
      PageController(viewportFraction: pagerItemRatio);

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = pagerItemRatio * screenSize.width;
    final itemHeight = itemWidth * 284 / 200;
    print('========================================');
    print('building MeetingPopularPager');
    print('========================================');

    return Column(
      children: <Widget>[
        Container(
          height: 38,
          width: double.infinity,
          color: MColors.white,
          padding: EdgeInsets.only(top: 14, left: 20),
          child: Text(
            '취향이 통하는 사람들의 인기모임',
            style: MTextStyles.bold18Black,
          ),
        ),
        (widget.dataList == null || widget.dataList.length == 0)
            ? Container(
                height: itemHeight,
                child: Center(child: Text('모임정보를 불러오지 못했습니다.😢')),
              )
            : Container(
                height: itemHeight + 40,
                width: double.infinity,
                //  color: MColors.white_two,
                padding: EdgeInsets.only(top: 16, bottom: 24),
                child: PageView.builder(
                  //  key: key,
                  controller: magazinePageController,
                  itemCount: widget.dataList.length,
                  itemBuilder: (context, index) {
                    final item = widget.dataList[index];
                    return Transform.translate(
                      offset: Offset(
                          -screenSize.width * (1 - pagerItemRatio) / 2 + 20, 0),
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        height: itemHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: MColors.pinkishGrey10),
                          // color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: GestureDetector(
                            onTap: () {
                              print('GestureDetector : ${item.name}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MeetingDetailPage(
                                        id: item.id,
                                        title: item.name,
                                        isMPASS: false,
                                      )));
                            },
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: item.popularCover == null
                                      ? SizedBox.shrink()
                                      : Image.network(
                                          item.popularCover,
                                          fit: BoxFit.fitHeight,
                                        ),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: (item.badge != null &&
                                          item.badge != '')
                                      ? Container(
                                          width: 66,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Color.fromRGBO(
                                                255, 82, 82, 0.8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              item.badge,
                                              style: MTextStyles.bold10White,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
