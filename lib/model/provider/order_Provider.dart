import 'package:munto_app/model/order/bootpay_Data.dart';
import 'package:munto_app/model/order/order_basket_Data.dart';
import 'package:munto_app/model/order/order_isValid_Data.dart';
import 'package:munto_app/model/order/order_items_data.dart';
import 'package:munto_app/model/order/paymentHistory/payment_History_Data.dart';
import 'package:munto_app/model/order/paymentid_Data.dart';
import 'package:munto_app/model/provider/Socialing_Pick_Return_Data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import 'package:munto_app/model/order/order_History_Data.dart';

class OrderProver extends ParentProvider {
  ApiService _api = ApiService();

  //1 합계금액
  int totalAmt = 0;
  int get getTotalAmt => totalAmt;
  setTotalAmt(bl) {
    totalAmt = bl;
    notifyListeners();
  }

  //2 혜택금액
  int benefitAmt = 0;
  int get getBenefitAmt => benefitAmt;
  setBenefitAmt(bl) {
    benefitAmt = bl;
    notifyListeners();
  }

  //3 적립금
  int reserveMoney = 0;
  int get getReserveMoney => reserveMoney;
  setReserveMoney(bl) {
    reserveMoney = bl;
    notifyListeners();
  }

  //4 적립금 사용할 금액
  int reserveUseMoney = 0;
  int get getReserveUseMoney => reserveUseMoney;
  setReserveUseMoney(bl) {
    reserveUseMoney = bl;
    notifyListeners();
  }

  //5 총합계금액
  int payTotalAmt = 0;
  int get getPayTotalAmt => payTotalAmt;
  setPayTotalAmt(bl) {
    payTotalAmt = bl;
    notifyListeners();
  }

  // 결재할 리스트 항목
  List<OrderBasketData> _orderDataList = [];
  List<OrderBasketData> get getOrderDataList => this._orderDataList;
  setOrderDataList(OrderBasketData data) {
    _orderDataList.add(data);
    notifyListeners();
  }

  // Method    : POST
  // url       : /api/order/bootpay/card
  // 사용페이지   :
  Future<dynamic> postOrderBootpayCard(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/bootpay/card";
    final response = await _api.post(_callUri, _map);
    return response;
  }

  // Method    : POST
  // url       : /api/order/item
  // 사용페이지   :

  Future<SocialingPickReturnData> postOrderItem(
      Map<String, dynamic> _map) async {
    final _callUri = "/api/order/item";
    final response = await _api.post(_callUri, _map);
    // 리턴값 : {"id":52,"createdAt":"2020-10-18T15:24:56.973Z","updatedAt":"2020-10-18T15:24:56.974Z","deletedAt":null,"userId":21924,"itemId":null,"socialingId":105,"orderStatus":"COMPLETE_PAYMENT","orderClaim":null}

    return SocialingPickReturnData.fromMap(response);
  }

  // Method    : POST
  // url       : /api/order/socialing
  // 사용페이지   :
  Future<dynamic> postOrderSocialing(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/socialing";
    final response = await _api.post(_callUri, _map);
    return response;
  }

  // Method    : POST
  // url       : /api/order/basket
  // 사용페이지   :
  Future<dynamic> postOrderBasket(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/basket";
    final response = await _api.post(_callUri, _map);

    return response;
  }

  // Method    : get
  // url       : /api/order/basket
  // 사용페이지   :
  Future<List<OrderBasketData>> getOrderBasket() async {
    final _callUri = "/api/order/basket";
    final response = await _api.get(_callUri);
    List<OrderBasketData> list = (response as List)
        .map((data) => OrderBasketData.fromMap(data))
        .toList();
    return list;
  }

  // Method    : DELETE
  // url       : /api/order/basket List<basketID>
  // 사용페이지   :
  Future<dynamic> deleteOrderBasket2(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/basket";
    final response = await _api.delete(_callUri, _map);
    return response;
  }

// Method    : POST
  // url       : /api/order/basket/{classType}/{classId}
  // 사용페이지   :
  Future<dynamic> deleteOrderBasket(String classType, String classId) async {
    Map<String, dynamic> _map = Map();
    final _callUri = "/api/order/basket/$classType/$classId";
    final response = await _api.delete(_callUri, _map);
    return response;
  }

  // Method    : GET
  // url       : /api/order/basket List<itemss> , List<spcialings>
  // http://54.180.101.226/api/docs/#/Order/OrderController_getClassInfoForOrder
  // 사용페이지   :
  Future<dynamic> getOrder(List<String> items, List<String> socialings) async {
    // items=1&items=2&socialings=3&socialings=4
    String itemslist = "";
    String socialinglist = "";
    for (var val1 in items) {
      itemslist = itemslist + "&items=" + val1;
    }
    for (var val2 in socialings) {
      socialinglist = socialinglist + "&socialings=" + val2;
    }
    print("itemslist = $itemslist");
    print("socialinglist = $socialinglist");

    final _callUri = "/api/order?items=";
    final response = await _api.get(_callUri);
    return response;
  }

  // 쇼셜링 상세 페이지 에서 사용  socialing_detail_page.dart
  // 하트 클릭시
  Future<SocialingPickReturnData> savePick(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/socialing";
    final response = await _api.post(_callUri, _map);
    // 리턴값 : {"id":52,"createdAt":"2020-10-18T15:24:56.973Z","updatedAt":"2020-10-18T15:24:56.974Z","deletedAt":null,"userId":21924,"itemId":null,"socialingId":105,"orderStatus":"COMPLETE_PAYMENT","orderClaim":null}
    return SocialingPickReturnData.fromMap(response);
  }

  // 결제하기 위한 정기모임, 소셜링, MPASS 기본 정보 및 결제 가능 여부
  Future<OrderItemsData> getOrderInfo(List<String> items,
      List<String> socialings, List<String> itemRounds) async {
    // items=1&items=2&socialings=3&socialings=4&itemRounds=5&itemRounds=6
    String params = "";
    String itemslist = "";
    String socialinglist = "";
    String itemRoundlist = "";

    items.forEach((val) {
      itemslist += "&items=" + val;
    });

    socialings.forEach((val) {
      socialinglist += "&socialings=" + val;
    });

    itemRounds.forEach((val) {
      itemRoundlist += "&itemRounds=" + val;
    });

    // print('itemslist : $itemslist');
    // print('socialinglist : $socialinglist');
    // print('itemRoundlist : $itemRoundlist');

    params += itemslist != "" ? itemslist : "";
    params += socialinglist != "" ? socialinglist : "";
    params += itemRoundlist != "" ? itemRoundlist : "";
    params = params.substring(1, params.length);

    final _callUri = "/api/order/info?$params";
    final response = await _api.get(_callUri);
    print('response : ${response.toString()}');
    return OrderItemsData.fromMap(response);
  }

  // 결제가능 여부
  Future<OrderisValidData> getOrderisValid(List<String> items,
      List<String> socialings, List<String> itemRounds) async {
    Map<String, dynamic> _map = Map();
    _map['items'] = items;
    _map['socialings'] = socialings;
    _map['itemRounds'] = itemRounds;

    final _callUri = "/api/order/isValid";
    final response = await _api.post(_callUri, _map);
    print('response : ${response.toString()}');
    return OrderisValidData.fromMap(response);
  }

  // 주문번호 생성
  Future<PaymentIdData> getOrderPaymentId(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/paymentId";
    final response = await _api.post(_callUri, _map);
    return PaymentIdData.fromMap(response);
  }

// 결제 금액이 0원인 경우
  Future<String> getOrderClassNoPayment(BootPayData _map) async {
    final _callUri = "/api/order/class/no-payment";
    final response = await _api.post(_callUri, _map.toMap());
    return response['paymentId'];
  }

  // 결제
  Future<String> getOrderClassBootpay(BootPayData _map) async {
    final _callUri = "/api/order/class/bootpay";
    final response = await _api.post(_callUri, _map.toMap());
    return response['paymentId'];
  }

  Future<String> getOrderTokenBootpay() async {
    final _callUri = "/api/order/token​/bootpay";
    final response = await _api.post(_callUri, '');
    return response['data']['token'];
  }

  Future<List<PaymentHistoryData>> getOrderHistory() async {
    final _callUri = "/api/order/history";
    final response = await _api.get(_callUri);
    //return OrderHistoryData.fromMap(response);
    List<PaymentHistoryData> list = (response as List)
        .map((data) => PaymentHistoryData.fromJson(data))
        .toList();
    return list;
  }

  Future<OrderHistoryData> getOrderHistoryDetail(String id) async {
    final _callUri = "/api/order/history/" + id;
    final response = await _api.get(_callUri);
    return OrderHistoryData.fromMap(response);
  }
}
