import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

class FeedWriteProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<bool> createFeed(FeedWriteData feedWriteData) async {
    setStateBusy();
    print('map = ${feedWriteData.toMap().toString()}');

    final result = await _api.multipart(
        '/api/feed', feedWriteData.toMap(), feedWriteData.photos);
    setStateIdle();
    return result;
  }


  Future<bool> updateFeed(map, photos,) async {
    print('updateFeed ${map.toString()}');

    final result = await _api.multipart('/api/feed', map, photos, isPut: true);
    return result;
  }
}

class FeedWriteData {
  List<String> photos;
  String content;
  List<String> tags;
  String feedType; // PUBLIC, PRIVATE
  String socialingId;
  String itemId;
  FeedWriteData({
    this.photos,
    this.content,
    this.tags,
    this.feedType,
    this.socialingId,
    this.itemId,
  });

  Map<String, dynamic> toMap() {
    return {
      //파일은 별도첨부
      // 'photos': photos,
      'content': content,
      'tags': tags,
      'feedType': _feedType,
      'classId':_classId,
      'status' : status,
    };
  }


  String get _feedType {
    if(socialingId != null && socialingId.isNotEmpty)
      return 'SOCIALING';
    if(itemId != null && itemId.isNotEmpty)
      return 'ITEM';

    return 'PUBLIC';
  }

  String get status{
    if(_feedType == 'SOCIALING' || _feedType == 'ITEM' )
      return 'PRIVATE';
    return 'PUBLIC';
  }

  String get _classId {
    if(socialingId != null && socialingId.isNotEmpty)
      return socialingId;
    if(itemId != null && itemId.isNotEmpty)
      return itemId;
    return '';
  }

  String getClassId() {
    if(socialingId != null && socialingId.isNotEmpty)
      return 'SOCIALING';
    if(itemId != null && itemId.isNotEmpty)
      return 'ITEM';

    return 'PUBLIC';
  }

  factory FeedWriteData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FeedWriteData(
      photos: List<String>.from(map['photos']),
      content: map['content'],
      tags: List<String>.from(map['tags']),
      feedType: map['feedType'],
      itemId: map['itemId'],
      socialingId: map['socialingId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedWriteData.fromJson(String source) =>
      FeedWriteData.fromMap(json.decode(source));
}

class ResponseJsonObject {
  bool result;
  ResponseJsonObject({
    this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
    };
  }

  factory ResponseJsonObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResponseJsonObject(
      result: map['result'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseJsonObject.fromJson(String source) =>
      ResponseJsonObject.fromMap(json.decode(source));
}
