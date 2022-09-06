import 'dart:convert';

class ClassProceedingRoundsData {
  int id;
  int round;
  String place;
  String startDate;
  String finishDate;
  ClassProceedingRoundsData({
    this.id,
    this.round,
    this.place,
    this.startDate,
    this.finishDate,
  });

  ClassProceedingRoundsData copyWith({
    int id,
    int round,
    String place,
    String startDate,
    String finishDate,
  }) {
    return ClassProceedingRoundsData(
      id: id ?? this.id,
      round: round ?? this.round,
      place: place ?? this.place,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'round': round,
      'place': place,
      'startDate': startDate,
      'finishDate': finishDate,
    };
  }
  factory ClassProceedingRoundsData.fromMap(Map<String, dynamic> map) {

    if (map == null) return null;
    print('ClassProceedingRoundsData.fromMap = ${map.toString()}');

    return ClassProceedingRoundsData(
      id: map['id'],
      round: map['round'],
      place: map['place'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
    );
  }


  String toJson() => json.encode(toMap());

  factory ClassProceedingRoundsData.fromJson(String source) => ClassProceedingRoundsData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassProceedingRoundsData(id: $id, round: $round, place: $place, startTime: $startDate, finishTime: $finishDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ClassProceedingRoundsData &&
        o.id == id &&
        o.round == round &&
        o.place == place &&
        o.startDate == startDate &&
        o.finishDate == finishDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ round.hashCode ^ place.hashCode ^ startDate.hashCode ^ finishDate.hashCode;
  }
}
