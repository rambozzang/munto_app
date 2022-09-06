import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/model/question_data.dart';
import 'package:munto_app/view/page/etcPage/question_profile_page.dart';
import 'package:munto_app/view/page/etcPage/tag_profile_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class PopularQuestionWidget extends StatelessWidget {
  final List<QuestionData> list;
  PopularQuestionWidget(this.list);
  PageController pageController = PageController(viewportFraction: 0.91);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // screenSize.width
    final horizonPadding = 5.0;
    final itemSize = 103.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children:<Widget>[
      Padding(
        padding: const EdgeInsets.only(left:20.0, top: 40, bottom: 12.0),
        child: Text('함께 나눌 질문들 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MColors.blackColor ),),
      ),
      Container(
        height: itemSize ,
        width: double.infinity,
        // color: Colors.yellow,
        child: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index){
            final questionData = list[index];
            final tag = questionData.mainTag;
            final path = questionData.imagePath;
            final question = questionData.question;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all( Radius.circular(8) ),
                child: Container(
                  width: 103, height: 103,
                  child:
                  Stack(children: <Widget>[
                    Positioned.fill(child: Image.asset(path, fit: BoxFit.cover)),
                    // Container(color: const Color(0x66000000),),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('', style: MTextStyles.bold14White, textAlign: TextAlign.center),
                      ),
                    ),
                    FlatButton(child: Container(), onPressed: (){
                      Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>QuestionProfilePage(questionData)));

                    },),
                  ],),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}



