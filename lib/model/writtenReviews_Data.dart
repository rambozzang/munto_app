import 'dart:convert';

import 'package:munto_app/model/review_Data.dart';

class WrittenReviewsData {
  int id;
  int orderId;
  String name;
  String cover;
  ReviewData review;
  String classStatus;
  String classType;
  String startDate;
  String finishDate;
  WrittenReviewsData({
    this.id,
    this.orderId,
    this.name,
    this.cover,
    this.review,
    this.classStatus,
    this.classType,
    this.startDate,
    this.finishDate,
  });

  WrittenReviewsData copyWith({
    int id,
    int orderId,
    String name,
    String cover,
    ReviewData review,
    String classStatus,
    String classType,
    String startDate,
    String finishDate,
  }) {
    return WrittenReviewsData(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      review: review ?? this.review,
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
      'review': review?.toMap(),
      'classStatus': classStatus,
      'classType': classType,
      'startDate': startDate,
      'finishDate': finishDate,
    };
  }

  factory WrittenReviewsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WrittenReviewsData(
      id: map['id'],
      orderId: map['orderId'],
      name: map['name'],
      cover: map['cover'],
      review: ReviewData.fromMap(map['review']),
      classStatus: map['classStatus'],
      classType: map['classType'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WrittenReviewsData.fromJson(String source) => WrittenReviewsData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WrittenReviewsData(id: $id, orderId: $orderId, name: $name, cover: $cover, review: $review, classStatus: $classStatus, classType: $classType, startDate: $startDate, finishDate: $finishDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WrittenReviewsData &&
        o.id == id &&
        o.orderId == orderId &&
        o.name == name &&
        o.cover == cover &&
        o.review == review &&
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
        review.hashCode ^
        classStatus.hashCode ^
        classType.hashCode ^
        startDate.hashCode ^
        finishDate.hashCode;
  }
}
