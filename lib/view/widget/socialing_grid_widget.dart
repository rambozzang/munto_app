import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import '../../util.dart';

class SocialingGridWidget extends StatefulWidget {
  final List<SocialingData> socialingData;
  SocialingGridWidget(Key key, this.socialingData) : super(key: key);
  @override
  _SocialingGridWidgetState createState() => _SocialingGridWidgetState();
}

class _SocialingGridWidgetState extends State<SocialingGridWidget>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final itemWidth = screenSize.width * 0.425;
    // final itemHeight = 282 * itemWidth / 153 + 10;
    final double itemWidth = (size.width / 2) - 20 - 9;
    final double itemHeight = 282;
    final length = widget.socialingData.length;
    print('socialing length = $length');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 4),
          child: Text(
            '소셜링 리스트',
            style: MTextStyles.bold18Black,
          ),
        ),
        widget.socialingData == null || widget.socialingData.length == 0
            ? Container(
                height: itemHeight,
                child: Center(child: Text('소셜링 정보를 불러오지 못했습니다.😢')),
              )
            : Container(
                padding: EdgeInsets.all(20),
                height:
                    ((widget.socialingData.length + 2) ~/ 2 * (itemHeight + 40))
                        .toDouble(),
                child: GridView(
                  key: widget.key,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisSpacing: 14.0,
                      mainAxisSpacing: 24),
                  physics: NeverScrollableScrollPhysics(),
                  children:
                      List.generate(length < 6 ? length : length + 1, (index) {
                    var item;
                    if (index < 5) item = widget.socialingData[index];
                    if (index == 5)
                      item = null;
                    else if (index > 5) item = widget.socialingData[index - 1];

                    String location = item?.location ?? '';
                    if (location.length > 6)
                      location = location.substring(0, 6);

                    if (item == null) {
                      return // Rectangle Copy 3
                          Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                              color: MColors.white_three08, width: 1),
//                          color: MColors.white_two
                        ),
                        child: InkWell(
                          onTap: () {
                            final loginPro = Provider.of<LoginProvider>(context,
                                listen: false);
                            if (loginPro.isSnsTempUser ||
                                loginPro.isGeneralUser) {
                              return;
                            }
                            Navigator.of(context)
                                .pushNamed('OpenSocialingPage');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Material(
                              color: MColors.white_two,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // 소셜링
                                  Text("소셜링",
                                      style: MTextStyles.bold20GrapeFruit,
                                      textAlign: TextAlign.center),
                                  // 나와 꼭 맞는 취향을 가진 사람들을
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                        top: 5,
                                        bottom: 36),
                                    child: Text(
                                        "나와 꼭 맞는 취향을\n가진 사람들을 만날 기회,\n직접 만들어볼까요?",
                                        style: const TextStyle(
                                            color: MColors.grey_06,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.center),
                                  ),
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor: MColors.white,
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: MColors.grapefruit,
                                        size: 44,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
//                  Navigator.of(context).push(MaterialPageRoute(builder:(_)=>GalleryDetail(item)));
                        Navigator.of(context)
                            .pushNamed('SocialingDetailPage', arguments: item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(
                              color: MColors.very_light_pink, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: itemHeight * 80 / 282,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4.0),
                                              topLeft: Radius.circular(4.0)),
                                          child: Image.network(
                                            item?.cover ?? '',
                                            fit: BoxFit.cover,
                                          ))),
                                  //BlackOpacity
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4.0),
                                          topLeft: Radius.circular(4.0)),
                                      child: Container(
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: item.badge != null
                                        ? Container(
                                            width: item.badge.length > 3
                                                ? 52.0
                                                : 38.0,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: MColors.grapefruit),
                                            child: Center(
                                              child: Text(item.badge,
                                                  style:
                                                      MTextStyles.bold10White,
                                                  textAlign: TextAlign.center),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 1.0,
                                  ),
                                  if (item.subjectList.length > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                      ),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        runSpacing: 3.0,
                                        spacing: 4.0,
                                        // runSpacing: 10,
                                        children: List.generate(
                                            item.subjectList.length,
                                            (index) => buildChip(
                                                item.subjectList[index])),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 1.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Text(
                                      item?.name ?? '',
                                      style: MTextStyles.bold14Grey06,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.0,
                                  ),
                                  SizedBox(
                                    height: 1.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 14,
                                          ),
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          item.startDateTime != null
                                              ? '${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                                  '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}시\n$location'
                                              : '',
                                          style: MTextStyles.regular10Grey06,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.group,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: (item?.totalMember
                                                              .toString() ??
                                                          '0') +
                                                      '명 참여중',
                                                  style: MTextStyles
                                                      .regular10Grey06,
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 12,),
                                      //   child: Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Container(
                                      //         width: 14,
                                      //         height: 14,
                                      //         child: Stack(
                                      //           children: [
                                      //             Container(
                                      //               padding: EdgeInsets.symmetric(horizontal: 10),
                                      //               height: 24,
                                      //               decoration: BoxDecoration(
                                      //                 borderRadius: BorderRadius.all(Radius.circular(12)),
                                      //                 border: Border.all(color: MColors.warm_grey, width: 1),
                                      //                 color: MColors.white,
                                      //               ),
                                      //             ),
                                      //             Center(
                                      //               child: Text(
                                      //                 '₩',
                                      //                 style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       SizedBox(width: 4),
                                      //       RichText(
                                      //         text: TextSpan(children: [
                                      //           TextSpan(
                                      //             text: item?.price == 0 ? '무료' :NumberFormat('###,###,###,###')
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              width: itemWidth - 24,
                              margin: new EdgeInsetsDirectional.only(
                                  start: 12.0, end: 12.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: MColors.white_three,
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10.0, top: 9.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        NetworkImage(item.user?.image ?? ''),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    item.user?.name ?? '',
                                    style: MTextStyles.regular12Grey06,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    item.user?.gradeString ?? '',
                                    style: MTextStyles.regular10WarmGrey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
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
