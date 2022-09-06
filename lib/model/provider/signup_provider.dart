
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/userinfo.dart';

import '../../util.dart';

class SignUpProvider extends ParentProvider{
  ApiService _api = ApiService();

  Future<bool> signUp(SignUpData signUpData) async {
    setStateBusy();
    bool result = false;

    final _callUri =signUpData.isSNS ? "/api/user/join": "/api/user/join/local";
    final response = await _api.post(_callUri, signUpData);
    setStateIdle();
    if(signUpData.isSNS){
      final String token = response['token'];
      UserInfo.myProfile = UserProfileData.fromMap(response['user']);
      if(token != null && token.isNotEmpty && UserInfo.myProfile != null){
        Util.setSharedString(KEY_TOKEN, token);
        return true;
      }
    }else{
      print('result1 =  ${response.toString()}');

      result = response['id'] != null && '${response['id']}' != '';
    }

    return result;
  }
}


class SignUpData{
  String email;
  String authentication = 'MUNTO';
  String password;
  String name;
  String sex;
  String phoneNumber;
  String userAccountId;
  bool get isSNS{
    return userAccountId != null && userAccountId.isNotEmpty;
  }

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SignUpData({
    @required this.email,
    @required this.authentication,
    @required this.password,
    @required this.name,
    @required this.sex,
    @required this.phoneNumber,
    @required this.userAccountId,
  });

  SignUpData copyWith({
    String email,
    String authentication,
    String password,
    String name,
    String sex,
    String phoneNumber,
    String userAccountId,
  }) {
    return new SignUpData(
      email: email ?? this.email,
      authentication: authentication ?? this.authentication,
      password: password ?? this.password,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userAccountId: userAccountId ?? this.userAccountId,
    );
  }

  @override
  String toString() {
    return 'SignUpData{email: $email, authentication: $authentication, password: $password, name: $name, sex: $sex, phoneNumber: $phoneNumber, userAccountId: $userAccountId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SignUpData &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          authentication == other.authentication &&
          password == other.password &&
          name == other.name &&
          sex == other.sex &&
          phoneNumber == other.phoneNumber &&
          userAccountId == other.userAccountId);

  @override
  int get hashCode =>
      email.hashCode ^
      authentication.hashCode ^
      password.hashCode ^
      name.hashCode ^
      sex.hashCode ^
      phoneNumber.hashCode ^
      userAccountId.hashCode;

  factory SignUpData.fromMap(Map<String, dynamic> map) {
    return new SignUpData(
      email: map['email'] as String,
      authentication: map['authentication'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      sex: map['sex'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userAccountId: map['userAccountId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    if(isSNS)
      return {
        'email': this.email,
        // 'authentication': this.authentication,
        // 'password': this.password,
        'name': this.name,
        'sex': this.sex,
        'phoneNumber': this.phoneNumber,
        'userAccountId': this.userAccountId,
      } ;
    else
      return {
      'email': this.email,
      'authentication': this.authentication ?? 'MUNTO',
      'password': this.password,
      'name': this.name,
      'sex': this.sex,
      'phoneNumber': this.phoneNumber,
    } ;
  }

//</editor-fold>

}