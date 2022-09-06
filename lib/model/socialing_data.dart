import 'dart:convert';

import '../util.dart';

class SocialingData {
  int id;
  String cover;
  String subject1;
  String subject2;
  String subject3;
  String name;
  String location;
  String startDate;
  DateTime get startDateTime {
    try{
      return DateTime.parse(startDate).toLocal();
    } catch (e){}
    return null;
  }
  String finishDate;
  String introduce;
  SocialingUser user;
  int totalMember;
  bool isPick;
  int price;
  String badge;

  List<String>  get subjectList{
    List<String> list = [];
    if (subject1 != "" && subject1 != null)
      list.add(subject1);
    if (subject2 != "" && subject2 != null)
      list.add(subject2);
    if (subject3 != "" && subject3 != null)
      list.add(subject3);
    return list;
  }
  SocialingData({
    this.id,
    this.cover,
    this.subject1,
    this.subject2,
    this.subject3,
    this.name,
    this.location,
    this.startDate,
    this.finishDate,
    this.introduce,
    this.user,
    this.totalMember,
    this.isPick,
    this.price,
    this.badge,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'subject1': subject1,
      'subject2': subject2,
      'subject3': subject3,
      'name': name,
      'location': location,
      'startDate': startDate,
      'finishDate': finishDate,
      'introduce': introduce,
      'user': user?.toMap(),
      'totalMember': totalMember,
      'isPick': isPick,
      'price': price,
      'badge': badge,
    };
  }

  factory SocialingData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SocialingData(
      id: map['id'],
      cover: map['cover'],
      subject1: map['subject1'],
      subject2: map['subject2'],
      subject3: map['subject3'],
      name: map['name'],
      location: map['location'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      introduce: map['introduce'],
      user: SocialingUser.fromMap(map['user']),
      totalMember: map['totalMember'],
      isPick: map['isPick'],
      price: map['price'],
      badge: map['badge'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingData.fromJson(String source) =>
      SocialingData.fromMap(json.decode(source));
}

class SocialingUser {
  int id;
  String image;
  String name;
  String grade;
  SocialingUser({
    this.id,
    this.image,
    this.name,
    this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'grade': grade,
    };
  }

  String get gradeString  => Util.getGradeName(grade);

  factory SocialingUser.fromMap(map) {
    if (map == null) return null;

    return SocialingUser(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingUser.fromJson(String source) =>
      SocialingUser.fromMap(json.decode(source));
}
