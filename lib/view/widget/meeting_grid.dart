import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:color_thief_flutter/utils.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingGridWidget extends StatefulWidget {
  final MeetingGroup group;
  MeetingGridWidget(this.group);
  @override
  _MeetingGridWidgetState createState() => _MeetingGridWidgetState();
}

class _MeetingGridWidgetState extends State<MeetingGridWidget>
    with TickerProviderStateMixin {
  MeetingGroup group;
  TabController tabController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    group = widget.group;
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = (screenSize.width - (20 * 2) - 14) / 2 - 6;
    final itemHeight = 290 * screenSize.width / 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Text(
            group.header.subTitle,
            style: MTextStyles.regular14Grey06,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 4),
          child: Text(
            group.header.title,
            style: MTextStyles.bold18Black,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          height: ((group.list.length + 1) ~/ 2 * itemHeight).toDouble(),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: itemWidth / 264,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 24),
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(group.list.length + 1, (index) {
              final item = index < 2
                  ? group.list[index]
                  : index == 2
                      ? null
                      : group.list[index - 1];
              final infoText = index == 5 ? '잔여 1자리' : 'D-1';
              if (item == null) {
                return // Rectangle Copy 3
                    Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border:
                        Border.all(color: MColors.white_three08, width: 1.0),
//                          color: MColors.white_two
                  ),
                  child: InkWell(
                    onTap: () {
                      print('add socialing');
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
                                style: MTextStyles.bold20Grey06,
                                textAlign: TextAlign.center),
                            // 나와 꼭 맞는 취향을 가진 사람들을
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 5, bottom: 36),
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
                                  color: MColors.blackColor,
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
//                  Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>GalleryDetail(item)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border:
                        Border.all(color: MColors.very_light_pink, width: 1),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 90,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(4.0),
                                        topLeft: Radius.circular(4.0)),
                                    child: Image.network(
                                      item.imageUrl,
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

//                      FutureBuilder(
//                        future:getColorFromUrl(item.imageUrl),
////                        future:getPaletteFromUrl(item.imageUrl),
//                        builder: (context, snapshot){
//                          if(snapshot.hasData){
//                            final data = snapshot.data;
////                            final data = snapshot.data[0];
//                            var red = data[0];
//                            var green = data[1];
//                            var blue = data[2];
//                            if(red > 220 && green > 220 && blue > 220){
//                              red -=40;
//                              green -= 40;
//                              blue -= 40;
//                            }
//                            return Positioned(
//                              left: 0,
//                              bottom: 0,
//                              child: Container(
//                                width: 89,
//                                height: 80,
//                                child: ClipRect(
//                                  child: CustomPaint(
//                                    size: Size(89, 80),
//                                    painter: MCirclePainter(Color.fromRGBO(red, green, blue, 1.0)),
//                                  ),
//                                ),
//                              ),
//                            );
//                          }
//                          return SizedBox.shrink();
//                        },
//                      ),
//                      Positioned(left: 8, bottom: 10, width:60,
//                        child: Text(item.title ,style: MTextStyles.bold16White, maxLines: 2,),),

                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                width: index == 5 ? 66.0 : 38.0,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: MColors.grapefruit),
                                child: Center(
                                  child: Text(infoText,
                                      style: MTextStyles.bold10White,
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Row(
                          children: List.generate(
                              item.tags.length,
                              (index) => Container(
                                  margin: EdgeInsets.only(right: 6),
                                  width: 40,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      color: MColors.white_two),
                                  child: Center(
                                      child: Text(
                                    item.tags[index],
                                    style: MTextStyles.regular10WarmGrey,
                                  )))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 12, right: 12),
                        child: Text(
                          item.introduction,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: MTextStyles.bold14Grey06,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 12, right: 12),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 6),
                            ),
                            Text(
                              '성수  ・  12.31(토) 오후 8시',
                              style: MTextStyles.regular10Grey06,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, left: 12, right: 12),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.people,
                              size: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 6),
                            ),
                            Text(
                              '6명 참여중',
                              style: MTextStyles.regular10Grey06,
                            )
                          ],
                        ),
                      ),
                      // Line
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12, right: 12),
                        child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MColors.white_three, width: 0.5))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0, left: 12),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(item.getLeaderProfileUrl()),
                              radius: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8),
                            ),
                            Text(
                              item.getLeaderName(),
                              style: MTextStyles.regular14Grey06,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4),
                            ),
                            Text(
                              item.getLeaderLevel(),
                              style: MTextStyles.regular10WarmGrey,
                            )
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
}
