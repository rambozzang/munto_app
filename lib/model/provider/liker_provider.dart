
import 'package:munto_app/model/provider/parent_provider.dart';

import '../user_data.dart';
import 'api_Service.dart';

class LikerProvider extends ParentProvider{
  ApiService _api = ApiService();
  LikerProvider();

  Future<List<UserData>> getLikerList(feedId) async {
    final _callUri = "/api/feed/liker/$feedId/0/30";
    print(_callUri);

    final response = await _api.get(_callUri);

    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }

  Future<bool> postFollow(userId) async {
    print('userId = $userId');
    setStateBusy();
    final _callUri = "/api/user/follow/$userId";
    final response = await _api.post(_callUri, null);
    setStateIdle();
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }

  Future<bool> deleteFollow(userId) async {
    print('userId = $userId');

    setStateBusy();
    final _callUri = "/api/user/follow/$userId";
    final response = await _api.delete(_callUri, {});
    setStateIdle();
    return response['id'] != null;
  }

}
