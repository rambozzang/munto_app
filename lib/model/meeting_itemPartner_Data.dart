
import 'dart:convert';

import 'package:munto_app/model/userProfile_Data.dart';

class MeetingItemPartnerData {
  bool showItemLeaderInfo;
  String careerSummary;
  String word;
  String introduction;
  String profileUrl;
  UserProfileData User;
  MeetingItemPartnerData({
    this.showItemLeaderInfo,
    this.careerSummary,
    this.word,
    this.introduction,
    this.profileUrl,
    this.User,
  });


  MeetingItemPartnerData copyWith({
    bool showItemLeaderInfo,
    String careerSummary,
    String word,
    String introduction,
    String profileUrl,
    UserProfileData User,
  }) {
    return MeetingItemPartnerData(
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

  factory MeetingItemPartnerData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingItemPartnerData(
      showItemLeaderInfo: map['showItemLeaderInfo'],
      careerSummary: map['careerSummary'],
      word: map['word'],
      introduction: map['introduction'],
      profileUrl: map['profileUrl'],
      User: UserProfileData.fromMap(map['User']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingItemPartnerData.fromJson(String source) => MeetingItemPartnerData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetingItemPartnerData(showItemLeaderInfo: $showItemLeaderInfo, careerSummary: $careerSummary, word: $word, introduction: $introduction, profileUrl: $profileUrl, User: $User)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingItemPartnerData &&
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
