import 'dart:convert';

import 'package:intl/intl.dart';

import '../util.dart';

class MeetingItemRoundData {
  int id;
  int round;
  String place;
  String get placeString{
    if(place != null && place.toUpperCase() == 'HAPJEONG')
      return '합정';
    return place ?? '';
  }
  String startDate;
  String finishDate;
  String howPlayingTitle;
  String howPlayingDescription;
  String howPlayingThumbnail;
  bool showHowPlaying;
  String curriculumTitle;
  String curriculumDescription;
  String curriculumThumbnail;
  bool showCurriculum;
  int mpassPrice;

  MeetingItemRoundData({
    this.id,
    this.round,
    this.place,
    this.startDate,
    this.finishDate,
    this.howPlayingTitle,
    this.howPlayingDescription,
    this.howPlayingThumbnail,
    this.showHowPlaying,
    this.curriculumTitle,
    this.curriculumDescription,
    this.curriculumThumbnail,
    this.showCurriculum,
    this.mpassPrice,
  });

  MeetingItemRoundData copyWith({
    int id,
    int round,
    String place,
    String startDate,
    String finishDate,
    String howPlayingTitle,
    String howPlayingDescription,
    String howPlayingThumbnail,
    bool showHowPlaying,
    String curriculumTitle,
    String curriculumDescription,
    String curriculumThumbnail,
    bool showCurriculum,
    int mpassPrice,
  }) {
    return MeetingItemRoundData(
      id: id ?? this.id,
      round: round ?? this.round,
      place: place ?? this.place,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      howPlayingTitle: howPlayingTitle ?? this.howPlayingTitle,
      howPlayingDescription: howPlayingDescription ?? this.howPlayingDescription,
      howPlayingThumbnail: howPlayingThumbnail ?? this.howPlayingThumbnail,
      showHowPlaying: showHowPlaying ?? this.showHowPlaying,
      curriculumTitle: curriculumTitle ?? this.curriculumTitle,
      curriculumDescription: curriculumDescription ?? this.curriculumDescription,
      curriculumThumbnail: curriculumThumbnail ?? this.curriculumThumbnail,
      showCurriculum: showCurriculum ?? this.showCurriculum,
      mpassPrice: mpassPrice ?? this.mpassPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'round': round,
      'place': place,
      'startDate': startDate,
      'finishDate': finishDate,
      'howPlayingTitle': howPlayingTitle,
      'howPlayingDescription': howPlayingDescription,
      'howPlayingThumbnail': howPlayingThumbnail,
      'showHowPlaying': showHowPlaying,
      'curriculumTitle': curriculumTitle,
      'curriculumDescription': curriculumDescription,
      'curriculumThumbnail': curriculumThumbnail,
      'showCurriculum': showCurriculum,
      'mpassPrice': mpassPrice,
    };
  }

  factory MeetingItemRoundData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingItemRoundData(
      id: map['id'],
      round: map['round'],
      place: map['place'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      howPlayingTitle: map['howPlayingTitle'],
      howPlayingDescription: map['howPlayingDescription'],
      howPlayingThumbnail: map['howPlayingThumbnail'],
      showHowPlaying: map['showHowPlaying'],
      curriculumTitle: map['curriculumTitle'],
      curriculumDescription: map['curriculumDescription'],
      curriculumThumbnail: map['curriculumThumbnail'],
      showCurriculum: map['showCurriculum'],
      mpassPrice: map['mpassPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingItemRoundData.fromJson(String source) => MeetingItemRoundData.fromMap(json.decode(source));

  @override
  String toString() {
    try {
      if (startDate != null && startDate.isNotEmpty) {
        final date = DateTime.parse(startDate);
        final dateString = DateFormat('yyyy.MM.dd').format(date);
        return '[${round ?? 0}]회차 $dateString(${Util.getWeekDayInt(
            date.weekday)}) $placeString';
      }
    }catch(e){}
    return '';
    // return 'MeetingItemRoundData(id: $id, round: $round, place: $place, startDate: $startDate, finishDate: $finishDate, howPlayingTitle: $howPlayingTitle, howPlayingDescription: $howPlayingDescription, howPlayingThumbnail: $howPlayingThumbnail, showHowPlaying: $showHowPlaying, curriculumTitle: $curriculumTitle, curriculumDescription: $curriculumDescription, curriculumThumbnail: $curriculumThumbnail, showCurriculum: $showCurriculum, mpassPrice: $mpassPrice)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingItemRoundData &&
      o.id == id &&
      o.round == round &&
      o.place == place &&
      o.startDate == startDate &&
      o.finishDate == finishDate &&
      o.howPlayingTitle == howPlayingTitle &&
      o.howPlayingDescription == howPlayingDescription &&
      o.howPlayingThumbnail == howPlayingThumbnail &&
      o.showHowPlaying == showHowPlaying &&
      o.curriculumTitle == curriculumTitle &&
      o.curriculumDescription == curriculumDescription &&
      o.curriculumThumbnail == curriculumThumbnail &&
      o.showCurriculum == showCurriculum &&
      o.mpassPrice == mpassPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      round.hashCode ^
      place.hashCode ^
      startDate.hashCode ^
      finishDate.hashCode ^
      howPlayingTitle.hashCode ^
      howPlayingDescription.hashCode ^
      howPlayingThumbnail.hashCode ^
      showHowPlaying.hashCode ^
      curriculumTitle.hashCode ^
      curriculumDescription.hashCode ^
      curriculumThumbnail.hashCode ^
      showCurriculum.hashCode ^
      mpassPrice.hashCode;
  }
}
