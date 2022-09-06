import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/user_Provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class PasswordFindPage extends StatefulWidget {
  @override
  _PasswordFindPageState createState() => _PasswordFindPageState();
}

class _PasswordFindPageState extends State<PasswordFindPage>
    with TickerProviderStateMixin {
  // 이름
  final FocusNode _txtNameFocus = FocusNode();
  final TextEditingController _txtNameCtrl = TextEditingController();
  // 전환번호
  final FocusNode _txtTelFocus = FocusNode();
  final TextEditingController _txtTelCtrl = TextEditingController();

  // 이메일
  final FocusNode _txtEmailFocus = FocusNode();
  final TextEditingController _txtEmailCtrl = TextEditingController();

  // 인증번호ㅓ
  final FocusNode _txtAuthCodeFocus = FocusNode();
  final TextEditingController _txtAuthCodeCtrl = TextEditingController();
  // form key
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formCodeKey = new GlobalKey<FormState>();

  final ValueNotifier<bool> _notifier = new ValueNotifier(false);
  final StreamController<bool> _processing = StreamController();

  UserProvider userProvider = UserProvider();

  // form auto 체크여부
  bool _autoValidate = false;
  bool _autoCodeValidate = false;

  @override
  void initState() {
    super.initState();
    _notifier.value = true;
    _txtNameCtrl.text = '';
    _txtTelCtrl.text = '';
    _txtEmailCtrl.text = '';
  }

  // 인증요청 발송 버튼
  _sendAuthCode() async {
    // _notifier.value = false;
    // _txtEmailFocus.unfocus();
    // _formCodeKey.currentState.validate(); // 코드 필드 발깐색 나오기 위한 호출
    // _txtAuthCodeFocus.requestFocus(); // 강제 포커스  주기
    // _txtAuthCodeCtrl.clear();
    // setState(() => _autoCodeValidate = true); // 5
    // return;
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        _processing.sink.add(true);
        String _name = _txtNameCtrl.text;
        String _tel = _txtTelCtrl.text;
        String _email = _txtEmailCtrl.text;

        //서비스 호출한다.
        Map<String, dynamic> _map = Map();
        _map['name'] = _name;
        _map['email'] = _email;
        _map['phoneNumber'] = _tel.substring(0, 3) +
            '-' +
            _tel.substring(3, 7) +
            '-' +
            _tel.substring(7, _tel.length);

        final response = await userProvider.postUserResetPasswordCode(_map);
        _processing.sink.add(false);
        bool result = response['result'];
        print(response['result']);
        if (result) {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: 'Email로 발송된 인증번호를 입력해주세요.');
          // 인증코드 쪽 강제 validation
          _notifier.value = false;
          _txtNameFocus.unfocus();
          _txtTelFocus.unfocus();
          _txtEmailFocus.unfocus();
          _formCodeKey.currentState.validate(); // 코드 필드 발깐색 나오기 위한 호출
          _txtAuthCodeCtrl.clear();
          _txtAuthCodeFocus.requestFocus(); // 강제 포커스  주기

          setState(() => _autoCodeValidate = true); // 5자리인경우 validata
        } else {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '다시 입력해주세요!');
        }
      } catch (e) {
        _processing.sink.add(false);
        Util.showCenterFlash(
            alignment: Alignment.center,
            context: context,
            // position: FlashPosition.top,
            // style: FlashStyle.floating,
            text: '다시 입력해주세요! ${e.toString()}');
        print(e.toString());
        // Response.error(e.toString());
      }
    } else {
      print('_sendAuthCode() 2 ');
      setState(() => _autoValidate = true);
    }
    // 이메일 보내기
  }

  // 비밀번호 재설정 버튼
  _savePassword() async {
    print('_notifier.value  : ${_notifier.value}');

    if (_notifier.value) {
      Util.showCenterFlash(
          alignment: Alignment.center,
          context: context,
          // position: FlashPosition.top,
          // style: FlashStyle.floating,
          text: '인증요청 후 다시 시도해주세요!');
    }
    // Navigator.of(context).pushNamed('PasswordNofindPage');
    if (this._formCodeKey.currentState.validate()) {
      _formCodeKey.currentState.save();

      try {
        _processing.sink.add(true);
        String _name = _txtNameCtrl.text;
        String _tel = _txtTelCtrl.text;
        String _email = _txtEmailCtrl.text;
        Map<String, dynamic> _map = Map();
        _map['name'] = _name;
        _map['email'] = _email;
        _map['phoneNumber'] = _tel.substring(0, 3) +
            '-' +
            _tel.substring(3, 7) +
            '-' +
            _tel.substring(7, _tel.length);
        _map['code'] = _txtAuthCodeCtrl.text;

        final response =
            await userProvider.postUserResetPasswordCodeisValid(_map);
        _processing.sink.add(false);
        final result = response['result'];
        print('결과 : ${response['result']}');

        if (result == true || result == 'true') {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '비밀번호를 재설정 해주세요!');
          Navigator.of(context).pushNamed('PasswordResetPage', arguments: _map);
        } else {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '인증코드가 틀립니다.다시 입력해주세요!');
        }
      } catch (e) {
        print(e.toString());
        _processing.sink.add(false);
        Util.showCenterFlash(
            alignment: Alignment.center,
            context: context,
            // position: FlashPosition.top,
            // style: FlashStyle.floating,
            text: '다시 입력해주세요! ${e.toString()}');
      }
    } else {
      setState(() => _autoCodeValidate = true);
    }
  }

  @override
  void dispose() {
    _processing.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _notifier.value = true;
    });
    return Scaffold(
        appBar: _appbar(),
        body: StreamBuilder<bool>(
            stream: _processing.stream,
            initialData: false,
            builder: (context, snapshot) {
              print('StreamBuilder');
              print('StreamBuilder ${snapshot.data}');
              print('StreamBuilder');
              print('StreamBuilder');
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: TitleBold16BlackView(
                                      '문토에 가입한\n계정 정보를 입력해 주세요.', ''),
                                ),
                                const SizedBox(
                                  height: 34,
                                ),
                                _buildTitle('이름'),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _txtNameCtrl,
                                    validator: (String arg) {
                                      if (arg.length <= 1) {
                                        // alert("받는분 이름을 정확히 입력하세요!");
                                        return '이름을 정확히 입력하세요!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    textInputAction: TextInputAction.next,
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 50,
                                    focusNode: _txtNameFocus,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(
                                              () => _txtNameCtrl.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor:
                                                _txtNameCtrl.text.length > 0
                                                    ? MColors.warm_grey
                                                    : MColors.white_three,
                                            radius: 10,
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      contentPadding: new EdgeInsets.all(
                                        7.0,
                                      ),
                                      hintText: '김문토',
                                      hintStyle: MTextStyles.regular14WarmGrey,
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
                                  height: 10,
                                ),
                                _buildTitle('전화번호'),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _txtTelCtrl,
                                    validator: (String arg) {
                                      if (arg.length <= 10) {
                                        // alert("받는분 이름을 정확히 입력하세요!");
                                        return '휴대폰번호를 정확히 입력하세요!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 11,
                                    focusNode: _txtTelFocus,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(
                                              () => _txtTelCtrl.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor:
                                                _txtTelCtrl.text.length > 0
                                                    ? MColors.warm_grey
                                                    : MColors.white_three,
                                            radius: 10,
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: MColors.white_two,
                                            width: 0.0),
                                      ),
                                      contentPadding: new EdgeInsets.all(
                                        7.0,
                                      ),
                                      hintText: '01012345678',
                                      hintStyle: MTextStyles.regular14WarmGrey,
                                      counterText: "",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: MColors.greyish,
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _buildTitle('이메일'),
                                Container(
                                  height: 70,
                                  alignment: Alignment.topCenter,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    //  autofocus: true,
                                    controller: _txtEmailCtrl,
                                    // validator: (String arg) {
                                    //   if (arg.length <= 1) {
                                    //     // alert("받는분 이름을 정확히 입력하세요!");
                                    //     return '받는분 이름을 정확히 입력하세요!';
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    validator: Util.validateEmail,
                                    onChanged: (txt) {
                                      //  checkValue();
                                    },
                                    style: MTextStyles.regular14BlackColor,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                                    },
                                    maxLength: 50,
                                    focusNode: _txtEmailFocus,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: new EdgeInsets.all(
                                        7.0,
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 10.0),
                                        child: Container(
                                          height: 30,
                                          width: 76,
                                          child: OutlineButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () => _sendAuthCode(),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: MColors.brown_grey,
                                            ),
                                            child: Text(
                                              '인증요청',
                                              style:
                                                  MTextStyles.regular12Grey06,
                                            ),
                                          ),
                                        ),
                                      ),
                                      hintText: 'example@naver.com',
                                      hintStyle: MTextStyles.regular14WarmGrey,
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
                              ],
                            ),
                          ),
                          Form(
                            key: _formCodeKey,
                            autovalidate: _autoCodeValidate,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _notifier,
                              builder: (context, value, child) {
                                return AnimatedSize(
                                  duration: Duration(milliseconds: 300),
                                  vsync: this,
                                  // height: value ? 0 : 70,
                                  //     height: 70,
                                  alignment: Alignment.topCenter,

                                  child: Container(
                                    height: value ? 0 : 70,
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10, top: 10),
                                    child: TextFormField(
                                      //  autofocus: true,
                                      controller: _txtAuthCodeCtrl,
                                      validator: (String arg) {
                                        if (arg.length != 5) {
                                          return '이메일로 발송된 5자리 인증번호를 입력해주세요.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (txt) {
                                        //  checkValue();
                                      },
                                      style: MTextStyles.regular14BlackColor,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                                      },
                                      maxLength: 5,
                                      focusNode: _txtAuthCodeFocus,
                                      decoration: InputDecoration(
                                        // border: OutlineInputBorder(),
                                        // contentPadding: new EdgeInsets.all(
                                        //   7.0,
                                        // ),
                                        hintText: '인증번호 입력',
                                        hintStyle:
                                            MTextStyles.regular14WarmGrey,
                                        counterText: "",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: MColors.tomato,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                );
                              },
                              //child:
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.8,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            //height: 48 * sizeWidth,
                            // padding: EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)),
                              color: MColors.tomato,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                _savePassword();
                              },
                              child: Center(
                                child: Text('비밀번호 재설정',
                                    style: MTextStyles.bold16White,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  snapshot.data
                      ? Container(
                          color: Color.fromRGBO(100, 100, 100, 0.5),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              );
            }));
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
