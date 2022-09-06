import 'dart:convert';

class FeedImageUserInfoData {
  int id;
  String image;
  String name;
  String grade;
  FeedImageUserInfoData({
    this.id,
    this.image,
    this.name,
    this.grade,
  });

  FeedImageUserInfoData copyWith({
    int id,
    String image,
    String name,
    String grade,
  }) {
    return FeedImageUserInfoData(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'grade': grade,
    };
  }

  factory FeedImageUserInfoData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return FeedImageUserInfoData(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedImageUserInfoData.fromJson(String source) => FeedImageUserInfoData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FeedImageUserInfoData(id: $id, image: $image, name: $name, grade: $grade)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is FeedImageUserInfoData &&
      o.id == id &&
      o.image == image &&
      o.name == name &&
      o.grade == grade;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      image.hashCode ^
      name.hashCode ^
      grade.hashCode;
  }
}
