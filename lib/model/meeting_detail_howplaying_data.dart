// {
// "id": 112,
// "createdAt": "2020-11-27T08:49:46.869Z",
// "updatedAt": "2020-11-27T08:49:46.870Z",
// "deletedAt": null,
// "title": null,
// "description": null,
// "thumbnail": null,
// "itemId": 5305
// }

import 'package:flutter/cupertino.dart';

class HowPlayingData{
  int id ;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String title;
  String description;
  String thumbnail;
  int itemId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  HowPlayingData({
    @required this.id,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
    @required this.title,
    @required this.description,
    @required this.thumbnail,
    @required this.itemId,
  });

  HowPlayingData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String title,
    String description,
    String thumbnail,
    int itemId,
  }) {
    return new HowPlayingData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      itemId: itemId ?? this.itemId,
    );
  }

  @override
  String toString() {
    return 'HowPlayingData{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, title: $title, description: $description, thumbnail: $thumbnail, itemId: $itemId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HowPlayingData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          deletedAt == other.deletedAt &&
          title == other.title &&
          description == other.description &&
          thumbnail == other.thumbnail &&
          itemId == other.itemId);

  @override
  int get hashCode =>
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      title.hashCode ^
      description.hashCode ^
      thumbnail.hashCode ^
      itemId.hashCode;

  factory HowPlayingData.fromMap(Map<String, dynamic> map) {
    return new HowPlayingData(
      id: map['id'] as int,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      deletedAt: map['deletedAt'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      thumbnail: map['thumbnail'] as String,
      itemId: map['itemId'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'deletedAt': this.deletedAt,
      'title': this.title,
      'description': this.description,
      'thumbnail': this.thumbnail,
      'itemId': this.itemId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}