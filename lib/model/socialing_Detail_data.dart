import 'dart:convert';

import 'package:munto_app/model/socialing_User_Data.dart';
import 'package:munto_app/model/socialing_data.dart';

class SocialingDetailData {
  int id;
  String cover;
  String name;
  String subject1;
  String subject2;
  String subject3;
  String location;
  String startDate;
  String finishDate;
  String preparation;
  String introduce;
  int minimumPerson;
  int maximumPerson;
  int price;
  int discountPrice;
   SocialingUserData user;
   bool isPick;
  int totalMember;
  String badge;
  String photo1;
  String photo2;

  DateTime get startDateTime {
    try{
      return DateTime.parse(startDate).toLocal();
    } catch (e){}
    return null;
  }


  SocialingDetailData({
    this.id,
    this.cover,
    this.name,
    this.subject1,
    this.subject2,
    this.subject3,
    this.location,
    this.startDate,
    this.finishDate,
    this.preparation,
    this.introduce,
    this.minimumPerson,
    this.maximumPerson,
    this.price,
    this.discountPrice,
    this.user,
    this.isPick,
    this.totalMember,
    this.badge,
    this.photo1,
    this.photo2
  });
 

  SocialingDetailData copyWith({
    int id,
    String cover,
    String name,
    String subject1,
    String subject2,
    String subject3,
    String location,
    String startDate,
    String finishDate,
    String preparation,
    String introduce,
    int minimumPerson,
    int maximumPerson,
    int price,
    int discountPrice,
    SocialingUserData user,
    bool isPick,
    int totalMember,
    String badge,
    String photo1,
    String photo2,
  }) {
    return SocialingDetailData(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      subject1: subject1 ?? this.subject1,
      subject2: subject2 ?? this.subject2,
      subject3: subject3 ?? this.subject3,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      preparation: preparation ?? this.preparation,
      introduce: introduce ?? this.introduce,
      minimumPerson: minimumPerson ?? this.minimumPerson,
      maximumPerson: maximumPerson ?? this.maximumPerson,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      user: user ?? this.user,
      isPick: isPick ?? this.isPick,
      totalMember: totalMember ?? this.totalMember,
      badge: badge ?? this.badge,
      photo1: photo1 ?? this.photo1,
      photo2: photo2 ?? this.photo2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'name': name,
      'subject1': subject1,
      'subject2': subject2,
      'subject3': subject3,
      'location': location,
      'startDate': startDate,
      'finishDate': finishDate,
      'preparation': preparation,
      'introduce': introduce,
      'minimumPerson': minimumPerson,
      'maximumPerson': maximumPerson,
      'price': price,
      'discountPrice': discountPrice,
      'user': user?.toMap(),
      'isPick': isPick,
      'totalMember': totalMember,
      'badge': badge,
      'photo1' : photo1,
      'photo2' : photo2,
    };
  }

  factory SocialingDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SocialingDetailData(
      id: map['id'],
      cover: map['cover'],
      name: map['name'],
      subject1: map['subject1'],
      subject2: map['subject2'],
      subject3: map['subject3'],
      location: map['location'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      preparation: map['preparation'],
      introduce: map['introduce'],
      minimumPerson: map['minimumPerson'],
      maximumPerson: map['maximumPerson'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      user: SocialingUserData.fromMap(map['user']),
      isPick: map['isPick'],
      totalMember: map['totalMember'],
      badge: map['badge'],
      photo1: map['photo1'],
      photo2: map['photo2'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingDetailData.fromJson(String source) => SocialingDetailData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialingDetailData(id: $id, cover: $cover, name: $name, subject1: $subject1, subject2: $subject2, subject3: $subject3, location: $location, startDate: $startDate, finishDate: $finishDate, preparation: $preparation, introduce: $introduce, minimumPerson: $minimumPerson, maximumPerson: $maximumPerson, price: $price, discountPrice: $discountPrice, user: $user, isPick: $isPick, totalMember: $totalMember, badge: $badge, photo1 : $photo1, photo2 : $photo2, )';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SocialingDetailData &&
      o.id == id &&
      o.cover == cover &&
      o.name == name &&
      o.subject1 == subject1 &&
      o.subject2 == subject2 &&
      o.subject3 == subject3 &&
      o.location == location &&
      o.startDate == startDate &&
      o.finishDate == finishDate &&
      o.preparation == preparation &&
      o.introduce == introduce &&
      o.minimumPerson == minimumPerson &&
      o.maximumPerson == maximumPerson &&
      o.price == price &&
      o.discountPrice == discountPrice &&
      o.user == user &&
      o.isPick == isPick &&
      o.totalMember == totalMember &&
      o.badge == badge &&
      o.photo1 == photo1 &&
      o.photo2 == photo2;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      cover.hashCode ^
      name.hashCode ^
      subject1.hashCode ^
      subject2.hashCode ^
      subject3.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      finishDate.hashCode ^
      preparation.hashCode ^
      introduce.hashCode ^
      minimumPerson.hashCode ^
      maximumPerson.hashCode ^
      price.hashCode ^
      discountPrice.hashCode ^
      user.hashCode ^
      isPick.hashCode ^
      totalMember.hashCode ^
      badge.hashCode ^
      photo1.hashCode ^
      photo2.hashCode;
  }
}
