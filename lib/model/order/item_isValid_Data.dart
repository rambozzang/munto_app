import 'dart:convert';

class ItemisValidData {
  bool result;
  int id;
  int price;
  String message;
  ItemisValidData({
    this.result,
    this.id,
    this.price,
    this.message,
  });

  ItemisValidData copyWith({
    bool result,
    int id,
    int price,
    String message,
  }) {
    return ItemisValidData(
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

  factory ItemisValidData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ItemisValidData(
      result: map['result'],
      id: map['id'],
      price: map['price'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemisValidData.fromJson(String source) => ItemisValidData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ItemisValidData(result: $result, id: $id, price: $price, message: $message)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ItemisValidData &&
      o.result == result &&
      o.id == id &&
      o.price == price &&
      o.message == message;
  }

  @override
  int get hashCode {
    return result.hashCode ^
      id.hashCode ^
      price.hashCode ^
      message.hashCode;
  }
}
 