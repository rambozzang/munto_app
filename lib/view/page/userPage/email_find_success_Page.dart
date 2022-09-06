import 'package:flutter/material.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class EmailFindSuccessPage extends StatefulWidget {
  String joineMail;
  EmailFindSuccessPage({this.joineMail});
  @override
  _EmailFindSuccessPageState createState() => _EmailFindSuccessPageState();
}

class _EmailFindSuccessPageState extends State<EmailFindSuccessPage> {
  @override
  Widget build(BuildContext context) {
    bool hasData =  widget.joineMail != null && widget.joineMail.isNotEmpty && widget.joineMail != 'no munto';

    return Scaffold(
      appBar: _appbar(),
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                const SizedBox(
                  height: 34,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TitleBold16BlackView(!hasData ? 'SNS가입회원 입니다.\nSNS로그인을 이용해 주세요.' :'입력하신 정보와 일치하는 이메일 정보입니다.', ''),
                ),
                const SizedBox(
                  height: 34,
                ),
                if(hasData)
                  _buildTitle('가입한 이메일'),
                if(hasData)
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (String arg) {
                        if (arg.length <= 1) {
                          // alert("받는분 이름을 정확히 입력하세요!");
                          return '이름을 입력해주세요!';
                        } else {
                          return null;
                        }
                      },
                      enabled: false,
                      style: MTextStyles.regular14BlackColor,
                      maxLength: 100,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: new EdgeInsets.all(
                          7.0,
                        ),
                        hintText: widget.joineMail, //'이름을 입력해주세요',
                        hintStyle: MTextStyles.bold14BlackColor,
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: MColors.greyish,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                if(hasData)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      color: MColors.tomato,
                    ),
                    child: FlatButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil('LoginPage2', (route) => route.isFirst),
                      //Navigator.of(context).pushNamed('LoginPage2'),
                      child: Center(
                        child: Text('로그인', style: MTextStyles.bold16White, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                if(hasData)
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('PasswordFindPage');
                    },
                    child: Text(
                      '비밀번호 재설정',
                      style: TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: MColors.tomato,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ]))),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "이메일 찾기",
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

  Widget _buildTitle(String title) {
    return Container(
      height: 22,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Text(
        title,
        style: MTextStyles.medium14Grey06,
      ),
    );
  }
}
