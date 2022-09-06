import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apple_sign_in/apple_sign_in.dart' as a;
import 'package:connectivity/connectivity.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/enum/loginProvier_Eum.dart';
import 'package:munto_app/model/exceptions.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/signup_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/loginPage/signup_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import '../../../app_state.dart';
import '../../../model/enum/viewstate.dart';
import 'package:http/http.dart' as http;

import '../../../util.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // static final facebookLogin = FacebookLogin();

  String log = '';
  @override
  void initState() {
    super.initState();

    if (!kReleaseMode) {
      emailController.text = "testleader@munto.kr";
      passwordController.text = "qwer1234";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toIso8601String());
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      bottom: false,
                      child: Container(
                        height: 52,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 38),
                      child: Image.asset(
                        'assets/title_logo.png',
                        width: 95,
                        height: 20,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    // Rectangle
                    // 이메일
                    Padding(
                      padding: const EdgeInsets.only(left: 28, top: 25),
                      child: Text("이메일",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: Container(
                        height: 46,
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: MColors.pinkish_grey, width: 1)),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "이메일을 입력해주세요.",
                            hintStyle: MTextStyles.regular14Warmgrey,
                            //                    labelText: "Email",
                            labelStyle: TextStyle(color: Colors.transparent),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 28, top: 25),
                      child: Text("비밀번호",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "NotoSansKR",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 4),
                      child: Container(
                        height: 46,
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: MColors.pinkish_grey, width: 1)),
                        child: TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "비밀번호를 입력해주세요.",
                            hintStyle: MTextStyles.regular14Warmgrey,
                            //                    labelText: "Email",
                            labelStyle: TextStyle(color: Colors.transparent),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 24),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x59fbe100),
                                  offset: Offset(0, 2),
                                  blurRadius: 25,
                                  spreadRadius: -10)
                            ],
                            color: MColors.tomato),
                        child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '로그인',
                                style: MTextStyles.bold14White,
                              )
                            ],
                          ),
                          onPressed: () async {
                            print('login pressed');

                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 1500),
                                content: Text('네트워크 상태를 확인해 주세요.'),
                              ));
                              return;
                            }

                            AppStateLog(context, LOG_IN);

                            if (!isEmail(emailController.text)) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 1500),
                                content: Text('정확한 이메일을 입력해 주세요.'),
                              ));
                            } else if (!isPasswordValid(
                                passwordController.text)) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 1500),
                                content: Text('정확한 비밀번호를 입력해 주세요'),
                              ));
                            } else {
                              provider.setStateBusy();
                              bool result = false;
                              try {
                                result = await provider.loginLocal(
                                    emailController.text,
                                    passwordController.text);
                                if (result) {
                                  Navigator.of(context).pop();
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    content: Text('아이디와 비밀번호를 확인해 주세요'),
                                  ));
                                }
                                provider.setStateIdle();
                              } catch (e) {
                                provider.setStateIdle();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 1500),
                                  content: Text(e.toString()),
                                ));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 8,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 0,
                              top: 0,
                              width: 160,
                              height: 20,
                              child: Text(
                                // '',
                                '계정정보를 잊으셨나요?',
                                style: TextStyle(
                                  fontFamily: 'NotoSansKR',
                                  color: MColors.warm_grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                width: 140,
                                height: 20,
                                child: Text(
                                  '회원가입하기',
                                  style:
                                      MTextStyles.regular12WarmGrey_underline,
                                  textAlign: TextAlign.right,
                                )),
                            Positioned(
                              left: 0,
                              top: 0,
                              width: 160,
                              height: 20,
                              child: FlatButton(
                                padding: EdgeInsets.only(top: 0),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('UserFindMainPage');
                                },
                                child: Container(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              width: 140,
                              height: 20,
                              child: FlatButton(
                                padding: EdgeInsets.only(top: 0),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) => SignUpPage()));
                                },
                                child: Container(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MColors.white_three,
                                        width: 0.5))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '또는',
                              style: MTextStyles.regular12WarmGrey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MColors.white_three,
                                        width: 0.5))),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 20, right: 20, top: 11),
                    //   child: Container(
                    //     height: 48,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(Radius.circular(24)),
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: const Color(0x59fbe100),
                    //               offset: Offset(0, 2),
                    //               blurRadius: 25,
                    //               spreadRadius: -10)
                    //         ],
                    //         color: MColors.naver_green),
                    //     child: FlatButton(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           SvgPicture.asset('assets/icons/naver.svg'),
                    //           Text(
                    //             '네이버로 시작하기',
                    //             style: MTextStyles.bold14White,
                    //           )
                    //         ],
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).push(CupertinoPageRoute(
                    //             builder: (_) => LoginPage2()));
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x59fbe100),
                                  offset: Offset(0, 2),
                                  blurRadius: 25,
                                  spreadRadius: -10)
                            ],
                            color: MColors.facebook_blue),
                        child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset('assets/icons/facebook.svg'),
                              Text(
                                '페이스북으로 시작하기',
                                style: MTextStyles.bold14White,
                              )
                            ],
                          ),
                          onPressed: () async {
                            final fb = FacebookLogin();

                            final res = await fb.logIn(permissions: [
                              FacebookPermission.publicProfile,
                              FacebookPermission.email,
                            ]);

                            // Check result status
                            switch (res.status) {
                              case FacebookLoginStatus.success:
                                // Logged in

                                // Send access token to server for validation and auth
                                final FacebookAccessToken accessToken =
                                    res.accessToken;
                                print('Access token: ${accessToken.token}');

                                // Get profile data
                                final profile = await fb.getUserProfile();
                                print(
                                    'Hello, ${profile.name}! You ID: ${profile.userId}');

                                // Get user profile image url
                                final imageUrl =
                                    await fb.getProfileImageUrl(width: 100);
                                print('Your profile image: $imageUrl');

                                // Get email (since we request email permission)
                                final email = await fb.getUserEmail();
                                // But user can decline permission
                                if (email != null)
                                  print('And your email is $email');

                                await handleSnsLogin(
                                    'FACEBOOK',
                                    accessToken.token,
                                    profile.name,
                                    email,
                                    null);

                                break;
                              case FacebookLoginStatus.cancel:
                                // User cancel log in
                                break;
                              case FacebookLoginStatus.error:
                                // Log in failed
                                print('Error while log in: ${res.error}');
                                break;
                            }
                          },
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: (){
                    //     setState(() {});
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: Text('result = $log'),
                    //   ),
                    // ),
                  ],
                ),
              ),
              provider.isAuthState == LoginStatus.Authenticating
                  ? Container(
                      color: Color.fromRGBO(100, 100, 100, 0.5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }

  bool isPasswordValid(String pw) {
    return pw != null && 6 <= pw.length && pw.length <= 50;
  }

  Future<LoginResponse> getToken(String identifier) async {
    print('identifier = $identifier');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final result = await loginProvider.login('APPLE', identifier);
    if (result != null) {
      if (result.token != null && result.token.isNotEmpty) {
        return result;
      } else {
        return LoginResponse(null, result.userAccountId);
      }
    } else {
      showErrorSnackBar(loginProvider, context);
      loginProvider.setIsAuth(LoginStatus.Logout);
    }
    return null;
  }

  showErrorSnackBar(loginProvider, context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
    ));
  }
  // Future<bool> checkAppleLoggedInState() async {
  //   userIdentifier = await FlutterSecureStorage().read(key: "appleUserId");
  //   appleEmail = await FlutterSecureStorage().read(key: "appleEmail");
  //   appleName = await FlutterSecureStorage().read(key: "appleFullName");
  //
  //   if (userIdentifier == null || userIdentifier.isEmpty) {
  //     print("No stored user ID");
  //     return false;
  //   }
  //
  //   final credentialState = await SignInWithApple.getCredentialState(userIdentifier);
  //
  //
  //   print('credentialState.index = ${credentialState.index}');
  //   print('credentialState.runtimeType ${credentialState.runtimeType}');
  //   print('userIdentifier = $userIdentifier');
  //   print('appleEmail = $appleEmail');
  //   print('appleName = $appleName');
  //   if(credentialState.index != 0){
  //     return false;
  //   }
  //
  //   return true;
  // }

  Future handleSnsLogin(String sourceProvider, String accessToken, String name,
      String email, String gender) async {
    print(
        'handleSnsLogin $sourceProvider, $accessToken, $name, $email, $gender');

    var loginMethodProvider = LoginMethodProvider.NONE;
    if (sourceProvider != null && sourceProvider.toUpperCase() == 'KAKAO')
      loginMethodProvider = LoginMethodProvider.KAKAO;
    else if (sourceProvider != null &&
        sourceProvider.toUpperCase() == 'FACEBOOK')
      loginMethodProvider = LoginMethodProvider.FACEBOOK;
    else if (sourceProvider != null && sourceProvider.toUpperCase() == 'APPLE')
      loginMethodProvider = LoginMethodProvider.APPLE;

    try {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      final result = await provider.login(sourceProvider, accessToken);
      print('$sourceProvider $accessToken');
      print('result = ${result.toString()}');

      if (result != null) {
        if (result.token != null && result.token.isEmpty) {
          //sns가입

          Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => LoginPage2()));
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => SignUpPage(
                    userAccountId: '${result.userAccountId}',
                    email: email,
                    name: name,
                    gender: gender,
                  )));
        } else if (result.token != null && result.token.isNotEmpty) {
          //sns 로그인
          print('sns login success : ${result.token}');
          Util.setSharedString(KEY_LOGIN_PROVIDER,
              EnumToString.convertToString(loginMethodProvider));
          Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
          Util.setSharedString(KEY_TOKEN, result.token);
          UserInfo.myProfile = await provider.getUserProfile();
          //  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => Main()));
          print('auth.Login1');
          provider.setIsAuth(LoginStatus.Login);
          Navigator.of(context).pop();
          print('auth.Login2');
        } else {
          print('error');

          //로그인 에러
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
          ));
          provider.setIsAuth(LoginStatus.Logout);
        }
      } else {
        //로그인 에러
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
        ));
        provider.setIsAuth(LoginStatus.Logout);
      }
    } catch (e) {
      print(e.toString());
      // other api or client-side errors

    }
  }

  Future _handleLoginSuccess(String identifier, String token) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    await Util.setSharedString(KEY_LOGIN_PROVIDER,
        EnumToString.convertToString(LoginMethodProvider.APPLE));
    await Util.setSharedString(KEY_ACCESS_TOKEN, identifier);
    await Util.setSharedString(KEY_TOKEN, token);
    UserInfo.myProfile = await loginProvider.getUserProfile();
    loginProvider.setGuestYn("N");
    loginProvider.setIsAuth(LoginStatus.Login);
    Navigator.of(context).pop();
    // Navigator.of(context).pushReplacement(
    //     CupertinoPageRoute(builder: (_) => Main()));
  }
}
