import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:munto_app/model/provider/tag_provider.dart';

class SocialingPopularSubjectProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<SocialingPopularSubjectData>> getPopularSubject() async {
    List<SocialingPopularSubjectData> dataList =
        new List<SocialingPopularSubjectData>();
    setStateBusy();
    final _callUri = "/api/socialing/popular/subject";
    final response = await _api.get(_callUri);

    if (response != null) {
      for (var r in response) {
        SocialingPopularSubjectData seachedData =
            SocialingPopularSubjectData.fromMap(r);
        dataList.add(seachedData);
      }
    }

    return dataList;
  }


  Future<List<TagData>> getPopularTag() async {
    setStateBusy();
    final _callUri = "/api/tag/popular";
    final response = await _api.get(_callUri);
    return (response as List).map((e) => TagData.fromMap(e)).toList();
  }

}

class SocialingPopularSubjectData {
  String name;
  String image;
  SocialingPopularSubjectData({
    this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  factory SocialingPopularSubjectData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SocialingPopularSubjectData(
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingPopularSubjectData.fromJson(String source) =>
      SocialingPopularSubjectData.fromMap(json.decode(source));
}
