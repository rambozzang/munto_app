import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문토란', style: MTextStyles.bold16Black,),
        elevation: 0.0,
        backgroundColor: MColors.barBackgroundColor ,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(barBorderWidth),
          child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.network('https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1579698419970_2500.jpg', fit: BoxFit.cover,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Text('소셜살롱, 문토', style: MTextStyles.bold20Black36,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text('내 안의 다양한 가능성에 주목하는 취향 기반 모임 공동체 라이프스타일 플랫폼입니다.', style: MTextStyles.medium14PinkishGrey,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30.0),
            child: Text('∙ 좋아하는 취향을 다른 사람들과 공유하며\n\n∙ 관심사를 나눌 다양한 사람들을 만나며\n\n∙ 일상을 더욱 특별하게 만들어 갑니다', style: MTextStyles.medium14Grey06,),
          ),







        ],),
      ),
    );
  }
}
