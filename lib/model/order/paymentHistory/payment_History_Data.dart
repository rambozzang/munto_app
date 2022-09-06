import 'dart:convert';

List<PaymentHistoryData> PaymentHistoryDataFromJson(String str) =>
    List<PaymentHistoryData>.from(
        json.decode(str).map((x) => PaymentHistoryData.fromJson(x)));

String PaymentHistoryDataToJson(List<PaymentHistoryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentHistoryData {
  PaymentHistoryData({
    this.id,
    this.item,
    this.itemRound,
    this.socialing,
    this.orderStatus,
    this.orderClaim,
    this.orderPrice,
    this.orderDate,
    this.userCoupon,
    this.orderKind,
    this.paymentId,
    this.purchasedAt,
    this.isAvailableRefund,
    this.orderHistory,
  });

  int id;
  Item item;
  PaymentHistoryDataItemRound itemRound;
  Item socialing;
  OrderStatus orderStatus;
  dynamic orderClaim;
  int orderPrice;
  DateTime orderDate;
  dynamic userCoupon;
  OrderKind orderKind;
  String paymentId;
  DateTime purchasedAt;
  bool isAvailableRefund;
  List<OrderHistory> orderHistory;

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryData(
        id: json["id"],
        item: json["Item"] == null ? null : Item.fromJson(json["Item"]),
        itemRound: json["ItemRound"] == null
            ? null
            : PaymentHistoryDataItemRound.fromJson(json["ItemRound"]),
        socialing:
            json["Socialing"] == null ? null : Item.fromJson(json["Socialing"]),
        orderStatus: orderStatusValues.map[json["orderStatus"]],
        orderClaim: json["orderClaim"],
        orderPrice: json["orderPrice"] == null ? null : json["orderPrice"],
        orderDate: DateTime.parse(json["orderDate"]),
        userCoupon: json["UserCoupon"],
        orderKind: orderKindValues.map[json["orderKind"]],
        paymentId: json["paymentId"],
        purchasedAt: DateTime.parse(json["purchasedAt"]),
        isAvailableRefund: json["isAvailableRefund"],
        orderHistory: List<OrderHistory>.from(
            json["OrderHistory"].map((x) => OrderHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Item": item == null ? null : item.toJson(),
        "ItemRound": itemRound == null ? null : itemRound.toJson(),
        "Socialing": socialing == null ? null : socialing.toJson(),
        "orderStatus": orderStatusValues.reverse[orderStatus],
        "orderClaim": orderClaim,
        "orderPrice": orderPrice == null ? null : orderPrice,
        "orderDate": orderDate.toIso8601String(),
        "UserCoupon": userCoupon,
        "orderKind": orderKindValues.reverse[orderKind],
        "paymentId": paymentId,
        "purchasedAt": purchasedAt.toIso8601String(),
        "isAvailableRefund": isAvailableRefund,
        "OrderHistory": List<dynamic>.from(orderHistory.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.cover,
    this.name,
    this.location,
    this.status,
    this.startDate,
    this.itemRound,
  });

  int id;
  String cover;
  String name;
  String location;
  Status status;
  DateTime startDate;
  List<ItemRoundElement> itemRound;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        cover: json["cover"],
        name: json["name"],
        location: json["location"],
        status: statusValues.map[json["status"]],
        startDate: DateTime.parse(json["startDate"]),
        itemRound: json["ItemRound"] == null
            ? null
            : List<ItemRoundElement>.from(
                json["ItemRound"].map((x) => ItemRoundElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cover": cover,
        "name": name,
        "location": location,
        "status": statusValues.reverse[status],
        "startDate": startDate.toIso8601String(),
        "ItemRound": itemRound == null
            ? null
            : List<dynamic>.from(itemRound.map((x) => x.toJson())),
      };
}

class ItemRoundElement {
  ItemRoundElement({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.itemId,
    this.round,
    this.place,
    this.startDate,
    this.finishDate,
    this.howPlayingTitle,
    this.howPlayingDescription,
    this.howPlayingThumbnail,
    this.showHowPlaying,
    this.curriculumTitle,
    this.curriculumDescription,
    this.curriculumThumbnail,
    this.showCurriculum,
    this.mpassPrice,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;
  int itemId;
  int round;
  Location place;
  DateTime startDate;
  DateTime finishDate;
  dynamic howPlayingTitle;
  dynamic howPlayingDescription;
  dynamic howPlayingThumbnail;
  bool showHowPlaying;
  String curriculumTitle;
  String curriculumDescription;
  String curriculumThumbnail;
  bool showCurriculum;
  int mpassPrice;

  factory ItemRoundElement.fromJson(Map<String, dynamic> json) =>
      ItemRoundElement(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"] == null
            ? null
            : DateTime.parse(json["deletedAt"]),
        itemId: json["itemId"],
        round: json["round"],
        place: locationValues.map[json["place"]],
        startDate: DateTime.parse(json["startDate"]),
        finishDate: DateTime.parse(json["finishDate"]),
        howPlayingTitle: json["howPlayingTitle"],
        howPlayingDescription: json["howPlayingDescription"],
        howPlayingThumbnail: json["howPlayingThumbnail"],
        showHowPlaying: json["showHowPlaying"],
        curriculumTitle: json["curriculumTitle"],
        curriculumDescription: json["curriculumDescription"],
        curriculumThumbnail: json["curriculumThumbnail"] == null
            ? null
            : json["curriculumThumbnail"],
        showCurriculum: json["showCurriculum"],
        mpassPrice: json["mpassPrice"] == null ? null : json["mpassPrice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt == null ? null : deletedAt.toIso8601String(),
        "itemId": itemId,
        "round": round,
        "place": locationValues.reverse[place],
        "startDate": startDate.toIso8601String(),
        "finishDate": finishDate.toIso8601String(),
        "howPlayingTitle": howPlayingTitle,
        "howPlayingDescription": howPlayingDescription,
        "howPlayingThumbnail": howPlayingThumbnail,
        "showHowPlaying": showHowPlaying,
        "curriculumTitle": curriculumTitle,
        "curriculumDescription": curriculumDescription,
        "curriculumThumbnail":
            curriculumThumbnail == null ? null : curriculumThumbnail,
        "showCurriculum": showCurriculum,
        "mpassPrice": mpassPrice == null ? null : mpassPrice,
      };
}

enum Location { HAPJEONG }

final locationValues = EnumValues({"HAPJEONG": Location.HAPJEONG});

enum Status { PLAYING, RECRUITING, STOPPED_RECRUITMENT, CONFIRM_PLAYING }

final statusValues = EnumValues({
  "CONFIRM_PLAYING": Status.CONFIRM_PLAYING,
  "PLAYING": Status.PLAYING,
  "RECRUITING": Status.RECRUITING,
  "STOPPED_RECRUITMENT": Status.STOPPED_RECRUITMENT
});

class PaymentHistoryDataItemRound {
  PaymentHistoryDataItemRound({
    this.id,
    this.startDate,
    this.finishDate,
    this.round,
    this.item,
  });

  int id;
  DateTime startDate;
  DateTime finishDate;
  int round;
  ItemRoundItem item;

  factory PaymentHistoryDataItemRound.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryDataItemRound(
        id: json["id"],
        startDate: DateTime.parse(json["startDate"]),
        finishDate: DateTime.parse(json["finishDate"]),
        round: json["round"],
        item: ItemRoundItem.fromJson(json["Item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate.toIso8601String(),
        "finishDate": finishDate.toIso8601String(),
        "round": round,
        "Item": item.toJson(),
      };
}

class ItemRoundItem {
  ItemRoundItem({
    this.cover,
    this.name,
    this.location,
    this.startDate,
  });

  String cover;
  String name;
  Location location;
  DateTime startDate;

  factory ItemRoundItem.fromJson(Map<String, dynamic> json) => ItemRoundItem(
        cover: json["cover"],
        name: json["name"],
        location: locationValues.map[json["location"]],
        startDate: DateTime.parse(json["startDate"]),
      );

  Map<String, dynamic> toJson() => {
        "cover": cover,
        "name": name,
        "location": locationValues.reverse[location],
        "startDate": startDate.toIso8601String(),
      };
}

class OrderHistory {
  OrderHistory({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.orderClaim,
    this.orderStatus,
    this.orderId,
    this.memo,
    this.data,
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic orderClaim;
  OrderStatus orderStatus;
  int orderId;
  Memo memo;
  Data data;

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
        orderClaim: json["orderClaim"],
        orderStatus: orderStatusValues.map[json["orderStatus"]],
        orderId: json["orderId"],
        memo: json["memo"] == null ? null : memoValues.map[json["memo"]],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "deletedAt": deletedAt,
        "orderClaim": orderClaim,
        "orderStatus": orderStatusValues.reverse[orderStatus],
        "orderId": orderId,
        "memo": memo == null ? null : memoValues.reverse[memo],
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.pg,
    this.name,
    this.unit,
    this.price,
    this.method,
    this.status,
    this.pgName,
    this.orderId,
    this.taxFree,
    this.itemName,
    this.statusEn,
    this.statusKo,
    this.receiptId,
    this.methodName,
    this.receiptUrl,
    this.paymentData,
    this.purchasedAt,
    this.remainPrice,
    this.requestedAt,
    this.cancelledPrice,
    this.remainTaxFree,
    this.cancelledTaxFree,
  });

  String pg;
  String name;
  String unit;
  int price;
  String method;
  int status;
  String pgName;
  String orderId;
  int taxFree;
  String itemName;
  String statusEn;
  String statusKo;
  String receiptId;
  String methodName;
  String receiptUrl;
  PaymentData paymentData;
  DateTime purchasedAt;
  int remainPrice;
  DateTime requestedAt;
  int cancelledPrice;
  int remainTaxFree;
  int cancelledTaxFree;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pg: json["pg"],
        name: json["name"],
        unit: json["unit"],
        price: json["price"],
        method: json["method"],
        status: json["status"],
        pgName: json["pg_name"],
        orderId: json["order_id"],
        taxFree: json["tax_free"],
        itemName: json["item_name"],
        statusEn: json["status_en"],
        statusKo: json["status_ko"],
        receiptId: json["receipt_id"],
        methodName: json["method_name"],
        receiptUrl: json["receipt_url"],
        paymentData: PaymentData.fromJson(json["payment_data"]),
        purchasedAt: DateTime.parse(json["purchased_at"]),
        remainPrice: json["remain_price"],
        requestedAt: DateTime.parse(json["requested_at"]),
        cancelledPrice: json["cancelled_price"],
        remainTaxFree: json["remain_tax_free"],
        cancelledTaxFree: json["cancelled_tax_free"],
      );

  Map<String, dynamic> toJson() => {
        "pg": pg,
        "name": name,
        "unit": unit,
        "price": price,
        "method": method,
        "status": status,
        "pg_name": pgName,
        "order_id": orderId,
        "tax_free": taxFree,
        "item_name": itemName,
        "status_en": statusEn,
        "status_ko": statusKo,
        "receipt_id": receiptId,
        "method_name": methodName,
        "receipt_url": receiptUrl,
        "payment_data": paymentData.toJson(),
        "purchased_at": purchasedAt.toIso8601String(),
        "remain_price": remainPrice,
        "requested_at": requestedAt.toIso8601String(),
        "cancelled_price": cancelledPrice,
        "remain_tax_free": remainTaxFree,
        "cancelled_tax_free": cancelledTaxFree,
      };
}

class PaymentData {
  PaymentData({
    this.g,
    this.n,
    this.p,
    this.s,
    this.pg,
    this.pm,
    this.tid,
    this.oId,
    this.pAt,
    this.pgA,
    this.pmA,
    this.cardNo,
    this.cardCode,
    this.cardName,
    this.cardQuota,
    this.receiptId,
    this.cardAuthNo,
    this.rAt,
  });

  int g;
  String n;
  int p;
  int s;
  String pg;
  String pm;
  String tid;
  String oId;
  DateTime pAt;
  String pgA;
  String pmA;
  String cardNo;
  String cardCode;
  String cardName;
  String cardQuota;
  String receiptId;
  String cardAuthNo;
  dynamic rAt;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        g: json["g"],
        n: json["n"],
        p: json["p"],
        s: json["s"],
        pg: json["pg"],
        pm: json["pm"],
        tid: json["tid"],
        oId: json["o_id"],
        pAt: DateTime.parse(json["p_at"]),
        pgA: json["pg_a"],
        pmA: json["pm_a"],
        cardNo: json["card_no"] == null ? null : json["card_no"],
        cardCode: json["card_code"] == null ? null : json["card_code"],
        cardName: json["card_name"] == null ? null : json["card_name"],
        cardQuota: json["card_quota"] == null ? null : json["card_quota"],
        receiptId: json["receipt_id"],
        cardAuthNo: json["card_auth_no"] == null ? null : json["card_auth_no"],
        rAt: json["r_at"],
      );

  Map<String, dynamic> toJson() => {
        "g": g,
        "n": n,
        "p": p,
        "s": s,
        "pg": pg,
        "pm": pm,
        "tid": tid,
        "o_id": oId,
        "p_at": pAt.toIso8601String(),
        "pg_a": pgA,
        "pm_a": pmA,
        "card_no": cardNo == null ? null : cardNo,
        "card_code": cardCode == null ? null : cardCode,
        "card_name": cardName == null ? null : cardName,
        "card_quota": cardQuota == null ? null : cardQuota,
        "receipt_id": receiptId,
        "card_auth_no": cardAuthNo == null ? null : cardAuthNo,
        "r_at": rAt,
      };
}

enum Memo { INVALID_CLASS, STATUS_500_CODE_2100_MESSAGE }

final memoValues = EnumValues({
  "INVALID_CLASS": Memo.INVALID_CLASS,
  "{\"status\":500,\"code\":-2100,\"message\":\"해당 결제 내역을 찾지 못했습니다.\"}":
      Memo.STATUS_500_CODE_2100_MESSAGE
});

enum OrderStatus { FAILED_PAYMENT, NONE, COMPLETED_PAYMENT }

final orderStatusValues = EnumValues({
  "COMPLETED_PAYMENT": OrderStatus.COMPLETED_PAYMENT,
  "FAILED_PAYMENT": OrderStatus.FAILED_PAYMENT,
  "NONE": OrderStatus.NONE
});

enum OrderKind { NO_PAYMENT, FREE, CARD }

final orderKindValues = EnumValues({
  "CARD": OrderKind.CARD,
  "FREE": OrderKind.FREE,
  "NO_PAYMENT": OrderKind.NO_PAYMENT
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
