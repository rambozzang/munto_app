import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:munto_app/model/feed_data.dart';
import 'package:munto_app/model/feed_image_list_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../util.dart';
import '../urls.dart';
import '../user_data.dart';

class FeedProvider extends ParentProvider {
  ApiService _api = ApiService();

  List<FeedData> dataList = []; // 최근 10개만 가져올때
  bool hasNewPost = false;

  List<FeedData> dataPageList = [];
  List<FeedData> myFeedDataList = [];
  bool dataPageListisMoreBool = false; // feed_page.dart 에서 페이징 리스트로 사용.
  Future<List<FeedData>> fetchPage(int page, {bool isFeedPage = false}) async {
    // setStateBusy();
    int _take = 30;
    int _skip = ((page ?? 1) - 1) * _take;
    if (page == 1) {
      if(isFeedPage)
        myFeedDataList = [];
      else
        dataPageList = [];
    }
    print('page :  $page , skip : $_skip , take : $_take');
    try {
      final _callUri = isFeedPage ? "/api/feed/$_skip/$_take?options=true" : "/api/feed/$_skip/$_take";
      final response = await _api.get(_callUri);
      int cnt = 0;
      response.forEach((feedJson) {
        if(isFeedPage)
          myFeedDataList.add(FeedData.fromMap(feedJson));
        else
          dataPageList.add(FeedData.fromMap(feedJson));
        cnt++;
      });
      // 리스트가 더 존재하는 여부 체크
      if (_take > cnt) {
        dataPageListisMoreBool = false;
      } else {
        dataPageListisMoreBool = true;
      }
    } catch (e) {
      //   setStateIdle();
      print(e.toString());
    }

    // setStateIdle();
    return isFeedPage ? myFeedDataList : dataPageList;
  }

  // 커뮤니티 게시판 내용 가져오기
  // /api/feed/{classType}/{classId}/{skip}/{take}
  Future<List<FeedData>> getFeedClassTypeClassIdSkipTake(String classType, String classId, int page) async {
    String _classTypeUp = classType.toUpperCase();
    int _take = 10;
    int _skip = ((page ?? 1) - 1) * _take;
    if (page == 1) {
      dataPageList = [];
    }
    print('page :  $page , skip : $_skip , take : $_take');

    final _callUri = "/api/feed/$_classTypeUp/$classId/$_skip/$_take";
    final response = await _api.get(_callUri);
    print('response : $response');
    List<FeedData> list = (response as List).map((data) => FeedData.fromMap(data)).toList();
    return list;
  }

  List<FeedData> dataLoungPageList = [];
  bool dataLoungPageListisMoreBool = false; // feed_page.dart 에서 페이징 리스트로 사용.
  Future<List<FeedData>> fectchLoungPage(int page) async {
    // setStateBusy();
    int _take = 10;
    int _skip = ((page ?? 1) - 1) * _take;
    if (page == 1) {
      dataList = [];
      // _skip = 3;
      // _take = 3;
    }

    try {
      final _callUri = "/api/feed/$_skip/$_take";
      final response = await _api.get(_callUri);
      int cnt = 0;
      response.forEach((feedJson) {
        if (cnt == 3 && page == 1) {
          dataList.add(tmpFeedData);
        }
        dataList.add(FeedData.fromMap(feedJson));
        cnt++;
      });
      // 리스트가 더 존재하는 여부 체크
      print('fectchLoungPage 실행  :  $page , skip : $_skip , take : $_take , cnt : $cnt ');
      if (_take > cnt) {
        dataLoungPageListisMoreBool = false;
      } else {
        dataLoungPageListisMoreBool = true;
      }
    } catch (e) {
      setStateIdle();
      print(e.toString());
    }

    setStateIdle();
    return dataPageList;
  }

  Future<List<OtherUserProfileData>> getPopularUsers() async {
    setStateBusy();
    final _callUri = '/api/user/popular';
    final response = await _api.get(_callUri);

    print('popular response = ${response.toString()}');
    return (response as List).map((e) => OtherUserProfileData.fromMap(e)).toList();
  }

  Future<bool> postFollow(userId) async {
    setStateBusy();
    final _callUri = "/api/user/follow/$userId";
    final response = await _api.post(_callUri, null);
    setStateIdle();
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }

  Future<bool> deleteFollow(userId) async {
    setStateBusy();
    final _callUri = "/api/user/follow/$userId";
    final response = await _api.delete(_callUri, {});
    setStateIdle();
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }

  Future<bool> postComment(int feedId, String content) async {
    setStateBusy();
    final _callUri = "/api/feed/comment";
    final response = await _api.post(_callUri, {
      'feedId': '$feedId',
      'content': content,
    });
    setStateIdle();
    print('response= ${response.toString()}');
    return response['result'];
  }

  Future<bool> postLike(FeedData feedData) async {
    setStateBusy();
    bool result = false;
    try {
      final _callUri = "/api/feed/like/${feedData.id}";
      final response = await _api.post(_callUri, {});
      result = response['result'] ?? false;
    } on Exception catch (e) {
      print(e.toString());
    }
    setStateIdle();
    return result;
  }

  Future<bool> deleteLike(FeedData feedData) async {
    setStateBusy();
    bool result = false;
    try {
      final _callUri = "/api/feed/like/${feedData.id}";
      final response = await _api.delete(_callUri, {});
      setStateIdle();
      return response['result'] != null;
    } on Exception catch (e) {
      print(e.toString());
    }
    setStateIdle();
    return false;
  }

  Future<bool> postFeedReport(feedId) async {
    final _callUri = "/api/feed/report/$feedId";
    final response = await _api.post(_callUri, null);
    return response['result'];
  }

  Future<bool> deleteFeed(feedId) async {
    setStateBusy();
    final _callUri = "/api/feed/$feedId";
    final response = await _api.delete(_callUri, {});
    setStateIdle();
    return response['result'];
  }

  Future<FeedData> getFeedById(feedId) async {
    final _callUri = "/api/feed/$feedId";
    final response = await _api.get(_callUri);
    return FeedData.fromMap(response);
  }

  // 커뮤니티 사진 가져오기
  Future<List<FeedImageListData>> getCommunitiPictureList(String classType, int itemId, int page) async {
    ///api/feed/image/{classType}/{classId}/{skip}/{take}
    /// 대문자로 변경
    String _classTypeUp = classType.toUpperCase();
    int _take = 10;
    int _skip = ((page ?? 1) - 1) * _take;
    // if (page == 1) {
    //   dataList = [];
    // }

    final _callUri = '/api/feed/image/$_classTypeUp/$itemId/$_skip/$_take';
    final response = await _api.get(_callUri);
    print(response);
    List<FeedImageListData> picturelist = (response as List).map((data) => FeedImageListData.fromMap(data)).toList();
    print('response');
    return picturelist;
  }
}

FeedData tmpFeedData = FeedData(
    id: 9999999999,
    likeCount: 0,
    commentCount: 0,
    content: '',
    type: '',
    createdAt: null,
    updatedAt: null,
    photos: [],
    likerImages: [],
    user: null,
    tags: [],
    commentUserId: 0,
    commentContent: '',
    commentUserImage: '',
    isLiked: false,
    isFollow: false);

class FeedData {
  int id;
  int likeCount;
  int commentCount;
  String content;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> photos; //photo
  List<String> likerImages;
  UserData user;
  List<TagData> tags;

  //comment
  int commentUserId;
  String commentContent;
  String commentUserImage;
  bool isLiked;
  bool isFollow;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  FeedData({
    @required this.id,
    @required this.likeCount,
    @required this.commentCount,
    @required this.content,
    @required this.type,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.photos,
    @required this.likerImages,
    @required this.user,
    @required this.tags,
    @required this.commentUserId,
    @required this.commentContent,
    @required this.commentUserImage,
    @required this.isLiked,
    @required this.isFollow,
  });

  FeedData copyWith({
    int id,
    int likeCount,
    int commentCount,
    String content,
    String type,
    DateTime createdAt,
    DateTime updatedAt,
    List<String> photos,
    List<String> likerImages,
    UserData user,
    List<TagData> tags,
    int commentUserId,
    String commentContent,
    String commentUserImage,
    bool isLiked,
    bool isFollow,
  }) {
    return new FeedData(
      id: id ?? this.id,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
      likerImages: likerImages ?? this.likerImages,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      commentUserId: commentUserId ?? this.commentUserId,
      commentContent: commentContent ?? this.commentContent,
      commentUserImage: commentUserImage ?? this.commentUserImage,
      isLiked: isLiked ?? this.isLiked,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  @override
  String toString() {
    return 'FeedData{id: $id, likeCount: $likeCount, commentCount: $commentCount, content: $content, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, photos: $photos, likerImages: $likerImages, user: $user, tags: $tags, commentUserId: $commentUserId, commentContent: $commentContent, commentUserImage: $commentUserImage, isLiked: $isLiked, isFollow: $isFollow}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          likeCount == other.likeCount &&
          commentCount == other.commentCount &&
          content == other.content &&
          type == other.type &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          photos == other.photos &&
          likerImages == other.likerImages &&
          user == other.user &&
          tags == other.tags &&
          commentUserId == other.commentUserId &&
          commentContent == other.commentContent &&
          commentUserImage == other.commentUserImage &&
          isLiked == other.isLiked &&
          isFollow == other.isFollow);

  @override
  int get hashCode =>
      id.hashCode ^
      likeCount.hashCode ^
      commentCount.hashCode ^
      content.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      photos.hashCode ^
      likerImages.hashCode ^
      user.hashCode ^
      tags.hashCode ^
      commentUserId.hashCode ^
      commentContent.hashCode ^
      commentUserImage.hashCode ^
      isLiked.hashCode ^
      isFollow.hashCode;

  factory FeedData.fromMap(Map<String, dynamic> map) {
    int commentUserId;
    String commentContent;
    String commentUserImage;
    if(map['comment'] != null){
      commentUserId = map['comment']['userId'];
      commentContent = map['comment']['content'];
      commentUserImage = map['comment']['user']['image'];
    }

    return new FeedData(
      id: map['id'] as int,
      likeCount: map['likeCount'] as int,
      commentCount: map['commentCount'] as int,
      content: map['content'] as String,
      type: map['type'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      photos: (map['photos'] as List)?.map((element) => '${element['photo']}')?.toList() ?? [],
      likerImages: map['likerImages'].cast<String>() as List<String>,
      user: UserData.fromMap(map['user']),
      tags: (map['tags'] as List)?.map((data) => TagData.fromMap(data))?.toList() ?? [],
      commentUserId: commentUserId,
      commentContent: commentContent,
      commentUserImage: commentUserImage,
      isLiked: map['isLiked'] as bool,
      isFollow: map['isFollow'] as bool,
    );

    // try {
    //   id = json['id'];
    //   likeCount = json['likeCount'];
    //   commentCount = json['commentCount'];
    //
    //   content = json['content'];
    //   type = json['type'];
    //   createdAt = DateTime.parse(json['createdAt']);
    //   updatedAt = DateTime.parse(json['updatedAt']);
    //   user = UserData.fromMap(json['user']);
    //   tags = [];
    //   json['tags'].forEach((json) {
    //     tags.add(TagData.fromJson(json));
    //   });
    //   photos = [];
    //   json['photos'].forEach((json) {
    //     photos.add(json['photo']);
    //   });
    //   commentorImages = [];
    //   if (json['comment'] != null) {
    //     commentUserId = json['comment']['userId'];
    //     commentContent = json['comment']['content'];
    //     commentUserImage = json['comment']['user']['image'];
    //   }
    // } on Exception catch (e) {
    //   //error 처리
    //   print('FeedData.fromJson e : ${e.toString()}');
    //   throw Exception();
    // }
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'likeCount': this.likeCount,
      'commentCount': this.commentCount,
      'content': this.content,
      'type': this.type,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'photos': this.photos,
      'likerImages': this.likerImages,
      'user': this.user,
      'tags': this.tags,
      'commentUserId': this.commentUserId,
      'commentContent': this.commentContent,
      'commentUserImage': this.commentUserImage,
      'isLiked': this.isLiked,
      'isFollow': this.isFollow,
    } as Map<String, dynamic>;
  }

  void toggleLike() {
    if (isLiked) {
      isLiked = false;
      likeCount--;
    } else {
      isLiked = true;
      likeCount++;
    }
  }

  static fromFeedImageListData(FeedImageListData item) {
    return FeedData(id: item.id, likeCount: item.likeCount, commentCount: item.commentCount, content: item.content,
        type: item.type, createdAt: DateTime.parse(item.createdAt), updatedAt: DateTime.parse(item.updatedAt),
        photos: item.photos.map((e) => e.photo).toList(), likerImages: item.likerImages, user: item.user, tags: [], commentUserId: null, commentContent: null,
        commentUserImage: null, isLiked: item.isLiked, isFollow: item.isFollow);
  }

//</editor-fold>

}
