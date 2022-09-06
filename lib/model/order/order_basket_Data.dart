import 'dart:convert';

class OrderBasketData {
    int basketId;
    String cover;
    String classType;
    int classId;
    String name;
    String location;
    String startDate;
    int price;
    int round;
  OrderBasketData({
    this.basketId,
    this.cover,
    this.classType,
    this.classId,
    this.name,
    this.location,
    this.startDate,
    this.price,
    this.round,
  });
  

  OrderBasketData copyWith({
    int basketId,
    String cover,
    String classType,
    int classId,
    String name,
    String location,
    String startDate,
    int price,
    int round,
  }) {
    return OrderBasketData(
      basketId: basketId ?? this.basketId,
      cover: cover ?? this.cover,
      classType: classType ?? this.classType,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      price: price ?? this.price,
      round: round ?? this.round,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'basketId': basketId,
      'cover': cover,
      'classType': classType,
      'classId': classId,
      'name': name,
      'location': location,
      'startDate': startDate,
      'price': price,
      'round': round,
    };
  }

  factory OrderBasketData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrderBasketData(
      basketId: map['basketId'],
      cover: map['cover'],
      classType: map['classType'],
      classId: map['classId'],
      name: map['name'],
      location: map['location'],
      startDate: map['startDate'],
      price: map['price'],
      round: map['round'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderBasketData.fromJson(String source) => OrderBasketData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderBasketData(basketId: $basketId, cover: $cover, classType: $classType, classId: $classId, name: $name, location: $location, startDate: $startDate, price: $price, round: $round)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrderBasketData &&
      o.basketId == basketId &&
      o.cover == cover &&
      o.classType == classType &&
      o.classId == classId &&
      o.name == name &&
      o.location == location &&
      o.startDate == startDate &&
      o.price == price &&
      o.round == round;
  }

  @override
  int get hashCode {
    return basketId.hashCode ^
      cover.hashCode ^
      classType.hashCode ^
      classId.hashCode ^
      name.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      price.hashCode ^
      round.hashCode;
  }
}
