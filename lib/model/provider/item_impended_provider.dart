import 'dart:developer';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import '../item_data.dart';
import '../item_impended_data.dart';

class ImpendedItemProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<ItemData>> getImpendedItems() async {
    final _callUri = "/api/item/impended";
    final response = await _api.get(_callUri);
    log('impended : ${response.toString()}');
    return (response as List)
        ?.map((data) => ItemData.fromMap(data))
        ?.toList();
  }
}
