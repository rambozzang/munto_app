import 'dart:async';
import 'package:munto_app/model/class_members_data.dart';
import 'package:munto_app/model/provider/Socialing_Pick_Return_Data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'package:munto_app/model/provider/socialing_free_return_data.dart';
import 'package:munto_app/model/socialing_Detail_data.dart';
import '../socialing_data.dart';

class SocialingProvider extends ParentProvider {
  List<SocialingData> dataList = [];
  ApiService _api = ApiService();

  Future<void> fetch(int skip, int take) async {
    setStateBusy();
    final _callUri = "/api/socialing/$skip/$take";
    print(_callUri);
    final response = await _api.get(_callUri);

    // 20201022 추가 bk
    if (skip == 0) {
      dataList = [];
    }

    if (response != null) {
      for (var r in response) {
        SocialingData searchedData = SocialingData.fromMap(r);
        dataList.add(searchedData);
      }
    }
    setStateIdle();
  }

  // 쇼셜링 상세 페이지 에서 사용  socialing_detail_page.dart
  // 소셜링 상세 정보 가져오기
  Future<SocialingDetailData> detailData(String socialingId) async {
    final _callUri = "/api/socialing/$socialingId";
    final response = await _api.get(_callUri);
    return SocialingDetailData.fromMap(response);
  }

  // 쇼셜링 상세 페이지 에서 사용  socialing_detail_page.dart
  // 하트 클릭시
  Future<SocialingPickReturnData> savePick(Map<String, dynamic> _map) async {
    final _callUri = "/api/order/socialing";
    final response = await _api.post(_callUri, _map);
    // 리턴값 : {"id":52,"createdAt":"2020-10-18T15:24:56.973Z","updatedAt":"2020-10-18T15:24:56.974Z","deletedAt":null,"userId":21924,"itemId":null,"socialingId":105,"orderStatus":"COMPLETE_PAYMENT","orderClaim":null}

    return SocialingPickReturnData.fromMap(response);
  }

  // 쇼셜링 상세 페이지 에서 사용  socialing_detail_page.dart
  // 소셜링 참여 하기
  Future<SocialingFreeReturnData> saveOrderSocialingFree(
      String socialingId) async {
    final _callUri = "/api/order/socialing/free";
    final response = await _api.post(_callUri, {
      'socialings': [socialingId]
    });
    print('response = ${response.toString()}');

    return SocialingFreeReturnData.fromMap(response[0]);
  }

  // 모집중인 모임정보 관리 리스트 가져오기
  // 소셜링인경우 /api​/socialing​/members​/ordered
  // 모임인 경우 ​/api​/item​/members​/ordered
  Future<List<ClassMembersData>> getSocialingMemberOrdered(
      String socialingId) async {
    final _callUri = '/api/socialing/$socialingId/members/ordered';
    final response = await _api.get(_callUri);
    List<ClassMembersData> list = (response as List)
        .map((data) => ClassMembersData.fromMap(data))
        .toList();
    return list;
  }

  // 쇼셜링 상세 페이지 에서 사용  class_manage_page.dart
  // 소셜링 상세 정보 가져오기
  Future<SocialingDetailData> getDetailData(String classType, String id) async {
    String classTypeLow = classType.toLowerCase();
    final _callUri = "/api/$classTypeLow/$id";
    final response = await _api.get(_callUri);
    return SocialingDetailData.fromMap(response);
  }


  Future<bool> postFollow(userId) async {
    print('postFollow userId = $userId');
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
    return response['id'] != null || (response['result'] != null && response['result'] == true);
  }
}
