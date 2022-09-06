import 'dart:convert';

class FundData {
  String bank;
  String accountNumber;
  String accountHolder;
  String idNumberFront;
  String idNumberBack;
  FundData({
    this.bank,
    this.accountNumber,
    this.accountHolder,
    this.idNumberFront,
    this.idNumberBack,
  });

  FundData copyWith({
    String bank,
    String accountNumber,
    String accountHolder,
    String idNumberFront,
    String idNumberBack,
  }) {
    return FundData(
      bank: bank ?? this.bank,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolder: accountHolder ?? this.accountHolder,
      idNumberFront: idNumberFront ?? this.idNumberFront,
      idNumberBack: idNumberBack ?? this.idNumberBack,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bank': bank,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
      'idNumberFront': idNumberFront,
      'idNumberBack': idNumberBack,
    };
  }

  factory FundData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FundData(
      bank: map['bank'],
      accountNumber: map['accountNumber'],
      accountHolder: map['accountHolder'],
      idNumberFront: map['idNumberFront'],
      idNumberBack: map['idNumberBack'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FundData.fromJson(String source) => FundData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FundData(bank: $bank, accountNumber: $accountNumber, accountHolder: $accountHolder, idNumberFront: $idNumberFront, idNumberBack: $idNumberBack)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FundData &&
        o.bank == bank &&
        o.accountNumber == accountNumber &&
        o.accountHolder == accountHolder &&
        o.idNumberFront == idNumberFront &&
        o.idNumberBack == idNumberBack;
  }

  @override
  int get hashCode {
    return bank.hashCode ^
        accountNumber.hashCode ^
        accountHolder.hashCode ^
        idNumberFront.hashCode ^
        idNumberBack.hashCode;
  }
}
