import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class UserFindMainPage extends StatefulWidget {
  @override
  _UserFindMainPageState createState() => _UserFindMainPageState();
}

class _UserFindMainPageState extends State<UserFindMainPage> {
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      child: new Text(
                        '계정정보를 잊으셨나요?',
                        textAlign: TextAlign.start,
                        style: MTextStyles.bold24Grey06,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 60,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 74,
                  // padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: MColors.pinkish_grey, width: 1.0),
                  ),
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).pushNamed('EmailFindPage'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.pause_presentation_sharp),
                            ),
                            Center(
                              child: Text('이메일 찾기', style: MTextStyles.bold16Grey06, textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 74,
                  // padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: MColors.pinkish_grey, width: 1.0),
                  ),
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).pushNamed('PasswordFindPage'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.pause_presentation_sharp),
                            ),
                            Center(
                              child: Text('비밀번호 찾기', style: MTextStyles.bold16Grey06, textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        )
                      ],
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
