import 'dart:convert';

class ClassMemberData {
  int userId;
  String name;
  String phoneNumber;
  String grade;
  String reason;
  bool isAttendance;
  bool isSurvey;
  ClassMemberData({
    this.userId,
    this.name,
    this.phoneNumber,
    this.grade,
    this.reason,
    this.isAttendance,
    this.isSurvey,
  });

  ClassMemberData copyWith({
    int userId,
    String name,
    String phoneNumber,
    String grade,
    String reason,
    bool isAttendance,
    bool isSurvey,
  }) {
    return ClassMemberData(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      grade: grade ?? this.grade,
      reason: reason ?? this.reason,
      isAttendance: isAttendance ?? this.isAttendance,
      isSurvey: isSurvey ?? this.isSurvey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'grade': grade,
      'reason': reason,
      'isAttendance': isAttendance,
      'isSurvey': isSurvey,
    };
  }

  factory ClassMemberData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ClassMemberData(
      userId: map['userId'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      grade: map['grade'],
      reason: map['reason'],
      isAttendance: map['isAttendance'],
      isSurvey: map['isSurvey'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassMemberData.fromJson(String source) => ClassMemberData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassMemberData(userId: $userId, name: $name, phoneNumber: $phoneNumber, grade: $grade, reason: $reason, isAttendance: $isAttendance, isSurvey: $isSurvey)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ClassMemberData &&
      o.userId == userId &&
      o.name == name &&
      o.phoneNumber == phoneNumber &&
      o.grade == grade &&
      o.reason == reason &&
      o.isAttendance == isAttendance &&
      o.isSurvey == isSurvey;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      grade.hashCode ^
      reason.hashCode ^
      isAttendance.hashCode ^
      isSurvey.hashCode;
  }
}
