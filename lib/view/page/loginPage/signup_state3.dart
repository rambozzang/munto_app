import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/signup_provider.dart';
import 'package:munto_app/view/page/loginPage/signup_state4.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import 'signup_page.dart';

const String SEX_FEMAIL = 'FEMALE';
const String SEX_MALE = 'MALE';
const String SEX_NONE = 'NONE';

class SignUpState3 extends StatefulWidget {
  @override
  _SignUpState3State createState() => _SignUpState3State();
}

class _SignUpState3State extends State<SignUpState3> {
  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  int selectedSexIndex = 0;

  @override
  void initState() {
    super.initState();
    if(signUpData.sex != null && signUpData.sex == 'MALE')
      selectedSexIndex = 0;
    else if (signUpData.sex != null && signUpData.sex == 'FEMALE')
      selectedSexIndex = 1;
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
                    key: _formKey3,
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

                        // if(!kReleaseMode)
                        //   Container(height: 400,),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 18),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            Expanded(child: Text('이름을 입력하고\n성별을 선택해 주세요.',style: MTextStyles.bold18Black,)),
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
                                  color: MColors.tomato,
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
                        //   child: Text('이름을 입력하고\n성별을 선택해 주세요.',style: MTextStyles.bold18Black,),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20, top:32, right: 20),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 2),
                            height: 46,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)
                                ),
                                border: Border.all(
                                    color: nameController.text.length > 0 ? MColors.tomato : MColors.pinkish_grey,
//                        color: MColors.tomato ,
                                    width: 1
                                )
                            ),
                            child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              style: MTextStyles.regular14Grey06,
                              decoration: InputDecoration(
                                suffixIcon: Transform.translate(
                                  offset: Offset(16,2),
                                  child: IconButton(
                                    onPressed: () => setState(() =>nameController.clear()),

                                    icon: CircleAvatar(child: Icon(Icons.clear, size: 16,color: MColors.white,), backgroundColor: nameController.text.length > 0 ? MColors.warm_grey : MColors.white_three, radius: 10,),
                                  ),
                                ),
                                hintText: "이문토 *띄어쓰기, 특수문자 사용불가",
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
                                if(value.length >20)
                                  nameController.text = value.substring(0,20);
                                setState(() {});
                              },
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 36.0, top: 6, right: 36.0, bottom: 10.0),
                          child: Text(
                              "더 나은 커뮤니티를 만들어가기 위해 실명으로 입력해 주세요.",
                              style: MTextStyles.regular12Grey06
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)
                                      ),
                                      border: Border.all(
                                          color: selectedSexIndex == 0 ? MColors.tomato : MColors.pinkish_grey,
                                          width: 1
                                      )
                                  ),
                                child: FlatButton(child: Text('남성', style: selectedSexIndex == 0? MTextStyles.bold14Tomato : MTextStyles.regular14Warmgrey,), onPressed: (){
                                  setState(() {
                                    selectedSexIndex = 0;
                                  });
                                },),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 10),),
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)
                                    ),
                                    border: Border.all(
                                        color: selectedSexIndex == 1 ? MColors.tomato : MColors.pinkish_grey,
                                        width: 1
                                    )
                                ),
                                child: FlatButton(child: Text('여성', style: selectedSexIndex == 1? MTextStyles.bold14Tomato : MTextStyles.regular14Warmgrey,), onPressed: (){
                                  setState(() {
                                    selectedSexIndex = 1;
                                  });
                                },),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 10),),
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(8)
                                    ),
                                    border: Border.all(
                                        color: selectedSexIndex == 2 ? MColors.tomato : MColors.pinkish_grey,
                                        width: 1
                                    )
                                ),
                                child: FlatButton(child: Text('선택안함', style: selectedSexIndex == 2? MTextStyles.bold14Tomato : MTextStyles.regular14Warmgrey,), onPressed: (){
                                  setState(() {
                                    selectedSexIndex = 2;
                                  });
                                },),
                              ),
                            )                    ],),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left:32.0, top: 4.0),
                        //   child: Text('선택사항', style: MTextStyles.medium12BrownGrey,),
                        // )
                        SizedBox(height: 140,),


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
                      if(nameController.text.length > 0){
                        signUpData.sex =
                          selectedSexIndex == 0? SEX_MALE :
                          selectedSexIndex == 1? SEX_FEMAIL :
                          SEX_NONE;
                        signUpData.name = nameController.text;
                        Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>
                            SignUpState4()
                        ));
                      }
                      else
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 1500),
                          content: Text('이름을 입력해 주세요.'),
                        ));

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

