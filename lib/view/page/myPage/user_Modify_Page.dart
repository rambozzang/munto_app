import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/enum/loginProvier_Eum.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/userinfo.dart';

import 'package:munto_app/util.dart';
import 'package:munto_app/utils/date.dart';
import 'package:munto_app/utils/date_format.dart';
import 'package:munto_app/utils/date_util.dart';
import 'package:munto_app/utils/dropdown_date_picker.dart';
import 'package:munto_app/utils/valid_date.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
//import 'package:munto_app/view/widget/allways_disable_focus_node.dart';
import 'package:munto_app/view/widget/munto_text_field.dart';
import 'package:provider/provider.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:string_validator/string_validator.dart';

class CustomerModifyPage extends StatefulWidget {
  @override
  _CustomerModifyPageState createState() => _CustomerModifyPageState();
}

class _CustomerModifyPageState extends State<CustomerModifyPage> {
  String dayValue;
  String monthValue;
  ClassProvider classProvider = ClassProvider();
  UserProfileData userProfileData = UserProfileData();
  int yearValue;

  bool _autoValidate = false;
  ValidDate _birthday;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //성별 선택
  String _gender = "FEMALE";

  final StreamController<bool> _loadingCtrl = StreamController<bool>();
  // final TextEditingController _txtBirthday = TextEditingController();
  // final FocusNode _txtBirthdayFocus = FocusNode();
  final TextEditingController _txtEmail = TextEditingController();

  final FocusNode _txtEmailFocus = FocusNode();
  final TextEditingController _txtName = TextEditingController();
  final FocusNode _txtNameFocus = FocusNode();
  final TextEditingController _txtPassword1 = TextEditingController();
  final FocusNode _txtPassword1Focus = FocusNode();
  final TextEditingController _txtPassword2 = TextEditingController();
  final FocusNode _txtPassword2Focus = FocusNode();
  final TextEditingController _txtPhone = TextEditingController();
  final FocusNode _txtPhoneFocus = FocusNode();
  final StreamController<Response<UserProfileData>> _userProfileDataCtrl =
      StreamController<Response<UserProfileData>>();

  // 남자 여자 선택시 rxdart
  StreamController<String> _genderCtrl = StreamController.broadcast();
  // final TextEditingController _txtSex = TextEditingController();
  // final FocusNode _txtSexFocus = FocusNode();
  List<DropdownMenuItem<String>> _dropMenuListYear;
  List<DropdownMenuItem<String>> _dropMenuListMonth;
  List<DropdownMenuItem<String>> _dropMenuListDay;
  DropdownDatePicker dataPicker;
  bool isSnsUser = false;
  @override
  void dispose() {
    _userProfileDataCtrl.close();
    _loadingCtrl.close();
    _genderCtrl.close();
    super.dispose();
  }

  Future<void> checkSNSUser() async {
    final loginMethodProvider = await Util.getSharedString(KEY_LOGIN_PROVIDER);
    final loginType = EnumToString.fromString(LoginMethodProvider.values, loginMethodProvider); // ENUM 를 반환
     isSnsUser = loginType == LoginMethodProvider.KAKAO || loginType == LoginMethodProvider.APPLE || loginType == LoginMethodProvider.FACEBOOK;
}

  @override
  void initState() {
    super.initState();
    _dropMenuListYear = getDropDownMenuItems(1960, 2020, null, '년도');
    _dropMenuListMonth = getDropDownMenuItems(1, 12, null, '월');
    _dropMenuListDay = getDropDownMenuItems(1, 31, null, '일');
    checkSNSUser();
    getUserData();
    // _genderCtrl.sink.add('MALE');
  }

  getUserData() async {
    try {
      _userProfileDataCtrl.sink.add(Response.loading());
      userProfileData = await classProvider.getUserProfile();

      if(userProfileData.phoneNumber != '010-0000-0000')
        _txtPhone.text = userProfileData.phoneNumber.replaceAll('-', '') ?? '';
      if(userProfileData.email != TEMP_KAKAO_MAIL && userProfileData.email != TEMP_APPLE_MAIL)
        _txtEmail.text = userProfileData.email ?? '';
      if(userProfileData.name != '이름없음')
        _txtName.text = userProfileData.name ?? '';


      print('userProfileData.sex = ${userProfileData.sex}');
      DateTime birthDay;
      try{
        birthDay= DateTime.parse(userProfileData.birthDay).toLocal();
      } catch (e){}
      if(birthDay == null)
        birthDay = DateTime.now();
      print('birthDay.month ${birthDay.month} birthDay.day = ${birthDay.day}');

      // 생년월일 셋팅
      print(userProfileData.birthDay);
      if (userProfileData.birthDay != null || userProfileData.birthDay != '') {

        _birthday = ValidDate(year: birthDay.year, month: birthDay.month, day: (birthDay.day) ,);
        dataPicker = DropdownDatePicker(
          firstDate: ValidDate(year: 1970, month: 01, day: 01, hour: 1, minute: 1),
          lastDate: ValidDate(year: 2020, month: 12, day: 31, hour: 1, minute: 1),
          dateFormat: DateFormat.ymd,
          initialDate: _birthday,
          mainAxisAlignment: MainAxisAlignment.start,
        );
      } else {
        dataPicker = DropdownDatePicker(
          firstDate: ValidDate(year: 1970, month: 01, day: 01, hour: 1, minute: 1),
          lastDate: ValidDate(year: 2020, month: 12, day: 31, hour: 1, minute: 1),
          dateFormat: DateFormat.ymd,
          mainAxisAlignment: MainAxisAlignment.start,
        );
      }
      // 성별 셋팅
      print(userProfileData.sex);
      _gender = userProfileData.sex == 'MALE' ? 'MALE' : 'FEMALE';
      Future.delayed(Duration(seconds: 1), (){
        print('_genderCtrl.sink.add(_gender); = ${_gender}');
        _genderCtrl.sink.add(_gender);
      });
      _userProfileDataCtrl.sink.add(Response.completed(userProfileData));
    } catch (e) {
      _userProfileDataCtrl.sink.add(Response.error(e.toString()));
    }
  }

  void checkValue() {
    // if (_accountNumberTxtCtrl.text.length > 1 &&
    //     _accountHolderTxtCtrl.text.length > 5 &&
    //     _idNumberFrontTxtCtrl.text.length > 2 &&
    //     _idNumberBackTxtCtrl.text.length == 15) {
    //   print("체크완료...");

    // } else {
    //   print("체크완료...");
    // }
  }

  saveBudgetData() async {
    print('password : ${_txtPassword1.text}');

    print('name : ${_txtName.text}');
    print('phoneNumber : ${_txtPhone.text}');

    print('birthDay : ${dataPicker.year}${dataPicker.month}${dataPicker.day}');
    print('sex : $_gender');

    String phoneNumber = _txtPhone.text.replaceAll('-', '').replaceAll(' ', '');
    if(isNumeric(phoneNumber) && phoneNumber.length > 8) {
      phoneNumber = addDashes(phoneNumber);
    } else {
      Util.showOneButtonDialog(context, '휴대폰 번호를 입력해 주세요', '원활한 문토 이용을 위해\n휴대폰 번호를 입력해주세요', '확인', () { });
      return;
    }

    String email = _txtEmail.text;
    if(!isEmail(email)) {
      Util.showOneButtonDialog(context, '이메일을 입력해 주세요', '원활한 문토 이용을 위해\n이메일을 입력해주세요', '확인', () { });
      return;
    }
    if(_txtName.text.isEmpty) {
      Util.showOneButtonDialog(context, '이름을 입력해 주세요', '원활한 문토 이용을 위해\n이름을 입력해주세요', '확인', () { });
      return;
    }

    if(_gender != 'MALE' && _gender != 'FEMALE')
      _gender = 'NONE';


    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      _loadingCtrl.sink.add(true);
      // 저장 api 호출
      bool result = false;
      try {
        //  {
        //     "password": "string",
        //     "name": "string",
        //     "phoneNumber": "string",
        //     "birthDay": "string",
        //     "sex": "FEMALE"
        //   }



        final birthDayDate = DateTime(dataPicker.year, dataPicker.month, dataPicker.day);
        print('birthDayDate = ${birthDayDate.toIso8601String()}');
        Map<String, dynamic> map = Map();
        if(_txtPassword1.text != '')
          map['password'] = _txtPassword1.text;

        if(isSnsUser)
          map['email'] = email;
        map['name'] = _txtName.text;
        map['phoneNumber'] = phoneNumber;
        map['birthDay'] = birthDayDate.toIso8601String();
        if(_gender != null && _gender.isNotEmpty)
          map['sex'] = _gender;

        // _userProfileDataCtrl.sink.add(Response.loading());
        final result = await classProvider.putUser(map);
        if(result){
          print("입력 성공!!!!!");
          _loadingCtrl.sink.add(true);
          UserInfo.myProfile = await classProvider.getUserProfile();
          Navigator.pop(context);
        } else {
          _loadingCtrl.sink.add(false);
        }
        print('result : $result');

      } catch (e) {
        print('오류발생 : ${e.toString()}');
        _loadingCtrl.sink.add(false);
        _userProfileDataCtrl.sink.add(Response.error(e.toString()));
      }

      // if (result) {
      //   print("입력 성공!!!!!");
      //   Navigator.pop(context);
      // } else {
      //   print("입력 실패!!!!!");
      // }
    } else {
      print('form validate 에러.');
      setState(() => _autoValidate = true);
    }
  }

  //
  //  Vignesh123! : true
  //   vignesh123 : false
  //   VIGNESH123! : false
  //   vignesh@ : false
  //   12345678? : false
  //r'^
//   (?=.*[A-Z])       // should contain at least one upper case
//   (?=.*[a-z])       // should contain at least one lower case
//   (?=.*?[0-9])          // should contain at least one digit
//  (?=.*?[!@#\$&*~]).{8,}  // should contain at least one Special character
// $
  bool validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Widget _appBar() {
    return new AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
          Center(
            child: Text(
              '회원 정보 수정',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            child: Text(
              '완료',
              style: MTextStyles.bold14Tomato,
            ),
            onPressed: () => saveBudgetData(),
          ),
        ],
      ),
    );
  }

  Widget _getStreamBuild(snapshot) {
    if (snapshot.hasData) {
      switch (snapshot.data.status) {
        case Status.LOADING:
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(68.0),
            child: CircularProgressIndicator(),
          ));
          break;
        case Status.COMPLETED:
          return snapshot.data.data != null ? _getbody(snapshot.data.data) : _classNoDataWidget();
          break;
        case Status.ERROR:
          return Error(
            errorMessage: snapshot.data.message,
            onRetryPressed: () => null,
          );
          break;
      }
    }
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: CircularProgressIndicator(),
    ));
  }

  Widget _getbody(UserProfileData userProfileData) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 22,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                '이메일',
                style: MTextStyles.medium13Black_three,
              ),
            ),

            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MTextField(
                //  autofocus: true,
                // onClear: ()=>setState(()=>_txtEmail.clear()),

                controller: _txtEmail,
                enabled: isSnsUser,
                // validator: (String arg) {
                //   if (arg.length <= 1) {
                //     // alert("받는분 이름을 정확히 입력하세요!");
                //     return '받는분 이름을 정확히 입력하세요!';
                //   } else {
                //     return null;
                //   }
                // },
                // validator: Util.validateEmail,
                onChanged: (txt) {
                  checkValue();

                },
                style: isSnsUser ? MTextStyles.regular14BlackColor : MTextStyles.regular14PinkishGrey,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                },
                maxLength: 50,
                focusNode: _txtEmailFocus,
                hintText: 'example@naver.com',
                keyboardType: TextInputType.text,
              ),
            ),
            // !isSnsUser? Container(
            //   height: 22,
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 18.0),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 20.0,
            //   ),
            //   child: Row(
            //     children: [
            //       Text(
            //         '비밀번호',
            //         style: MTextStyles.medium13Black_three,
            //       ),
            //       const SizedBox(
            //         width: 11,
            //       ),
            //       Text(
            //         '영문/숫자/6~15자리',
            //         style: MTextStyles.regular12WarmGrey08,
            //       ),
            //     ],
            //   ),
            // ) : SizedBox.shrink(),
            // !isSnsUser? Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: MTextField(
            //     //    autofocus: true,
            //     obscureText: true,
            //     style: MTextStyles.regular14BlackColor,
            //     controller: _txtPassword1,
            //     validator: (String arg) {
            //       if(arg.length == 0)
            //         return null;
            //       if (arg.length < 6 || arg.length > 15) {
            //         return '비밀번호를 정확히 입력하세요!';
            //       } else {
            //         return null;
            //       }
            //     },
            //     onChanged: (txt) {
            //       checkValue();
            //     },
            //     textInputAction: TextInputAction.next,
            //     onFieldSubmitted: (term) {
            //       // fieldFocusChange(context, _destNameFocus, _destTelFocus);
            //     },
            //
            //     maxLength: 50,
            //     focusNode: _txtPassword1Focus,
            //     hintText: '***********',
            //     keyboardType: TextInputType.text,
            //   ),
            // ) : SizedBox.shrink(),
            // !isSnsUser? Container(
            //   height: 22,
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 18.0),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 20.0,
            //   ),
            //   child: Text(
            //     '비밀번호 확인',
            //     style: MTextStyles.medium13Black_three,
            //   ),
            // ) : SizedBox.shrink(),
            // !isSnsUser? Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: MTextField(
            //     // autofocus: true,
            //     controller: _txtPassword2,
            //     validator: (String arg) {
            //       if(arg.length == 0) return null;
            //       if (arg.length <= 5) return '비밀번호를 정확히 입력하세요!';
            //       if (arg != _txtPassword1.text) return '위 비밀번호와 일치 하지 않습니다.';
            //
            //       return null;
            //     },
            //     onChanged: (txt) {
            //       checkValue();
            //     },
            //     obscureText: true,
            //     textInputAction: TextInputAction.next,
            //     onFieldSubmitted: (term) {
            //       // fieldFocusChange(context, _destNameFocus, _destTelFocus);
            //     },
            //     style: MTextStyles.regular14BlackColor,
            //     maxLength: 50,
            //     focusNode: _txtPassword2Focus,
            //     hintText: '***********',
            //     keyboardType: TextInputType.text,
            //   ),
            // ) : SizedBox.shrink(),
            Container(
              height: 22,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 18.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                '이름',
                style: MTextStyles.medium13Black_three,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MTextField(
                //  autofocus: true,
                controller: _txtName,
                validator: (String arg) {
                  if (arg.length <= 1) {
                    // alert("받는분 이름을 정확히 입력하세요!");
                    return '이름을 정확히 입력하세요!';
                  } else {
                    return null;
                  }
                },
                onChanged: (txt) {
                  checkValue();
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                },
                style: MTextStyles.regular14BlackColor,
                maxLength: 50,
                focusNode: _txtNameFocus,
                hintText: '김문토',
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              height: 22,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 18.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                '휴대폰 번호',
                style: MTextStyles.medium13Black_three,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MTextField(
                //  autofocus: true,
                controller: _txtPhone,
                validator: (String arg) {
                  if (arg.length <= 10) {
                    // alert("받는분 이름을 정확히 입력하세요!");
                    return '휴대폰번호를 정확히 입력하세요!';
                  } else {
                    return null;
                  }
                },
                onChanged: (txt) {
                  checkValue();
                },

                // textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                },
                style: MTextStyles.regular14BlackColor,
                maxLength: 11,
                focusNode: _txtPhoneFocus,
                hintText: '01012345678',
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Center(
                child: Text(
                  '올바른 전화번호를 등록해야 모임에 참여가 가능합니다.',
                  style: MTextStyles.regular12Grey06,
                ),
              ),
            ),

            Container(
              height: 29,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 18.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                '생년월일',
                style: MTextStyles.medium13Black_three,
              ),
            ),
            Container(
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                // width: double.infinity,
                alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),

                child: dataPicker),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 22,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Text(
                '성별',
                style: MTextStyles.medium13Black_three,
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonTheme(
                      minWidth: 104,
                      height: 40,
                      child: StreamBuilder<Object>(
                          stream: _genderCtrl.stream,
                          builder: (context, snapshot) {
                            _gender = snapshot.data;
                            print('snapshot.data  = ${snapshot.data}');

                            return OutlineButton(
                                child: new Text("남성",
                                    style: _gender == "MALE" ? MTextStyles.medium13Tomato : MTextStyles.regular13BrownGrey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                borderSide: BorderSide(
                                  color: _gender == "MALE" ? MColors.tomato : MColors.brown_grey,
                                ),
                                onPressed: () => _genderCtrl.sink.add('MALE'));
                          }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ButtonTheme(
                      minWidth: 104,
                      height: 40,
                      child: StreamBuilder<String>(
                          stream: _genderCtrl.stream,
                          initialData: userProfileData.sex ,
                          builder: (context, snapshot) {
                            _gender = snapshot.data;
                            return OutlineButton(
                                child: new Text("여성",
                                    // style: _gender == "F"
                                    //     ? MTextStyles.regular14Tomato
                                    //     : MTextStyles.regular14Grey06),
                                    style: _gender == "FEMALE" ? MTextStyles.medium13Tomato : MTextStyles.regular13BrownGrey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                borderSide: BorderSide(
                                  color: _gender == "FEMALE" ? MColors.tomato : MColors.brown_grey,
                                ),
                                onPressed: () => _genderCtrl.sink.add('FEMALE'));
                          }),
                    ),
                  ],
                )),
            const SizedBox(
              height: 40,
            )
          ],
        ))
      ],
    );
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_survey_60_px.svg', colors: Colors.grey),
              const SizedBox(height: 15),
              Text('회원 정보가 존재하지 하지 않습니다.', style: MTextStyles.medium16WarmGrey),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingInStack(bool busy) {
    return Offstage(
      offstage: !busy,
      child: IgnorePointer(
        child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.3),
            child: busy ? CircularProgressIndicator() : Container()),
      ),
    );
    // return Positioned.fill(
    //   child: Center(
    //     child: Container(
    //       color: Colors.grey,
    //         // height: 0.0,
    //         child: busy
    //             ? CircularProgressIndicator(
    //               )
    //             : SizedBox.shrink()),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: StreamBuilder<Response<UserProfileData>>(
                      stream: _userProfileDataCtrl.stream,
                      builder: (BuildContext context, AsyncSnapshot<Response<UserProfileData>> snapshot) {
                        return _getStreamBuild(snapshot);
                      }))),
          StreamBuilder<bool>(
              stream: _loadingCtrl.stream,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return loadingInStack(snapshot.data);
                } else {
                  return loadingInStack(false);
                }
              })
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(int start, int end, dynamic func, String endText) {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = start; i <= end; i++) {
      items.add(new DropdownMenuItem(
          value: i.toString(),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Text(
              i.toString() + ' $endText',
              style: TextStyle(fontSize: 13),
            ),
          )));
    }
    return items;
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
