import 'dart:convert';

class MeetingDetailUserData {
  String name;
  String image;
  String grade;
  MeetingDetailUserData({
    this.name,
    this.image,
    this.grade,
  });

  MeetingDetailUserData copyWith({
    String name,
    String image,
    String grade,
  }) {
    return MeetingDetailUserData(
      name: name ?? this.name,
      image: image ?? this.image,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'grade': grade,
    };
  }

  factory MeetingDetailUserData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingDetailUserData(
      name: map['name'],
      image: map['image'],
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingDetailUserData.fromJson(String source) => MeetingDetailUserData.fromMap(json.decode(source));

  @override
  String toString() => 'MeetingDetailUserData(name: $name, image: $image, grade: $grade)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingDetailUserData &&
      o.name == name &&
      o.image == image &&
      o.grade == grade;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ grade.hashCode;
}
