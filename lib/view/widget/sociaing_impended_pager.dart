import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/socialing_impended_provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class SocialingImpendedPager extends StatefulWidget {
  List<SocialingData> dataList;
  SocialingImpendedPager(this.dataList);

  @override
  _SocialingImpendedPagerState createState() => _SocialingImpendedPagerState();
}

class _SocialingImpendedPagerState extends State<SocialingImpendedPager>
    with AutomaticKeepAliveClientMixin<SocialingImpendedPager> {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final itemHeight = 311.0;
    final itemWidth = 200.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 40, bottom: 24.0),
          child: Text(
            '시작 임박 소셜링',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MColors.blackColor),
          ),
        ),
        widget.dataList == null || widget.dataList.length == 0
            ? Container(
                height: itemHeight,
                child: Center(child: Text('소셜링 정보를 불러오지 못했습니다.😢')),
              )
            : Container(
                height: itemHeight,
                width: double.infinity,
                color: Colors.transparent,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.dataList.length,
                  itemBuilder: (context, index) {
                    final item = widget.dataList[index];

                    return Transform.translate(
                      offset: Offset(20, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('SocialingDetailPage',
                              arguments: item);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 14.0),
                          height: itemHeight,
                          width: itemWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            border: Border.all(color: MColors.pinkishGrey10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 103,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.4),
                                      topLeft: Radius.circular(10.4)),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                          child: item.cover == null
                                              ? SizedBox.shrink()
                                              : Image.network(
                                                  item.cover,
                                                  fit: BoxFit.cover,
                                                )),
                                      // TODO : 하트 그림 삭제
                                      // Positioned(
                                      //   right: 10,
                                      //   top: 10,
                                      //   child: InkWell(
                                      //     onTap: () {},
                                      //     child: Container(
                                      //       width: 24,
                                      //       height: 24,
                                      //       child: Center(
                                      //         child: SvgPicture.asset(
                                      //             'assets/icons/likeit_disabled_shadow.svg'),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, top: 10.0, right: 12.0),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        runSpacing: 3.0,
                                        spacing: 4.0,
                                        // runSpacing: 6,
                                        children: item.subjectList.length == 0
                                            ? [SizedBox.shrink()]
                                            : List.generate(
                                                item.subjectList.length,
                                                (index) => buildChip(
                                                    item.subjectList[index])),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 4.0, right: 12),
                                      child: Text(
                                        item?.name ?? '',
                                        style: MTextStyles.bold14Grey06,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 2.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: item?.location ?? '',
                                                style:
                                                    MTextStyles.regular10Grey06,
                                              ),
                                              TextSpan(
                                                text: "・ ",
                                                style:
                                                    MTextStyles.regular10Grey06,
                                              ),
                                              TextSpan(
                                                text: item.startDate != null
                                                    ? item.startDate
                                                            .substring(5, 7) +
                                                        '.' +
                                                        item.startDate
                                                            .substring(8, 10) +
                                                        '(' +
                                                        getWeekDay(DateFormat('EEEE')
                                                            .format(DateTime.parse(item
                                                                .startDate))) +
                                                        ')' +
                                                        getTypeOfTime(DateTime.parse(
                                                            item.startDate)) +
                                                        getHour(DateTime.parse(
                                                            item.startDate)) +
                                                        '시'
                                                    : '',
                                                style:
                                                    MTextStyles.regular10Grey06,
                                              ),
                                              TextSpan()
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 2.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.group_rounded,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: item?.totalMember
                                                        .toString() ??
                                                    '0' + '명 참여중',
                                                style:
                                                    MTextStyles.regular10Grey06,
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 12, top: 2.0),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.center,
                                    //     children: [
                                    //       Container(
                                    //         width: 14,
                                    //         height: 14,
                                    //         child: Stack(
                                    //           children: [
                                    //             Container(
                                    //               padding: EdgeInsets.symmetric(
                                    //                   horizontal: 10),
                                    //               height: 24,
                                    //               decoration: BoxDecoration(
                                    //                 borderRadius: BorderRadius.all(
                                    //                     Radius.circular(12)),
                                    //                 border: Border.all(
                                    //                     color: MColors.warm_grey,
                                    //                     width: 1),
                                    //                 color: MColors.white,
                                    //               ),
                                    //             ),
                                    //             Center(
                                    //               child: Text(
                                    //                 '₩',
                                    //                 style: TextStyle(
                                    //                     fontSize: 8,
                                    //                     fontWeight: FontWeight.bold),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 4),
                                    //       RichText(
                                    //         text: TextSpan(children: [
                                    //           TextSpan(
                                    //             text: NumberFormat('###,###,###,###')
                                    //                 .format(item?.price ?? '0')
                                    //                 .replaceAll(' ', '') +
                                    //                 '원',
                                    //             style: MTextStyles.regular10Grey06,
                                    //           ),
                                    //         ]),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(height: 7),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                indent: 12,
                                endIndent: 12,
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, bottom: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                        item.user?.image ?? '',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(item.user?.name ?? '',
                                        style: MTextStyles.regular12Grey06),
                                    SizedBox(width: 8),
                                    Text(item.user?.gradeString ?? '',
                                        style: MTextStyles.regular10WarmGrey),
                                  ],
                                ),
                              ),
                            ],
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
        padding: EdgeInsets.only(bottom: 10.0, left: 2.0, right: 2.0),
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
