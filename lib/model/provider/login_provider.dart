import 'dart:async';
import 'dart:io';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/enum/loginProvier_Eum.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/util.dart';

import '../userProfile_Data.dart';

enum LoginStatus { Login, Logout, Authenticating }

class LoginProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<LoginResponse> login(String provider, String accessToken) async {
    try {
      //  setStateBusy();

      final _callUri = "/api/user/login";
      final response = await _api.post(_callUri, {'provider': provider, 'accessToken': accessToken});
      setGuestYn('N');
      // setStateIdle();
      return LoginResponse(response['token'], response['userAccountId']);
    } on Exception catch (e) {
      print(e.toString());
    }
    // setStateIdle();
    return null;
  }

  LoginStatus _isAuthState = LoginStatus.Authenticating; // Success : 로그인상태  ,
  LoginStatus get isAuthState => _isAuthState;
  String guestYn = "N";

  bool get isSnsTempUser {
    if(UserInfo.myProfile != null && isSNSTempMail(UserInfo.myProfile.email))
      if(UserInfo.myProfile.name != null && UserInfo.myProfile.name.isNotEmpty)
        return true;
    return false;
  }

  bool get isGeneralUser{
    // if(UserInfo.myProfile != null && UserInfo.myProfile.grade == 'GENERAL')
    //   return true;
    return false;
  }

  setGuestYn(val) {
    guestYn = val;
  }

  setIsAuth(LoginStatus state) {
    if (_isAuthState != state) {
      _isAuthState = state;
      notifyListeners();
    }
  }

  Future logout() async {
    print('provider logout');

    setIsAuth(LoginStatus.Authenticating);
    kakao.AccessTokenStore.instance.clear();
    Util.delSharedString(KEY_EMAIL);
    Util.delSharedString(KEY_PASSWORD);
    Util.delSharedString(KEY_TOKEN);
    Util.delSharedString(KEY_ACCESS_TOKEN);
    Util.delSharedString(KEY_LOGIN_PROVIDER);
    // UserInfo Data 클래서 초기화 가 필요함.
    UserInfo.myProfile = null;
    setIsAuth(LoginStatus.Logout);
  }

  Future<bool> loginLocal(String email, String password) async {
    try {
      final _callUri = "/api/user/login/local";
      final response = await _api.post(_callUri, LoginData(email: email, password: password));
      final token = response['token'];

      if (token == null || token == 'no user') {
        setIsAuth(LoginStatus.Logout);
        return false;
      }
      final pwEncrypted = Util.encodeAES(password);
      Util.setSharedString(KEY_EMAIL, email);
      Util.setSharedString(KEY_PASSWORD, pwEncrypted);
      Util.setSharedString(KEY_TOKEN, token);

      // 게스트 인 경우 판단
      if ('guest@munto.kr' == email) {
        setGuestYn('Y');
        Util.setSharedString(KEY_LOGIN_PROVIDER, EnumToString.convertToString(LoginMethodProvider.NONE));
      } else {
        setGuestYn('N');
        Util.setSharedString(KEY_LOGIN_PROVIDER, EnumToString.convertToString(LoginMethodProvider.EMAIL));
      }

      UserInfo.myProfile = await this.getUserProfile();
      // 인증 완료 처리
      setIsAuth(LoginStatus.Login);
      return true;
    } on UnauthorisedException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserProfileData> getUserProfile() async {
    setStateBusy();
    try {
      final _callUri = "/api/user/profile";
      final response = await _api.get(_callUri);
      print('${_callUri }\n ${response.toString()}');
      setStateIdle();
      return UserProfileData.fromMap(response);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkEmail(email) async {
    setStateBusy();
    try {
      final _callUri = "/api/user/check/email/$email";
      final response = await _api.get(_callUri);
      setStateIdle();
      return response['result'] ?? false;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}

class LoginData {
  String email;
  String password;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  LoginData({
    @required this.email,
    @required this.password,
  });

  LoginData copyWith({
    String email,
    String password,
  }) {
    return new LoginData(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'LoginData{email: $email, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoginData && runtimeType == other.runtimeType && email == other.email && password == other.password);

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  factory LoginData.fromMap(Map<String, dynamic> map) {
    return new LoginData(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'password': this.password,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class LoginResponse {
  String token;
  int userAccountId;
  LoginResponse(this.token, this.userAccountId);
}

// class SignUpData {
//   String email; //"string",
//   String authentication; //"FACEBOOK",
//   String password; //"string",
//   String name; //"string",
//   String sex; //"FEMALE",
//   String phoneNumber; //"string"
//
//   Map<String, dynamic> toMap() {
//     return {
//       'email': email ?? '',
//       'authentication': authentication ?? '',
//       'password': password ?? '',
//       'name': name ?? '',
//       'sex': sex ?? '',
//       'phoneNumber': phoneNumber ?? '',
//     };
//   }
// }
