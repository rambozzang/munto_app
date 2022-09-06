import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoundData{
  int id;
  String place;
  DateTime startDate;
  DateTime finishDate;


  String get round{
    if(place != null && startDate == null)
      return place;
    if(place == null && startDate != null)
      return DateFormat('MM.dd(E)a h시').format(startDate);
    return '$place ${DateFormat('MM.dd(E)a h시').format(startDate)}';
  }

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  RoundData({
    @required this.id,
    @required this.place,
    @required this.startDate,
    @required this.finishDate,
  });

  RoundData copyWith({
    int id,
    String place,
    DateTime startDate,
    DateTime finishDate,
  }) {
    return new RoundData(
      id: id ?? this.id,
      place: place ?? this.place,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
    );
  }

  @override
  String toString() {
    return 'RoundData{id: $id, place: $place, startDate: $startDate, finishDate: $finishDate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoundData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          place == other.place &&
          startDate == other.startDate &&
          finishDate == other.finishDate);

  @override
  int get hashCode =>
      id.hashCode ^ place.hashCode ^ startDate.hashCode ^ finishDate.hashCode;

  factory RoundData.fromMap(Map<String, dynamic> map) {
    return new RoundData(
      id: map['id'] as int,
      place: map['place'] as String,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      finishDate: map['finishDate'] != null ? DateTime.parse(map['finishDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'place': this.place,
      'startDate': this.startDate.toIso8601String(),
      'finishDate': this.finishDate.toIso8601String(),
    } as Map<String, dynamic>;
  }

//</editor-fold>

}