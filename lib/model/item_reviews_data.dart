import 'dart:convert';

class ItemReviewsData {
  int id;
  String updatedAt;
  User user;
  String content;
  String photo;
  Item item;
  ItemReviewsData({
    this.id,
    this.updatedAt,
    this.user,
    this.content,
    this.photo,
    this.item,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'updatedAt': updatedAt,
      'user': user?.toMap(),
      'content': content,
      'photo': photo,
      'item': item?.toMap(),
    };
  }

  factory ItemReviewsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ItemReviewsData(
      id: map['id'],
      updatedAt: map['updatedAt'],
      user: User.fromMap(map['user']),
      content: map['content'],
      photo: map['photo'],
      item: Item.fromMap(map['item']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemReviewsData.fromJson(String source) =>
      ItemReviewsData.fromMap(json.decode(source));
}

class User {
  String image;
  String name;
  String grade;
  User({
    this.image,
    this.name,
    this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'grade': grade,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      image: map['image'],
      name: map['name'],
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class Item {
  int id;
  String name;
  int lastRound;
  Item({
    this.id,
    this.name,
    this.lastRound,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastRound': lastRound,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Item(
      id: map['id'],
      name: map['name'],
      lastRound: map['lastRound'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
