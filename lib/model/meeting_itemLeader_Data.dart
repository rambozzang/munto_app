import 'dart:convert';

import 'package:munto_app/model/meeting_Detail_User_Data.dart';
import 'package:munto_app/model/userProfile_Data.dart';

class MeetingItemLeaderData {
  bool showItemLeaderInfo;
  String careerSummary;
  String word;
  String introduction;
  String profileUrl;
  MeetingDetailUserData User;
  MeetingItemLeaderData({
    this.showItemLeaderInfo,
    this.careerSummary,
    this.word,
    this.introduction,
    this.profileUrl,
    this.User,
  });

  MeetingItemLeaderData copyWith({
    bool showItemLeaderInfo,
    String careerSummary,
    String word,
    String introduction,
    String profileUrl,
    MeetingDetailUserData User,
  }) {
    return MeetingItemLeaderData(
      showItemLeaderInfo: showItemLeaderInfo ?? this.showItemLeaderInfo,
      careerSummary: careerSummary ?? this.careerSummary,
      word: word ?? this.word,
      introduction: introduction ?? this.introduction,
      profileUrl: profileUrl ?? this.profileUrl,
      User: User ?? this.User,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showItemLeaderInfo': showItemLeaderInfo,
      'careerSummary': careerSummary,
      'word': word,
      'introduction': introduction,
      'profileUrl': profileUrl,
      'User': User?.toMap(),
    };
  }

  factory MeetingItemLeaderData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingItemLeaderData(
      showItemLeaderInfo: map['showItemLeaderInfo'],
      careerSummary: map['careerSummary'],
      word: map['word'],
      introduction: map['introduction'],
      profileUrl: map['profileUrl'],
      User: MeetingDetailUserData.fromMap(map['User']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingItemLeaderData.fromJson(String source) => MeetingItemLeaderData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetingItemLeaderData(showItemLeaderInfo: $showItemLeaderInfo, careerSummary: $careerSummary, word: $word, introduction: $introduction, profileUrl: $profileUrl, User: $User)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingItemLeaderData &&
      o.showItemLeaderInfo == showItemLeaderInfo &&
      o.careerSummary == careerSummary &&
      o.word == word &&
      o.introduction == introduction &&
      o.profileUrl == profileUrl &&
      o.User == User;
  }

  @override
  int get hashCode {
    return showItemLeaderInfo.hashCode ^
      careerSummary.hashCode ^
      word.hashCode ^
      introduction.hashCode ^
      profileUrl.hashCode ^
      User.hashCode;
  }
}
