import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/view/style/colors.dart';

const double pagerItemRatio = 226 / 360;

class SocialingWidget extends StatelessWidget {
  PageController socialingPageController =
      PageController(viewportFraction: pagerItemRatio);
  final List<SocialingData> dataList;
  final String title;
  SocialingWidget(this.dataList, this.title);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(children: <Widget>[
      Container(
        color: MColors.white,
        height: 38,
        width: double.infinity,
        padding: EdgeInsets.only(top: 14, left: 20),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MColors.blackColor),
            ),
//            Icon(Icons.pause_circle_outline)
          ],
        ),
      ),
//      Center(
//        child: dataList == null || dataList.length == 0?
//          Container(height: 140,child: Center(child: Text('소셜링을 불러오지 못했습니다.😢')),)
//        :Container(
//          height: 140,
//          width: double.infinity,
//          color: MColors.white,
//          padding: EdgeInsets.only(top: 16, bottom: 24),
//          child: ListView.builder(
//            scrollDirection: Axis.horizontal,
//            controller: socialingPageController,
//            itemCount: dataList.length,
//            itemBuilder: (context, index){
//              final item = dataList[index];
//              final user = item.user;
//              final dateFormat = DateFormat('MM월 dd일');
//              return Transform.translate(
//                offset: Offset(20,0),
//                child: Container(
//                  margin: EdgeInsets.only(right: 10),
//                  height: 100,
//                  width: 226,
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                    border: Border.all(color: MColors.pinkishGrey10),
//                    color: MColors.whiteColor,
//                    boxShadow: [BoxShadow(
//                        color: const Color(0x1ab9b6b6),
////                      color: Colors.red,
//                        offset: Offset(0,1),
//                        blurRadius: 4,
//                        spreadRadius: 0
//                    )] ,
//                  ),
//
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Padding(padding: EdgeInsets.only(right: 10),),
//                      Container(
//                        width: 54,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            CircleAvatar(backgroundImage: NetworkImage(user.image), radius: 15,),
//                            Padding(padding: EdgeInsets.only(bottom: 8),),
//                            Text(user.name, style: TextStyle(fontSize: 12, color: MColors.blackColor, fontWeight: FontWeight.bold),
//                              maxLines: 1, ),
//                            Text(user.grade, style: TextStyle(fontSize: 10, color: MColors.warm_grey),),
//                          ],
//                        ),
//                      ),
//                      Container(
//                        width: 160,
//                        padding: EdgeInsets.only(left: 4, right: 16),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(dateFormat.format(item.startDate), style: TextStyle(fontSize: 12, color: MColors.warm_grey), ),
//                            Text(item.introduce, style: TextStyle(fontSize: 18, color: MColors.blackColor, fontWeight: FontWeight.bold),
//                              textAlign: TextAlign.center, maxLines: 2,),
//                          ],
//                        ),
//                      )
//
//                    ],
//                  ),
//                ),
//              );
//
//            },
//          ),
//        ),
//      ),
    ]);
  }
}

final socialingDummyData = [
  // SocialingData(0,'🍰치즈 케이크 먹으러 가실분!!', '합정',DateTime.now(), DateTime.now(), UserData(0, '김문토', '', 'MEMBER')),
  // SocialingData(0,'🏀같이 농구할 사람 구해요~', '합정',DateTime.now(), DateTime.now(), UserData(0, '김문토', '', 'MEMBER')),
  // SocialingData(0,'🍺수제맥주 원정대 구합니다', '합정',DateTime.now(), DateTime.now(), UserData(0, '김문토', '', 'MEMBER')),
  // SocialingData(0,'🍰치즈 케이크 먹으러 가실분!!', '합정',DateTime.now(), DateTime.now(), UserData(0, '김문토', '', 'MEMBER')),
];
