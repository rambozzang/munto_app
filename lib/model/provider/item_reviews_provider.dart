import 'dart:async';
import 'package:munto_app/model/item_reviews_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import '../socialing_data.dart';

class ItemReviewsProvider extends ParentProvider {
  List<ItemReviewsData> dataList;
  ApiService _api = ApiService();
  Future<List<ItemReviewsData>> getItemReviewsData(int skip, int take) async {
    // setStateBusy();
    final _callUri = "/api/item/reviews/$skip/$take";
    final response = await _api.get(_callUri);
    if (skip == 0) {
      dataList = [];
    }
    if (response != null) {
      for (var r in response) {
        ItemReviewsData searchedData = ItemReviewsData.fromMap(r);
        dataList.add(searchedData);
      }
    }
    // setStateIdle();

    return dataList;
  }
}
