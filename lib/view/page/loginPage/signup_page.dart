import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/signup_provider.dart';
import 'package:munto_app/view/page/loginPage/signup_state3.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import 'signup_state2.dart';

SignUpData signUpData;
class SignUpPage extends StatefulWidget {
  final String email;
  final String userAccountId;
  final String name;
  final String gender;

  SignUpPage({this.userAccountId, this.email, this.name, this.gender});
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    signUpData = SignUpData();
    signUpData.userAccountId = widget.userAccountId;
    signUpData.name = widget.name;
    signUpData.sex = widget.gender;

    print('isSNS = ${signUpData.isSNS.toString()}');
    print('userAccountId = ${signUpData.userAccountId}');

    if(widget.email != null && widget.email.isNotEmpty){
      signUpData.email = widget.email;
      goNext();
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
        builder: (context){
          return SizedBox( width: double.infinity, height: double.infinity,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Form(
                    key: _formKey1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SafeArea(
                          bottom: false,
                          child:
                          IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
                            Navigator.of(context).pop();
                          },),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 18),
                          child: Row(children: <Widget>[
                            Expanded(child: Text('회원가입', style: MTextStyles.bold24Grey06,)),
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
                                  color: MColors.white,
                                  border: Border.all(color: MColors.tomato, ),
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
                                  color: MColors.white,
                                  border: Border.all(color: MColors.tomato, ),
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
                                  color: MColors.white,
                                  border: Border.all(color: MColors.tomato, ),
                                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                ),
                              ),
                            ),

//              DotsIndicator(
//                dotsCount: 4,
//                position: 0,
//                decorator: DotsDecorator(
//                  size: Size(6,6),
//                  activeSize: Size(6,6),
//                  color: MColors.warm_grey,
//                  activeColor: MColors.tomato,
//
//                ),
//              )
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 40),
                          child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        style: MTextStyles.bold18Black,
                                        text: "계정으로 사용하실\n"),
                                    TextSpan(
                                        style: const TextStyle(
                                            color: MColors.tomato,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "NotoSansKR",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18.0
                                        ),
                                        text: "이메일"),
                                    TextSpan(
                                        style: MTextStyles.bold18Black,
                                        text: "을 입력해 주세요.")
                                  ]
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 24, right: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
                            height: 46,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),
                                border: Border.all(
                                    color: emailController.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
//                        color: MColors.tomato ,
                                    width: 1
                                )
                            ),
                            child: TextFormField(
                              controller: emailController,
                              maxLengthEnforced: true,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              style: MTextStyles.regular14Grey06,
                              decoration: InputDecoration(
                                suffixIcon: Transform.translate(
                                  offset: Offset(16,2),
                                  child: IconButton(
                                    onPressed: () => setState(() =>emailController.clear()),

                                    icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: emailController.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
                                  ),
                                ),
                                hintText: "example@munto.kr",
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
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        
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

                      if(isEmail(emailController.text)){
                        signUpData.email = emailController.text;
                        goNext();
                      }
                      else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 1500),
                          content: Text('정확한 이메일을 입력해 주세요.'),
                        ));
                      }
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

  void goNext() {
    Future.delayed(Duration.zero, (){
      if(signUpData.isSNS)
        Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>SignUpState3()));
      else
        Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>SignUpState2()));
    });
  }
}

