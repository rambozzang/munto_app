import 'package:flutter/material.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/userProfile_Data.dart';

class UserData{
  int id;
  String name;
  String image;
  String introduce;
  bool isFollow;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  UserData({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.introduce,
    @required this.isFollow,
  });

  UserData copyWith({
    int id,
    String name,
    String image,
    String introduce,
    bool isFollow,
  }) {
    return new UserData(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      introduce: introduce ?? this.introduce,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  @override
  String toString() {
    return 'UserData{id: $id, name: $name, image: $image, introduce: $introduce, isFollow: $isFollow}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          introduce == other.introduce &&
          isFollow == other.isFollow);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      introduce.hashCode ^
      isFollow.hashCode;

  factory UserData.fromMap(Map<String, dynamic> map) {
    return new UserData(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      introduce: map['introduce'] as String,
      isFollow: map['isFollow'] != null ? (map['isFollow'] as bool) : false,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'introduce': this.introduce,
      'isFollow': this.isFollow,
    } as Map<String, dynamic>;
  }

  factory UserData.fromProfile(UserProfileData profile) {
    return new UserData(
      id: profile.id,
      name: profile.name,
      image: profile.image,
      introduce: profile.introduce,
      isFollow: false,
    );
  }

//</editor-fold>

}