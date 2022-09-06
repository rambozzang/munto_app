import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import '../socialing_data.dart';

class SocialingImpendedProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<List<SocialingData>> getImpendedSocialing() async {
    List<SocialingData> dataList = new List<SocialingData>();
    setStateBusy();
    final _callUri = "/api/socialing/impended";
    final response = await _api.get(_callUri);

    setStateIdle();
    if (response != null) {
      for (var r in response) {
        SocialingData searchedData = SocialingData.fromMap(r);
        dataList.add(searchedData);
      }
    }

    return dataList;
  }
}
