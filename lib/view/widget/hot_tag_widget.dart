import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/view/page/etcPage/tag_profile_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';


class PopularTagWidget extends StatelessWidget {
  final List<TagData> dataList ;
  PopularTagWidget(this.dataList);
  @override
  Widget build(BuildContext context) {
    final itemSize = 103.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children:<Widget>[
      Padding(
        padding: const EdgeInsets.only(left:20.0, top: 40, bottom: 12.0),
        child: Text('인기태그 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MColors.blackColor ),),
      ),
      dataList == null || dataList.length == 0?
        Container(height: itemSize ,child: Center(child: Text('태그 정보를 불러오지 못했습니다.😢')),)
      :Container(
        height: itemSize ,
        width: double.infinity,
        // color: Colors.yellow,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dataList.length,
          itemBuilder: (context, index){
            final item = dataList[index];
            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Transform.translate(
                offset: Offset(20.0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all( Radius.circular(8) ),
                  child: Container(
                    width: 103, height: 103,
                    child:
                    Stack(children: <Widget>[
                      Positioned.fill(child: item.image != null ? CachedNetworkImage(imageUrl: item.image,fit: BoxFit.cover,) :Container()),
                      Container(color: const Color(0x66000000),),
                      Center(
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              border: Border.all(color: MColors.white, width: 1)
                          ),
                          child: // 마케팅
                          Text(item.name, style: MTextStyles.bold14White, textAlign: TextAlign.center),
                        ),
                      ),
                      FlatButton(child: Container(), onPressed: (){
                        print('selectedTag = ${item.name}');
                        Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>
                            ChangeNotifierProvider(
                              create: (_)=>TagProfileProvider(item),
                              child: TagProfilePage(item),
                            )
                        ));

                      },),
                    ],),
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



