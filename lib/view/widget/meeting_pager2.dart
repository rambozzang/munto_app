import 'package:flutter/material.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/style_data.dart';
import 'package:munto_app/view/style/textstyles.dart';

const pagerItemRatio = 200 / 360;


class MeetingPagerWidget2 extends StatelessWidget {

  MeetingGroup group;
  MeetingPagerWidget2(this.group);
  List<MeetingItem> get dataList => group.list;

  final magazinePageController = PageController(viewportFraction: pagerItemRatio);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = pagerItemRatio * screenSize.width;
    final itemHeight = itemWidth * 283 / 200;

    return Column(children:<Widget>[
      Container(
        height: 38,
        width: double.infinity,
        color: MColors.white_two,
        padding: EdgeInsets.only(top: 14, left: 20),
        child: Text(group.header.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MColors.blackColor ),),
      ),
      dataList == null || dataList.length == 0?
      Container(height: itemHeight,child: Center(child: Text('모임정보를 불러오지 못했습니다.😢')),)
          :Container(
        height: itemHeight + 40,
        width: double.infinity,
        color: MColors.white_two,
        padding: EdgeInsets.only(top: 16, bottom: 24),
        child: PageView.builder(

          controller: magazinePageController,
          itemCount: dataList.length,
          itemBuilder: (context, index){
            final item = dataList[index];
            final url = index%3 == 0? 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1569405599045_500.png'
                : index%3 ==1? 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1595079259032_500.png'
                : 'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1590634785022_500.png';
            return Transform.translate(
              offset: Offset(-screenSize.width*(1-pagerItemRatio) / 2 + 20,0),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: itemHeight ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: MColors.pinkishGrey10),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(child: Image.network(url, fit: BoxFit.cover,),),
                      Positioned(
                        left: 10, top: 10,
                        child: Container(
                          width: 66,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)
                              ),
                              color: Color.fromRGBO(255, 82, 82, 0.8)
                          ),
                          child: Center(child: Text('시작1일전', style: MTextStyles.bold10White,)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}

