

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/item_attendee_data.dart';

class ItemSaveData {
  String itemId;
  String itemRoundId;
  List<ItemAttendeeData> attendeeList;
  ItemSaveData({
    this.itemId,
    this.itemRoundId,
    this.attendeeList,
  });

  ItemSaveData copyWith({
    String itemId,
    String itemRoundId,
    List<ItemAttendeeData> attendeeList,
  }) {
    return ItemSaveData(
      itemId: itemId ?? this.itemId,
      itemRoundId: itemRoundId ?? this.itemRoundId,
      attendeeList: attendeeList ?? this.attendeeList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemRoundId': itemRoundId,
      'attendeeList': attendeeList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ItemSaveData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ItemSaveData(
      itemId: map['itemId'],
      itemRoundId: map['itemRoundId'],
      attendeeList: List<ItemAttendeeData>.from(map['attendeeList']?.map((x) => ItemAttendeeData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemSaveData.fromJson(String source) => ItemSaveData.fromMap(json.decode(source));

  @override
  String toString() => 'ItemSaveData(itemId: $itemId, itemRoundId: $itemRoundId, attendeeList: $attendeeList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ItemSaveData &&
      o.itemId == itemId &&
      o.itemRoundId == itemRoundId &&
      listEquals(o.attendeeList, attendeeList);
  }

  @override
  int get hashCode => itemId.hashCode ^ itemRoundId.hashCode ^ attendeeList.hashCode;
}
