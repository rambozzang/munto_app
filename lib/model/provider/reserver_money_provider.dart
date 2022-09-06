import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/message_Push_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/user_reserve_money_data.dart';

class ReserveMoneyProvider with ChangeNotifier {
  ApiService _api = ApiService();

  List<UserReserveMoneyData> reserveMoneyDataList = [];
  List<UserReserveMoneyData> get getUserReserveDataList => reserveMoneyDataList;

  Future<List<UserReserveMoneyData>> getUserReserveMoneyList() async {

    final _callUri = "/api/reservesMoney";
    final response = await _api.get(_callUri);
    print(response.toString());

    List<UserReserveMoneyData> list = (response['reserveMoneyHistory'] as List).map((data) => UserReserveMoneyData.fromMap(data)).toList();

    return list;
  }
}
