import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';


class GuestBannerWidget extends StatelessWidget {
  final VoidCallback onPositive;
  final VoidCallback onCancel;
  GuestBannerWidget({@required this.onPositive, @required this.onCancel});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,height: double.infinity,
      child: Column(children:[
        Expanded(child: GestureDetector(onTap: (){
          onCancel();
        },)),
        Container(
          decoration: BoxDecoration(color: const Color(0xcc000000)),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0),
          child: Text(
              "잠깐! 피드 업로드 전에👀\n다른 멤버들이 회원님을 알 수 있도록 아래 버튼을 눌러서 프로필을 설정해주세요.",
              style: MTextStyles.bold14White),
        ),
        Container(
          color: const Color(0xcc000000),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 16.0),
          child: Container(
            width: double.infinity, height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(24)
                ),
                color: MColors.tomato
            ),
            child: FlatButton(child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Text('10초만에 프로필 설정하기', style: MTextStyles.bold14White,),
              SvgPicture.asset('assets/icons/arrow_right.svg', color: MColors.white,),
            ],), onPressed: onPositive,),
          ),
        )
      ]),
    );
  }
}
