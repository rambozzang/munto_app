import 'dart:convert';

class TagsData {
  String createdAt;
  String updatedAt;
  String deletedAt;
  int id;
  String name;
  String image;
  TagsData({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
    this.name,
    this.image,
  });

  TagsData copyWith({
    String createdAt,
    String updatedAt,
    String deletedAt,
    int id,
    String name,
    String image,
  }) {
    return TagsData(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory TagsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TagsData(
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TagsData.fromJson(String source) => TagsData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TagsData(createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, id: $id, name: $name, image: $image)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TagsData &&
      o.createdAt == createdAt &&
      o.updatedAt == updatedAt &&
      o.deletedAt == deletedAt &&
      o.id == id &&
      o.name == name &&
      o.image == image;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      id.hashCode ^
      name.hashCode ^
      image.hashCode;
  }
}
