import 'dart:convert';

class SocialingAttendeeData {
  String userId;
  String isAttendance;
  String reason;
  SocialingAttendeeData({
    this.userId,
    this.isAttendance,
    this.reason,
  });

  SocialingAttendeeData copyWith({
    String userId,
    String isAttendance,
    String reason,
  }) {
    return SocialingAttendeeData(
      userId: userId ?? this.userId,
      isAttendance: isAttendance ?? this.isAttendance,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'isAttendance': isAttendance,
      'reason': reason,
    };
  }

  factory SocialingAttendeeData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SocialingAttendeeData(
      userId: map['userId'],
      isAttendance: map['isAttendance'],
      reason: map['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingAttendeeData.fromJson(String source) => SocialingAttendeeData.fromMap(json.decode(source));

  @override
  String toString() => 'SocialingAttendeeData(userId: $userId, isAttendance: $isAttendance, reason: $reason)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SocialingAttendeeData &&
      o.userId == userId &&
      o.isAttendance == isAttendance &&
      o.reason == reason;
  }

  @override
  int get hashCode => userId.hashCode ^ isAttendance.hashCode ^ reason.hashCode;
}
