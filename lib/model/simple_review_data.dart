

import 'package:flutter/cupertino.dart';

class SimpleReviewData {

  String content;
  String photo;
  String userImage;
  String userName;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SimpleReviewData({
    @required this.content,
    @required this.photo,
    @required this.userImage,
    @required this.userName,
  });

  SimpleReviewData copyWith({
    String content,
    String photo,
    String userImage,
    String userName,
  }) {
    return new SimpleReviewData(
      content: content ?? this.content,
      photo: photo ?? this.photo,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() {
    return 'SimpleReviewData{content: $content, photo: $photo, userImage: $userImage, userName: $userName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SimpleReviewData &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          photo == other.photo &&
          userImage == other.userImage &&
          userName == other.userName);

  @override
  int get hashCode =>
      content.hashCode ^
      photo.hashCode ^
      userImage.hashCode ^
      userName.hashCode;

  factory SimpleReviewData.fromMap(Map<String, dynamic> map) {
    String image = '';
    String name = '';

    if(map['User'] != null){
      image = map['User']['image'] as String;
      name = map['User']['name'] as String;

    }
    return new SimpleReviewData(
      content: map['content'] as String,
      photo: map['photo'] as String,
      userImage: image,
      userName: name,
    );
  }

//</editor-fold>

}