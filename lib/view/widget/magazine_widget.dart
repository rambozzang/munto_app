import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/style_data.dart';
import 'package:munto_app/view/style/textstyles.dart';

const pagerItemRatio = 280 / 360;

class MagazineWidget extends StatelessWidget {

  final List<MagazineData> dataList;
  MagazineWidget(this.dataList);

  final magazinePageController = PageController(viewportFraction: pagerItemRatio);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(children:<Widget>[
      Container(
        height: 38,
        width: double.infinity,
        color: MColors.white_two,
        padding: EdgeInsets.only(top: 14, left: 20),
        child: Row(
          children: <Widget>[
            Expanded(child: Text('매거진 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MColors.blackColor ),)),
            Padding(
              padding: const EdgeInsets.only(right: 20,),
              child: Text('전체보기>', style: MTextStyles.regular14PinkishGrey, ),
            )
          ],
        ),
      ),
      dataList == null || dataList.length == 0?
      Container(height: 140,child: Center(child: Text('매거진을 불러오지 못했습니다.😢')),)
          :Container(
        height: 440,
        width: double.infinity,
        color: MColors.white_two,
        padding: EdgeInsets.only(top: 16, bottom: 24),
        child: PageView.builder(

          controller: magazinePageController,
          itemCount: dataList.length,
          itemBuilder: (context, index){
            final item = dataList[index];

            return Transform.translate(
              offset: Offset(-screenSize.width*(1-pagerItemRatio) / 2 + 20,0),
              child: Container(
                margin: EdgeInsets.only(right: 10),
//                height: 430,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(color: MColors.pinkishGrey10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
                      child: Image.network(item.imageUrl,fit: BoxFit.cover, height: 198,width: double.infinity,)),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20.0, top: 16),
                      child: Text(item.category, style: MTextStyles.medium12PinkishGrey,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20.0, top: 8),
                      child: Text(item.title, style: MTextStyles.bold18Grey06, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0, right: 20.0, top: 12),
                      child: Text(item.description, style: MTextStyles.regular14Grey06, maxLines: 3, overflow: TextOverflow.ellipsis,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only( right: 20.0, top: 16),
                      child:
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 70.0,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(17.5)
                            ),
                            border: Border.all(
                                color: MColors.white_three,
                                width: 1
                            ),
                          ),
                          child:
                          FlatButton(
                            padding: EdgeInsets.zero,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,children:[
                            Text('이어읽기', style: MTextStyles.regular12Greyish,)
                            ]),
                            onPressed: (){
                            },
                          )
                        ),
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



final magazineDummyData = [
  MagazineData('https://t1.daumcdn.net/cfile/tistory/267BF03A52F4CCCA0F', '문토 레터', '한계가 없는 뮤지션이 되고싶어요',
      '재즈하면 무엇이 떠오르시나요? 여기 재즈에서도 독특한 발자취를 남겨가고 있는 아티스트가 있습니다. 선화예고, 서울대 기악과…', ''),
  MagazineData('https://t1.daumcdn.net/cfile/tistory/267BF03A52F4CCCA0F', '문토 레터', '한계가 없는 뮤지션이 되고싶어요',
      '재즈하면 무엇이 떠오르시나요? 여기 재즈에서도 독특한 발자취를 남겨가고 있는 아티스트가 있습니다. 선화예고, 서울대 기악과…', ''),
  MagazineData('https://t1.daumcdn.net/cfile/tistory/267BF03A52F4CCCA0F', '문토 레터', '한계가 없는 뮤지션이 되고싶어요',
      '재즈하면 무엇이 떠오르시나요? 여기 재즈에서도 독특한 발자취를 남겨가고 있는 아티스트가 있습니다. 선화예고, 서울대 기악과…', ''),
  MagazineData('https://t1.daumcdn.net/cfile/tistory/267BF03A52F4CCCA0F', '문토 레터', '한계가 없는 뮤지션이 되고싶어요',
      '재즈하면 무엇이 떠오르시나요? 여기 재즈에서도 독특한 발자취를 남겨가고 있는 아티스트가 있습니다. 선화예고, 서울대 기악과…', ''),

];

class MagazineData {
  final String imageUrl;
  final String category;
  final String title;
  final String description;
  final String linkUrl;

  MagazineData(this.imageUrl, this.category, this.title,
      this.description, this.linkUrl);

}
