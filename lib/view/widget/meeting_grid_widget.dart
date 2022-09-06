import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingGridWidget extends StatelessWidget {
  final StreamController<List<ItemData>> itemDataList;
  MeetingGridWidget(this.itemDataList);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = screenSize.width * 0.425;

    final itemHeight = 220 * itemWidth / 153;

    return StreamBuilder<Object>(
        stream: itemDataList.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          var item = List<ItemData>();
          if (snapshot.hasData)
            item.addAll(snapshot.data);
          else
            itemDataList.sink.add(item);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              snapshot == null || snapshot.data.length == 0
                  ? Container(
                      height: itemHeight,
                      child: Center(child: Text('모임 정보를 불러오지 못했습니다.😢')),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          // height: ((snapshot.data.length + 1) ~/
                          //         2 *
                          //         (itemHeight + 40))
                          //     .toDouble(),
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: itemWidth / itemHeight,
                                    crossAxisSpacing: 14.0,
                                    mainAxisSpacing: 24),
                            physics: NeverScrollableScrollPhysics(),
                            children:
                                List.generate(snapshot.data.length, (index) {
                              ItemData item = snapshot.data[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  border: Border.all(
                                      color: MColors.very_light_pink, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: itemHeight * 80 / 220,
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned.fill(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0)),
                                                  child: Image.network(
                                                    item?.cover ?? '',
                                                    fit: BoxFit.cover,
                                                  ))),
                                          //BlackOpacity
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(4.0),
                                                  topLeft:
                                                      Radius.circular(4.0)),
                                              child: Container(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.4),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: item.badge != null
                                                ? Container(
                                                    width: 38.0,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        color:
                                                            MColors.grapefruit),
                                                    child: Center(
                                                      child: Text(item.badge,
                                                          style: MTextStyles
                                                              .bold10White,
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Wrap(
                                                  direction: Axis.horizontal,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 6,
                                                  // runSpacing: 6,
                                                  children: [
                                                    if (item.itemSubject1 !=
                                                            "" &&
                                                        item.itemSubject1 !=
                                                            null)
                                                      buildChip(
                                                          item.itemSubject1),
                                                    if (item.itemSubject2 !=
                                                            "" &&
                                                        item.itemSubject2 !=
                                                            null)
                                                      buildChip(
                                                          item.itemSubject2),
                                                    if ((item.itemSubject1 ==
                                                                "" ||
                                                            item.itemSubject1 ==
                                                                null) &&
                                                        (item.itemSubject2 ==
                                                                "" ||
                                                            item.itemSubject2 ==
                                                                null))
                                                      SizedBox(
                                                        height: 32,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 10),
                                                child: Text(
                                                  item?.name ?? '',
                                                  style:
                                                      MTextStyles.bold14Grey06,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  item?.itemDetail1 ?? '',
                                                  style: MTextStyles
                                                      .regular12Grey06,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Container(
                                                  width: 15,
                                                  height: 15,
                                                  child: CircleAvatar(
                                                    // radius: 15,
                                                    backgroundImage:
                                                        NetworkImage(item
                                                                .itemLeader
                                                                ?.user
                                                                ?.image ??
                                                            ''),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                RichText(
                                                  overflow: TextOverflow.fade,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: item?.location ?? '',
                                                      style: MTextStyles
                                                          .regular10Grey06,
                                                    ),
                                                    TextSpan(
                                                      text: "・ ",
                                                      style: MTextStyles
                                                          .regular10Grey06,
                                                    ),
                                                    TextSpan(
                                                      text: item?.startDate != null
                                                          ? item.startDate.substring(5, 7) +
                                                              '.' +
                                                            item.startDate.substring(
                                                                      8, 10) +
                                                              '(' +
                                                              getWeekDay(DateFormat('EEEE').format(
                                                                  DateTime.parse(item.startDate))) +
                                                              ')' +
                                                              getTypeOfTime(
                                                                  DateTime.parse(item?.startDate)) +
                                                              getHour(DateTime.parse(item?.startDate)) +
                                                              '시'
                                                          : '',
                                                      style: MTextStyles
                                                          .regular10Grey06,
                                                    ),
                                                    TextSpan()
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    )
            ],
          );
        });
  }

  Widget buildChip(String chip) {
    return Chip(
      label: Text(
        chip,
        style: MTextStyles.regular10Grey06,
      ),
      backgroundColor: MColors.white_two,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
