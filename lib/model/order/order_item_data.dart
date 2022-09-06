import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/order/item_Round_Data.dart';
import 'package:munto_app/model/order/item_isValid_Data.dart';

class OrderItemData {
  int id;
  String cover;
  String name;
  String startDate;
  List<ItemRounData> ItemRound;
  int price;
  int discountPrice;
  ItemisValidData isValid;
  OrderItemData({
    this.id,
    this.cover,
    this.name,
    this.startDate,
    this.ItemRound,
    this.price,
    this.discountPrice,
    this.isValid,
  });

  OrderItemData copyWith({
    int id,
    String cover,
    String name,
    String startDate,
    List<ItemRounData> ItemRound,
    int price,
    int discountPrice,
    ItemisValidData isValid,
  }) {
    return OrderItemData(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      ItemRound: ItemRound ?? this.ItemRound,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'name': name,
      'startDate': startDate,
      'ItemRound': ItemRound?.map((x) => x?.toMap())?.toList(),
      'price': price,
      'discountPrice': discountPrice,
      'isValid': isValid?.toMap(),
    };
  }

  factory OrderItemData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderItemData(
      id: map['id'],
      cover: map['cover'],
      name: map['name'],
      startDate: map['startDate'],
      ItemRound: List<ItemRounData>.from(
          map['ItemRound']?.map((x) => ItemRounData.fromMap(x))),
      price: map['price'],
      discountPrice: map['discountPrice'],
      isValid: ItemisValidData.fromMap(map['isValid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemData.fromJson(String source) =>
      OrderItemData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItemData(id: $id, cover: $cover, name: $name, startDate: $startDate, ItemRound: $ItemRound, price: $price, discountPrice: $discountPrice, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderItemData &&
        o.id == id &&
        o.cover == cover &&
        o.name == name &&
        o.startDate == startDate &&
        listEquals(o.ItemRound, ItemRound) &&
        o.price == price &&
        o.discountPrice == discountPrice &&
        o.isValid == isValid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        startDate.hashCode ^
        ItemRound.hashCode ^
        price.hashCode ^
        discountPrice.hashCode ^
        isValid.hashCode;
  }
}
