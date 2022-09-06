import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class PasswordNofindPage extends StatefulWidget {
  @override
  _PasswordNofindPageState createState() => _PasswordNofindPageState();
}

class _PasswordNofindPageState extends State<PasswordNofindPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Text(
                        '일치하는 계정이 없습니다!',
                        textAlign: TextAlign.start,
                        style: MTextStyles.bold16Tomato,
                      ),
                      new Text(
                        '입력한 정보를 다시 확인해 주세요.',
                        textAlign: TextAlign.start,
                        style: MTextStyles.bold16Black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 44,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                   height: 48 ,
                  // padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: MColors.tomato,
                  ),
                  child: FlatButton(
                    onPressed: ()=> Navigator.of(context).pushNamed('EmailFindPage'),
                    child: Center(
                      child: Text('문토 이메일 찾기', style: MTextStyles.bold14White, textAlign: TextAlign.center),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 48 ,
                  // padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: MColors.white_three,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('LoginPage2', (route) => route.isFirst);
                      //Navigator.of(context).pushNamed('LoginPage2'),

                    },
                    child: Center(
                      child: Text('로그인', style: MTextStyles.bold14Black, textAlign: TextAlign.center),
                    ),
                  ),
                ),

                //  _cardListBox(),
              ],
            ),
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "비밀번호 찾기",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
    );
  }
}
