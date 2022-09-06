import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util.dart';
import '../class_Data.dart';
import '../other_userprofile_data.dart';
import '../urls.dart';
import '../userProfile_Data.dart';
import 'api_Service.dart';

class OtherUserProfileProvider extends ParentProvider {
  final String id;
  OtherUserProfileProvider(this.id);

  OtherUserProfileData otherUserProfileData;
  List<FeedData> userFeedList;

  ApiService _api = ApiService();

  Future<void> fetchProfile() async {
    setStateBusy();

    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
          await http.get(Uri.encodeFull('$hostUrl/api/user/profile/$id'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC));

      setStateIdle();

      if (isSuccess(response.statusCode)) {
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        print('_json = ${_json.toString()}');

        otherUserProfileData = OtherUserProfileData.fromMap(_json);
        notifyListeners();
        return;
      } else {
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        throwException(response);
      }
    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch (e) {
      setStateIdle();
      throw SocketException(e.toString());
    } on Exception catch (e) {
      setStateIdle();
      print('on Exception : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

//  {userId}/{skip}/{take}

  Future<void> fetchUserFeeds() async {
    setStateBusy();

    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
          await http.get(Uri.encodeFull('$hostUrl/api/feed/byUser/$id/0/50'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC));

      if (isSuccess(response.statusCode)) {
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);

        userFeedList = [];
        _json.forEach((feedJson) {
          userFeedList.add(FeedData.fromMap(feedJson));
        });

        setStateIdle();
        return;
      } else {
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        throwException(response);
      }
    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch (e) {
      setStateIdle();
      throw SocketException(e.toString());
    } on Exception catch (e) {
      setStateIdle();
      print('on Exception : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<bool> postFollow() async {
    setStateBusy();
    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response = await http.post(
        Uri.encodeFull('$hostUrl/api/user/follow/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC));

      setStateIdle();
      if (isSuccess(response.statusCode)) {
//        final _jsonResponse = utf8.decode(response.bodyBytes);
//        final _json = json.decode(_jsonResponse);
//        final _result = _json['result'];
//        if(_result){
//          notifyListeners();
//        }
//        return _result;
        return true;
      } else {
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        throwException(response);
      }
    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch (e) {
      setStateIdle();
      throw SocketException(e.toString());
    }
    return false;
  }

  Future<bool> deleteFollow() async {
    setStateBusy();
    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response = await http.delete(
        Uri.encodeFull('$hostUrl/api/user/follow/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC));

      setStateIdle();
      if (isSuccess(response.statusCode)) {
//        final _jsonResponse = utf8.decode(response.bodyBytes);
//        final _json = json.decode(_jsonResponse);
//        final _result = _json['result'];
//        if(_result){
//          notifyListeners();
//        }
//        return _result;
        return true;
      } else {
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        throwException(response);
      }
    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch (e) {
      setStateIdle();
      throw SocketException(e.toString());
    }
    return false;
  }

  Future<List<ClassData>> getClassListForAdminstrator() async {
    final _callUri = "/api/class/list/forAdministrator";
    final response = await _api.get(_callUri);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }
}
