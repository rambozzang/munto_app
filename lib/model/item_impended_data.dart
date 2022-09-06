import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:munto_app/model/round_data.dart';

class ItemImpendedData {
  int id;
  String cover;
  String itemKind;
  String leaderImage;
  String location;
  String badge;
  bool isPick;
  String startDate;
  String finishDate;
  ItemImpendedData({
    this.id,
    this.cover,
    this.itemKind,
    this.leaderImage,
    this.location,
    this.badge,
    this.isPick,
    this.startDate,
    this.finishDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'itemKind': itemKind,
      'leaderImage': leaderImage,
      'location': location,
      'badge': badge,
      'isPick': isPick,
      'startDate': startDate,
      'finishDate': finishDate,
    };
  }

  factory ItemImpendedData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ItemImpendedData(
      id: map['id'],
      cover: map['cover'],
      itemKind: map['itemKind'],
      leaderImage: map['leaderImage'],
      location: map['location'],
      badge: map['badge'],
      isPick: map['isPick'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemImpendedData.fromJson(String source) =>
      ItemImpendedData.fromMap(json.decode(source));
}
