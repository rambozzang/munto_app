import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/provider/tag_provider.dart';

import 'user_data.dart';

class FeedData2 {
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
  FeedData2({
    this.id,
    this.likeCount,
    this.commentCount,
    this.content,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.photos,
    this.likerImages,
    this.user,
    this.tags,
    this.commentUserId,
    this.commentContent,
    this.commentUserImage,
    this.isLiked,
    this.isFollow,
  });

  FeedData2 copyWith({
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
    return FeedData2(
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'content': content,
      'type': type,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'photos': photos,
      'likerImages': likerImages,
      'user': user?.toMap(),
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'commentUserId': commentUserId,
      'commentContent': commentContent,
      'commentUserImage': commentUserImage,
      'isLiked': isLiked,
      'isFollow': isFollow,
    };
  }

  factory FeedData2.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return FeedData2(
      id: map['id'],
      likeCount: map['likeCount'],
      commentCount: map['commentCount'],
      content: map['content'],
      type: map['type'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      photos: List<String>.from(map['photos']),
      likerImages: List<String>.from(map['likerImages']),
      user: UserData.fromMap(map['user']),
      tags: List<TagData>.from(map['tags']?.map((x) => TagData.fromMap(x))),
      commentUserId: map['commentUserId'],
      commentContent: map['commentContent'],
      commentUserImage: map['commentUserImage'],
      isLiked: map['isLiked'],
      isFollow: map['isFollow'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedData2.fromJson(String source) => FeedData2.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeedData2(id: $id, likeCount: $likeCount, commentCount: $commentCount, content: $content, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, photos: $photos, likerImages: $likerImages, user: $user, tags: $tags, commentUserId: $commentUserId, commentContent: $commentContent, commentUserImage: $commentUserImage, isLiked: $isLiked, isFollow: $isFollow)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is FeedData2 &&
      o.id == id &&
      o.likeCount == likeCount &&
      o.commentCount == commentCount &&
      o.content == content &&
      o.type == type &&
      o.createdAt == createdAt &&
      o.updatedAt == updatedAt &&
      listEquals(o.photos, photos) &&
      listEquals(o.likerImages, likerImages) &&
      o.user == user &&
      listEquals(o.tags, tags) &&
      o.commentUserId == commentUserId &&
      o.commentContent == commentContent &&
      o.commentUserImage == commentUserImage &&
      o.isLiked == isLiked &&
      o.isFollow == isFollow;
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
  }
}
