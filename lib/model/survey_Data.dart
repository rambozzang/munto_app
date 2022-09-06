import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/round_data.dart';

class SurveyData {
  String classType;
  int classId;
  int surveyId;
  int presurveyId;
  String startDate;
  String finishDate;
  String cover;
  String name;
  RoundData round;
  String Q1;
  String Q2;
  String Q3;
  String Q4;
  String Q5;
  String Q6;
  String Q7;
  String Q8;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SurveyData({
    @required this.classType,
    @required this.classId,
    @required this.surveyId,
    @required this.presurveyId,
    @required this.startDate,
    @required this.finishDate,
    @required this.cover,
    @required this.name,
    @required this.round,
    @required this.Q1,
    @required this.Q2,
    @required this.Q3,
    @required this.Q4,
    @required this.Q5,
    @required this.Q6,
    @required this.Q7,
    @required this.Q8,
  });

  SurveyData copyWith({
    String classType,
    int classId,
    int surveyId,
    int presurveyId,
    String startDate,
    String finishDate,
    String cover,
    String name,
    RoundData round,
    String Q1,
    String Q2,
    String Q3,
    String Q4,
    String Q5,
    String Q6,
    String Q7,
    String Q8,
  }) {
    return new SurveyData(
      classType: classType ?? this.classType,
      classId: classId ?? this.classId,
      surveyId: surveyId ?? this.surveyId,
      presurveyId: presurveyId ?? this.presurveyId,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      round: round ?? this.round,
      Q1: Q1 ?? this.Q1,
      Q2: Q2 ?? this.Q2,
      Q3: Q3 ?? this.Q3,
      Q4: Q4 ?? this.Q4,
      Q5: Q5 ?? this.Q5,
      Q6: Q6 ?? this.Q6,
      Q7: Q7 ?? this.Q7,
      Q8: Q8 ?? this.Q8,
    );
  }

  @override
  String toString() {
    return 'SurveyData{classType: $classType, classId: $classId, surveyId: $surveyId, presurveyId: $presurveyId, startDate: $startDate, finishDate: $finishDate, cover: $cover, name: $name, round: $round, Q1: $Q1, Q2: $Q2, Q3: $Q3, Q4: $Q4, Q5: $Q5, Q6: $Q6, Q7: $Q7, Q8: $Q8}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurveyData &&
          runtimeType == other.runtimeType &&
          classType == other.classType &&
          classId == other.classId &&
          surveyId == other.surveyId &&
          presurveyId == other.presurveyId &&
          startDate == other.startDate &&
          finishDate == other.finishDate &&
          cover == other.cover &&
          name == other.name &&
          round == other.round &&
          Q1 == other.Q1 &&
          Q2 == other.Q2 &&
          Q3 == other.Q3 &&
          Q4 == other.Q4 &&
          Q5 == other.Q5 &&
          Q6 == other.Q6 &&
          Q7 == other.Q7 &&
          Q8 == other.Q8);

  @override
  int get hashCode =>
      classType.hashCode ^
      classId.hashCode ^
      surveyId.hashCode ^
      presurveyId.hashCode ^
      startDate.hashCode ^
      finishDate.hashCode ^
      cover.hashCode ^
      name.hashCode ^
      round.hashCode ^
      Q1.hashCode ^
      Q2.hashCode ^
      Q3.hashCode ^
      Q4.hashCode ^
      Q5.hashCode ^
      Q6.hashCode ^
      Q7.hashCode ^
      Q8.hashCode;

  factory SurveyData.fromMap(Map<String, dynamic> map) {
    return new SurveyData(
      classType: map['classType'] as String,
      classId: map['classId'] as int,
      surveyId: map['surveyId'] as int,
      presurveyId: map['presurveyId'] as int,
      startDate: map['startDate'] as String,
      finishDate: map['finishDate'] as String,
      cover: map['cover'] as String,
      name: map['name'] as String,
      round: map['round'] as RoundData,
      Q1: map['Q1'] as String,
      Q2: map['Q2'] as String,
      Q3: map['Q3'] as String,
      Q4: map['Q4'] as String,
      Q5: map['Q5'] as String,
      Q6: map['Q6'] as String,
      Q7: map['Q7'] as String,
      Q8: map['Q8'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'classType': this.classType,
      'classId': this.classId,
      'surveyId': this.surveyId,
      'presurveyId': this.presurveyId,
      'startDate': this.startDate,
      'finishDate': this.finishDate,
      'cover': this.cover,
      'name': this.name,
      'round': this.round,
      'Q1': this.Q1,
      'Q2': this.Q2,
      'Q3': this.Q3,
      'Q4': this.Q4,
      'Q5': this.Q5,
      'Q6': this.Q6,
      'Q7': this.Q7,
      'Q8': this.Q8,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
