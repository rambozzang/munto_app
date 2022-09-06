import 'dart:convert';

import 'package:flutter/cupertino.dart';

class FollowingData {
  int followedUserId;
  FollowingData({
    this.followedUserId,
  });

  FollowingData copyWith({
    int followedUserId,
  }) {
    return FollowingData(
      followedUserId: followedUserId ?? this.followedUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'followedUserId': followedUserId,
    };
  }

  factory FollowingData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FollowingData(
      followedUserId: map['followedUserId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowingData.fromJson(String source) => FollowingData.fromMap(json.decode(source));

  @override
  String toString() => 'FollowingData(followedUserId: $followedUserId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FollowingData && o.followedUserId == followedUserId;
  }

  @override
  int get hashCode => followedUserId.hashCode;
}
