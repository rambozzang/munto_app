import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/socialing_attendee_data.dart';

class SocialingSaveData {
  String socialingId;
  List<SocialingAttendeeData> attendeeList;
  SocialingSaveData({
    this.socialingId,
    this.attendeeList,
  });

  SocialingSaveData copyWith({
    String socialingId,
    List<SocialingAttendeeData> attendeeList,
  }) {
    return SocialingSaveData(
      socialingId: socialingId ?? this.socialingId,
      attendeeList: attendeeList ?? this.attendeeList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'socialingId': socialingId,
      'attendeeList': attendeeList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory SocialingSaveData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SocialingSaveData(
      socialingId: map['socialingId'],
      attendeeList: List<SocialingAttendeeData>.from(map['attendeeList']?.map((x) => SocialingAttendeeData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingSaveData.fromJson(String source) => SocialingSaveData.fromMap(json.decode(source));

  @override
  String toString() => 'SocialingSaveData(socialingId: $socialingId, attendeeList: $attendeeList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SocialingSaveData &&
      o.socialingId == socialingId &&
      listEquals(o.attendeeList, attendeeList);
  }

  @override
  int get hashCode => socialingId.hashCode ^ attendeeList.hashCode;
}
