import 'dart:math';

import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/style_data.dart';

const double pagerItemRatio =  300 / 360;

class ReviewWidget extends StatelessWidget {
  PageController reviewPageController = PageController(viewportFraction: pagerItemRatio);
  final List<ReviewData> dataList ;
  ReviewWidget(this.dataList);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return       dataList == null || dataList.length == 0?
    Container(height: 272,child: Center(child: Text('리뷰를 불러오지 못했습니다.😢')),)
        :
    Container(
      height: 272,
      width: double.infinity,
//      color: whiteTwo,
//      padding: EdgeInsets.only(top: 16, bottom: 24),
      child: Stack(
        children: <Widget>[
          Image.network('https://is.gd/35wlD1', scale: 3.0, fit: BoxFit.fitHeight,),
          Container(color: Color.fromRGBO(0, 0, 0, 0.6),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 60, bottom: 24),
                child: Text('실시간 모임 후기', style: TextStyle(color: MColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              Container(
                height: 138, // ios에서 132로 작업한게 안드로이드에서 138로 해야 안짤림. 적정값 확인필요
                width: double.infinity,
                child: PageView.builder(
                  controller: reviewPageController,
                  itemCount: dataList.length,
                  itemBuilder: (context, index){
                    final item = dataList[index];
                    return Container(
                      margin: EdgeInsets.only(right: 10),

                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MColors.pinkishGrey10),
                        color: MColors.whiteColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                            child: Row( children: <Widget>[
                              CircleAvatar(backgroundImage: NetworkImage(item.profileUrl), radius: 12,),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Text(item.userName, style: TextStyle(color: MColors.blackColor, fontSize: 12, fontWeight: FontWeight.bold, ),),
                              Padding(padding: EdgeInsets.only(right: 3)),
                              Text(item.userLevel, style: TextStyle(color: MColors.warm_grey, fontSize: 10, ),),
                              Expanded(child: Text(item.createdDate, textAlign: TextAlign.right, style: TextStyle(color: MColors.warm_grey, fontSize: 10, )),)
                            ],),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:7.0, bottom: 7),
                            child: Text(item.review, maxLines: 2,),
                          ),
                          Container(
                              width: 140,
                              height: 28,
                              decoration: BoxDecoration(color: MColors.golden_rod ,borderRadius: BorderRadius.all(Radius.circular(22.5 ))),
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                child: Text(item.linkButton, style: TextStyle(color: MColors.blackColor, fontSize: 10, fontWeight: FontWeight.bold),), onPressed: (){
                                    print('go review detail');
                              },),
                          )                        ],
                      ),

                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );

  }
}
final reviewDummyData = [
  ReviewData('방금 전', 'https://is.gd/LqnDOZ','이미리', '문지기', '글을 꾸준히 쓰고 싶은 직장인이에요ㅎㅎ 근데 직장인들이라면 알겠지만 글 한 줄 써보니 너무 좋았습니다.', '거기서부터 쓰기 : 2회차 >'),
  ReviewData('2시간 전', 'https://is.gd/rPq59k','이주용', '문지기', '글을 꾸준히 쓰고 싶은 직장인이에요ㅎㅎ 근데 직장인들이라면 알겠지만 글 한 줄 써보니 너무 좋았습니다.', '거기서부터 쓰기 : 2회차 >'),
  ReviewData('10시간 전', 'https://is.gd/U16ru2','이경준', '멤버',   '글을 꾸준히 쓰고 싶은 직장인이에요ㅎㅎ 근데 직장인들이라면 알겠지만 글 한 줄 써보니 너무 좋았습니다.', '거기서부터 쓰기 : 2회차 >'),
  ReviewData('어제', 'https://is.gd/rPq59k','이미리', '문지기', '글을 꾸준히 쓰고 싶은 직장인이에요ㅎㅎ 근데 직장인들이라면 알겠지만 글 한 줄 써보니 너무 좋았습니다.', '거기서부터 쓰기 : 2회차 >'),
];

class ReviewData {
  final String createdDate;
  final String profileUrl;
  final String userName;
  final String userLevel;
  final String review;
  final String linkButton;

  ReviewData(this.createdDate, this.profileUrl, this.userName, this.userLevel, this.review, this.linkButton);

}
