import 'dart:convert';

import 'package:munto_app/model/survey_Data.dart';

//  "id": 1509,
//     "name": "테스트 모임6",
//     "cover": "http://naver.com",
//     "status": "RECRUITING",
//     "startDate": "2020-10-10T01:00:00.000Z",
//     "finishDate": "2020-10-10T01:00:00.000Z",
//     "classType": "ITEM"

class ClassData {
  int id;
  String name;
  String cover;
  String status;
  String startDate;
  String finishDate;
  String classType;
  ClassData({
    this.id,
    this.name,
    this.cover,
    this.status,
    this.startDate,
    this.finishDate,
    this.classType,
  });

  ClassData copyWith({
    int id,
    String name,
    String cover,
    String status,
    String startDate,
    String finishDate,
    String classType,
  }) {
    return ClassData(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      classType: classType ?? this.classType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover,
      'status': status,
      'startDate': startDate,
      'finishDate': finishDate,
      'classType': classType,
    };
  }

  factory ClassData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ClassData(
      id: map['id'],
      name: map['name'],
      cover: map['cover'],
      status: map['status'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      classType: map['classType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassData.fromJson(String source) => ClassData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassData(id: $id, name: $name, cover: $cover, status: $status, startDate: $startDate, finishDate: $finishDate, classType: $classType)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ClassData &&
        o.id == id &&
        o.name == name &&
        o.cover == cover &&
        o.status == status &&
        o.startDate == startDate &&
        o.finishDate == finishDate &&
        o.classType == classType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        cover.hashCode ^
        status.hashCode ^
        startDate.hashCode ^
        finishDate.hashCode ^
        classType.hashCode;
  }

  static ClassData fromSurveyData(SurveyData item) {
    return ClassData(id:item.classId, name:item.name, cover: item.cover, startDate: item.startDate, finishDate: item.finishDate, classType: item.classType);
  }
}
