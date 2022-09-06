import 'package:munto_app/model/item_recommend_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import '../item_data.dart';

class PlayingItemProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<ItemData>> getPlayingItems() async {
    final _callUri = "/api/item/0/10?status=PLAYING";
    final response = await _api.get(_callUri);
    print(response.toString());
    return (response as List)
        ?.map((data) => ItemData.fromMap(data))
        ?.toList();
  }
}
