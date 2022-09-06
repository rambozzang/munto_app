import 'dart:convert';

class CommonData {
  String createdAt;
  String updatedAt;
  String deletedAt;
  int id;
  CommonData({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
  });

  CommonData copyWith({
    String createdAt,
    String updatedAt,
    String deletedAt,
    int id,
  }) {
    return CommonData(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'id': id,
    };
  }

  factory CommonData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CommonData(
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommonData.fromJson(String source) => CommonData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommonData(createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, id: $id)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CommonData &&
      o.createdAt == createdAt &&
      o.updatedAt == updatedAt &&
      o.deletedAt == deletedAt &&
      o.id == id;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      id.hashCode;
  }
}
