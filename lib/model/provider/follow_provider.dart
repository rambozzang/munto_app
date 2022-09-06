
import 'package:munto_app/model/provider/parent_provider.dart';

import '../user_data.dart';
import 'api_Service.dart';

class FollowProvider extends ParentProvider{
  ApiService _api = ApiService();
  FollowProvider();

  Future<List<UserData>> getFollowerList(userId) async {
    final _callUri = "/api/user/follower/$userId";
    final response = await _api.get(_callUri);
    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }
  Future<List<UserData>> getFollowingList(userId) async {
    final _callUri = "/api/user/following/$userId";
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
