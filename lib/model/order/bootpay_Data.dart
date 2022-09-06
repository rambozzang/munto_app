import 'dart:convert';

import 'package:flutter/foundation.dart';

class BootPayData {
  String paymentId;
  String receiptId;
  List<BootPayDetailData> items;
  List<BootPayDetailData> socialings;
  List<BootPayDetailData> itemRounds;
  String totalPrice;
  String reservesMoney;
  String orderKind;
  BootPayData({
    this.paymentId,
    this.receiptId,
    this.items,
    this.socialings,
    this.itemRounds,
    this.totalPrice,
    this.reservesMoney,
    this.orderKind,
  });

  BootPayData copyWith({
    String paymentId,
    String receiptId,
    List<BootPayDetailData> items,
    List<BootPayDetailData> socialings,
    List<BootPayDetailData> itemRounds,
    String totalPrice,
    String reservesMoney,
    String orderKind,
  }) {
    return BootPayData(
      paymentId: paymentId ?? this.paymentId,
      receiptId: receiptId ?? this.receiptId,
      items: items ?? this.items,
      socialings: socialings ?? this.socialings,
      itemRounds: itemRounds ?? this.itemRounds,
      totalPrice: totalPrice ?? this.totalPrice,
      reservesMoney: reservesMoney ?? this.reservesMoney,
      orderKind: orderKind ?? this.orderKind,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'receiptId': receiptId,
      'items': items?.map((x) => x?.toMap())?.toList(),
      'socialings': socialings?.map((x) => x?.toMap())?.toList(),
      'itemRounds': itemRounds?.map((x) => x?.toMap())?.toList(),
      'totalPrice': totalPrice,
      'reservesMoney': reservesMoney,
      'orderKind': orderKind,
    };
  }

  factory BootPayData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BootPayData(
      paymentId: map['paymentId'],
      receiptId: map['receiptId'],
      items: List<BootPayDetailData>.from(map['items']?.map((x) => BootPayDetailData.fromMap(x))),
      socialings: List<BootPayDetailData>.from(map['socialings']?.map((x) => BootPayDetailData.fromMap(x))),
      itemRounds: List<BootPayDetailData>.from(map['itemRounds']?.map((x) => BootPayDetailData.fromMap(x))),
      totalPrice: map['totalPrice'],
      reservesMoney: map['reservesMoney'],
      orderKind: map['orderKind'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BootPayData.fromJson(String source) => BootPayData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BootPayData(paymentId: $paymentId, receiptId: $receiptId, items: $items, socialings: $socialings, itemRounds: $itemRounds, totalPrice: $totalPrice, reservesMoney: $reservesMoney, orderKind: $orderKind)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BootPayData &&
        o.paymentId == paymentId &&
        o.receiptId == receiptId &&
        listEquals(o.items, items) &&
        listEquals(o.socialings, socialings) &&
        listEquals(o.itemRounds, itemRounds) &&
        o.totalPrice == totalPrice &&
        o.reservesMoney == reservesMoney &&
        o.orderKind == orderKind;
  }

  @override
  int get hashCode {
    return paymentId.hashCode ^
        receiptId.hashCode ^
        items.hashCode ^
        socialings.hashCode ^
        itemRounds.hashCode ^
        totalPrice.hashCode ^
        reservesMoney.hashCode ^
        orderKind.hashCode;
  }
}

class BootPayDetailData {
  String id;
  String couponId;
  BootPayDetailData({
    this.id,
    this.couponId,
  });

  BootPayDetailData copyWith({
    String id,
    String couponId,
  }) {
    return BootPayDetailData(
      id: id ?? this.id,
      couponId: couponId ?? this.couponId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'couponId': couponId,
    };
  }

  factory BootPayDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return BootPayDetailData(
      id: map['id'],
      couponId: map['couponId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BootPayDetailData.fromJson(String source) => BootPayDetailData.fromMap(json.decode(source));

  @override
  String toString() => 'BootPayDetailData(id: $id, couponId: $couponId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BootPayDetailData && o.id == id && o.couponId == couponId;
  }

  @override
  int get hashCode => id.hashCode ^ couponId.hashCode;
}
