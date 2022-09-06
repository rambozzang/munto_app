import 'dart:convert';


// "id": 3816,
// "name": "사진전 관람회",
// "cover": "https://munto-images.s3.amazonaws.com/dev-item/1605025769874-cover-%25EC%2582%25AC%25EC%25A7%2584%25EC%25A0%2584.JPG",
// "startDate": "2020-11-10T00:00:00.000Z",
// "finishDate": "2020-11-15T00:00:00.000Z",
// "totalOrderCount": 1,
// "validOrderCount": 1,
// "validRoundOrderCount": 0,
// "refundCount": 0,
// "averageAttendor": 0.3333333333333333,
// "averageAttendanceRate": 0.1111111111111111,
// "classValue": 5,
// "leaderValue": 4,
// "partnerValue": 3,
// "calculateMeasureMoney": 1000,
// "calculateStatus": "BEFORE",
// "calculatedDay": null,
// "itemCalculateKind": "ROUND",
// "totalCalculateMoney": 3000,
// "incomeTax": 90,
// "localIncomeTax": 9,
// "finalCalculateMoney": 2901,
// "roundORpeople": 3

class ClassProceedingStateData {

  int totalOrderCount;
  int refundCount;
  int validOrderCount;
  double averageAttendor;
  double averageAttendanceRate;
  ClassProceedingStateData({
    this.totalOrderCount,
    this.refundCount,
    this.validOrderCount,
    this.averageAttendor,
    this.averageAttendanceRate,
  });

  ClassProceedingStateData copyWith({
    int totalOrderCount,
    int refundCount,
    int validOrderCount,
    int averageAttendor,
    int averageAttendanceRate,
  }) {
    return ClassProceedingStateData(
      totalOrderCount: totalOrderCount ?? this.totalOrderCount,
      refundCount: refundCount ?? this.refundCount,
      validOrderCount: validOrderCount ?? this.validOrderCount,
      averageAttendor: averageAttendor ?? this.averageAttendor,
      averageAttendanceRate: averageAttendanceRate ?? this.averageAttendanceRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalOrderCount': totalOrderCount,
      'refundCount': refundCount,
      'validOrderCount': validOrderCount,
      'averageAttendor': averageAttendor,
      'averageAttendanceRate': averageAttendanceRate,
    };
  }

  factory ClassProceedingStateData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ClassProceedingStateData(
      totalOrderCount: map['totalOrderCount'],
      refundCount: map['refundCount'],
      validOrderCount: map['validOrderCount'],
      averageAttendor: map['averageAttendor'] != null ? map['averageAttendor'].toDouble() : 0,
      averageAttendanceRate: map['averageAttendanceRate'] != null ? map['averageAttendanceRate'].toDouble() : 0,
    );

  }

  String toJson() => json.encode(toMap());

  factory ClassProceedingStateData.fromJson(String source) => ClassProceedingStateData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassProceedingStateData(totalOrderCount: $totalOrderCount, refundCount: $refundCount, validOrderCount: $validOrderCount, averageAttendor: $averageAttendor, averageAttendanceRate: $averageAttendanceRate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ClassProceedingStateData &&
        o.totalOrderCount == totalOrderCount &&
        o.refundCount == refundCount &&
        o.validOrderCount == validOrderCount &&
        o.averageAttendor == averageAttendor &&
        o.averageAttendanceRate == averageAttendanceRate;
  }

  @override
  int get hashCode {
    return totalOrderCount.hashCode ^
        refundCount.hashCode ^
        validOrderCount.hashCode ^
        averageAttendor.hashCode ^
        averageAttendanceRate.hashCode;
  }
}
