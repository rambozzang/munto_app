
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util.dart';
import '../urls.dart';
import '../user_data.dart';
import '../userinfo.dart';
import 'feed_provider.dart';

class FeedDetailProvider extends ParentProvider{
  ApiService _api = ApiService();
  final FeedData feedData;
  FeedDetailProvider(this.feedData);
  List<CommentData> commentList = [];

  // Future<List<CommentData>> fetchComments() async {
  //   setStateBusy();
  //   final path = '/api/feed/comments/${feedData.id}/0/50';
  //   final response = await _api.get(path);
  //   print('response = ${response.toString()}');
  //   setStateBusy();
  //   List<CommentData> list = (response as List)?.map((data) => CommentData.fromMap(data))?.toList();
  //   return list;
  // }

  Future<void> checkViewCount() async {
    setStateBusy();
    final _callUri = '/api/feed/${feedData.id}/view';
    final response = await _api.post(_callUri, null);
    setStateIdle();
    return;

  }
  Future<void> fetchComments() async {
    setStateBusy();

    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.get(Uri.encodeFull('$hostUrl/api/feed/comments/${feedData.id}/0/50'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      })
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );

      setStateIdle();

      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        print('_json = ${_json.toString()}');

        // commentList = [];
        // _json.forEach((feedJson){
        //   final comment = CommentData.fromMap(feedJson);
        //   print('${comment.id} : ${comment.content}');
        //   commentList.add(comment);
        // });
        commentList = (_json as List)?.map((comment)=> CommentData.fromMap(comment))?.toList() ?? [];
        //댓글 시간 내림차순정렬
        commentList.sort((a,b)=> a.updatedAt.compareTo(b.updatedAt));

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

  Future<bool> postLike(CommentData commentData) async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.post(Uri.encodeFull('$hostUrl/api/feed/comment/like/${commentData.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },)
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );


      setStateIdle();
      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        final _result = _json['result'];
        if(_result){
          commentData.toggleLike();
          notifyListeners();
        }
        return _result;

      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
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


  Future<bool> deleteLike(CommentData commentData) async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.delete(Uri.encodeFull('$hostUrl/api/feed/comment/like/${commentData.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },)
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );


      setStateIdle();
      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        final _result = _json['result'];
        if(_result){
          commentData.toggleLike();
          notifyListeners();
        }
        return _result;

      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
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



  Future<bool> postFollow() async {
    print('userId = ${feedData.user.id}');
    setStateBusy();
    final _callUri = "/api/user/follow/${feedData.user.id}";
    final response = await _api.post(_callUri, null);
    setStateIdle();
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }

  Future<bool> deleteFollow() async {
    print('userId = ${feedData.user.id}');

    setStateBusy();
    final _callUri = "/api/user/follow/${feedData.user.id}";
    final response = await _api.delete(_callUri, {});
    setStateIdle();
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }



  Future<bool> postComment(int feedId, String content) async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.post(Uri.encodeFull('$hostUrl/api/feed/comment'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "feedId": '$feedId',
//            "content": Uri.encodeComponent(content),
            "content": content,
          }))
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );


      setStateIdle();
      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        final result = _json['result'];
        // addComment(CommentData.fromContent(content));
        return result;

      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
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
  Future<bool> deleteComment(commentId) async {
    setStateBusy();
    final _callUri = "/api/feed/comment/$commentId";
    final response = await _api.delete(_callUri, {});
    setStateIdle();
    return response['result'];
  }


  Future<bool> postRecomment(int feedId, String content, int parentId) async {
    setStateBusy();
    try{
      final token = await Util.getSharedString(KEY_TOKEN);

      http.Response response =
      await http.post(Uri.encodeFull('$hostUrl/api/feed/recomment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      body: jsonEncode({
        "feedId": '$feedId',
        "content": content,
        "parentId": '$parentId'
      }))
          .timeout(Duration(seconds: DEFAULT_TIMEOUT_SEC)
      );


      setStateIdle();
      if(isSuccess(response.statusCode)){
        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
        final result = _json['result'];
        // insertRecommand(content, parentId);
        return result;

      }else{
        print('response.statusCode = ${response.statusCode}');
        print('utf8.decode = ${utf8.decode(response.bodyBytes).toString()}');

        final _jsonResponse = utf8.decode(response.bodyBytes);
        final _json = json.decode(_jsonResponse);
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

  Future<bool> postFeedReport() async {
    final _callUri = "/api/feed/report/${feedData.id}";
    final response = await _api.post(_callUri, null);
    return response['result'];
  }

  Future<bool> postCommentReport(commentId) async {
    final _callUri = "/api/feed/report/comment/$commentId";
    final response = await _api.post(_callUri, null);
    return response['result'];
  }



//   void addComment(CommentData comment){
//     commentList.add(comment);
//   }
//
//   void insertRecommand(String content, int parentId) {
//     try {
//       if (commentList != null) {
//         final newComment = CommentData.fromContent(content, parentId: parentId);
//         commentList.forEach((comment) {
//           if(comment.id == parentId)
//             comment.recomments.add(newComment);
//           else if(comment.recomments != null){
//             comment.recomments.forEach((recomment) {
//               if(recomment.id == parentId)
//                 comment.recomments.add(newComment);
//             });
//           }
//         });
//       }
//     } on Exception catch (e){
//       print(e.toString());
//     }
//   }
}

class CommentData{
  int id;
  DateTime updatedAt;
  int parentId;
  String content;
  int userId;
  int feedId;
  bool isLike;
  int likeCount;
  List<CommentData> recomments;
  UserData user;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  CommentData({
    @required this.id,
    @required this.updatedAt,
    @required this.parentId,
    @required this.content,
    @required this.userId,
    @required this.feedId,
    @required this.isLike,
    @required this.likeCount,
    @required this.recomments,
    @required this.user,
  });

  CommentData copyWith({
    int id,
    DateTime updatedAt,
    int parentId,
    String content,
    int userId,
    int feedId,
    bool isLike,
    int likeCount,
    List<CommentData> recomments,
    UserData user,
  }) {
    return new CommentData(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      feedId: feedId ?? this.feedId,
      isLike: isLike ?? this.isLike,
      likeCount: likeCount ?? this.likeCount,
      recomments: recomments ?? this.recomments,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'CommentData{id: $id, updatedAt: $updatedAt, parentId: $parentId, content: $content, userId: $userId, feedId: $feedId, isLike: $isLike, likeCount: $likeCount, recomments: $recomments, user: $user}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          updatedAt == other.updatedAt &&
          parentId == other.parentId &&
          content == other.content &&
          userId == other.userId &&
          feedId == other.feedId &&
          isLike == other.isLike &&
          likeCount == other.likeCount &&
          recomments == other.recomments &&
          user == other.user);

  @override
  int get hashCode =>
      id.hashCode ^
      updatedAt.hashCode ^
      parentId.hashCode ^
      content.hashCode ^
      userId.hashCode ^
      feedId.hashCode ^
      isLike.hashCode ^
      likeCount.hashCode ^
      recomments.hashCode ^
      user.hashCode;

  factory CommentData.fromMap(Map<String, dynamic> map) {
    //댓글 시간 내림차순정렬
    List<CommentData> recomments = (map['recomments'] as List)?.map((data) => CommentData.fromMap(data))?.toList() ?? [];
    recomments.sort((a,b)=>a.updatedAt.compareTo(b.updatedAt));
    return new CommentData(
      id: map['id'] as int,
      updatedAt: DateTime.parse(map['updatedAt']),
      parentId: map['parentId'] as int,
      content: map['content'] as String,
      userId: map['userId'] as int,
      feedId: map['feedId'] as int,
      isLike: map['isLike'] as bool,
      likeCount: map['likeCount'] as int,
      recomments: recomments,
      user: UserData.fromMap(map['user']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'updatedAt': this.updatedAt,
      'parentId': this.parentId,
      'content': this.content,
      'userId': this.userId,
      'feedId': this.feedId,
      'isLike': this.isLike,
      'likeCount': this.likeCount,
      'recomments': this.recomments,
      'user': this.user,
    } as Map<String, dynamic>;
  }

//</editor-fold>


  CommentData.fromContent(String content, {int parentId}){

    this.content = content;
    this.parentId = parentId;
    id = 0;
    updatedAt = DateTime.now();
    userId = UserInfo.myProfile.id;
    feedId = 0;
    isLike = false;
    likeCount = 0;
    recomments = [];
    user = UserData.fromProfile(UserInfo.myProfile);

  }

  void toggleLike() {
    if(isLike){
      if(likeCount >0)
        likeCount--;

    } else
      likeCount++;

    isLike = !isLike;
  }
}


