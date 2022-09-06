import 'dart:convert';

import 'package:munto_app/model/enum/grade_Enum.dart';
class ClassMembersData {
  int id;
  String name;
  String phoneNumber;
  String  grade;
  bool isPreSurvey;
  ClassMembersData({
    this.id,
    this.name,
    this.phoneNumber,
    this.grade,
    this.isPreSurvey,
  });

  ClassMembersData copyWith({
    int id,
    String name,
    String phoneNumber,
    String grade,
    bool isPreSurvey,
  }) {
    return ClassMembersData(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      grade: grade ?? this.grade,
      isPreSurvey: isPreSurvey ?? this.isPreSurvey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'grade': grade,
      'isPreSurvey': isPreSurvey,
    };
  }

  factory ClassMembersData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ClassMembersData(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      grade: map['grade'],
      isPreSurvey: map['isPreSurvey'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassMembersData.fromJson(String source) => ClassMembersData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassMembersData(id: $id, name: $name, phoneNumber: $phoneNumber, grade: $grade, isPreSurvey: $isPreSurvey)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ClassMembersData &&
      o.id == id &&
      o.name == name &&
      o.phoneNumber == phoneNumber &&
      o.grade == grade &&
      o.isPreSurvey == isPreSurvey;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      grade.hashCode ^
      isPreSurvey.hashCode;
  }
}
