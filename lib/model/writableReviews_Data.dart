import 'dart:convert';

import 'package:munto_app/model/writtenReviews_Data.dart';

class WritableReviewsData {
  int id;
  int orderId;
  String name;
  String cover;
  String classStatus;
  String classType;
  String startDate;
  String finishDate;
  WritableReviewsData({
    this.id,
    this.orderId,
    this.name,
    this.cover,
    this.classStatus,
    this.classType,
    this.startDate,
    this.finishDate,
  });

  WritableReviewsData copyWith({
    int id,
    int orderId,
    String name,
    String cover,
    String classStatus,
    String classType,
    String startDate,
    String finishDate,
  }) {
    return WritableReviewsData(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      classStatus: classStatus ?? this.classStatus,
      classType: classType ?? this.classType,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'name': name,
      'cover': cover,
      'classStatus': classStatus,
      'classType': classType,
      'startDate': startDate,
      'finishDate': finishDate,
    };
  }

  factory WritableReviewsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WritableReviewsData(
      id: map['id'],
      orderId: map['orderId'],
      name: map['name'],
      cover: map['cover'],
      classStatus: map['classStatus'],
      classType: map['classType'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
    );
  }

  factory WritableReviewsData.fromWritten(WrittenReviewsData data) {
    if (data == null) return null;

    return WritableReviewsData(
      id: data.id,
      orderId: data.orderId,
      name: data.name,
      cover: data.cover,
      classStatus: data.classStatus,
      classType: data.classType,
      startDate: data.startDate,
      finishDate:data.finishDate,
    );
  }

  String toJson() => json.encode(toMap());

  factory WritableReviewsData.fromJson(String source) => WritableReviewsData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WritableReviewsData(id: $id, orderId: $orderId, name: $name, cover: $cover, classStatus: $classStatus, classType: $classType, startDate: $startDate, finishDate: $finishDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WritableReviewsData &&
        o.id == id &&
        o.orderId == orderId &&
        o.name == name &&
        o.cover == cover &&
        o.classStatus == classStatus &&
        o.classType == classType &&
        o.startDate == startDate &&
        o.finishDate == finishDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderId.hashCode ^
        name.hashCode ^
        cover.hashCode ^
        classStatus.hashCode ^
        classType.hashCode ^
        startDate.hashCode ^
        finishDate.hashCode;
  }
}
