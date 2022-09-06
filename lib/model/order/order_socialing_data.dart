import 'dart:convert';

import 'package:munto_app/model/order/item_isValid_Data.dart';


class OrderSocialingData {
    int id;
    String cover;
    String name;
    String startDate;
    String location;
    int price;
    int discountPrice;
    ItemisValidData isValid;
  OrderSocialingData({
    this.id,
    this.cover,
    this.name,
    this.startDate,
    this.location,
    this.price,
    this.discountPrice,
    this.isValid,
  });


  OrderSocialingData copyWith({
    int id,
    String cover,
    String name,
    String startDate,
    String location,
    int price,
    int discountPrice,
    ItemisValidData isValid,
  }) {
    return OrderSocialingData(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      location: location ?? this.location,
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
      'location': location,
      'price': price,
      'discountPrice': discountPrice,
      'isValid': isValid?.toMap(),
    };
  }

  factory OrderSocialingData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrderSocialingData(
      id: map['id'],
      cover: map['cover'],
      name: map['name'],
      startDate: map['startDate'],
      location: map['location'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      isValid: ItemisValidData.fromMap(map['isValid']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSocialingData.fromJson(String source) => OrderSocialingData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderSocialingData(id: $id, cover: $cover, name: $name, startDate: $startDate, location: $location, price: $price, discountPrice: $discountPrice, isValid: $isValid)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrderSocialingData &&
      o.id == id &&
      o.cover == cover &&
      o.name == name &&
      o.startDate == startDate &&
      o.location == location &&
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
      location.hashCode ^
      price.hashCode ^
      discountPrice.hashCode ^
      isValid.hashCode;
  }
}
