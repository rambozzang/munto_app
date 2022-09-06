import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/item_impended_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import '../../util.dart';

const pagerItemRatio = 0.55;

class MeetingImpendedPager extends StatefulWidget {
  List<ItemData> dataList;
  MeetingImpendedPager(this.dataList);

  @override
  _MeetingImpendedPagerState createState() => _MeetingImpendedPagerState();
}

class _MeetingImpendedPagerState extends State<MeetingImpendedPager>
    with AutomaticKeepAliveClientMixin<MeetingImpendedPager> {
  bool get wantKeepAlive => true;

  final magazinePageController =
      PageController(viewportFraction: pagerItemRatio);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final itemHeight = 246.0;
    print('========================================');
    print('building MeetingImpendedPager');
    print('========================================');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 24.0),
          child: Text(
            '⏰ 시작 임박 모임',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MColors.blackColor),
          ),
        ),
        widget.dataList == null || widget.dataList.length == 0
            ? Container(
                height: itemHeight,
                child: Center(child: Text('모임 정보를 불러오지 못했습니다.😢')),
              )
            : Container(
                height: itemHeight,
                width: double.infinity,

                color: Colors.transparent,
                // padding: EdgeInsets.only(top: 16, bottom: 24),
                child: ListView.builder(
                  // controller: magazinePageController,
                  //   key: key,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.dataList.length,
                  itemBuilder: (context, index) {
                    ItemData item = widget.dataList[index];

                    return Transform.translate(
                      offset: Offset(20, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              'MeetingDetailPage',
                              arguments: [item.id, item.name, false]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.4),
                              topLeft: Radius.circular(10.4),
                              bottomLeft: Radius.circular(10.4),
                              bottomRight: Radius.circular(10.4),
                            ),
                            child: Container(
                              width: 200,
                              height: 246.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: MColors.very_light_pink, width: 1.0),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.4),
                                  topLeft: Radius.circular(10.4),
                                  bottomLeft: Radius.circular(10.4),
                                  bottomRight: Radius.circular(10.4),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 104.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                            child: item.cover == null
                                                ? SizedBox.shrink()
                                                : CachedNetworkImage(
                                                    imageUrl: item.cover,
                                                    fit: BoxFit.cover,
                                                  )),
                                        // Positioned(
                                        //   right: 10,
                                        //   top: 10,
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       print('like');
                                        //     },
                                        //     child: SvgPicture.asset('assets/icons/likeit_disabled_shadow.svg'),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.start,
                                      spacing: 6,
                                      // runSpacing: 6,
                                      children: [
                                        if (item.itemSubject1 != null)
                                          buildChip(Util.getCategoryName1(
                                              item.itemSubject1)),
                                        if (item.itemSubject2 != null)
                                          buildChip(Util.getCategoryName2(
                                              item.itemSubject2)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
                                      item?.name ?? '',
                                      style: MTextStyles.bold14Grey06,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 4,
                                        bottom: 12.0,
                                        right: 12.0),
                                    child: SizedBox(
                                      height: 36.0,
                                      child: Text(
                                        item?.summary ?? '',
                                        style: MTextStyles.regular12Grey06,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 8.0,
                                          backgroundImage: NetworkImage(
                                              item?.itemLeader?.profileUrl ??
                                                  ''),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          item.startDateTime != null
                                              ? '${item?.locationString ?? ''} ・ ${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                                  '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}시'
                                              : '',
                                          style:
                                              MTextStyles.regular11WarmGrey_049,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),
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

  Widget buildChip(String chip) {
    return SizedBox(
      height: 22,
      child: Chip(
        padding: EdgeInsets.only(bottom: 10.0, left: 4.0, right: 4.0),
        label: Text(
          chip,
          style: MTextStyles.regular10Grey06,
        ),
        backgroundColor: MColors.white_two,
      ),
    );
  }

  String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '-';
    }
  }

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }
}
