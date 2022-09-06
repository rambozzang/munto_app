
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:munto_app/model/provider/tag_profile_provider.dart';

import '../user_data.dart';
import 'feed_provider.dart';


class QuestionProvider extends ParentProvider{
  ApiService _api = ApiService();

  Future<TagFollowerData> getFollowers(id) async {
    final _path = '/api/tag/follower/$id/0/10';
    final response = await _api.get(_path);
    print('response = ${response.toString()}');
    return TagFollowerData.fromMap(response);
  }
  Future<List<UserData>> getWriters(id) async {
    final _path = '/api/tag/$id/writer/';
    final response = await _api.get(_path);
    print('response = ${response.toString()}');
    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }

  List<FeedData> dataPageList = [];
  Future<List<FeedData>> getTagFeeds(String tagId, int page) async {
    int _take = 30;
    int _skip = ((page ?? 1) - 1) * _take;
    if (page == 1) {
      dataPageList = [];
    }
    print('page :  $page , skip : $_skip , take : $_take');

    final _callUri = "/api/feed/byTag/$tagId/$_skip/$_take";
    final response = await _api.get(_callUri);
    print('getTagFeeds response : $response');
    List<FeedData> list = (response as List).map((data) => FeedData.fromMap(data)).toList();
    return list;
  }




}


