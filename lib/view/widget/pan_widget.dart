import 'dart:math';

import 'package:flutter/material.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/style_data.dart';
import 'package:munto_app/view/style/textstyles.dart';

const defaultSidePadding = EdgeInsets.symmetric(horizontal: 20);

class PanWidget extends StatefulWidget {
  final String title;
  final Color headerColor;
  bool isSubscribing;
  final int memberCount;

  PanWidget(this.title, this.headerColor, this.isSubscribing, this. memberCount);

  @override
  _PanWidgetState createState() => _PanWidgetState();
}

class _PanWidgetState extends State<PanWidget> {

  String profile1 = 'https://is.gd/rPq59k';
  String profile2 = 'https://is.gd/LqnDOZ';
  String profile3 = 'https://is.gd/U16ru2';
  String profile4 = 'https://is.gd/LqnDOZ';
  String coffeeUrl = 'https://is.gd/RPlpVh';


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: defaultSidePadding,
      width: double.infinity,
      height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        color: MColors.tomato,
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildItem(profile1, '여름밤에 듣는 Blue in Green', '마일즈에 색소폰 연주를 듣고 있으면 낮에 더위도 잊은 채  무더위를 싹 날려버리는 기분이 들곤 해요..', null ),
          _buildItem(profile2, '비가 내리면 쳇 베이커…','비가 내리면 괜히 우울해지곤 하는데.. 저는 쳇 베이커 Come rain or Come shine…', coffeeUrl),
          _buildItem(profile3,'사무실 비지엠 재즈 앨범 추천좀!!','너무 삭막한 사무실 분위기로 인해 비지엠을 틀어보고자 하는데 그중에 재즈앨범으로 틀어보고 싶은데 추천좀…', null ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(

      width: double.infinity,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        color: widget.headerColor,
      ),
      child: Row(
        children: <Widget>[

          Padding(padding: EdgeInsets.only(left: 16),child: _buildProfileGroupWidget(Size(36,36))),
//          _buildProfileGroupWidget(Size(80,80 )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text(widget.title, style: TextStyle(color: MColors.whiteColor),),
                Row(children: [
                  Icon(Icons.people, size: 18, color: MColors.whiteColor,),
                  Padding(padding: EdgeInsets.only(right: 4),),
                  Text('${widget.memberCount}', style: TextStyle(fontSize: 12, color: MColors.whiteColor),)],)
              ],),
            ),
          ),
          Container(
            width: widget.isSubscribing? 58 : 48,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: MColors.whiteColor),
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: widget.isSubscribing? MColors.whiteColor : Colors.transparent
            ),
            child: widget.isSubscribing
              ? FlatButton(
                padding: EdgeInsets.zero,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,children:[
                  Icon(Icons.check, size: 12,),
                  Text('구독중', style: TextStyle(fontSize: 10),)
                ]),
                onPressed: (){
                  setState((){
                    widget.isSubscribing = false;
                  });
                },
              )
              : FlatButton(
                padding: EdgeInsets.zero,
                child: Text('+ 구독', style: TextStyle(fontSize: 10,color: MColors.whiteColor),),
                onPressed: (){
                  setState((){
                    widget.isSubscribing = true;
                  });
                }
                ,
              ),
          ),
          Padding(padding: EdgeInsets.only(right: 14),)

        ],
      ),
    );
  }

  Widget _buildItem(String profileUrl, String itemTitle, String itemDetail, String imageUrl){
    final borderSide = BorderSide(color: MColors.white_two, width: 1,);
    return Container(
      padding: EdgeInsets.only(top: 14, left: 14, right: 14),
      width: double.infinity,
      height: 106,
      decoration: BoxDecoration(
        border: Border(left: borderSide, right: borderSide, bottom: borderSide),
        color: MColors.whiteColor
      ),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(profileUrl), radius: 12,),
            Padding(padding: EdgeInsets.only(right: 8),),
            Expanded(child: Text(itemTitle ,style: MTextStyles.bold16Black,)),
            Text('방금 전', style: TextStyle(color: MColors.warm_grey, fontSize: 10),)
          ],),
          Padding(padding: EdgeInsets.only(bottom: 8),),
          Row(children: <Widget>[
            Expanded(child: Text(itemDetail, style: TextStyle(fontSize: 14, color: MColors.warm_grey,),maxLines: 2,)),
            Padding(padding: EdgeInsets.only(right: 8),),
            imageUrl != null ? SizedBox(width:44, height: 44,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(imageUrl, fit: BoxFit.cover,)))
            : SizedBox.shrink()
          ],),

        ],
      ),
    );
  }

  Widget _buildFooter() {
    final borderSide = BorderSide(color: MColors.white_two, width: 1,);
    return Container(
      width: double.infinity,
      height: 34,
      decoration: BoxDecoration(
          border: Border(left: borderSide, right: borderSide, bottom: borderSide),
          color: MColors.whiteColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text('더 보 기 ', style: TextStyle(color: MColors.pinkishGrey10, fontSize: 12),),
        Icon(Icons.chevron_right, color: MColors.pinkishGrey10, size: 12,)
      ],),
    );
  }

  Widget _buildProfileGroupWidget(Size size) {
    final itemSize = min(size.width / 2, size.height / 2);
    final radius = itemSize/2;
    final backgroundColor = MColors.whiteColor;
    final borderWidth = 0.5;
//    final borderWidth = 1;
    final firstTop = size.height / 2 - itemSize;
    final secondTop = size.height / 2;
    final firstLeft = size.width / 2 - itemSize;
    final secondLeft = size.width / 2;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: firstLeft, top: firstTop,
            width: itemSize, height: itemSize,
            child: CircleAvatar(radius: itemSize, backgroundColor: backgroundColor,child:
              CircleAvatar(radius:radius-borderWidth ,backgroundImage: NetworkImage('https://is.gd/rPq59k'),)),),
          Positioned(
            left: secondLeft, top: firstTop,
            width: itemSize, height: itemSize,
            child: CircleAvatar(radius: radius, backgroundColor: backgroundColor,child:
            CircleAvatar(radius:radius-borderWidth ,backgroundImage: NetworkImage('https://is.gd/LqnDOZ'),)),),
          Positioned(
            left: firstLeft, top: secondTop,
            width: itemSize, height: itemSize,
            child: CircleAvatar(radius: radius, backgroundColor: backgroundColor,child:
            CircleAvatar(radius:radius-borderWidth ,backgroundImage: NetworkImage('https://is.gd/U16ru2'),)),),
          Positioned(
            left: secondLeft, top: secondTop,
            width: itemSize, height: itemSize,
            child: CircleAvatar(radius: radius, backgroundColor: backgroundColor,child:
            CircleAvatar(radius:radius-borderWidth ,backgroundImage: NetworkImage('https://is.gd/LqnDOZ'),)),)
        ],
      ),
    );
  }

}
