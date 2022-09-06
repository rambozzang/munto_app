import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/exceptions.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/signup_provider.dart';
import 'package:munto_app/view/page/loginPage/login_page.dart';
import 'package:munto_app/view/page/loginPage/signup_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';



class SignUpState4 extends StatefulWidget {
  @override
  _SignUpState4State createState() => _SignUpState4State();
}

class _SignUpState4State extends State<SignUpState4> {
  final _formKey4 = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  int selectedSexIndex = 0;

  String errorMessage = '';
  @override
  Widget build(BuildContext context1) {
    final signUpProvider = Provider.of<SignUpProvider>(context1);
    final loginProvider = Provider.of<LoginProvider>(context1, listen: false);
    return Stack(
      children: [
        Scaffold(
          body: Builder(
            builder: (buildContext){
              return SizedBox( width: double.infinity, height: double.infinity,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SafeArea(
                              bottom: false,
                              child:
                              IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
                                Navigator.of(buildContext).pop();
                              },),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 18),
                              child: Row(children: <Widget>[
                                Expanded(child: Text('전화번호를 입력해 주세요.',style: MTextStyles.bold18Black,)),
                                Padding(
                                  padding: const EdgeInsets.only(right:6.0),
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
                                  padding: const EdgeInsets.only(right:6.0),
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
                                  padding: const EdgeInsets.only(right:6.0),
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
                                  padding: const EdgeInsets.only(right:20.0),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: MColors.tomato,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                    ),
                                  ),
                                ),
                              ],),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 20, top: 40),
                            //   child: Text('전화번호를 입력해 주세요.',style: MTextStyles.bold18Black,),
                            // ),

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 20, top: 20),
                            //   child: Text('선택사항',style: MTextStyles.medium12BrownGrey,),
                            // ),

                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 56, right: 20),
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16, bottom: 2),
                                height: 46,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)
                                    ),
                                    border: Border.all(
                                        color: phoneNumberController.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
//                        color: MColors.tomato ,
                                        width: 1
                                    )
                                ),
                                child: TextFormField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  style: MTextStyles.regular14Grey06,
                                  decoration: InputDecoration(
                                    suffixIcon: Transform.translate(
                                      offset: Offset(16,2),
                                      child: IconButton(
                                        onPressed: () => setState(() =>phoneNumberController.clear()),

                                        icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: phoneNumberController.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
                                      ),
                                    ),
                                    hintText: "01012345678",
                                    hintStyle: MTextStyles.regular14Warmgrey,
//                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Colors.transparent
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(13),
                                  ],

                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 36.0, top: 6, right: 36, bottom: 10.0),
                              child: Text(
                                  "추후에 모임 안내 및 결제문자 발송을 위해 사용되므로 정확하게 입력해주세요.",
                                  style: MTextStyles.regular12Grey06
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 36.0, top: 20, right: 36, bottom: 10.0),
                              child: Text(
                                  errorMessage,
                                  style: MTextStyles.regular12Tomato
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20, right: 20,
                      bottom: MediaQuery.of(buildContext).viewInsets.bottom + 30,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 10, right: 8, bottom: 14.0),
                            // child: Text('계정 생성과 동시에 서비스 이용약관, 개인정보 보호약관에 동의하게 됩니다.', style: MTextStyles.regular12Grey06,),
                            child:           RichText(
                                text: new TextSpan(children: [
                                  new TextSpan(
                                    text: "계정 생성과 동시에 서비스",
                                    style: MTextStyles.regular13Grey06,
                                  ),
                                  new TextSpan(
                                      text: "이용약관",
                                      style: MTextStyles.bold14Grey06,
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        launch('https://www.munto.co.kr/policy');
                                      }
                                  ),
                                  new TextSpan(
                                    text: ",",
                                    style: MTextStyles.regular13Grey06,
                                  ),
                                  new TextSpan(
                                      text: "개인정보 보호약관",
                                      style: MTextStyles.bold14Grey06,
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        launch('https://www.munto.kr/privacy');
                                      }
                                  ),
                                  new TextSpan(
                                    text: "에 동의합니다.",
                                    style: MTextStyles.regular13Grey06,
                                  ),
                                ])),
                          ),
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(24)
                                ),
                                color: MColors.tomato
                            ),
                            child: FlatButton(child: Text('회원가입 완료', style: MTextStyles.bold14White,), onPressed: () async {

                                final number = phoneNumberController.text.replaceAll('-', '').replaceAll(' ', '');
                                if(isNumeric(number) && number.length > 8) {
                                  signUpData.phoneNumber = addDashes(number);
                                  print(signUpData.toMap().toString());

                                  try {
                                    AppStateLog(context, SIGN_UP);

                                    final result = await signUpProvider.signUp(signUpData);
                                    if (result){
                                      await showDialog(
                                        context: buildContext,
                                        builder: (dialogContext) => AlertDialog(
                                          title: Text('회원가입 완료'),
                                          content: Text('문토에 가입해주셔서 감사합니다.'),
                                          actions: [
                                            FlatButton(
                                              child: Text('확인'),
                                              onPressed: (){
                                                Navigator.of(dialogContext).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ).then((value) {
                                        if(signUpData.isSNS){
                                          Navigator.of(buildContext).popUntil((route) => route.isFirst);
                                          // Navigator.of(context).pushReplacement(
                                          //     CupertinoPageRoute(builder: (_) => Main()));
                                          loginProvider.setIsAuth(LoginStatus.Login);
                                        } else {
                                           Navigator.of(buildContext).popUntil((route) => route.isFirst);
                                        //  Navigator.of(context).popUntil(ModalRoute.withName("/LoginPage2"));
                                          loginProvider.setIsAuth(LoginStatus.Logout);
                                        }
                                      }).catchError((error){
                                        print('catchError : ${error.toString()}');

                                      });
                                      // Navigator.of(context).popUntil(ModalRoute.withName("/LoginPage2"));
                                    }

                                  }on BadRequestException catch (e) {
                                    print('e = ${e.toString()}');
                                    signUpProvider.setStateIdle();
                                    Scaffold.of(buildContext).showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content: Text('${e.toString()}'),
                                    ));
                                    print(e.toString());
                                  } on SocketException catch (e) {
                                    print('e = ${e.toString()}');
                                    signUpProvider.setStateIdle();
                                    Scaffold.of(buildContext).showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content: Text('네트워크 연결을 확인해 주세요'),
                                    ));
                                  } on TimeoutException catch (e) {
                                    print('TimeoutException = ${e.toString()}');
                                    signUpProvider.setStateIdle();
                                    Scaffold.of(buildContext).showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content: Text('네트워크 상태를 확인해 주세요'),
                                    ));
                                  } on Exception catch (e){
                                    setState(() {
                                      errorMessage = e.toString();
                                    });
                                    print('Exception = ${e.toString()}');
                                    signUpProvider.setStateIdle();

                                  }

                                } else {
                                  Scaffold.of(buildContext).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    content: Text('올바른 전화번호를 입력해 주세요'),
                                  ));
                                }

                            },),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              );
            },
          ),
        ),
        signUpProvider.state == ViewState.Busy
            ? Container(
          color: Color.fromRGBO(100, 100, 100, 0.5),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : SizedBox.shrink()

      ],
    );
  }

  String addDashes(String number) {
    if(number.length == 9)
      return '${number.substring(0,2)}-${number.substring(2,5)}-${number.substring(5,9)}';
    if(number.length == 10)
      if(number.substring(0,2) == '02')
        return '${number.substring(0,2)}-${number.substring(2,6)}-${number.substring(6,10)}';
      else
        return '${number.substring(0,3)}-${number.substring(3,6)}-${number.substring(6,10)}';
    if(number.length == 11)
      return '${number.substring(0,3)}-${number.substring(3,7)}-${number.substring(7,11)}';
    return number;
  }

}

