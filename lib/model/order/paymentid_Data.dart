import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/order/paymentId_Detail_Data.dart';

class PaymentIdData {
  List<PaymentIdDetailData> items;
  List<PaymentIdDetailData> socialings;
  List<PaymentIdDetailData> itemRounds;
  String paymentId;
  PaymentIdData({
    this.items,
    this.socialings,
    this.itemRounds,
    this.paymentId,
  });

  PaymentIdData copyWith({
    List<PaymentIdDetailData> items,
    List<PaymentIdDetailData> socialings,
    List<PaymentIdDetailData> itemRounds,
    String paymentId,
  }) {
    return PaymentIdData(
      items: items ?? this.items,
      socialings: socialings ?? this.socialings,
      itemRounds: itemRounds ?? this.itemRounds,
      paymentId: paymentId ?? this.paymentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items?.map((x) => x?.toMap())?.toList(),
      'socialings': socialings?.map((x) => x?.toMap())?.toList(),
      'itemRounds': itemRounds?.map((x) => x?.toMap())?.toList(),
      'paymentId': paymentId,
    };
  }

  factory PaymentIdData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PaymentIdData(
      items: List<PaymentIdDetailData>.from(map['items']?.map((x) => PaymentIdDetailData.fromMap(x))),
      socialings: List<PaymentIdDetailData>.from(map['socialings']?.map((x) => PaymentIdDetailData.fromMap(x))),
      itemRounds: List<PaymentIdDetailData>.from(map['itemRounds']?.map((x) => PaymentIdDetailData.fromMap(x))),
      paymentId: map['paymentId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentIdData.fromJson(String source) => PaymentIdData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentIdData(items: $items, socialings: $socialings, itemRounds: $itemRounds, paymentId: $paymentId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PaymentIdData &&
        listEquals(o.items, items) &&
        listEquals(o.socialings, socialings) &&
        listEquals(o.itemRounds, itemRounds) &&
        o.paymentId == paymentId;
  }

  @override
  int get hashCode {
    return items.hashCode ^ socialings.hashCode ^ itemRounds.hashCode ^ paymentId.hashCode;
  }
}
