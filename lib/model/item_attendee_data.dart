import 'dart:convert';

class ItemAttendeeData {
  String userId;
  String isAttendance;
  String reason;
  ItemAttendeeData({
    this.userId,
    this.isAttendance,
    this.reason,
  });

  ItemAttendeeData copyWith({
    String userId,
    String isAttendance,
    String reason,
  }) {
    return ItemAttendeeData(
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

  factory ItemAttendeeData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ItemAttendeeData(
      userId: map['userId'],
      isAttendance: map['isAttendance'],
      reason: map['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemAttendeeData.fromJson(String source) => ItemAttendeeData.fromMap(json.decode(source));

  @override
  String toString() => 'ItemAttendeeData(userId: $userId, isAttendance: $isAttendance, reason: $reason)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ItemAttendeeData &&
      o.userId == userId &&
      o.isAttendance == isAttendance &&
      o.reason == reason;
  }

  @override
  int get hashCode => userId.hashCode ^ isAttendance.hashCode ^ reason.hashCode;
}
