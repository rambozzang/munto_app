import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import '../item_data.dart';
import '../item_popular_data.dart';

class PopularItemProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<ItemData>> getPopularItems() async {
    final _callUri = "/api/item/popular";
    final response = await _api.get(_callUri);
    print(response.toString());
    return (response as List)
        ?.map((data) => ItemData.fromMap(data))
        ?.toList();
  }
}
