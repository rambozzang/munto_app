import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/user_Provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class PasswordResetPage extends StatefulWidget {
  Map<String, dynamic> map = Map();
  PasswordResetPage({this.map});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  // 이름
  final FocusNode _txtPasswordFocus = FocusNode();
  final TextEditingController _txtPasswordCtrl = TextEditingController();
  // 전환번호
  final FocusNode _txtPasswordFocus2 = FocusNode();
  final TextEditingController _txtPasswordCtrl2 = TextEditingController();

  // form key
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  UserProvider userProvider = UserProvider();

  final StreamController<bool> _processing = StreamController();

  // form auto 체크여부
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _notifier.value = true;
  }

  // 인증요청 발송 버튼
  _savePassword() async {
    print('_sendAuthCode()');
    // _showResultDialog(context, '비밀번호 재설정 완료', '새로운 비밀번호로 다시 로그인 해주세요.\n확인을 누르면 로그인화면으로 이동합니다.');

    if (this._formKey.currentState.validate()) {
      print('_sendAuthCode() 1');
      String _txtPassword = _txtPasswordCtrl.text;
      String _txtPassword2 = _txtPasswordCtrl2.text;

      if (_txtPassword == _txtPassword2) {
        Map<String, dynamic> _map = Map();
        _map['code'] = widget.map['code'];
        _map['email'] = widget.map['email'];
        _map['password'] = _txtPassword;
        _processing.sink.add(true);
        final response = await userProvider.postUserResetPassword(_map);
        _processing.sink.add(false);
        print('response : ${response.toString()}');
        bool result = response['result'];

        if (result) {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '패스워드가 정상적으로 변경되었습니다. 다시 로그인 해주세요');
          Navigator.of(context).pushNamedAndRemoveUntil('LoginPage2', (route) => route.isFirst);
          //Navigator.of(context).pushNamed('LoginPage2'),

        } else {
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '오류가 발생했습니다. 다시 시도 해주세요');
        }
      } else {
        Util.showCenterFlash(
            // alignment: Alignment.center,
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '비밀번호가 동일하지 않습니다! 다시 확인해주세요');
      }

      _formKey.currentState.save();
      _notifier.value = false;
    } else {
      print('_sendAuthCode() 2 ');
      setState(() => _autoValidate = true);
    }
    // 이메일 보내기
  }

  // 비밀번호 재설정 버튼
  _savePassword_bak() {
    //Navigator.of(context).pushNamed('PasswordNofindPage');

    // if (this._formKey.currentState.validate()) {
    //   _formKey.currentState.save();
    //   _notifier.value = false;
    //   String _name = _txtNameCtrl.text;
    //   String _tel = _txtTelCtrl.text;
    //   String _email = _txtEmailCtrl.text;
    // } else {}
  }

  @override
  void dispose() {
    _txtPasswordCtrl.dispose();
    _txtPasswordCtrl2.dispose();
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
        body: StreamBuilder<Object>(
            stream: _processing.stream,
            initialData: false,
            builder: (context, snapshot) {
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: TitleBold16BlackView('새로운 비밀번호를 입력해 주세요.', ''),
                                ),
                                const SizedBox(
                                  height: 34,
                                ),
                                Container(
                                  height: 22,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '비밀번호',
                                        style: MTextStyles.medium13Black_three,
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      Text(
                                        '영문/숫자/6~15자리',
                                        style: MTextStyles.regular12WarmGrey08,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    obscureText: true,
                                    controller: _txtPasswordCtrl,
                                    // validator: (String arg) {
                                    //   if (arg.length <= 5) {
                                    //     // alert("받는분 이름을 정확히 입력하세요!");
                                    //     return '비밀번호를 조건에 맞게 입력해 주세요!';
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    validator: Util.validatePassword,
                                    onChanged: (txt) {
                                      //   checkValue();
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      //   fieldFocusChange(context, _txtNameFocus, _txtTelFocus);
                                    },
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 100,
                                    focusNode: _txtPasswordFocus,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(() => _txtPasswordCtrl.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor: _txtPasswordCtrl.text.length > 0
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
                                      hintText: '영문/숫자/6~15자리 조건으로 입력해 주세요.',
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
                                _buildTitle('비밀번호 확인'),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _txtPasswordCtrl2,
                                    obscureText: true,
                                    // validator: (String arg) {
                                    //   if (arg.length <= 5) {
                                    //     // alert("받는분 이름을 정확히 입력하세요!");
                                    //     return '비밀번호를 조건에 맞게 입력해 주세요!';
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    validator: Util.validatePassword,
                                    onChanged: (txt) {
                                      // checkValue();
                                    },

                                    //textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                                    },
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 100,
                                    focusNode: _txtPasswordFocus2,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(() => _txtPasswordCtrl2.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor: _txtPasswordCtrl2.text.length > 0
                                                ? MColors.warm_grey
                                                : MColors.white_three,
                                            radius: 10,
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: MColors.white_two, width: 0.0),
                                      ),
                                      contentPadding: new EdgeInsets.all(
                                        7.0,
                                      ),
                                      hintText: '비밀번호를 다시 입력해 주세요.',
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
                                  height: 30,
                                ),
                                ValueListenableBuilder<bool>(
                                    valueListenable: _notifier,
                                    builder: (context, value, _) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(35)),
                                          color: value ? MColors.white_three : MColors.tomato,
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            _savePassword();
                                          },
                                          child: Center(
                                            child: Text('비밀번호 재설정',
                                                style: value ? MTextStyles.bold16Grey06 : MTextStyles.bold16White,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
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

  Future<Widget> _showResultDialog(context, text, subtext) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
            child: Container(
              height: 150,
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSansCJKkr",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      subtext,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansCJKkr",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    height: 55,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '확인',
                        style: MTextStyles.bold14Tomato,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
