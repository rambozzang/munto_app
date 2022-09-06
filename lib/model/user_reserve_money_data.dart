
import 'package:flutter/cupertino.dart';

class UserReserveMoneyData{
  String reasonKind;
  String reason;
  String disappearDate;
  int money;
  String createdAt;
  String paymentId;



//<editor-fold desc="Data Methods" defaultstate="collapsed">

  UserReserveMoneyData({
    @required this.reasonKind,
    @required this.reason,
    @required this.disappearDate,
    @required this.money,
    @required this.createdAt,
    @required this.paymentId,
  });

  UserReserveMoneyData copyWith({
    String reasonKind,
    String reason,
    String disappearDate,
    int money,
    String createdAt,
    String paymentId,
  }) {
    return new UserReserveMoneyData(
      reasonKind: reasonKind ?? this.reasonKind,
      reason: reason ?? this.reason,
      disappearDate: disappearDate ?? this.disappearDate,
      money: money ?? this.money,
      createdAt: createdAt ?? this.createdAt,
      paymentId: paymentId ?? this.paymentId,
    );
  }

  @override
  String toString() {
    return 'UserReserveMoneyData{reasonKind: $reasonKind, reason: $reason, disappearDate: $disappearDate, money: $money, createdAt: $createdAt, paymentId: $paymentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserReserveMoneyData &&
          runtimeType == other.runtimeType &&
          reasonKind == other.reasonKind &&
          reason == other.reason &&
          disappearDate == other.disappearDate &&
          money == other.money &&
          createdAt == other.createdAt &&
          paymentId == other.paymentId);

  @override
  int get hashCode =>
      reasonKind.hashCode ^
      reason.hashCode ^
      disappearDate.hashCode ^
      money.hashCode ^
      createdAt.hashCode ^
      paymentId.hashCode;

  factory UserReserveMoneyData.fromMap(Map<String, dynamic> map) {
    return new UserReserveMoneyData(
      reasonKind: map['reasonKind'] as String,
      reason: map['reason'] as String,
      disappearDate: map['disappearDate'] as String,
      money: map['money'] as int,
      createdAt: map['createdAt'] as String,
      paymentId: map['paymentId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'reasonKind': this.reasonKind,
      'reason': this.reason,
      'disappearDate': this.disappearDate,
      'money': this.money,
      'createdAt': this.createdAt,
      'paymentId': this.paymentId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}