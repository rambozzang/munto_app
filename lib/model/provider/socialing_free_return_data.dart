import 'package:flutter/cupertino.dart';

class SocialingFreeReturnData {

  bool result;
  int id;
  // dynamic price;
  String message;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  SocialingFreeReturnData({
    @required this.result,
    @required this.id,
    @required this.message,
  });

  SocialingFreeReturnData copyWith({
    bool result,
    int id,
    String message,
  }) {
    return new SocialingFreeReturnData(
      result: result ?? this.result,
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'SocialingFreeReturnData{result: $result, id: $id, message: $message}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialingFreeReturnData &&
          runtimeType == other.runtimeType &&
          result == other.result &&
          id == other.id &&
          message == other.message);

  @override
  int get hashCode => result.hashCode ^ id.hashCode ^ message.hashCode;

  factory SocialingFreeReturnData.fromMap(Map<String, dynamic> map) {
    return new SocialingFreeReturnData(
      result: map['result'] as bool,
      id: map['id'] as int,
      message: map['message'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'result': this.result,
      'id': this.id,
      'message': this.message,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}