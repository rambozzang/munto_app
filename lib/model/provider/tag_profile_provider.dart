
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'dart:convert';

import '../../util.dart';
import '../urls.dart';

class TagProfileProvider extends ParentProvider{
  final TagData tagData;
  TagProfileProvider(this.tagData);
  List<FeedData> tagFeedList;
  ApiService _api = ApiService();
  TagFollowerData tagFollowerData;
  Future<void> fetchTagFeeds() async {
    setStateBusy();

    try{
      final token = await Util.getSharedString(KEY_TOKEN);
      http.Response response =
      await http.get(Uri.encodeFull('$hostUrl/api/feed/byTag/${tagData.id}/0/20'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          })
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );

      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        print('_json = $_json');

        tagFeedList = [];
        _json.forEach((feedJson){
          tagFeedList.add(FeedData.fromMap(feedJson));
        });

        // tagFeedList = (_json as List)?.map((comment)=> FeedData.fromMap(comment))?.toList() ?? [];

        setStateIdle();
        return ;
      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');
        throwException(response);
      }

    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch(e){
      setStateIdle();
      throw SocketException(e.toString());
    } on Exception catch(e){
      setStateIdle();
      print('on Exception : ${e.toString()}');
      throw Exception(e.toString());
    }
  }



  Future<bool> postFollow() async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.post(Uri.encodeFull('$hostUrl/api/tag/follow/${tagData.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },)
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );

      setStateIdle();
      if(isSuccess(response.statusCode)){
        if(tagFollowerData != null)
          tagFollowerData.followers.add(UserData.fromProfile(UserInfo.myProfile));
        return true;
      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');
        throwException(response);
      }

    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch(e){
      setStateIdle();
      throw SocketException(e.toString());
    }
    return false;
  }


  Future<bool> deleteFollow() async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.delete(Uri.encodeFull('$hostUrl/api/tag/follow/${tagData.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },)
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );

      setStateIdle();
      if(isSuccess(response.statusCode)){
        if(tagFollowerData != null)
          tagFollowerData.followers.removeWhere((element) => element.id == UserInfo.myProfile.id,);
        return true;
      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');
        throwException(response);
      }

    } on TimeoutException catch (e) {
      setStateIdle();
      throw TimeoutException(e.toString());
    } on SocketException catch(e){
      setStateIdle();
      throw SocketException(e.toString());
    }
    return false;
  }


  Future<TagFollowerData> fetchFollowers() async {
    final _path = '/api/tag/follower/${tagData.id}/0/10';
    final response = await _api.get(_path);
    print('response = ${response.toString()}');
    return tagFollowerData = TagFollowerData.fromMap(response);
  }

  Future<List<UserData>> getWriters() async {
    final _path = '/api/tag/${tagData.id}/writer/';
    final response = await _api.get(_path);
    print('response = ${response.toString()}');
    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }





}


class TagProfileData{
  int          id;
  String       name;
  String       image;
  String       introduce;
  int          followingCount;
  int          followerCount;
  int          feedCount;
  List<String> career;
  List<String> cultureArt;
  List<String> write;
  List<String> lifeStyle1;
  List<String> lifeStyle2;
  List<String> food;
  List<String> beautyHealth;
  List<String> artCraft;

  List<String> get tags{
    return career + cultureArt + write + lifeStyle1
        + lifeStyle2 + food + beautyHealth + artCraft ;
  }


  TagProfileData.fromJson(Map<String, dynamic> json){

    id               = json['id'];
    name             = json['name'];
    image            = json['image'];
    introduce        = json['introduce'];
    followingCount   = json['followingCount'];
    followerCount    = json['followerCount'];
    feedCount        = json['feedCount'];
    career           = parseList(json, 'career');
    cultureArt       = parseList(json, 'cultureArt');
    write            = parseList(json, 'write');
    lifeStyle1       = parseList(json, 'lifeStyle1');
    lifeStyle2       = parseList(json, 'lifeStyle2');
    food             = parseList(json, 'food');
    beautyHealth     = parseList(json, 'beautyHealth');
    artCraft         = parseList(json, 'artCraft');
  }

}

class TagFollowerData{
  int followerCount;
  List<UserData> followers;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TagFollowerData({
    @required this.followerCount,
    @required this.followers,
  });

  TagFollowerData copyWith({
    int followerCount,
    List<UserData> followers,
  }) {
    return new TagFollowerData(
      followerCount: followerCount ?? this.followerCount,
      followers: followers ?? this.followers,
    );
  }

  @override
  String toString() {
    return 'TagFollowerData{followerCount: $followerCount, followers: $followers}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagFollowerData &&
          runtimeType == other.runtimeType &&
          followerCount == other.followerCount &&
          followers == other.followers);

  @override
  int get hashCode => followerCount.hashCode ^ followers.hashCode;

  factory TagFollowerData.fromMap(Map<String, dynamic> map) {
    return new TagFollowerData(
      followerCount: map['followerCount'] as int,
      followers: (map['followers'] as List)?.map((data) => UserData.fromMap(data))?.toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'followerCount': this.followerCount,
      'followers': this.followers,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

List<String> parseList(Map<String, dynamic> json, String key) {
  List<String> result= [];
//  if(json[key] != null){
//    json[key].forEach((value){
//      result.add(value);
//    });
//  }
  return result;
}


