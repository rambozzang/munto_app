import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

const pagerItemRatio = 306/380;
class RecommendWidget extends StatelessWidget {
  final List<RecommendData> dataList;
  final PageController pageController = PageController(viewportFraction: pagerItemRatio);

  RecommendWidget(this.dataList);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print('screenSize = ${screenSize.toString()}');
    return Container(
      height: 256,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text('다른 모임은 어떤 사람들이 모여있을까?👀', style: MTextStyles.regular14Grey06,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 15),
          child: Text('MPASS 추천모임', style: MTextStyles.bold18Black,),
        ),
        Container(
          height: 152,
          child: PageView.builder(
            controller: pageController,
            itemCount: dataList.length,
            itemBuilder: (context, index){
              final item = dataList[index];
              return Container(
                width: 306,
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: MColors.white_three),
                  color: Colors.white,
                ),
                child:Row(children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Container(width: double.infinity,child: Text(item.title, style: MTextStyles.bold18Black, textAlign: TextAlign.center,)),
                        Padding(padding: EdgeInsets.only(bottom: 2),),
                      Text(item.subtitle, style: MTextStyles.regular14Grey05,),
                        Padding(padding: EdgeInsets.only(bottom: 12),),
                      Row(children: <Widget>[
                        CircleAvatar(backgroundImage: NetworkImage(item.profileUrl), radius: 12,),
                        Padding(padding: EdgeInsets.only(right: 6),),
                        Text(item.userName, style: MTextStyles.bold12Black,),
                        Padding(padding: EdgeInsets.only(right: 4),),
                        Text(item.userLevel, style: MTextStyles.regular10WarmGrey,),
                      ],),
                      Padding(padding: EdgeInsets.only(bottom: 7),),
                      Text(item.startingDate, style: MTextStyles.bold10Black,),
                    ],),
                  ),
                  Stack(
                    children: <Widget>[
                    Container(
                      width: 104,
                      height: 104,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.network(item.imageUrl,fit: BoxFit.cover,)),
                    )
                  ],)
                ],
                )
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    SizedBox(
//                      height: 24,
//                      child: Row( children: <Widget>[
//                        CircleAvatar(backgroundImage: NetworkImage(item.profileUrl), radius: 12,),
//                        Padding(padding: EdgeInsets.only(right: 4)),
//                        Text(item.userName, style: TextStyle(color: blackColor, fontSize: 12, fontWeight: FontWeight.bold, ),),
//                        Padding(padding: EdgeInsets.only(right: 3)),
//                        Text(item.userLevel, style: TextStyle(color: warmGrey, fontSize: 10, ),),
//                        Expanded(child: Text(item.startingDate, textAlign: TextAlign.right, style: TextStyle(color: warmGrey, fontSize: 10, )),)
//                      ],),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(top:7.0, bottom: 7),
//                      child: Text(item.title, maxLines: 2,),
//                    ),
//                    Container(
//                      width: 140,
//                      height: 28,
//                      decoration: BoxDecoration(color: goldenRob ,borderRadius: BorderRadius.all(Radius.circular(22.5 ))),
//                      child: FlatButton(
//                        padding: EdgeInsets.zero,
//                        child: Text(item.subtitle, style: TextStyle(color: blackColor, fontSize: 10, fontWeight: FontWeight.bold),), onPressed: (){
//                        print('go review detail');
//                      },),
//                    )                        ],
//                ),

              );
            },
          ),
        )
      ],),
    );
  }
}

final recommendDummyData = [
  RecommendData('합정 | 07/04(토) 오후 8시', 'https://is.gd/LqnDOZ','서준혁', '리더', '사기꾼의 글짓기',
      '1회차 나에 대해서 써보기', 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/product/image_1584415272335_1000.jpg'),
  RecommendData('합정 | 07/04(토) 오후 8시', 'https://is.gd/LqnDOZ','서준혁', '리더', '사기꾼의 글짓기',
      '1회차 나에 대해서 써보기', 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/product/image_1584415272335_1000.jpg'),
  RecommendData('합정 | 07/04(토) 오후 8시', 'https://is.gd/LqnDOZ','서준혁', '리더', '사기꾼의 글짓기',
      '1회차 나에 대해서 써보기', 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/product/image_1584415272335_1000.jpg'),
  RecommendData('합정 | 07/04(토) 오후 8시', 'https://is.gd/LqnDOZ','서준혁', '리더', '사기꾼의 글짓기',
      '1회차 나에 대해서 써보기', 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/product/image_1584415272335_1000.jpg'),

];

class RecommendData {
  //user
  final String profileUrl;
  final String userName;
  final String userLevel;

  //recommend
  final String startingDate;
  final String title;
  final String subtitle;
  final String imageUrl;

  RecommendData(this.startingDate, this.profileUrl, this.userName, this.userLevel, this.title, this.subtitle, this.imageUrl);

}
