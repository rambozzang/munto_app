import 'dart:async';
import 'dart:convert';
import 'package:munto_app/model/provider/api_Service.dart';

import 'package:munto_app/model/provider/parent_provider.dart';

class TagSearchProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<TagSearchData>> searchTag(
      String query, String skip, String take) async {
    List<TagSearchData> dataList = new List<TagSearchData>();
    setStateBusy();
    final _callUri = "/api/tag/search/$query/$skip/$take";
    final response = await _api.get(_callUri);

    if (response != null) {
      for (var r in response) {
        TagSearchData tagSearchData = TagSearchData.fromMap(r);
        dataList.add(tagSearchData);
      }
    }

    return dataList;
  }
}

class TagSearchData {
  int id;
  String name;
  int count;
  TagSearchData({
    this.id,
    this.name,
    this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }

  factory TagSearchData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TagSearchData(
      id: map['id'],
      name: map['name'],
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TagSearchData.fromJson(String source) =>
      TagSearchData.fromMap(json.decode(source));
}
