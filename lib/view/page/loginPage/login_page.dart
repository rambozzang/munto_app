import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:munto_app/app_state.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/enum/loginProvier_Eum.dart';
import 'package:munto_app/model/exceptions.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/signup_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/util.dart' as muntoUtil;
import 'package:munto_app/view/page/loginPage/login_page2.dart';
import 'package:munto_app/view/page/loginPage/signup_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/munto_text_field.dart';
import 'package:provider/provider.dart';

import 'package:apple_sign_in/apple_sign_in.dart' as a;

class LoginPage extends StatefulWidget {
  // bool kakaoAuto =false ;
  // LoginPage({this.kakaoAuto});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String adminString = '';

  @override
  void initState() {
    super.initState();
    checkPermissionInfoShown().then((result) {
      if (result) {
        showPermissionInfo();
      }
    });
  }

  void newLoginKakao() async {
    print('newLoginKakao');
    try {
      KakaoContext.clientId = '16d7bd065f6301a08b6ca0f7ac764b85';

      var storedToken = await AccessTokenStore.instance.fromStore();
      debugPrint(storedToken.toString());
      if (storedToken != null && storedToken.accessToken != null) {
        print('storedToken');
        AccessTokenStore.instance.clear();
        return;
      }

      final installed =   await isKakaoTalkInstalled();
      // final installed = false;
      print('installed = ${installed.toString()}');
      final authCode = installed ? await AuthCodeClient.instance.requestWithTalk() : await AuthCodeClient.instance.request();
      print('authCode = ${authCode.toString()}');

      AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      requestMe(token.accessToken);
    } on KakaoAuthException catch (e) {
      print('e : ${e.errorDescription}');

    } on KakaoClientException catch (e) {
      print('ee');
    } on Exception catch (e) {
      print('catch : ${e.toString()}');
    }
  }

  void requestMe(accessToken) async {
      User user = await UserApi.instance.me();
      if (user.kakaoAccount.emailNeedsAgreement || user.kakaoAccount.genderNeedsAgreement) {
        // email and gender can be retrieved after user agreement
        // you can also check for other scopes.
        await retryAfterUserAgrees(["account_email",]);
        print('requestMe finished');
        return;
      }
      print('user.kakaoAccount.email ${user.kakaoAccount.email}');
      print('user.kakaoAccount.gender ${user.kakaoAccount.gender}');
      print('user.kakaoAccount.profile.nickname ${user.kakaoAccount.profile.nickname}');
      final gender = user.kakaoAccount.gender != null && user.kakaoAccount.gender == Gender.FEMALE ? 'FEMALE' : 'MALE';

      AppStateLog(context, LOG_IN);

    await handleSnsLogin('KAKAO',accessToken, user.kakaoAccount.profile.nickname, user.kakaoAccount.email, gender);
  }

  Future handleSnsLogin(String sourceProvider,accessToken,name, email,  gender) async {
    print('handleSnsLogin $sourceProvider, $accessToken, $name, $email, $gender');
    var loginMethodProvider = LoginMethodProvider.NONE;
    if(sourceProvider != null && sourceProvider.toUpperCase() == 'KAKAO')
      loginMethodProvider = LoginMethodProvider.KAKAO;
    else if(sourceProvider != null && sourceProvider.toUpperCase() == 'FACEBOOK')
      loginMethodProvider = LoginMethodProvider.FACEBOOK;
    else if(sourceProvider != null && sourceProvider.toUpperCase() == 'APPLE')
      loginMethodProvider = LoginMethodProvider.APPLE;

    try {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      final result = await provider.login(sourceProvider, accessToken);
      print('$sourceProvider $accessToken');
      print('result = ${result.toString()}');
    
      if (result != null) {
        if (result.token != null && result.token.isEmpty) {
          //sns가입

          muntoUtil.Util.setSharedString(muntoUtil.KEY_ACCESS_TOKEN, accessToken);
          Navigator.of(context).push(CupertinoPageRoute(builder: (_) => LoginPage2()));
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
          muntoUtil.Util.setSharedString(muntoUtil.KEY_LOGIN_PROVIDER, EnumToString.convertToString(loginMethodProvider));
          muntoUtil.Util.setSharedString(muntoUtil.KEY_ACCESS_TOKEN, accessToken);
          muntoUtil.Util.setSharedString(muntoUtil.KEY_TOKEN, result.token);
          UserInfo.myProfile = await provider.getUserProfile();
          //  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => Main()));
          provider.setIsAuth(LoginStatus.Login);
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
    
      // await Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
      // await Util.setSharedString(KEY_TOKEN, result);
      // UserInfo.myProfile = await provider.getUserProfile();
      // Navigator.of(context).pushReplacement(
      //     CupertinoPageRoute(builder: (_) => Main()));
    } on KakaoAuthException catch (e) {
      print(e.toString());
      // if (e.error == ApiErrorCause.INVALID_TOKEN) { // access token has expired and cannot be refrsehd. access tokens are already cleared here
      //   Navigator.of(context).pushReplacementNamed('/login'); // redirect to login page
      // }
    } catch (e) {
      print(e.toString());
      // other api or client-side errors
    
    
    }
  }
  Future<void> retryAfterUserAgrees(List<String> requiredScopes) async {
    // Getting a new access token with current access token and required scopes.
    String authCode = await AuthCodeClient.instance.requestWithAgt(requiredScopes);
    AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenStore.instance.toStore(token); // Store access token in AccessTokenStore for future API requests.
    await requestMe(token.accessToken);
  }

  // void loginKakao(context) async {
  //   try {
  //     final FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
  //     final login = await kakaoSignIn.logIn();
  //     final KakaoToken token = await (kakaoSignIn.currentToken);
  //     final KakaoAccountResult loginAccount = login.account;
  //     final accessToken = token.accessToken;
  //
  //     final userMe = await kakaoSignIn.getUserMe();
  //     final KakaoAccountResult userMeAccount = userMe.account;
  //
  //     print('kakao accessToken = ${accessToken}');
  //     if (accessToken != null) {
  //       final provider = Provider.of<LoginProvider>(context, listen: false);
  //       final result = await provider.login('KAKAO', accessToken);
  //       print('result = ${result.toString()}');
  //
  //       if (result != null) {
  //         if (result.token != null && result.token.isEmpty) {
  //           //sns가입
  //           print('userGender : ${userMeAccount.userGender}');
  //           print('userAgeRange : ${userMeAccount.userAgeRange}');
  //
  //           Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
  //           Navigator.of(context).push(CupertinoPageRoute(builder: (_) => LoginPage2()));
  //           Navigator.of(context).push(CupertinoPageRoute(
  //               builder: (_) => SignUpPage(
  //                     userAccountId: '${result.userAccountId}',
  //                     email: loginAccount.userEmail,
  //                     name: userMeAccount.userNickname,
  //                     gender: userMeAccount.userGender,
  //                   )));
  //         } else if (result.token != null && result.token.isNotEmpty) {
  //           //sns 로그인
  //           print('sns login success : ${result.token}');
  //           Util.setSharedString(KEY_LOGIN_PROVIDER, EnumToString.convertToString(LoginMethodProvider.KAKAO));
  //           Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
  //           Util.setSharedString(KEY_TOKEN, result.token);
  //           UserInfo.myProfile = await provider.getUserProfile();
  //           //  Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => Main()));
  //           provider.setIsAuth(LoginStatus.Login);
  //         } else {
  //           print('error');
  //
  //           //로그인 에러
  //           Scaffold.of(context).showSnackBar(SnackBar(
  //             duration: Duration(milliseconds: 1500),
  //             content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
  //           ));
  //           provider.setIsAuth(LoginStatus.Logout);
  //         }
  //       } else {
  //         //로그인 에러
  //         Scaffold.of(context).showSnackBar(SnackBar(
  //           duration: Duration(milliseconds: 1500),
  //           content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
  //         ));
  //         provider.setIsAuth(LoginStatus.Logout);
  //       }
  //
  //       // await Util.setSharedString(KEY_ACCESS_TOKEN, accessToken);
  //       // await Util.setSharedString(KEY_TOKEN, result);
  //       // UserInfo.myProfile = await provider.getUserProfile();
  //       // Navigator.of(context).pushReplacement(
  //       //     CupertinoPageRoute(builder: (_) => Main()));
  //     }
  //
  //     // final result = await kakaoSignIn.getUserMe();
  //     // final KakaoAccountResult account = result.account;
  //     // if (account != null) {
  //     //   final KakaoAccountResult account = result.account;
  //     //   final userID = account.userID;
  //     //   final userEmail = account.userEmail;
  //     //   final userPhoneNumber = account.userPhoneNumber;
  //     //   final userDisplayID = account.userDisplayID;
  //     //   final userNickname = account.userNickname;
  //     //   final userGender = account.userGender;
  //     //   final userAgeRange = account.userAgeRange;
  //     //   final userBirthday = account.userBirthday;
  //     //   final userProfileImagePath = account.userProfileImagePath;
  //     //   final userThumbnailImagePath = account.userThumbnailImagePath;
  //     //   print('userID = $userID');
  //     //   print('userEmail = $userEmail');
  //     //   print('userPhoneNumber = $userPhoneNumber');
  //     //   print('userDisplayID = $userDisplayID');
  //     //   print('userNickname = $userNickname');
  //     //   print('userGender = $userGender');
  //     //   print('userAgeRange = $userAgeRange');
  //     //   print('userBirthday = $userBirthday');
  //     //   print('userProfileImagePath = $userProfileImagePath');
  //     //   print('userThumbnailImagePath = $userThumbnailImagePath');
  //     // }
  //   } catch (e) {
  //     print("catch error : ${e.code} ${e.message}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    // 자동 클릭 기능 수정중
    // if (widget.kakaoAuto) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) => loginKakao(context));
    // }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/main_bg.png',
                fit: BoxFit.fitWidth,
              )),
          Positioned.fill(
              child: Container(
            color: Color.fromRGBO(8, 6, 6, 0.2),
          )),
          Positioned(
            left: 80,
            top: 91,
            right: 80,
            child: Builder(
              builder: (context)=> GestureDetector(
                onLongPress: (){
                  showAdminAlert(context);
                },
                child: Image.asset(
                  'assets/logo_munto.png',
                  width: 200,
                  height: 38,
                ),
              ),

            ),
          ),
          Positioned(
            left: 24,
            top: 144,
            right: 24,
            child: Text(
              '좋아하는 취향에서부터\n좋아하는 사람들까지',
              style: MTextStyles.bold16White,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: isIos ? (136.0 + 48.0 + 10.0) : 136.0,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: const Color(0x59fbe100), offset: Offset(0, 2), blurRadius: 25, spreadRadius: -10)
                  ],
                  color: const Color(0xfffbe100)),
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset('assets/icons/kakao.svg'),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Text(
                      '카카오톡으로 5초만에 시작하기',
                      style: MTextStyles.medium17Black_10,
                    )
                  ],
                ),
                onPressed: () async {
                  //카카오 로그인 라이브러리 변경
                  // loginKakao(context);
                  newLoginKakao();
                },
              ),
            ),
          ),
          if (isIos)
            Positioned(
              left: 20,
              right: 20,
              bottom: 136,
              height: 48,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: const Color(0x59fbe100), offset: Offset(0, 2), blurRadius: 25, spreadRadius: -10)
                    ],
                    color: MColors.white),
                // child: a.AppleSignInButton(
                //   cornerRadius: 24.0,
                //   style: a.ButtonStyle.black,
                //   onPressed: logIn,
                // ),
                child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Image.asset('assets/apple.png', width: 20, height: 20,),
                        SvgPicture.asset(
                          'assets/icons/apple.svg',
                          width: 16,
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                        ),
                        Text(
                          'Apple로 로그인',
                          style: MTextStyles.appleMedium19Black,
                        )
                      ],
                    ),
                    onPressed: appleLogin),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 78,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: const Color(0x59fbe100), offset: Offset(0, 2), blurRadius: 25, spreadRadius: -10)
                  ],
                  color: Colors.white),
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '다른 방법으로 로그인',
                      style: MTextStyles.bold14BlackColor,
                    )
                  ],
                ),
                onPressed: () {
                  print('hostUrl = $hostUrl');
                  Navigator.of(context).push(
                      CupertinoPageRoute(settings: RouteSettings(name: "/LoginPage2"), builder: (_) => LoginPage2()));
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            height: 24,
            child: Container(
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '둘러보기',
                      style: MTextStyles.regular14WhiteTwo,
                    )
                  ],
                ),
                onPressed: () async {
                  final email = 'guest@munto.kr';
                  final password = 'guest@1012';
                  final provider = Provider.of<LoginProvider>(context, listen: false);
                  bool result = false;
                  try {
                    result = await provider.loginLocal(email, password);
                    if (!result) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 1500),
                        content: Text('아이디와 비밀번호를 확인해 주세요'),
                      ));
                    }
                    provider.setStateIdle();
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 1500),
                      content: Text(e.toString()),
                    ));
                  }
                  // final pwEncrypted = Util.encodeAES(password);
                  // Util.setSharedString(KEY_EMAIL, email);
                  // Util.setSharedString(KEY_PASSWORD, pwEncrypted);
                  // await Util.setSharedString(KEY_TOKEN, result);
                  // UserInfo.myProfile = await provider.getUserProfile();
                  // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => Main()));
//                Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>CommunityListPage()));//
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showPermissionInfo() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            height: 466,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 24.0),
                  child: Text(
                    '문토 앱을 사용하기 위해 필요한\n접근권한을 안내해드릴게요.',
                    style: MTextStyles.bold16Grey06,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: MColors.white_two,
                  padding: EdgeInsets.only(left: 24.0, top: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("사진 권한(선택)", style: MTextStyles.bold14Grey06),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
                        child: Text("피드, 프로필, 후기 작성, 소셜링 열기 사진 첨부", style: MTextStyles.regular12WarmGrey),
                      ),
                      Text("카메라(선택)", style: MTextStyles.bold14Grey06),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
                        child: Text("피드, 프로필, 후기 작성, 소셜링 열기 사진 촬영", style: MTextStyles.regular12WarmGrey),
                      ),
                      Text("알림(선택)", style: MTextStyles.bold14Grey06),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text("모임 및 이벤트 혜택 알림", style: MTextStyles.regular12WarmGrey),
                      ),
                    ],
                  ),
                ),

                // 더욱 멋진 문토앱을 이용할 수 있도록
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text("더욱 멋진 문토앱을 이용할 수 있도록 사용됩니다.해당 기능을 허용하지 않으셔도 문토앱을 이용하실 수 있습니다.",
                      style: MTextStyles.regular12WarmGrey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(38)),
                        color: MColors.tomato,
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                          ),
                          Text('확인', style: MTextStyles.bold14White, textAlign: TextAlign.center),
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    print('dialog dismissed');
    muntoUtil.Util.setSharedString(muntoUtil.KEY_PERMISSION_INFO_SHOWN, 'true');
  }



  showAdminAlert(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: 300, height: 300,
            child: adminTestMode
                ? FlatButton(
                  onPressed: (){
                    adminTestMode =false;
                    muntoUtil.Util.setSharedString(muntoUtil.KEY_ADMIN_TEST, 'false');
                    Navigator.of(dialogContext).pop();
                    showSnackBar(context, '운영 서버로 로그인됩니다.');
                  },
                  child: Text('테스트 모드 종료'),
              )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 1.0,
                      crossAxisSpacing: 10.0,mainAxisSpacing: 10.0
                    ),
                    itemCount: 9,
                    itemBuilder: (gridContext, index){
                      return FlatButton(
                        onPressed: (){

                          adminString += '${index+1}';
                          print(adminString);
                          if(adminString =='13579999999'){
                            Navigator.of(dialogContext).pop();
                            adminTestMode = true;
                            muntoUtil.Util.setSharedString(muntoUtil.KEY_ADMIN_TEST, 'true');
                            showSnackBar(context, '테스트 서버로 로그인됩니다.');
                          }
                        },
                        child: Text('${index+1}',style:MTextStyles.medium16WarmGrey),
                      );
                    },
                ),
          ),
        );
      },
    );
    adminString = '';
    print('dialog dismissed');
    muntoUtil.Util.setSharedString(muntoUtil.KEY_PERMISSION_INFO_SHOWN, 'true');
  }


  Future<bool> checkPermissionInfoShown() async {
    final permissionInfoShown = await muntoUtil.Util.getSharedString(muntoUtil.KEY_PERMISSION_INFO_SHOWN);
    if (permissionInfoShown != null && permissionInfoShown == 'true') return false;
    return true;
  }

  Future<LoginResponse> getToken(String identifier) async {
    print('identifier = $identifier');
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final result = await loginProvider.login('APPLE', identifier);
    if (result != null) {
      if (result.token != null && result.token.isNotEmpty) {
        // UserInfo.myProfile = await loginProvider.getUserProfile();
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

  void appleLogin() async {
    AppStateLog(context, LOG_IN);

    final a.AuthorizationResult result = await a.AppleSignIn.performRequests([
      a.AppleIdRequest(requestedScopes: [a.Scope.email, a.Scope.fullName])
    ]);

    switch (result.status) {
      case a.AuthorizationStatus.authorized:
        // log += "a.AuthorizationStatus.authorized : ${result.credential.user}";
        // Store user ID
        await FlutterSecureStorage().write(key: "userId", value: result.credential.user);

        final identifier = Utf8Decoder().convert(result.credential.identityToken);
        String email = result.credential.email ?? '';
        final name = '';

        // await handleSnsLogin('APPLE',identifier,name , email, '');

        final loginResponse = await getToken(identifier);
        if (loginResponse != null && loginResponse.token != null) {
          await _handleLoginSuccess(identifier, loginResponse.token);
          return;
        } else if (loginResponse != null && loginResponse.userAccountId != null) {
          print('email = $email');
          // if (email.isEmpty)
          //   alertEmailPermission();
          // else if (await checkEmail(email)) handleSignUp(identifier, email, loginResponse.userAccountId);
          handleSignUp(identifier, email, loginResponse.userAccountId);

          // if(email == null && email.isEmpty)
          //   email = TEMP_APPLE_MAIL;
          //
          // await handleSnsLogin('APPLE',loginResponse.token,name , email, '');
        } else {
          alertInvalidToken();
        }

        print('result = ${result.credential.email.toString()}');

        break;

      case a.AuthorizationStatus.error:
        // log += "Sign in failed: ${result.error.localizedDescription}";
        setState(() {
          // errorMessage = "Sign in failed 😿";
        });
        break;

      case a.AuthorizationStatus.cancelled:
        // log += 'User cancelled';
        break;
    }
  }

  Future _handleLoginSuccess(String identifier, String token) async {
    print('_handleLoginSuccess');

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    await muntoUtil.Util.setSharedString(muntoUtil.KEY_LOGIN_PROVIDER, EnumToString.convertToString(LoginMethodProvider.APPLE));
    await muntoUtil.Util.setSharedString(muntoUtil.KEY_ACCESS_TOKEN, identifier);
    await muntoUtil.Util.setSharedString(muntoUtil.KEY_TOKEN, token);
    UserInfo.myProfile = await loginProvider.getUserProfile();
    loginProvider.setGuestYn("N");
    loginProvider.setIsAuth(LoginStatus.Login);
    // Navigator.of(context).pushReplacement(
    //     CupertinoPageRoute(builder: (_) => Main()));
  }

  showErrorSnackBar(loginProvider, context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
    ));
  }

  showSnackBar(context, message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text(message),
    ));
  }


  void alertInvalidToken() {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text('토큰 오류'),
              content: Text('알 수 없는 오류가 발생했습니다. 다시 시도해 주세요. '),
              actions: [
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                )
              ],
            ));
  }

  void alertEmailPermission() {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text('권한 부족'),
              content:
                  Text('이메일 정보를 공유해 주세요.\n\n[설정]-[Apple Id]-[암호 및 보안]-[Apple ID를 사용하는 앱]에서 MUNTO를 삭제하고 다시 시도해 주세요. '),
              actions: [
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                )
              ],
            ));
  }

  Future<bool> checkEmail(String email) async {
    if (email == null) return false;

    //서버상 정책변경으로 이메일 체크 안함. 10.26 경준
    return true;

    // final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    // final checkEmail = await loginProvider.checkEmail(email);
    // if (checkEmail) {
    //   showDialog(
    //       context: context,
    //       builder: (dialogContext) => AlertDialog(
    //         title: Text('가입한 이메일'),
    //         content: Text('이미 가입한 메일주소 입니다.\n이메일로그인 이나 다른 SNS로그인을 이용해 보세요.'),
    //         actions: [
    //           FlatButton(
    //             child: Text('확인'),
    //             onPressed: () {
    //               Navigator.of(dialogContext).pop();
    //             },
    //           )
    //         ],
    //       ));
    //   return false;
    // }
    // return true;
  }

  Future<void> handleSignUp(identifier, email, userAccountId) async {
    print('handleSignUp : $identifier / $email / $userAccountId');
    //sns가입
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    String errorMessage;
    print('handleSignUp2');
    try {

      SignUpData _signUpdata = SignUpData();
      _signUpdata.userAccountId = '$userAccountId';
      _signUpdata.name = '이름없음';
      _signUpdata.sex = 'NONE';
      _signUpdata.phoneNumber = '010-0000-0000';
      _signUpdata.email = email == '' ? 'temp_apple@munto.kr' : email;
      final result = await signUpProvider.signUp(_signUpdata);
      if (result) {
        //다시 로그인
        AppStateLog(context, SIGN_UP);

        print('다시 로그인');
        final loginResponse = await getToken(identifier);
        await _handleLoginSuccess(identifier, loginResponse.token);
      } else {
        print('가입 에러 ');
      }
    } on BadRequestException catch (e) {
      errorMessage = e.toString();
      print('BadRequestException = ${e.toString()}');
    } on SocketException catch (e) {
      errorMessage = '네트워크 연결을 확인해 주세요';
      print('SocketException = ${e.toString()}');
    } on TimeoutException catch (e) {
      print('TimeoutException = ${e.toString()}');
      errorMessage = '네트워크 연결을 확인해 주세요';
    }

    signUpProvider.setStateIdle();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text('${errorMessage ?? '알 수 없는 에러'}'),
    ));
    return;
  }
}
