import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/view/page/loginPage/signup_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:string_validator/string_validator.dart';

import 'signup_state3.dart';

class SignUpState2 extends StatefulWidget {
  @override
  _SignUpState2State createState() => _SignUpState2State();
}

class _SignUpState2State extends State<SignUpState2> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context){
          return SizedBox(  width: double.infinity, height: double.infinity,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SafeArea(
                          bottom: false,
                          child:
                          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
                            Navigator.of(context).pop();
                            if(signUpData.isSNS)
                              Navigator.of(context).pop();
                          },),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 18),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                            Expanded(child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          style: const TextStyle(
                                              color: MColors.tomato,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "NotoSansKR",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 18.0
                                          ),
                                          text: "비밀번호"),
                                      TextSpan(
                                          style: MTextStyles.bold18Black,
                                          text: "를\n입력해 주세요.")
                                    ]
                                )
                            )),
                            Padding(
                              padding: const EdgeInsets.only(right:6.0, top: 12.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: MColors.tomato,
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:6.0, top: 12.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: MColors.tomato,
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:6.0, top: 12.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: MColors.white,
                                  border: Border.all(color: MColors.tomato, ),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:20.0, top: 12.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: MColors.white,
                                  border: Border.all(color: MColors.tomato, ),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            ),
                          ],),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 20, top: 40),
                        //   child: RichText(
                        //       text: TextSpan(
                        //           children: [
                        //             TextSpan(
                        //                 style: const TextStyle(
                        //                     color: MColors.tomato,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontFamily: "NotoSansKR",
                        //                     fontStyle: FontStyle.normal,
                        //                     fontSize: 18.0
                        //                 ),
                        //                 text: "비밀번호"),
                        //             TextSpan(
                        //                 style: MTextStyles.bold18Black,
                        //                 text: "를 입력해 주세요.")
                        //           ]
                        //       )
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 36, top: 24),
                          child: Text('비밀번호', style: MTextStyles.medium14Grey06,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 6, right: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 2),
                            height: 46,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),
                                border: Border.all(
                                    color: password1Controller.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
//                        color: MColors.tomato ,
                                    width: 1
                                )
                            ),
                            child: TextFormField(
                              controller: password1Controller,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              maxLines: 1,
                              style: MTextStyles.regular14Grey06,
                              decoration: InputDecoration(
                                suffixIcon: Transform.translate(
                                  offset: Offset(16,2),
                                  child: IconButton(
                                    onPressed: () => setState(() =>password1Controller.clear()),

                                    icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: password1Controller.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
                                  ),
                                ),
                                hintText: "아래 조건으로 입력해 주세요.",
                                hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.transparent
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value){
                                if(value.length >15)
                                  password1Controller.text = value.substring(0,15);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 36, top: 6),
                          child: Text('영문 / 숫자 / 6~15자리', style: MTextStyles.regular12Grey06,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 36, top: 16),
                          child: Text('비밀번호 확인', style: MTextStyles.medium14Grey06,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 6, right: 20, bottom: 140.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 2),
                            height: 46,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),
                                border: Border.all(
                                    color: password2Controller.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
//                        color: MColors.tomato ,
                                    width: 1
                                )
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              controller: password2Controller,
                              maxLengthEnforced: true,
                              maxLines: 1,
                              style: MTextStyles.regular14Grey06,
                              decoration: InputDecoration(
                                suffixIcon: Transform.translate(
                                  offset: Offset(16,2),
                                  child: IconButton(
                                    onPressed: () => setState(() =>password2Controller.clear()),

                                    icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: password2Controller.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
                                  ),
                                ),
                                hintText: "비밀번호를 다시 입력해 주세요.",
                                hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.transparent
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value){
                                if(value.length >15)
                                  password2Controller.text = value.substring(0,15);
                                setState(() {});
                              },
                            ),
                          ),
                        ),
//                      Padding(
//                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 69, bottom: 30),
//                        child: Container(
//                          width: double.infinity,
//                          height: 48,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(
//                                  Radius.circular(24)
//                              ),
//                              color: MColors.tomato
//                          ),
//                          child: FlatButton(child: Text('다음', style: MTextStyles.bold14White,), onPressed: (){
//
//                          },),
//                        ),
//                      ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20, right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(24)
                        ),
                        color: MColors.tomato
                    ),
                    child: FlatButton(child: Text('다음', style: MTextStyles.bold14White,), onPressed: (){
                      final password1 = password1Controller.text;
                      final password2 = password2Controller.text;
                      final regExp = RegExp('^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}\$');
                      String message = '';
                      if(password1.length < 6){
                        message = '6자 이상으로 입력해 주세요.';
                      } else if(password1 != password2){
                        //패스워드 다름
                        message = '비밀번호가 다릅니다.';
                      } else if(isAlpha(password1)){
                        //숫자가 포함되어야함
                        message = '숫자가 포함되어야 합니다.';
                      } else if(isNumeric(password1)){
                        //영문자가 포함되어야함
                        message = '영문자가 포함되어야 합니다.';
//                        } else if(contains(password1,  )){
//                          message = '숫자와 영문자가 포함되어야 합니다.';
                      } else {
                        signUpData.password = password1Controller.text;
                        Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>SignUpState3()));
                        return;
                      }
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),));

                    },),
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}

