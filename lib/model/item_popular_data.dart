import 'dart:convert';

class PopularItemData {
  int id;
  String cover;
  String badge;
  PopularItemData({
    this.id,
    this.cover,
    this.badge,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'badge': badge,
    };
  }

  factory PopularItemData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PopularItemData(
      id: map['id'],
      cover: map['cover'],
      badge: map['badge'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PopularItemData.fromJson(String source) =>
      PopularItemData.fromMap(json.decode(source));
}
