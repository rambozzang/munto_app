// import 'dart:convert';
//
// import 'package:flutter/material.dart';
//
// import 'package:munto_app/model/round_data.dart';
//
// class ItemRecommendData {
//   int id;
//   String cover;
//   String itemKind;
//   String leaderImage;
//   String location;
//   String badge;
//   bool isPick;
//   String startDate;
//   String finishDate;
//   ItemRecommendData({
//     this.id,
//     this.cover,
//     this.itemKind,
//     this.leaderImage,
//     this.location,
//     this.badge,
//     this.isPick,
//     this.startDate,
//     this.finishDate,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'cover': cover,
//       'itemKind': itemKind,
//       'leaderImage': leaderImage,
//       'location': location,
//       'badge': badge,
//       'isPick': isPick,
//       'startDate': startDate,
//       'finishDate': finishDate,
//     };
//   }
//
//   factory ItemRecommendData.fromMap(Map<String, dynamic> map) {
//     if (map == null) return null;
//
//     return ItemRecommendData(
//       id: map['id'],
//       cover: map['cover'],
//       itemKind: map['itemKind'],
//       leaderImage: map['leaderImage'],
//       location: map['location'],
//       badge: map['badge'],
//       isPick: map['isPick'],
//       startDate: map['startDate'],
//       finishDate: map['finishDate'],
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory ItemRecommendData.fromJson(String source) =>
//       ItemRecommendData.fromMap(json.decode(source));
// }
