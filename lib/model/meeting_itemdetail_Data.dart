import 'dart:convert';

class MeetingItemDetailData {
  String ttile;
  String description;
  String thumbnail;
  MeetingItemDetailData({
    this.ttile,
    this.description,
    this.thumbnail,
  });

  MeetingItemDetailData copyWith({
    String ttile,
    String description,
    String thumbnail,
  }) {
    return MeetingItemDetailData(
      ttile: ttile ?? this.ttile,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ttile': ttile,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  factory MeetingItemDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingItemDetailData(
      ttile: map['ttile'],
      description: map['description'],
      thumbnail: map['thumbnail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingItemDetailData.fromJson(String source) => MeetingItemDetailData.fromMap(json.decode(source));

  @override
  String toString() => 'MeetingItemDetailData(ttile: $ttile, description: $description, thumbnail: $thumbnail)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingItemDetailData &&
      o.ttile == ttile &&
      o.description == description &&
      o.thumbnail == thumbnail;
  }

  @override
  int get hashCode => ttile.hashCode ^ description.hashCode ^ thumbnail.hashCode;
}
