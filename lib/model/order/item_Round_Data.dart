import 'dart:convert';

class ItemRounData {
  String place;
  int round;
  String startDate;
  ItemRounData({
    this.place,
    this.round,
    this.startDate,
  });

  ItemRounData copyWith({
    String place,
    int round,
    String startDate,
  }) {
    return ItemRounData(
      place: place ?? this.place,
      round: round ?? this.round,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'round': round,
      'startDate': startDate,
    };
  }

  factory ItemRounData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ItemRounData(
      place: map['place'],
      round: map['round'],
      startDate: map['startDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemRounData.fromJson(String source) => ItemRounData.fromMap(json.decode(source));

  @override
  String toString() => 'ItemRounData(place: $place, round: $round, startDate: $startDate)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ItemRounData &&
      o.place == place &&
      o.round == round &&
      o.startDate == startDate;
  }

  @override
  int get hashCode => place.hashCode ^ round.hashCode ^ startDate.hashCode;
}
