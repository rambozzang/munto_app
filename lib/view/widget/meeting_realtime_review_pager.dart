import 'package:flutter/material.dart';
import 'package:munto_app/model/item_reviews_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingRealtimeReviewPager extends StatelessWidget {
  List<ItemReviewsData> dataList;

  MeetingRealtimeReviewPager(this.getItemReviewsItem, this.dataList,
      this._hasMoreReviews, this._imageUrl);

  final magazinePageController = PageController(
      viewportFraction: (SizeConfig.screenWidth - 60) / SizeConfig.screenWidth);
  Function getItemReviewsItem;
  final bool _hasMoreReviews;
  final String _imageUrl;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = screenSize.width - 60;
    final itemHeight = 132.0;

    return Column(
      children: <Widget>[
        (dataList == null || dataList.length == 0)
            ? Container(
                height: itemHeight + 140,
                child: Center(child: Text('모임정보를 불러오지 못했습니다.😢')),
              )
            : Container(
                height: itemHeight + 140,
                width: double.infinity,
                color: MColors.white_two,
                child: Stack(
                  children: [
                    Image.network(
                      _imageUrl,
                      fit: BoxFit.fill,
                      width: SizeConfig.screenWidth,
                    ),
                    Positioned(
                      top: 60,
                      left: 30,
                      child: Text('실시간 모임 후기', style: MTextStyles.bold18White),
                    ),
                    PageView.builder(
                      controller: magazinePageController,
                      itemCount: dataList.length,
                      onPageChanged: (index) {
                        if (index + 1 == dataList.length) {
                          if (_hasMoreReviews) getItemReviewsItem();
                        }
                      },
                      itemBuilder: (context, index) {
                        final item = dataList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 10,
                            left: 10,
                            top: 108,
                            bottom: 32,
                          ),
                          child: Container(
                            // height: itemHeight,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: MColors.pinkishGrey10),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MColors.white_two,
                                                width: 0.5),
                                          ),
                                          child: CircleAvatar(
                                            radius: 24,
                                            backgroundImage: NetworkImage(
                                                item.user?.image ?? ''),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          item.user?.name ?? '',
                                          style: MTextStyles.bold12Black,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          item.user?.grade ?? '',
                                          style: MTextStyles.regular10WarmGrey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 21,
                                    right: 16,
                                    child: Text(getUpdatedTime(item) + '시간전',
                                        style: MTextStyles.regular10WarmGrey),
                                  ),
                                  Positioned(
                                    top: 48,
                                    left: 16,
                                    child: Text(
                                      item?.content ?? '',
                                      style: MTextStyles.regular12WarmGrey,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Positioned(
                                    top: 92,
                                    left: 16,
                                    child: InkWell(
                                      onTap: () {
                                        //TODO : 실시간 모임 후기 쓰기 처리 필요
                                      },
                                      child: Container(
                                        width: 140,
                                        height: 28,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                            color: MColors.golden_rod
                                                .withOpacity(
                                                    0.6000000238418579)),
                                        child: Center(
                                          child: Text(
                                            '거기서부터 쓰기 : ' +
                                                item.item?.lastRound
                                                    .toString() +
                                                '회차>',
                                            style: MTextStyles.bold10Black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  String getUpdatedTime(ItemReviewsData item) {
    DateTime updateTime = DateTime.parse(item.updatedAt);
    int _day = DateTime.now().day - updateTime.day;
    int _hour = DateTime.now().hour - updateTime.hour;
    if (_day > 0) _hour = (_day * 24) + _hour;
    return _hour.toString();
  }
}
