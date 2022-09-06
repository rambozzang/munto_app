import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munto_app/model/provider/user_Provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class EmailFindPage extends StatefulWidget {
  @override
  _EmailFindPageState createState() => _EmailFindPageState();
}

class _EmailFindPageState extends State<EmailFindPage> {
  // 이름
  final FocusNode _txtNameFocus = FocusNode();
  final TextEditingController _txtNameCtrl = TextEditingController();
  // 전환번호
  final FocusNode _txtTelFocus2 = FocusNode();
  final TextEditingController _txtTelCtrl2 = TextEditingController();

  // form key
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  // form auto 체크여부
  bool _autoValidate = false;
  //
  bool notFound = false;

  final StreamController<bool> _processing = StreamController();

  UserProvider userProvider = UserProvider();

  @override
  void initState() {
    super.initState();
  }

  findEmail() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      String _name = _txtNameCtrl.text;
      String _tel = _txtTelCtrl2.text;
      String _phoneNumber = _tel.substring(0, 3) + '-' + _tel.substring(3, 7) + '-' + _tel.substring(7, _tel.length);

      try {
        _processing.sink.add(true);
        final response = await userProvider.getUserFindEmail(_name, _phoneNumber);
        _processing.sink.add(false);
        String result = response['result'];
        print('result : ${response['result']}');
        // 성공
        if (result != 'no user') {
          Navigator.of(context).pushNamed('EmailFindSuccessPage', arguments: result);
        } else {
          // 사용자가 없을 경우
          // Navigator.of(context).pushNamed('EmailNotfindPage');
          Util.showCenterFlash(
              alignment: Alignment.center,
              context: context,
              // position: FlashPosition.top,
              // style: FlashStyle.floating,
              text: '일치하는 계정이 없습니다! 다시입력해주세요.');
          setState(() => notFound = true);

          _processing.sink.add(false);
        }
        // Navigator.of(context).pushNamed('EmailFindSuccessPage');
      } catch (e) {
        Util.showCenterFlash(
            alignment: Alignment.center,
            context: context,
            // position: FlashPosition.top,
            // style: FlashStyle.floating,
            text: '일치하는 계정이 없습니다! 다시입력해주세요.');
        setState(() => notFound = true);
        _processing.sink.add(false);
        print(e.toString());
        //   Navigator.of(context).pushNamed('EmailNotfindPage');
        // Response.error(e.toString());
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  void dispose() {
    _processing.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: StreamBuilder<bool>(
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
                                notFound
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            new Text(
                                              '일치하는 계정이 없습니다!',
                                              style: MTextStyles.bold16Tomato,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            new Text(
                                              '입력한 정보를 다시 확인해 주세요.',
                                              style: MTextStyles.bold16Black,
                                            ),
                                          ],
                                        ))
                                    : Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: TitleBold16BlackView('문토에 등록된\n이름과 전화번보를 입력해 주세요.', ''),
                                    ),
                                const SizedBox(
                                  height: 34,
                                ),
                                _buildTitle('이름'),
                                Container(
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _txtNameCtrl,
                                    validator: (String arg) {
                                      if (arg.length <= 1) {
                                        // alert("받는분 이름을 정확히 입력하세요!");
                                        return '이름을 입력해주세요!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (txt) {
                                      //   checkValue();
                                    },
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      //   fieldFocusChange(context, _txtNameFocus, _txtTelFocus);
                                    },
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 100,
                                    focusNode: _txtNameFocus,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(() => _txtNameCtrl.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor:
                                                _txtNameCtrl.text.length > 0 ? MColors.warm_grey : MColors.white_three,
                                            radius: 10,
                                          ),
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      contentPadding: new EdgeInsets.all(
                                        7.0,
                                      ),
                                      hintText: '이름을 입력해주세요',
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _txtTelCtrl2,
                                    validator: (String arg) {
                                      if (arg.length < 9) {
                                        // alert("받는분 이름을 정확히 입력하세요!");
                                        return '전화번호를 입력해 주세요!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onChanged: (txt) {
                                      // checkValue();
                                    },
                                    //textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (term) {
                                      // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                                    },
                                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                                    style: MTextStyles.regular14BlackColor,
                                    maxLength: 11,
                                    focusNode: _txtTelFocus2,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.translate(
                                        offset: Offset(0, 1),
                                        child: IconButton(
                                          onPressed: () => setState(() => _txtTelCtrl2.clear()),
                                          icon: CircleAvatar(
                                            child: Icon(
                                              Icons.clear,
                                              size: 16,
                                              color: MColors.white,
                                            ),
                                            backgroundColor:
                                                _txtTelCtrl2.text.length > 0 ? MColors.warm_grey : MColors.white_three,
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
                                      hintText: '전화번호를 입력해주세요',
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
                                            findEmail();
                                          },
                                          child: Center(
                                            child: Text('이메일 찾기',
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
        horizontal: 10.0,
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
