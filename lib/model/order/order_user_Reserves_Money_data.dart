import 'dart:convert';

class OrerUserReservesMoneyData {
  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String disappearDate;
  String reasonKind;
  String reason;
  int money;
  String parentId;
  int userId;
  String paymentId;
  String orderHistoryId;
  OrerUserReservesMoneyData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.disappearDate,
    this.reasonKind,
    this.reason,
    this.money,
    this.parentId,
    this.userId,
    this.paymentId,
    this.orderHistoryId,
  });


  OrerUserReservesMoneyData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String disappearDate,
    String reasonKind,
    String reason,
    int money,
    String parentId,
    int userId,
    String paymentId,
    String orderHistoryId,
  }) {
    return OrerUserReservesMoneyData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      disappearDate: disappearDate ?? this.disappearDate,
      reasonKind: reasonKind ?? this.reasonKind,
      reason: reason ?? this.reason,
      money: money ?? this.money,
      parentId: parentId ?? this.parentId,
      userId: userId ?? this.userId,
      paymentId: paymentId ?? this.paymentId,
      orderHistoryId: orderHistoryId ?? this.orderHistoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'disappearDate': disappearDate,
      'reasonKind': reasonKind,
      'reason': reason,
      'money': money,
      'parentId': parentId,
      'userId': userId,
      'paymentId': paymentId,
      'orderHistoryId': orderHistoryId,
    };
  }

  factory OrerUserReservesMoneyData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return OrerUserReservesMoneyData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      disappearDate: map['disappearDate'],
      reasonKind: map['reasonKind'],
      reason: map['reason'],
      money: map['money'],
      parentId: map['parentId'],
      userId: map['userId'],
      paymentId: map['paymentId'],
      orderHistoryId: map['orderHistoryId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrerUserReservesMoneyData.fromJson(String source) => OrerUserReservesMoneyData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrerUserReservesMoneyData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, disappearDate: $disappearDate, reasonKind: $reasonKind, reason: $reason, money: $money, parentId: $parentId, userId: $userId, paymentId: $paymentId, orderHistoryId: $orderHistoryId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is OrerUserReservesMoneyData &&
      o.id == id &&
      o.createdAt == createdAt &&
      o.updatedAt == updatedAt &&
      o.deletedAt == deletedAt &&
      o.disappearDate == disappearDate &&
      o.reasonKind == reasonKind &&
      o.reason == reason &&
      o.money == money &&
      o.parentId == parentId &&
      o.userId == userId &&
      o.paymentId == paymentId &&
      o.orderHistoryId == orderHistoryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      disappearDate.hashCode ^
      reasonKind.hashCode ^
      reason.hashCode ^
      money.hashCode ^
      parentId.hashCode ^
      userId.hashCode ^
      paymentId.hashCode ^
      orderHistoryId.hashCode;
  }
}

