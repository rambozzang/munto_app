import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/order/order_item_data.dart';
import 'package:munto_app/model/order/order_socialing_data.dart';
import 'package:munto_app/model/order/order_user_data.dart';

class OrderItemsData {
  List<OrderItemData> items;
   List<OrderSocialingData> socialings;
   List<String> itemRounds;
   OrderUserData user;
  OrderItemsData({
    this.items,
    this.socialings,
    this.itemRounds,
    this.user,
  });

  OrderItemsData copyWith({
    List<OrderItemData> items,
    List<OrderSocialingData> socialings,
    List<String> itemRounds,
    OrderUserData user,
  }) {
    return OrderItemsData(
      items: items ?? this.items,
      socialings: socialings ?? this.socialings,
      itemRounds: itemRounds ?? this.itemRounds,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items?.map((x) => x?.toMap())?.toList(),
      'socialings': socialings?.map((x) => x?.toMap())?.toList(),
      'itemRounds': itemRounds,
      'user': user?.toMap(),
    };
  }

  factory OrderItemsData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrderItemsData(
      items: List<OrderItemData>.from(map['items']?.map((x) => OrderItemData.fromMap(x))),
      socialings: List<OrderSocialingData>.from(map['socialings']?.map((x) => OrderSocialingData.fromMap(x))),
      itemRounds: List<String>.from(map['itemRounds']),
      user: OrderUserData.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemsData.fromJson(String source) => OrderItemsData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItemsData(items: $items, socialings: $socialings, itemRounds: $itemRounds, user: $user)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrderItemsData &&
      listEquals(o.items, items) &&
      listEquals(o.socialings, socialings) &&
      listEquals(o.itemRounds, itemRounds) &&
      o.user == user;
  }

  @override
  int get hashCode {
    return items.hashCode ^
      socialings.hashCode ^
      itemRounds.hashCode ^
      user.hashCode;
  }
}
