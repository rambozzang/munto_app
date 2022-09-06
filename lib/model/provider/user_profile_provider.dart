import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util.dart';
import '../other_userprofile_data.dart';
import '../urls.dart';
import '../userProfile_Data.dart';
import 'api_Service.dart';

class UserProfileProvider extends ParentProvider {
  UserProfileProvider();

  UserProfileData userProfileData;
  List<FeedData> userFeedList;

  ApiService _api = ApiService();

  Future<void> fetchProfile() async {
    //  setStateBusy();

    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
          await http.get(Uri.encodeFull('$hostUrl/api/user/profile'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }).timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC));

      //   setStateIdle();

      if (isSuccess(response.statusCode)) {
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        print('_json = ${_json.toString()}');

        userProfileData = UserProfileData.fromMap(_json);

        return;
      } else {
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        throwException(response);
      }
    } on TimeoutException catch (e) {
      //  setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch (e) {
      //    setStateIdle();
      throw SocketException(e.toString());
    } on Exception catch (e) {
      //   setStateIdle();
      print('on Exception : ${e.toString()}');
      throw Exception(e.toString());
    }
  }

//  {userId}/{skip}/{take}

  Future<void> fetchUserFeeds() async {
    if (userProfileData == null) return;

    setStateBusy();

    try {
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
          await http.get(Uri.encodeFull('$hostUrl/api/feed/byUser/${userProfileData.id}/0/30'), headers: {
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

  Future<bool> updateProfile(UserProfileData data) async {
    print('updateProfile : ${data.toMap().toString()}');
    print('updateProfile : ${data.toFileMap().toString()}');

    final response = await _api.multipartMap('/api/user/profile', data.toMap(), data.toFileMap());
    return response != null;
  }
}
