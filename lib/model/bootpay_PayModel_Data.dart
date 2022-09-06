import 'package:bootpay_api/model/bio_payload.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:flutter/foundation.dart';

class BootpayPayModelData {
  User user;
  List<Item> itemList;
  Extra extra;
  Payload payload;
  BioPayload biopayload;
  BootpayPayModelData({
    this.user,
    this.itemList,
    this.extra,
    this.payload,
    this.biopayload,
  });

  BootpayPayModelData copyWith({
    User user,
    List<Item> itemList,
    Extra extra,
    Payload payload,
    BioPayload biopayload,
  }) {
    return BootpayPayModelData(
      user: user ?? this.user,
      itemList: itemList ?? this.itemList,
      extra: extra ?? this.extra,
      payload: payload ?? this.payload,
      biopayload: biopayload ?? this.biopayload,
    );
  }

  @override
  String toString() {
    return 'BootpayPayModelData(user: $user, itemList: $itemList, extra: $extra, payload: $payload, biopayload: $biopayload)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BootpayPayModelData &&
        o.user == user &&
        listEquals(o.itemList, itemList) &&
        o.extra == extra &&
        o.payload == payload &&
        o.biopayload == biopayload;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        itemList.hashCode ^
        extra.hashCode ^
        payload.hashCode ^
        biopayload.hashCode;
  }
}
