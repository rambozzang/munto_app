import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/feed_Image_Userinfo_data.dart';
import 'package:munto_app/model/photos_data.dart';
import 'package:munto_app/model/tags_data.dart';
import 'package:munto_app/model/user_data.dart';

class FeedImageListData {
  int id;
  String createdAt;
  String updatedAt;
  String content;
  String type;
  List<PhotosData> photos;
  UserData user;
  List<TagsData> tags;
  List<String> likerImages;
  int likeCount;
  bool isLiked;
  bool isFollow;
  int commentCount;
  FeedImageListData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.content,
    this.type,
    this.photos,
    this.user,
    this.tags,
    this.likerImages,
    this.likeCount,
    this.isLiked,
    this.isFollow,
    this.commentCount,
  });

  FeedImageListData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String content,
    String type,
    List<PhotosData> photos,
    UserData user,
    List<TagsData> tags,
    List<String> likerImages,
    int likeCount,
    bool isLiked,
    bool isFollow,
    int commentCount,
  }) {
    return FeedImageListData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      type: type ?? this.type,
      photos: photos ?? this.photos,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      likerImages: likerImages ?? this.likerImages,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isFollow: isFollow ?? this.isFollow,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'content': content,
      'type': type,
      'photos': photos?.map((x) => x?.toMap())?.toList(),
      'user': user?.toMap(),
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'likerImages': likerImages,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'isFollow': isFollow,
      'commentCount': commentCount,
    };
  }

  factory FeedImageListData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FeedImageListData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      content: map['content'],
      type: map['type'],
      photos: List<PhotosData>.from(map['photos']?.map((x) => PhotosData.fromMap(x))),
      user: UserData.fromMap(map['user']),
      tags: List<TagsData>.from(map['tags']?.map((x) => TagsData.fromMap(x))),
      likerImages: List<String>.from(map['likerImages']),
      likeCount: map['likeCount'],
      isLiked: map['isLiked'],
      isFollow: map['isFollow'],
      commentCount: map['commentCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedImageListData.fromJson(String source) => FeedImageListData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeedImageListData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, content: $content, type: $type, photos: $photos, user: $user, tags: $tags, likerImages: $likerImages, likeCount: $likeCount, isLiked: $isLiked, isFollow: $isFollow, commentCount: $commentCount)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FeedImageListData &&
        o.id == id &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.content == content &&
        o.type == type &&
        listEquals(o.photos, photos) &&
        o.user == user &&
        listEquals(o.tags, tags) &&
        listEquals(o.likerImages, likerImages) &&
        o.likeCount == likeCount &&
        o.isLiked == isLiked &&
        o.isFollow == isFollow &&
        o.commentCount == commentCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        content.hashCode ^
        type.hashCode ^
        photos.hashCode ^
        user.hashCode ^
        tags.hashCode ^
        likerImages.hashCode ^
        likeCount.hashCode ^
        isLiked.hashCode ^
        isFollow.hashCode ^
        commentCount.hashCode;
  }
}
