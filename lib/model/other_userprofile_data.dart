import 'package:flutter/material.dart';

class OtherUserProfileData{
  int          id;
  String       name;
  String       image;
  String       cover;
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
  bool isFollow;

  String facebookId;
  String instagramId;
  String snsId;

  List<String> get interestList{
    return career + cultureArt + write + lifeStyle1
        + lifeStyle2 + food + beautyHealth + artCraft ;
  }

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  OtherUserProfileData({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.cover,
    @required this.introduce,
    @required this.followingCount,
    @required this.followerCount,
    @required this.feedCount,
    @required this.career,
    @required this.cultureArt,
    @required this.write,
    @required this.lifeStyle1,
    @required this.lifeStyle2,
    @required this.food,
    @required this.beautyHealth,
    @required this.artCraft,
    @required this.isFollow,
    @required this.facebookId,
    @required this.instagramId,
    @required this.snsId,
  });

  OtherUserProfileData copyWith({
    int id,
    String name,
    String image,
    String cover,
    String introduce,
    int followingCount,
    int followerCount,
    int feedCount,
    List<String> career,
    List<String> cultureArt,
    List<String> write,
    List<String> lifeStyle1,
    List<String> lifeStyle2,
    List<String> food,
    List<String> beautyHealth,
    List<String> artCraft,
    bool isFollow,
    String facebookId,
    String instagramId,
    String snsId,
  }) {
    return new OtherUserProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      cover: image ?? this.cover,
      introduce: introduce ?? this.introduce,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      feedCount: feedCount ?? this.feedCount,
      career: career ?? this.career,
      cultureArt: cultureArt ?? this.cultureArt,
      write: write ?? this.write,
      lifeStyle1: lifeStyle1 ?? this.lifeStyle1,
      lifeStyle2: lifeStyle2 ?? this.lifeStyle2,
      food: food ?? this.food,
      beautyHealth: beautyHealth ?? this.beautyHealth,
      artCraft: artCraft ?? this.artCraft,
      isFollow: isFollow ?? this.isFollow,
      facebookId: facebookId ?? this.facebookId,
      instagramId: instagramId ?? this.instagramId,
      snsId: snsId ?? this.snsId,
    );
  }

  @override
  String toString() {
    return 'OtherUserProfileData{id: $id, name: $name, image: $image, introduce: $introduce, followingCount: $followingCount, followerCount: $followerCount, feedCount: $feedCount, career: $career, cultureArt: $cultureArt, write: $write, lifeStyle1: $lifeStyle1, lifeStyle2: $lifeStyle2, food: $food, beautyHealth: $beautyHealth, artCraft: $artCraft, isFollow: $isFollow, cover: $cover}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OtherUserProfileData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          cover == other.cover &&
          introduce == other.introduce &&
          followingCount == other.followingCount &&
          followerCount == other.followerCount &&
          feedCount == other.feedCount &&
          career == other.career &&
          cultureArt == other.cultureArt &&
          write == other.write &&
          lifeStyle1 == other.lifeStyle1 &&
          lifeStyle2 == other.lifeStyle2 &&
          food == other.food &&
          beautyHealth == other.beautyHealth &&
          artCraft == other.artCraft &&
          isFollow == other.isFollow &&
          facebookId == other.facebookId &&
          instagramId == other.instagramId &&
          snsId == other.snsId
      );

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      cover.hashCode ^
      introduce.hashCode ^
      followingCount.hashCode ^
      followerCount.hashCode ^
      feedCount.hashCode ^
      career.hashCode ^
      cultureArt.hashCode ^
      write.hashCode ^
      lifeStyle1.hashCode ^
      lifeStyle2.hashCode ^
      food.hashCode ^
      beautyHealth.hashCode ^
      artCraft.hashCode ^
      isFollow.hashCode ^
      facebookId.hashCode ^
      instagramId.hashCode ^
      snsId.hashCode
  ;

  factory OtherUserProfileData.fromMap(Map<String, dynamic> map) {
    return new OtherUserProfileData(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      cover: map['cover'] as String,
      introduce: map['introduce'] as String,
      followingCount: map['followingCount'] as int,
      followerCount: map['followerCount'] as int,
      feedCount: map['feedCount'] as int,
      career: map['career'].cast<String>() as List<String>,
      cultureArt: map['cultureArt'].cast<String>() as List<String>,
      write: map['write'].cast<String>() as List<String>,
      lifeStyle1: map['lifeStyle1'].cast<String>() as List<String>,
      lifeStyle2: map['lifeStyle2'].cast<String>() as List<String>,
      food: map['food'].cast<String>() as List<String>,
      beautyHealth: map['beautyHealth'].cast<String>() as List<String>,
      artCraft: map['artCraft'].cast<String>() as List<String>,
      isFollow: map['isFollow'] as bool,
      facebookId : map['facebookId'] as String,
      instagramId : map['instagramId'] as String,
      snsId : map['snsId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'cover': this.cover,
      'introduce': this.introduce,
      'followingCount': this.followingCount,
      'followerCount': this.followerCount,
      'feedCount': this.feedCount,
      'career': this.career,
      'cultureArt': this.cultureArt,
      'write': this.write,
      'lifeStyle1': this.lifeStyle1,
      'lifeStyle2': this.lifeStyle2,
      'food': this.food,
      'beautyHealth': this.beautyHealth,
      'artCraft': this.artCraft,
      'isFollow': this.isFollow,
      'facebookId' : this.facebookId,
      'instagramId' : this.instagramId,
      'snsId' : this.snsId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
