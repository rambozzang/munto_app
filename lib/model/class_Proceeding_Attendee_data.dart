import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/class_Member_data.dart';

class ClassProceedingAttendeeData {
  int totalMember;
  int attendanceMembers;
  int attendanceRate;
  List<ClassMemberData> list;
  ClassProceedingAttendeeData({
    this.totalMember,
    this.attendanceMembers,
    this.attendanceRate,
    this.list,
  });

  ClassProceedingAttendeeData copyWith({
    int totalMember,
    int attendanceMembers,
    int attendanceRate,
    List<ClassMemberData> list,
  }) {
    return ClassProceedingAttendeeData(
      totalMember: totalMember ?? this.totalMember,
      attendanceMembers: attendanceMembers ?? this.attendanceMembers,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMember': totalMember,
      'attendanceMembers': attendanceMembers,
      'attendanceRate': attendanceRate,
      'list': list?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ClassProceedingAttendeeData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ClassProceedingAttendeeData(
      totalMember: map['totalMember'],
      attendanceMembers: map['attendanceMembers'],
      attendanceRate: map['attendanceRate'],
      list: List<ClassMemberData>.from(map['list']?.map((x) => ClassMemberData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassProceedingAttendeeData.fromJson(String source) =>
      ClassProceedingAttendeeData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassProceedingAttendeeData(totalMember: $totalMember, attendanceMembers: $attendanceMembers, attendanceRate: $attendanceRate, list: $list)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ClassProceedingAttendeeData &&
        o.totalMember == totalMember &&
        o.attendanceMembers == attendanceMembers &&
        o.attendanceRate == attendanceRate &&
        listEquals(o.list, list);
  }

  @override
  int get hashCode {
    return totalMember.hashCode ^ attendanceMembers.hashCode ^ attendanceRate.hashCode ^ list.hashCode;
  }
}
