import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/meeting_data.dart';

import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:rxdart/rxdart.dart';

import '../../util.dart';

const pagerItemRatio = 0.55;

class MeetingPlayingPager extends StatefulWidget {
  List<ItemData> dataList;
  MeetingPlayingPager(this.dataList);

  @override
  _MeetingPlayingPagerState createState() => _MeetingPlayingPagerState();
}

class _MeetingPlayingPagerState extends State<MeetingPlayingPager>
    with AutomaticKeepAliveClientMixin<MeetingPlayingPager> {
  bool get wantKeepAlive => true;

  final magazinePageController =
      PageController(viewportFraction: pagerItemRatio);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    SizeConfig().init(context);
    print('========================================');
    print('building MeetingPlayingPager');
    print('========================================');

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/agreement_image.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Color.fromRGBO(0, 0, 0, 0.8),
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '약속 없는 이번 주, 다른 모임에 놀러가고 싶다면?',
                  style: MTextStyles.regular14White,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'MPASS 추천 모임',
                  style: MTextStyles.bold18White,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('MeetingMpassListPage'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '더보기',
                      textAlign: TextAlign.right,
                      style: MTextStyles.bold16White,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              widget.dataList?.length == 0
                  ? Container(
                      height: 246.0,
                      child: Center(
                          child: Text(
                        '모임 정보를 불러오지 못했습니다.😢',
                        style: MTextStyles.regular12White,
                      )),
                    )
                  : Container(
                      height: 246.0,
                      width: double.infinity,
                      color: Colors.transparent,
                      // padding: EdgeInsets.only(top: 16, bottom: 24),
                      child: ListView.builder(
                        //  key: key,
                        // controller: magazinePageController,
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
                                    arguments: [item.id, item.name, true]),
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
                                      // border: Border.all(color: MColors.pinkishGrey10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: double.infinity,
                                          height: 104.0,
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned.fill(
                                                  child: item.cover == null
                                                      ? SizedBox.shrink()
                                                      : Hero(
                                                          tag: 'a_${item.id}',
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                item.cover,
                                                            fit: BoxFit.cover,
                                                          ),
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
                                          padding:
                                              const EdgeInsets.only(left: 12),
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
                                              style:
                                                  MTextStyles.regular12Grey06,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 8.0,
                                                backgroundImage: NetworkImage(
                                                    item?.itemLeader
                                                            ?.profileUrl ??
                                                        ''),
                                              ),
                                              SizedBox(width: 8),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text:
                                                        item?.locationString ??
                                                            '',
                                                    style: MTextStyles
                                                        .regular11WarmGrey_049,
                                                  ),
                                                  TextSpan(
                                                    text: " ・ ",
                                                    style: MTextStyles
                                                        .regular11WarmGrey_049,
                                                  ),
                                                  TextSpan(
                                                    text: item.startDate != null
                                                        ? item.startDate.substring(
                                                                5, 7) +
                                                            '.' +
                                                            item.startDate
                                                                .substring(
                                                                    8, 10) +
                                                            '(' +
                                                            getWeekDay(DateFormat(
                                                                    'EEEE')
                                                                .format(DateTime.parse(item
                                                                    .startDate))) +
                                                            ')' +
                                                            getTypeOfTime(
                                                                DateTime.parse(
                                                                    item.startDate)) +
                                                            getHour(DateTime.parse(item.startDate)) +
                                                            '시'
                                                        : '',
                                                    style: MTextStyles
                                                        .regular11WarmGrey_049,
                                                  ),
                                                ]),
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
