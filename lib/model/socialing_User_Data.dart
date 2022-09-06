import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/common_data.dart';
import 'package:munto_app/model/image_data.dart';

class SocialingUserData {

  int id;
  String image;
  String name;
  String grade;
  String introduce;

  List<String> career;
  List<String> cultureArt;
  List<String> write;
  List<String> lifeStyle1;
  List<String> lifeStyle2;
  List<String> food;
  List<String> beautyHealth;
  List<String> artCraft;
  bool isFollow;
  SocialingUserData({
    this.id,
    this.image,
    this.name,
    this.grade,
    this.introduce,
    this.career,
    this.cultureArt,
    this.write,
    this.lifeStyle1,
    this.lifeStyle2,
    this.food,
    this.beautyHealth,
    this.artCraft,
    this.isFollow,
  });


  SocialingUserData copyWith({
    int id,
    String image,
    String name,
    String grade,
    String introduce,
    List<String> career,
    List<String> cultureArt,
    List<String> write,
    List<String> lifeStyle1,
    List<String> lifeStyle2,
    List<String> food,
    List<String> beautyHealth,
    List<String> artCraft,
    bool isFollow,
  }) {
    return SocialingUserData(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      introduce: introduce ?? this.introduce,
      career: career ?? this.career,
      cultureArt: cultureArt ?? this.cultureArt,
      write: write ?? this.write,
      lifeStyle1: lifeStyle1 ?? this.lifeStyle1,
      lifeStyle2: lifeStyle2 ?? this.lifeStyle2,
      food: food ?? this.food,
      beautyHealth: beautyHealth ?? this.beautyHealth,
      artCraft: artCraft ?? this.artCraft,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'grade': grade,
      'introduce': introduce,
      'career': career,
      'cultureArt': cultureArt,
      'write': write,
      'lifeStyle1': lifeStyle1,
      'lifeStyle2': lifeStyle2,
      'food': food,
      'beautyHealth': beautyHealth,
      'artCraft': artCraft,
      'isFollow': isFollow,
    };
  }

  factory SocialingUserData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SocialingUserData(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      grade: map['grade'],
      introduce: map['introduce'],
      career: List<String>.from(map['career']),
      cultureArt: List<String>.from(map['cultureArt']),
      write: List<String>.from(map['write']),
      lifeStyle1: List<String>.from(map['lifeStyle1']),
      lifeStyle2: List<String>.from(map['lifeStyle2']),
      food: List<String>.from(map['food']),
      beautyHealth: List<String>.from(map['beautyHealth']),
      artCraft: List<String>.from(map['artCraft']),
      isFollow: map['isFollow'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingUserData.fromJson(String source) => SocialingUserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialingUserData(id: $id, image: $image, name: $name, grade: $grade, introduce: $introduce, career: $career, cultureArt: $cultureArt, write: $write, lifeStyle1: $lifeStyle1, lifeStyle2: $lifeStyle2, food: $food, beautyHealth: $beautyHealth, artCraft: $artCraft, isFollow: $isFollow)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SocialingUserData &&
      o.id == id &&
      o.image == image &&
      o.name == name &&
      o.grade == grade &&
      o.introduce == introduce &&
      listEquals(o.career, career) &&
      listEquals(o.cultureArt, cultureArt) &&
      listEquals(o.write, write) &&
      listEquals(o.lifeStyle1, lifeStyle1) &&
      listEquals(o.lifeStyle2, lifeStyle2) &&
      listEquals(o.food, food) &&
      listEquals(o.beautyHealth, beautyHealth) &&
      listEquals(o.artCraft, artCraft) &&
      o.isFollow == isFollow;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      image.hashCode ^
      name.hashCode ^
      grade.hashCode ^
      introduce.hashCode ^
      career.hashCode ^
      cultureArt.hashCode ^
      write.hashCode ^
      lifeStyle1.hashCode ^
      lifeStyle2.hashCode ^
      food.hashCode ^
      beautyHealth.hashCode ^
      artCraft.hashCode ^
      isFollow.hashCode;
  }
}
