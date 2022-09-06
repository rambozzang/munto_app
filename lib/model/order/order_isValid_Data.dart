import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderisValidData {
  List<Invalid> validItems;
  List<Invalid> invalidItems;
  List<Invalid> validItemRounds;
  List<Invalid> invalidItemRounds;
  List<Invalid> validSocialings;
  List<Invalid> invalidSocialings;
  OrderisValidData({
    this.validItems,
    this.invalidItems,
    this.validItemRounds,
    this.invalidItemRounds,
    this.validSocialings,
    this.invalidSocialings,
  });

  OrderisValidData copyWith({
    List<Invalid> validItems,
    List<Invalid> invalidItems,
    List<Invalid> validItemRounds,
    List<Invalid> invalidItemRounds,
    List<Invalid> validSocialings,
    List<Invalid> invalidSocialings,
  }) {
    return OrderisValidData(
      validItems: validItems ?? this.validItems,
      invalidItems: invalidItems ?? this.invalidItems,
      validItemRounds: validItemRounds ?? this.validItemRounds,
      invalidItemRounds: invalidItemRounds ?? this.invalidItemRounds,
      validSocialings: validSocialings ?? this.validSocialings,
      invalidSocialings: invalidSocialings ?? this.invalidSocialings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'validItems': validItems?.map((x) => x?.toMap())?.toList(),
      'invalidItems': invalidItems?.map((x) => x?.toMap())?.toList(),
      'validItemRounds': validItemRounds?.map((x) => x?.toMap())?.toList(),
      'invalidItemRounds': invalidItemRounds?.map((x) => x?.toMap())?.toList(),
      'validSocialings': validSocialings?.map((x) => x?.toMap())?.toList(),
      'invalidSocialings': invalidSocialings?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory OrderisValidData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderisValidData(
      validItems:
          List<Invalid>.from(map['validItems']?.map((x) => Invalid.fromMap(x))),
      invalidItems: List<Invalid>.from(
          map['invalidItems']?.map((x) => Invalid.fromMap(x))),
      validItemRounds: List<Invalid>.from(
          map['validItemRounds']?.map((x) => Invalid.fromMap(x))),
      invalidItemRounds: List<Invalid>.from(
          map['invalidItemRounds']?.map((x) => Invalid.fromMap(x))),
      validSocialings: List<Invalid>.from(
          map['validSocialings']?.map((x) => Invalid.fromMap(x))),
      invalidSocialings: List<Invalid>.from(
          map['invalidSocialings']?.map((x) => Invalid.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderisValidData.fromJson(String source) =>
      OrderisValidData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderisValidData(validItems: $validItems, invalidItems: $invalidItems, validItemRounds: $validItemRounds, invalidItemRounds: $invalidItemRounds, validSocialings: $validSocialings, invalidSocialings: $invalidSocialings)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderisValidData &&
        listEquals(o.validItems, validItems) &&
        listEquals(o.invalidItems, invalidItems) &&
        listEquals(o.validItemRounds, validItemRounds) &&
        listEquals(o.invalidItemRounds, invalidItemRounds) &&
        listEquals(o.validSocialings, validSocialings) &&
        listEquals(o.invalidSocialings, invalidSocialings);
  }

  @override
  int get hashCode {
    return validItems.hashCode ^
        invalidItems.hashCode ^
        validItemRounds.hashCode ^
        invalidItemRounds.hashCode ^
        validSocialings.hashCode ^
        invalidSocialings.hashCode;
  }
}

class Invalid {
  bool result;
  int id;
  dynamic price;
  String message;
  Invalid({
    this.result,
    this.id,
    this.price,
    this.message,
  });

  Invalid copyWith({
    bool result,
    int id,
    dynamic price,
    String message,
  }) {
    return Invalid(
      result: result ?? this.result,
      id: id ?? this.id,
      price: price ?? this.price,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'id': id,
      'price': price,
      'message': message,
    };
  }

  factory Invalid.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Invalid(
      result: map['result'],
      id: map['id'],
      price: map['price'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Invalid.fromJson(String source) =>
      Invalid.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Invalid(result: $result, id: $id, price: $price, message: $message)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Invalid &&
        o.result == result &&
        o.id == id &&
        o.price == price &&
        o.message == message;
  }

  @override
  int get hashCode {
    return result.hashCode ^ id.hashCode ^ price.hashCode ^ message.hashCode;
  }
}
