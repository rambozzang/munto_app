import 'dart:convert';

class PaymentIdDetailData {
  bool result;
  int id;
  int price;
  String message; 
  PaymentIdDetailData({
    this.result,
    this.id,
    this.price,
    this.message,
  });
     

  PaymentIdDetailData copyWith({
    bool result,
    int id,
    int price,
    String message,
  }) {
    return PaymentIdDetailData(
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

  factory PaymentIdDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PaymentIdDetailData(
      result: map['result'],
      id: map['id'],
      price: map['price'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentIdDetailData.fromJson(String source) => PaymentIdDetailData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentIdDetailData(result: $result, id: $id, price: $price, message: $message)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PaymentIdDetailData &&
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
