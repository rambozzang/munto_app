
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/order/order_user_Reserves_Money_data.dart';

class OrderUserData {
  int id;
  String sex;
  String email;
  String name;
  String phoneNumber;
  List<String> UserCoupon;
  List<OrerUserReservesMoneyData> UserReservesMoney;
  String grade;
  OrderUserData({
    this.id,
    this.sex,
    this.email,
    this.name,
    this.phoneNumber,
    this.UserCoupon,
    this.UserReservesMoney,
    this.grade,
  });


  OrderUserData copyWith({
    int id,
    String sex,
    String email,
    String name,
    String phoneNumber,
    List<String> UserCoupon,
    List<OrerUserReservesMoneyData> UserReservesMoney,
    String grade,
  }) {
    return OrderUserData(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      UserCoupon: UserCoupon ?? this.UserCoupon,
      UserReservesMoney: UserReservesMoney ?? this.UserReservesMoney,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sex': sex,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'UserCoupon': UserCoupon,
      'UserReservesMoney': UserReservesMoney?.map((x) => x?.toMap())?.toList(),
      'grade': grade,
    };
  }

  factory OrderUserData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrderUserData(
      id: map['id'],
      sex: map['sex'],
      email: map['email'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      UserCoupon: List<String>.from(map['UserCoupon']),
      UserReservesMoney: List<OrerUserReservesMoneyData>.from(map['UserReservesMoney']?.map((x) => OrerUserReservesMoneyData.fromMap(x))),
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderUserData.fromJson(String source) => OrderUserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderUserData(id: $id, sex: $sex, email: $email, name: $name, phoneNumber: $phoneNumber, UserCoupon: $UserCoupon, UserReservesMoney: $UserReservesMoney, grade: $grade)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrderUserData &&
      o.id == id &&
      o.sex == sex &&
      o.email == email &&
      o.name == name &&
      o.phoneNumber == phoneNumber &&
      listEquals(o.UserCoupon, UserCoupon) &&
      listEquals(o.UserReservesMoney, UserReservesMoney) &&
      o.grade == grade;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      sex.hashCode ^
      email.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      UserCoupon.hashCode ^
      UserReservesMoney.hashCode ^
      grade.hashCode;
  }
}
