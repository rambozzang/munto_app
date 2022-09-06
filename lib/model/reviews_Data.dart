import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/writableReviews_Data.dart';
import 'package:munto_app/model/writtenReviews_Data.dart';

class ReviewsData {
  List<WritableReviewsData> writableReviews;
  List<WrittenReviewsData> writtenReviews;
  ReviewsData({
    this.writableReviews,
    this.writtenReviews,
  });

  ReviewsData copyWith({
    List<WritableReviewsData> writableReviews,
    List<WrittenReviewsData> writtenReviews,
  }) {
    return ReviewsData(
      writableReviews: writableReviews ?? this.writableReviews,
      writtenReviews: writtenReviews ?? this.writtenReviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'writableReviews': writableReviews?.map((x) => x?.toMap())?.toList(),
      'writtenReviews': writtenReviews?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ReviewsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReviewsData(
      writableReviews:
          List<WritableReviewsData>.from(map['writableReviews']?.map((x) => WritableReviewsData.fromMap(x))),
      writtenReviews: List<WrittenReviewsData>.from(map['writtenReviews']?.map((x) => WrittenReviewsData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewsData.fromJson(String source) => ReviewsData.fromMap(json.decode(source));

  @override
  String toString() => 'ReviewsData(writableReviews: $writableReviews, writtenReviews: $writtenReviews)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReviewsData &&
        listEquals(o.writableReviews, writableReviews) &&
        listEquals(o.writtenReviews, writtenReviews);
  }

  @override
  int get hashCode => writableReviews.hashCode ^ writtenReviews.hashCode;
}
