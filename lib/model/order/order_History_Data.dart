import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/order/order_item_data.dart';
import 'package:munto_app/model/order/order_user_Reserves_Money_data.dart';

class OrderHistoryData {
  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String paymentId;
  String receiptId;
  String orderKind;
  int userId;
  int price;
  OrderHistoryDataData data;
  String memo;
  List<OrerUserReservesMoneyData> UserReservesMoney;
  List<OrderOrderData> Order;
  OrderHistoryData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.paymentId,
    this.receiptId,
    this.orderKind,
    this.userId,
    this.price,
    this.memo,
    this.UserReservesMoney,
    this.Order,
  });

  OrderHistoryData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String paymentId,
    String receiptId,
    String orderKind,
    int userId,
    int price,
    String memo,
    List<OrerUserReservesMoneyData> UserReservesMoney,
    List<OrderOrderData> Order,
  }) {
    return OrderHistoryData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      paymentId: paymentId ?? this.paymentId,
      receiptId: receiptId ?? this.receiptId,
      orderKind: orderKind ?? this.orderKind,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      memo: memo ?? this.memo,
      UserReservesMoney: UserReservesMoney ?? this.UserReservesMoney,
      Order: Order ?? this.Order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'paymentId': paymentId,
      'receiptId': receiptId,
      'orderKind': orderKind,
      'userId': userId,
      'price': price,
      'memo': memo,
      'UserReservesMoney': UserReservesMoney?.map((x) => x?.toMap())?.toList(),
      'Order': Order?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory OrderHistoryData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderHistoryData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      paymentId: map['paymentId'],
      receiptId: map['receiptId'],
      orderKind: map['orderKind'],
      userId: map['userId'],
      price: map['price'],
      memo: map['memo'],
      UserReservesMoney: List<OrerUserReservesMoneyData>.from(
          map['UserReservesMoney']
              ?.map((x) => OrerUserReservesMoneyData.fromMap(x))),
      Order: List<OrderOrderData>.from(
          map['Order']?.map((x) => OrderOrderData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderHistoryData.fromJson(String source) =>
      OrderHistoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderHistoryData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, paymentId: $paymentId, receiptId: $receiptId, orderKind: $orderKind, userId: $userId, price: $price, memo: $memo, UserReservesMoney: $UserReservesMoney, Order: $Order)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderHistoryData &&
        o.id == id &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.deletedAt == deletedAt &&
        o.paymentId == paymentId &&
        o.receiptId == receiptId &&
        o.orderKind == orderKind &&
        o.userId == userId &&
        o.price == price &&
        o.memo == memo &&
        listEquals(o.UserReservesMoney, UserReservesMoney) &&
        listEquals(o.Order, Order);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        paymentId.hashCode ^
        receiptId.hashCode ^
        orderKind.hashCode ^
        userId.hashCode ^
        price.hashCode ^
        memo.hashCode ^
        UserReservesMoney.hashCode ^
        Order.hashCode;
  }
}

class OrderOrderData {
  int id;
  OrderItemData Item;
  OrderItemData ItemRound;
  OrderSocialing Socialing;
  List<OrderHistoryDetailData> OrderHistory;
  String orderKind;
  String orderStatus;
  String orderClaim;
  int orderPrice;
  String orderDate;
  String UserCoupon;
  bool isAvailableRefund;
  OrderOrderData({
    this.id,
    this.Item,
    this.ItemRound,
    this.Socialing,
    this.OrderHistory,
    this.orderKind,
    this.orderStatus,
    this.orderClaim,
    this.orderPrice,
    this.orderDate,
    this.UserCoupon,
    this.isAvailableRefund,
  });

  OrderOrderData copyWith({
    int id,
    OrderItemData Item,
    OrderItemData ItemRound,
    OrderSocialing Socialing,
    List<OrderHistoryDetailData> OrderHistory,
    String orderKind,
    String orderStatus,
    String orderClaim,
    int orderPrice,
    String orderDate,
    String UserCoupon,
    bool isAvailableRefund,
  }) {
    return OrderOrderData(
      id: id ?? this.id,
      Item: Item ?? this.Item,
      ItemRound: ItemRound ?? this.ItemRound,
      Socialing: Socialing ?? this.Socialing,
      OrderHistory: OrderHistory ?? this.OrderHistory,
      orderKind: orderKind ?? this.orderKind,
      orderStatus: orderStatus ?? this.orderStatus,
      orderClaim: orderClaim ?? this.orderClaim,
      orderPrice: orderPrice ?? this.orderPrice,
      orderDate: orderDate ?? this.orderDate,
      UserCoupon: UserCoupon ?? this.UserCoupon,
      isAvailableRefund: isAvailableRefund ?? this.isAvailableRefund,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Item': Item?.toMap(),
      'ItemRound': ItemRound?.toMap(),
      'Socialing': Socialing?.toMap(),
      'OrderHistory': OrderHistory?.map((x) => x?.toMap())?.toList(),
      'orderKind': orderKind,
      'orderStatus': orderStatus,
      'orderClaim': orderClaim,
      'orderPrice': orderPrice,
      'orderDate': orderDate,
      'UserCoupon': UserCoupon,
      'isAvailableRefund': isAvailableRefund,
    };
  }

  factory OrderOrderData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderOrderData(
      id: map['id'],
      Item: OrderItemData.fromMap(map['Item']),
      ItemRound: OrderItemData.fromMap(map['ItemRound']),
      Socialing: OrderSocialing.fromMap(map['Socialing']),
      OrderHistory: List<OrderHistoryDetailData>.from(
          map['OrderHistory']?.map((x) => OrderHistoryDetailData.fromMap(x))),
      orderKind: map['orderKind'],
      orderStatus: map['orderStatus'],
      orderClaim: map['orderClaim'],
      orderPrice: map['orderPrice'],
      orderDate: map['orderDate'],
      UserCoupon: map['UserCoupon'],
      isAvailableRefund: map['isAvailableRefund'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderOrderData.fromJson(String source) =>
      OrderOrderData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderOrderData(id: $id, Item: $Item, ItemRound: $ItemRound, Socialing: $Socialing, OrderHistory: $OrderHistory, orderKind: $orderKind, orderStatus: $orderStatus, orderClaim: $orderClaim, orderPrice: $orderPrice, orderDate: $orderDate, UserCoupon: $UserCoupon, isAvailableRefund: $isAvailableRefund)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderOrderData &&
        o.id == id &&
        o.Item == Item &&
        o.ItemRound == ItemRound &&
        o.Socialing == Socialing &&
        listEquals(o.OrderHistory, OrderHistory) &&
        o.orderKind == orderKind &&
        o.orderStatus == orderStatus &&
        o.orderClaim == orderClaim &&
        o.orderPrice == orderPrice &&
        o.orderDate == orderDate &&
        o.UserCoupon == UserCoupon &&
        o.isAvailableRefund == isAvailableRefund;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        Item.hashCode ^
        ItemRound.hashCode ^
        Socialing.hashCode ^
        OrderHistory.hashCode ^
        orderKind.hashCode ^
        orderStatus.hashCode ^
        orderClaim.hashCode ^
        orderPrice.hashCode ^
        orderDate.hashCode ^
        UserCoupon.hashCode ^
        isAvailableRefund.hashCode;
  }
}

// class OrderItemData {
//   int id;
//   String cover;
//   String name;
//   String status;
//   String startDate;
//   List<OrderItemRoundData> ItemRound;
//   OrderItemData({
//     this.id,
//     this.cover,
//     this.name,
//     this.status,
//     this.startDate,
//     this.ItemRound,
//   });

//   OrderItemData copyWith({
//     int id,
//     String cover,
//     String name,
//     String status,
//     String startDate,
//     List<OrderItemRoundData> ItemRound,
//   }) {
//     return OrderItemData(
//       id: id ?? this.id,
//       cover: cover ?? this.cover,
//       name: name ?? this.name,
//       status: status ?? this.status,
//       startDate: startDate ?? this.startDate,
//       ItemRound: ItemRound ?? this.ItemRound,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'cover': cover,
//       'name': name,
//       'status': status,
//       'startDate': startDate,
//       'ItemRound': ItemRound?.map((x) => x?.toMap())?.toList(),
//     };
//   }

//   factory OrderItemData.fromMap(Map<String, dynamic> map) {
//     if (map == null) return null;

//     return OrderItemData(
//       id: map['id'],
//       cover: map['cover'],
//       name: map['name'],
//       status: map['status'],
//       startDate: map['startDate'],
//       ItemRound: List<OrderItemRoundData>.from(map['ItemRound']?.map((x) => OrderItemRoundData.fromMap(x))),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory OrderItemData.fromJson(String source) => OrderItemData.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'OrderItemData(id: $id, cover: $cover, name: $name, status: $status, startDate: $startDate, ItemRound: $ItemRound)';
//   }

//   @override
//   bool operator ==(Object o) {
//     if (identical(this, o)) return true;

//     return o is OrderItemData &&
//         o.id == id &&
//         o.cover == cover &&
//         o.name == name &&
//         o.status == status &&
//         o.startDate == startDate &&
//         listEquals(o.ItemRound, ItemRound);
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^ cover.hashCode ^ name.hashCode ^ status.hashCode ^ startDate.hashCode ^ ItemRound.hashCode;
//   }
// }

class OrderSocialing {
  int id;
  String cover;
  String name;
  String location;
  String startDate;
  String status;
  OrderSocialing({
    this.id,
    this.cover,
    this.name,
    this.location,
    this.startDate,
    this.status,
  });

  OrderSocialing copyWith({
    int id,
    String cover,
    String name,
    String location,
    String startDate,
    String status,
  }) {
    return OrderSocialing(
      id: id ?? this.id,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cover': cover,
      'name': name,
      'location': location,
      'startDate': startDate,
      'status': status,
    };
  }

  factory OrderSocialing.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderSocialing(
      id: map['id'],
      cover: map['cover'],
      name: map['name'],
      location: map['location'],
      startDate: map['startDate'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderSocialing.fromJson(String source) =>
      OrderSocialing.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderSocialing(id: $id, cover: $cover, name: $name, location: $location, startDate: $startDate, status: $status)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderSocialing &&
        o.id == id &&
        o.cover == cover &&
        o.name == name &&
        o.location == location &&
        o.startDate == startDate &&
        o.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cover.hashCode ^
        name.hashCode ^
        location.hashCode ^
        startDate.hashCode ^
        status.hashCode;
  }
}

class OrderHistoryDetailData {
  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String orderClaim;
  int orderId;
  String memo;
  OrderHistoryDataData data;
  List<OrerUserReservesMoneyData> UserReservesMoney;
  OrderHistoryDetailData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.orderClaim,
    this.orderId,
    this.memo,
    this.data,
    this.UserReservesMoney,
  });

  OrderHistoryDetailData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String orderClaim,
    int orderId,
    String memo,
    OrderHistoryDataData data,
    List<OrerUserReservesMoneyData> UserReservesMoney,
  }) {
    return OrderHistoryDetailData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      orderClaim: orderClaim ?? this.orderClaim,
      orderId: orderId ?? this.orderId,
      memo: memo ?? this.memo,
      data: data ?? this.data,
      UserReservesMoney: UserReservesMoney ?? this.UserReservesMoney,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'orderClaim': orderClaim,
      'orderId': orderId,
      'memo': memo,
      'data': data?.toMap(),
      'UserReservesMoney': UserReservesMoney?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory OrderHistoryDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderHistoryDetailData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      orderClaim: map['orderClaim'],
      orderId: map['orderId'],
      memo: map['memo'],
      data: OrderHistoryDataData.fromMap(map['data']),
      UserReservesMoney: List<OrerUserReservesMoneyData>.from(
          map['UserReservesMoney']
              ?.map((x) => OrerUserReservesMoneyData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderHistoryDetailData.fromJson(String source) =>
      OrderHistoryDetailData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderHistoryDetailData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, orderClaim: $orderClaim, orderId: $orderId, memo: $memo, data: $data, UserReservesMoney: $UserReservesMoney)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderHistoryDetailData &&
        o.id == id &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.deletedAt == deletedAt &&
        o.orderClaim == orderClaim &&
        o.orderId == orderId &&
        o.memo == memo &&
        o.data == data &&
        listEquals(o.UserReservesMoney, UserReservesMoney);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        orderClaim.hashCode ^
        orderId.hashCode ^
        memo.hashCode ^
        data.hashCode ^
        UserReservesMoney.hashCode;
  }
}

class OrderHistoryDataData {
  String pg;
  String name;
  String unit;
  int price;
  String method;
  int stauts;
  String pg_name;
  String orderPid;
  int tax_free;
  String item_name;
  String status_en;
  String status_ko;
  String receipt_id;
  String method_name;
  String receipt_url;
  OrderhistoryDataPaymentData payment_data;
  String purchased_at;
  int remain_price;
  String requested_at;
  int cancelled_price;
  int remain_tax_free;
  int cancelled_tax_free;
  OrderHistoryDataData({
    this.pg,
    this.name,
    this.unit,
    this.price,
    this.method,
    this.stauts,
    this.pg_name,
    this.orderPid,
    this.tax_free,
    this.item_name,
    this.status_en,
    this.status_ko,
    this.receipt_id,
    this.method_name,
    this.receipt_url,
    this.payment_data,
    this.purchased_at,
    this.remain_price,
    this.requested_at,
    this.cancelled_price,
    this.remain_tax_free,
    this.cancelled_tax_free,
  });

  OrderHistoryDataData copyWith({
    String pg,
    String name,
    String unit,
    int price,
    String method,
    int stauts,
    String pg_name,
    String orderPid,
    int tax_free,
    String item_name,
    String status_en,
    String status_ko,
    String receipt_id,
    String method_name,
    String receipt_url,
    OrderhistoryDataPaymentData payment_data,
    String purchased_at,
    int remain_price,
    String requested_at,
    int cancelled_price,
    int remain_tax_free,
    int cancelled_tax_free,
  }) {
    return OrderHistoryDataData(
      pg: pg ?? this.pg,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      method: method ?? this.method,
      stauts: stauts ?? this.stauts,
      pg_name: pg_name ?? this.pg_name,
      orderPid: orderPid ?? this.orderPid,
      tax_free: tax_free ?? this.tax_free,
      item_name: item_name ?? this.item_name,
      status_en: status_en ?? this.status_en,
      status_ko: status_ko ?? this.status_ko,
      receipt_id: receipt_id ?? this.receipt_id,
      method_name: method_name ?? this.method_name,
      receipt_url: receipt_url ?? this.receipt_url,
      payment_data: payment_data ?? this.payment_data,
      purchased_at: purchased_at ?? this.purchased_at,
      remain_price: remain_price ?? this.remain_price,
      requested_at: requested_at ?? this.requested_at,
      cancelled_price: cancelled_price ?? this.cancelled_price,
      remain_tax_free: remain_tax_free ?? this.remain_tax_free,
      cancelled_tax_free: cancelled_tax_free ?? this.cancelled_tax_free,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pg': pg,
      'name': name,
      'unit': unit,
      'price': price,
      'method': method,
      'stauts': stauts,
      'pg_name': pg_name,
      'orderPid': orderPid,
      'tax_free': tax_free,
      'item_name': item_name,
      'status_en': status_en,
      'status_ko': status_ko,
      'receipt_id': receipt_id,
      'method_name': method_name,
      'receipt_url': receipt_url,
      'payment_data': payment_data?.toMap(),
      'purchased_at': purchased_at,
      'remain_price': remain_price,
      'requested_at': requested_at,
      'cancelled_price': cancelled_price,
      'remain_tax_free': remain_tax_free,
      'cancelled_tax_free': cancelled_tax_free,
    };
  }

  factory OrderHistoryDataData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderHistoryDataData(
      pg: map['pg'],
      name: map['name'],
      unit: map['unit'],
      price: map['price'],
      method: map['method'],
      stauts: map['stauts'],
      pg_name: map['pg_name'],
      orderPid: map['orderPid'],
      tax_free: map['tax_free'],
      item_name: map['item_name'],
      status_en: map['status_en'],
      status_ko: map['status_ko'],
      receipt_id: map['receipt_id'],
      method_name: map['method_name'],
      receipt_url: map['receipt_url'],
      payment_data: OrderhistoryDataPaymentData.fromMap(map['payment_data']),
      purchased_at: map['purchased_at'],
      remain_price: map['remain_price'],
      requested_at: map['requested_at'],
      cancelled_price: map['cancelled_price'],
      remain_tax_free: map['remain_tax_free'],
      cancelled_tax_free: map['cancelled_tax_free'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderHistoryDataData.fromJson(String source) =>
      OrderHistoryDataData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderHistoryDataData(pg: $pg, name: $name, unit: $unit, price: $price, method: $method, stauts: $stauts, pg_name: $pg_name, orderPid: $orderPid, tax_free: $tax_free, item_name: $item_name, status_en: $status_en, status_ko: $status_ko, receipt_id: $receipt_id, method_name: $method_name, receipt_url: $receipt_url, payment_data: $payment_data, purchased_at: $purchased_at, remain_price: $remain_price, requested_at: $requested_at, cancelled_price: $cancelled_price, remain_tax_free: $remain_tax_free, cancelled_tax_free: $cancelled_tax_free)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderHistoryDataData &&
        o.pg == pg &&
        o.name == name &&
        o.unit == unit &&
        o.price == price &&
        o.method == method &&
        o.stauts == stauts &&
        o.pg_name == pg_name &&
        o.orderPid == orderPid &&
        o.tax_free == tax_free &&
        o.item_name == item_name &&
        o.status_en == status_en &&
        o.status_ko == status_ko &&
        o.receipt_id == receipt_id &&
        o.method_name == method_name &&
        o.receipt_url == receipt_url &&
        o.payment_data == payment_data &&
        o.purchased_at == purchased_at &&
        o.remain_price == remain_price &&
        o.requested_at == requested_at &&
        o.cancelled_price == cancelled_price &&
        o.remain_tax_free == remain_tax_free &&
        o.cancelled_tax_free == cancelled_tax_free;
  }

  @override
  int get hashCode {
    return pg.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        method.hashCode ^
        stauts.hashCode ^
        pg_name.hashCode ^
        orderPid.hashCode ^
        tax_free.hashCode ^
        item_name.hashCode ^
        status_en.hashCode ^
        status_ko.hashCode ^
        receipt_id.hashCode ^
        method_name.hashCode ^
        receipt_url.hashCode ^
        payment_data.hashCode ^
        purchased_at.hashCode ^
        remain_price.hashCode ^
        requested_at.hashCode ^
        cancelled_price.hashCode ^
        remain_tax_free.hashCode ^
        cancelled_tax_free.hashCode;
  }
}

class OrderhistoryDataPaymentData {
  int g;
  String n;
  int p;
  int s;
  String pg;
  String pm;
  String tid;
  String o_id;
  String p_at;
  String pg_a;
  String r_at;
  String receipt_id;
  OrderhistoryDataPaymentData({
    this.g,
    this.n,
    this.p,
    this.s,
    this.pg,
    this.pm,
    this.tid,
    this.o_id,
    this.p_at,
    this.pg_a,
    this.r_at,
    this.receipt_id,
  });

  OrderhistoryDataPaymentData copyWith({
    int g,
    String n,
    int p,
    int s,
    String pg,
    String pm,
    String tid,
    String o_id,
    String p_at,
    String pg_a,
    String r_at,
    String receipt_id,
  }) {
    return OrderhistoryDataPaymentData(
      g: g ?? this.g,
      n: n ?? this.n,
      p: p ?? this.p,
      s: s ?? this.s,
      pg: pg ?? this.pg,
      pm: pm ?? this.pm,
      tid: tid ?? this.tid,
      o_id: o_id ?? this.o_id,
      p_at: p_at ?? this.p_at,
      pg_a: pg_a ?? this.pg_a,
      r_at: r_at ?? this.r_at,
      receipt_id: receipt_id ?? this.receipt_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'g': g,
      'n': n,
      'p': p,
      's': s,
      'pg': pg,
      'pm': pm,
      'tid': tid,
      'o_id': o_id,
      'p_at': p_at,
      'pg_a': pg_a,
      'r_at': r_at,
      'receipt_id': receipt_id,
    };
  }

  factory OrderhistoryDataPaymentData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OrderhistoryDataPaymentData(
      g: map['g'],
      n: map['n'],
      p: map['p'],
      s: map['s'],
      pg: map['pg'],
      pm: map['pm'],
      tid: map['tid'],
      o_id: map['o_id'],
      p_at: map['p_at'],
      pg_a: map['pg_a'],
      r_at: map['r_at'],
      receipt_id: map['receipt_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderhistoryDataPaymentData.fromJson(String source) =>
      OrderhistoryDataPaymentData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderhistoryDataPaymentData(g: $g, n: $n, p: $p, s: $s, pg: $pg, pm: $pm, tid: $tid, o_id: $o_id, p_at: $p_at, pg_a: $pg_a, r_at: $r_at, receipt_id: $receipt_id)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrderhistoryDataPaymentData &&
        o.g == g &&
        o.n == n &&
        o.p == p &&
        o.s == s &&
        o.pg == pg &&
        o.pm == pm &&
        o.tid == tid &&
        o.o_id == o_id &&
        o.p_at == p_at &&
        o.pg_a == pg_a &&
        o.r_at == r_at &&
        o.receipt_id == receipt_id;
  }

  @override
  int get hashCode {
    return g.hashCode ^
        n.hashCode ^
        p.hashCode ^
        s.hashCode ^
        pg.hashCode ^
        pm.hashCode ^
        tid.hashCode ^
        o_id.hashCode ^
        p_at.hashCode ^
        pg_a.hashCode ^
        r_at.hashCode ^
        receipt_id.hashCode;
  }
}

// {
//   “id”: 173,
//   “createdAt”: “2020-12-21T13:47:24.159Z”,
//   “updatedAt”: “2020-12-21T13:47:24.159Z”,
//   “deletedAt”: null,
//   “paymentId”: “20201221RMCNR66",
//   “receiptId”: “12345",
//   “orderKind”: “CARD”,
//   “userId”: 21924,
//   “price”: 10000,
//   “data”: null,
//   “memo”: null,
//   “UserReservesMoney”: [],
//   “Order”: [
//     {
//       “id”: 7308,
//       “Item”: {
//         “id”: 5336,
//         “cover”: “https://munto-images.s3.amazonaws.com/dev-item/1608185932363-cover-%25EC%25BA%25A1%25EC%25B2%2598.JPG”,
//         “name”: “기림님과 정기모임 테스트“,
//         “location”: “HAPJEONG”,
//         “status”: “RECRUITING”,
//         “startDate”: “2020-12-30T00:00:00.000Z”,
//         “ItemRound”: [
//           {
//             “id”: 9113,
//             “createdAt”: “2020-12-17T06:18:53.370Z”,
//             “updatedAt”: “2020-12-18T09:32:45.431Z”,
//             “deletedAt”: null,
//             “itemId”: 5336,
//             “round”: 1,
//             “place”: “HAPJEONG”,
//             “startDate”: “2020-12-10T00:00:00.000Z”,
//             “finishDate”: “2020-12-10T00:00:00.000Z”,
//             “howPlayingTitle”: null,
//             “howPlayingDescription”: null,
//             “howPlayingThumbnail”: null,
//             “showHowPlaying”: true,
//             “curriculumTitle”: “1회차 커리큘럼“,
//             “curriculumDescription”: “1회차 설명“,
//             “curriculumThumbnail”: “https://munto-images.s3.amazonaws.com/dev-item/1608260187145-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20curriculumThumbnail-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%201-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%25EC%2597%25A3%25EC%25B7%25BD.JPG”,
//             “showCurriculum”: false,
//             “mpassPrice”: 10000
//           },
//           {
//             “id”: 9114,
//             “createdAt”: “2020-12-17T06:18:53.370Z”,
//             “updatedAt”: “2020-12-18T09:32:45.431Z”,
//             “deletedAt”: null,
//             “itemId”: 5336,
//             “round”: 2,
//             “place”: “HAPJEONG”,
//             “startDate”: “2020-12-11T00:00:00.000Z”,
//             “finishDate”: “2020-12-11T00:00:00.000Z”,
//             “howPlayingTitle”: null,
//             “howPlayingDescription”: null,
//             “howPlayingThumbnail”: null,
//             “showHowPlaying”: true,
//             “curriculumTitle”: “2회차 커리큘럼“,
//             “curriculumDescription”: “2회차 설명“,
//             “curriculumThumbnail”: “https://munto-images.s3.ap-northeast-2.amazonaws.com/dev-item/1608260187398-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20curriculumThumbnail-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%202-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%25EC%259A%2594%25EC%25A7%2580.JPG”,
//             “showCurriculum”: false,
//             “mpassPrice”: 10000
//           },
//           {
//             “id”: 9115,
//             “createdAt”: “2020-12-17T06:18:53.370Z”,
//             “updatedAt”: “2020-12-18T09:32:45.431Z”,
//             “deletedAt”: null,
//             “itemId”: 5336,
//             “round”: 3,
//             “place”: “HAPJEONG”,
//             “startDate”: “2020-12-14T00:00:00.000Z”,
//             “finishDate”: “2020-12-14T00:00:00.000Z”,
//             “howPlayingTitle”: null,
//             “howPlayingDescription”: null,
//             “howPlayingThumbnail”: null,
//             “showHowPlaying”: true,
//             “curriculumTitle”: “3회차 커리큘럼“,
//             “curriculumDescription”: “3회차 설명“,
//             “curriculumThumbnail”: null,
//             “showCurriculum”: false,
//             “mpassPrice”: 10000
//           },
//           {
//             “id”: 9116,
//             “createdAt”: “2020-12-17T06:18:53.370Z”,
//             “updatedAt”: “2020-12-18T09:32:45.431Z”,
//             “deletedAt”: null,
//             “itemId”: 5336,
//             “round”: 4,
//             “place”: “HAPJEONG”,
//             “startDate”: “2020-12-17T00:00:00.000Z”,
//             “finishDate”: “2020-12-17T00:00:00.000Z”,
//             “howPlayingTitle”: null,
//             “howPlayingDescription”: null,
//             “howPlayingThumbnail”: null,
//             “showHowPlaying”: true,
//             “curriculumTitle”: “4회차 커리큘럼“,
//             “curriculumDescription”: “4회차 설명“,
//             “curriculumThumbnail”: null,
//             “showCurriculum”: false,
//             “mpassPrice”: 10000
//           }
//         ]
//       },
//       “ItemRound”: null,
//       “Socialing”: null,
//       “OrderHistory”: [
//         {
//           “id”: 728,
//           “createdAt”: “2020-12-21T13:47:24.307Z”,
//           “updatedAt”: “2020-12-21T13:47:24.308Z”,
//           “deletedAt”: null,
//           “orderClaim”: null,
//           “orderStatus”: “FAILED_PAYMENT”,
//           “orderId”: 7308,
//           “memo”: “{\“status\“:500,\“code\“:-2100,\“message\“:\“해당 결제 내역을 찾지 못했습니다.\“}”,
//           “data”: null,
//           “UserReservesMoney”: []
//         },
//         {
//           “id”: 727,
//           “createdAt”: “2020-12-21T13:47:24.171Z”,
//           “updatedAt”: “2020-12-21T13:47:24.172Z”,
//           “deletedAt”: null,
//           “orderClaim”: null,
//           “orderStatus”: “NONE”,
//           “orderId”: 7308,
//           “memo”: null,
//           “data”: null,
//           “UserReservesMoney”: []
//         }
//       ],
//       “orderKind”: “CARD”,
//       “orderStatus”: “FAILED_PAYMENT”,
//       “orderClaim”: null,
//       “orderPrice”: 10000,
//       “orderDate”: “2020-12-21T13:47:24.304Z”,
//       “UserCoupon”: null,
//       “isAvailableRefund”: false
//     }
//   ]
// }
