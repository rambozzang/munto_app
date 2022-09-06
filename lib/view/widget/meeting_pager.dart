import 'package:flutter/material.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/style_data.dart';
import 'package:munto_app/view/style/textstyles.dart';

const pagerItemRatio = 200 / 360;

class MeetingPagerWidget extends StatelessWidget {
  MeetingGroup group;
  MeetingPagerWidget(this.group);
  List<MeetingItem> get dataList => group.list;

  final magazinePageController =
      PageController(viewportFraction: pagerItemRatio);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = pagerItemRatio * screenSize.width;
    final itemHeight = itemWidth * 246 / 200;
    print('itemWidth = $itemWidth');
    print('itemHeight = $itemHeight');
    print('sizeHeight = ${itemHeight * 100 / 246}');

    return Column(children: <Widget>[
      Container(
        height: 38,
        width: double.infinity,
        color: MColors.white_two,
        padding: EdgeInsets.only(top: 14, left: 20),
        child: Text(
          group.header.title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MColors.blackColor),
        ),
      ),
      dataList == null || dataList.length == 0
          ? Container(
              height: itemHeight,
              child: Center(child: Text('모임정보를 불러오지 못했습니다.😢')),
            )
          : Container(
              height: itemHeight + 40,
              width: double.infinity,
              color: MColors.white_two,
              padding: EdgeInsets.only(top: 16, bottom: 24),
              child: PageView.builder(
                controller: magazinePageController,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];

                  return Transform.translate(
                    offset: Offset(
                        -screenSize.width * (1 - pagerItemRatio) / 2 + 20, 0),
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: itemHeight,
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
                            height: itemHeight * 100 / 246,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0)),
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                      child: Image.network(
                                    item.imageUrl,
                                    fit: BoxFit.cover,
                                  )),
                                  index == 0
                                      ? Positioned(
                                          left: 10,
                                          top: 10,
                                          child: Container(
                                            width: 78,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                color: Color.fromRGBO(
                                                    255, 82, 82, 0.8)),
                                            child: Center(
                                                child: Text(
                                              '남성모집마감',
                                              style: MTextStyles.bold10White,
                                            )),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10),
                            child: Row(
                              children: List.generate(
                                  item.tags.length,
                                  (index) => Container(
                                        margin: EdgeInsets.only(right: 5),
                                        width: 46,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          color: MColors.white_two,
                                        ),
                                        child: Center(
                                            child: Text(
                                          item.tags[index],
                                          style: MTextStyles.regular10WarmGrey,
                                        )),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 10),
                            child: Text(
                              item.title,
                              style: MTextStyles.bold14Grey06,
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 4),
                            child: Text(
                              item.introduction,
                              style: MTextStyles.regular12Grey06,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 16),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(item.getLeaderProfileUrl()),
                                  radius: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                Text(
                                  item.startDateString,
                                  style: MTextStyles.regular12WarmGrey,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    ]);
  }
}
