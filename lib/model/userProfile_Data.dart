import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/following_Data.dart';

class UserProfileData {
  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String loginedAt;
  int userAccountId;
  String name;
  String phoneNumber;
  String sex;
  String email;
  String image;
  String cover;
  String birthDay;
  String grade;
  int age;
  bool isMarketing;
  String additionalInfo;
  List<String> career;
  List<String> cultureArt;
  List<String> write;
  List<String> lifeStyle1;
  List<String> lifeStyle2;
  List<String> food;
  List<String> beautyHealth;
  List<String> artCraft;
  String facebookId;
  String instagramId;
  String snsId;
  String introduce;
  bool showClass;
  List<int> UserReservesMoney;

  List<String> get interestList{
    return career + cultureArt + write + lifeStyle1
        + lifeStyle2 + food + beautyHealth + artCraft ;
  }

  List<FollowingData> following;
  UserProfileData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.loginedAt,
    this.userAccountId,
    this.name,
    this.phoneNumber,
    this.sex,
    this.email,
    this.image,
    this.cover,
    this.birthDay,
    this.grade,
    this.age,
    this.isMarketing,
    this.additionalInfo,
    this.career,
    this.cultureArt,
    this.write,
    this.lifeStyle1,
    this.lifeStyle2,
    this.food,
    this.beautyHealth,
    this.artCraft,
    this.facebookId,
    this.instagramId,
    this.snsId,
    this.introduce,
    this.following,
    this.showClass,
    this.UserReservesMoney,
  });

  int get reserveMoney {
    if(UserReservesMoney != null && UserReservesMoney.length >0){
      return UserReservesMoney.reduce((a,b) => a+b );
    }
    return 0;
  }

  UserProfileData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String loginedAt,
    int userAccountId,
    String name,
    String phoneNumber,
    String sex,
    String email,
    String image,
    String cover,
    String birthDay,
    String grade,
    String age,
    bool isMarketing,
    String additionalInfo,
    List<String> career,
    List<String> cultureArt,
    List<String> write,
    List<String> lifeStyle1,
    List<String> lifeStyle2,
    List<String> food,
    List<String> beautyHealth,
    List<String> artCraft,
    String facebookId,
    String instagramId,
    String snsId,
    String introduce,
    List<FollowingData> following,
    bool showClass,
    List<int> UserReservesMoney,

  }) {
    return UserProfileData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      loginedAt: loginedAt ?? this.loginedAt,
      userAccountId: userAccountId ?? this.userAccountId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      image: image ?? this.image,
      cover: image ?? this.cover,
      birthDay: birthDay ?? this.birthDay,
      grade: grade ?? this.grade,
      age: age ?? this.age,
      isMarketing: isMarketing ?? this.isMarketing,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      career: career ?? this.career,
      cultureArt: cultureArt ?? this.cultureArt,
      write: write ?? this.write,
      lifeStyle1: lifeStyle1 ?? this.lifeStyle1,
      lifeStyle2: lifeStyle2 ?? this.lifeStyle2,
      food: food ?? this.food,
      beautyHealth: beautyHealth ?? this.beautyHealth,
      artCraft: artCraft ?? this.artCraft,
      facebookId: facebookId ?? this.facebookId,
      instagramId: instagramId ?? this.instagramId,
      snsId: snsId ?? this.snsId,
      introduce: introduce ?? this.introduce,
      following: following ?? this.following,
      showClass: showClass ?? this.showClass,
      UserReservesMoney: UserReservesMoney ?? this.UserReservesMoney,
    );
  }

  Map<String, dynamic> toFileMap() {
    Map<String, dynamic> map = {};
    if(image != null)
      map['profileImage']= image;
    if(cover != null)
      map['cover'] = cover;
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      "introduce": introduce  ?? "",
      "facebookId": facebookId ?? "",
      "instagramId": instagramId ?? "",
      "snsId": snsId ?? "",
      "showClass": showClass ?? false,
      "career": career?? [],
      "cultureArt": cultureArt ?? [],
      "write": write?? [],
      "lifeStyle1": lifeStyle1 ?? [],
      "lifeStyle2": lifeStyle2 ?? [],
      "food": food?? [],
      "beautyHealth": beautyHealth?? [],
      "artCraft": artCraft?? [],
      "UserReservesMoney" : UserReservesMoney ?? []
    };

  }

  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    var list = <int>[];
    if(map['UserReservesMoney'] != null)
      map['UserReservesMoney'].forEach((e)=>list.add(e['money']));


    return UserProfileData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      loginedAt: map['loginedAt'],
      userAccountId: map['userAccountId'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      sex: map['sex'],
      email: map['email'],
      image: map['image'],
      cover: map['cover'],
      birthDay: map['birthDay'],
      grade: map['grade'],
      age: map['age'],
      isMarketing: map['isMarketing'],
      additionalInfo: map['additionalInfo'],
      career: List<String>.from(map['career']),
      cultureArt: List<String>.from(map['cultureArt']),
      write: List<String>.from(map['write']),
      lifeStyle1: List<String>.from(map['lifeStyle1']),
      lifeStyle2: List<String>.from(map['lifeStyle2']),
      food: List<String>.from(map['food']),
      beautyHealth: List<String>.from(map['beautyHealth']),
      artCraft: List<String>.from(map['artCraft']),
      facebookId: map['facebookId'],
      instagramId: map['instagramId'],
      snsId: map['snsId'],
      introduce: map['introduce'],
      showClass: map['showClass'],
      following:map['following'] == null ? null: List<FollowingData>.from(
          map['following']?.map((x) => FollowingData.fromMap(x))),
      // UserReservesMoney :map['UserReservesMoney'] == null ? []: (map['UserReservesMoney'] as List).map((e) => e['money']).toList(),
        UserReservesMoney :list,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileData.fromJson(String source) =>
      UserProfileData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, loginedAt: $loginedAt, userAccountId: $userAccountId, name: $name, phoneNumber: $phoneNumber, sex: $sex, email: $email, image: $image, birthDay: $birthDay, grade: $grade, age: $age, isMarketing: $isMarketing, additionalInfo: $additionalInfo, career: $career, cultureArt: $cultureArt, write: $write, lifeStyle1: $lifeStyle1, lifeStyle2: $lifeStyle2, food: $food, beautyHealth: $beautyHealth, artCraft: $artCraft, facebookId: $facebookId, instagramId: $instagramId, snsId: $snsId, introduce: $introduce, following: $following, cover:$cover)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserProfileData &&
        o.id == id &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.deletedAt == deletedAt &&
        o.loginedAt == loginedAt &&
        o.userAccountId == userAccountId &&
        o.name == name &&
        o.phoneNumber == phoneNumber &&
        o.sex == sex &&
        o.email == email &&
        o.image == image &&
        o.cover == cover &&
        o.birthDay == birthDay &&
        o.grade == grade &&
        o.age == age &&
        o.isMarketing == isMarketing &&
        o.additionalInfo == additionalInfo &&
        listEquals(o.career, career) &&
        listEquals(o.cultureArt, cultureArt) &&
        listEquals(o.write, write) &&
        listEquals(o.lifeStyle1, lifeStyle1) &&
        listEquals(o.lifeStyle2, lifeStyle2) &&
        listEquals(o.food, food) &&
        listEquals(o.beautyHealth, beautyHealth) &&
        listEquals(o.artCraft, artCraft) &&
        o.facebookId == facebookId &&
        o.instagramId == instagramId &&
        o.snsId == snsId &&
        o.introduce == introduce &&
        listEquals(o.following, following);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        loginedAt.hashCode ^
        userAccountId.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        sex.hashCode ^
        email.hashCode ^
        image.hashCode ^
        cover.hashCode ^
        birthDay.hashCode ^
        grade.hashCode ^
        age.hashCode ^
        isMarketing.hashCode ^
        additionalInfo.hashCode ^
        career.hashCode ^
        cultureArt.hashCode ^
        write.hashCode ^
        lifeStyle1.hashCode ^
        lifeStyle2.hashCode ^
        food.hashCode ^
        beautyHealth.hashCode ^
        artCraft.hashCode ^
        facebookId.hashCode ^
        instagramId.hashCode ^
        snsId.hashCode ^
        introduce.hashCode ^
        following.hashCode;
  }
}
