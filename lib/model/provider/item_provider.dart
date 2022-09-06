import 'dart:async';
import 'package:munto_app/model/class_Proceeding_Attendee_data.dart';
import 'package:munto_app/model/class_Proceeding_Rounds_Data.dart';
import 'package:munto_app/model/class_Proceeding_State_Data.dart';
import 'package:munto_app/model/class_members_data.dart';
import 'package:munto_app/model/item_save_data.dart';
import 'package:munto_app/model/item_subject_data.dart';
import 'package:munto_app/model/meeting_Detail_Data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

import '../item_data.dart';

class ItemProvider extends ParentProvider {
  ApiService _api = ApiService();

  List<ItemData> dataList;
  Future<List<ItemData>> getData(int skip, int take, String subject) async {
    // setStateBusy();
    String subjectQuery;
    subject != '' ? subjectQuery = '?subject=$subject' : subjectQuery = '';
    final _callUri = "/api/item/$skip/$take" + subjectQuery;
    final response = await _api.get(_callUri);
    if (skip == 0) {
      dataList = [];
    }
    if (response != null) {
      for (var r in response) {
        ItemData data = ItemData.fromMap(r);
        dataList.add(data);
      }
    }
    // setStateIdle();
    return dataList;
  }

  // louunge_page.dart
  // MPAss 추천모임
  Future<List<ItemData>> getMeetingData(bool isGuest, int skip, int take, String status, String subject) async {
    String subjectQuery;
    List<ItemData> list;

    subject != '' ? subjectQuery = '?status=$status&subject=$subject' : subjectQuery = '?status=$status';
    final _callUri = isGuest ? "/api/guest/item/$skip/$take" + subjectQuery : "/api/item/$skip/$take" + subjectQuery;
    final response = await _api.get(_callUri);
    if (skip == 0) {
      list = [];
    }
    if (response != null) {
      for (var r in response) {
        ItemData data = ItemData.fromMap(r);
        list.add(data);
      }
    }
    return list;
  }

  // 모임인 경우 ​/api​/item​/members​/ordered
  Future<List<ClassMembersData>> getItemMemberOrdered(String itemId) async {
    final _callUri = "/api​/item​/members​/ordered?item=$itemId";
    final response = await _api.get(_callUri);
    List<ClassMembersData> list = (response as List).map((data) => ClassMembersData.fromMap(data)).toList();
    return list;
  }

  // 진행중 모임 정보관리
  // - 출석률 등 상태 정보 조회
  Future<ClassProceedingStateData> getItemStats(String classtype, String itemId) async {
    String classTypeLow = classtype.toLowerCase();

    final _callUri = '/api/$classTypeLow/${itemId.toString()}/stats';
    final response = await _api.get(_callUri);

    return ClassProceedingStateData.fromMap(response);
  }

  // 진행중 모임 정보관리
  // - 회차 dropboxlist 가져오기
  Future<List<ClassProceedingRoundsData>> getItemRounds(String itemId) async {
    // getClassRoundsData
    final _callUri = '/api/item/${itemId.toString()}/round';
    print('getItemRounds uri = $_callUri');
    // final _callUri = '/api/item/${itemId.toString()}/rounds/info';
    final response = await _api.get(_callUri);
    List<ClassProceedingRoundsData> list =
        (response as List).map((data) => ClassProceedingRoundsData.fromMap(data)).toList();
    return list;
  }

  // 진행중 모임 정보관리
  // - 회차 dropboxlist 가져오기
  // Future<List<ClassProceedingRoundsData>> getItemRoundInfo(String classtype, String itemId) async {
  //   String classTypeLow = classtype.toUpperCase();
  //   // getClassRoundsData
  //
  //   // final _callUri = '/api/item/${itemId.toString()}/rounds/info';  // 정기모임
  //   final _callUri = '/api/socialing/${itemId.toString()}/info';
  //   final response = await _api.get(_callUri);
  //   print('getItemRoundInfo response : $response');
  //   List<ClassProceedingRoundsData> list =
  //       (response as List).map((data) => ClassProceedingRoundsData.fromMap(data)).toList();
  //   return list;
  // }


  Future<ClassProceedingAttendeeData> getAttendee(String classType, String _id, { ClassProceedingRoundsData round}) async {
    if(classType == 'ITEM' && round != null )
      return await getItemMembersAttendee(round.id, _id);
    else
      return await getSocialingMembersAttendee( _id);
  }


  // 진행중 소셜링 정보관리
  // - 출석 인원 가져오기
  Future<ClassProceedingAttendeeData> getSocialingMembersAttendee(String _id) async {

    final _callUri = '/api/socialing/$_id/members/attendee';
    final response = await _api.get(_callUri);
    print('response : $response');
    // List<ClassProceedingAttendeeData> list =
    //     (response as List).map((data) => ClassProceedingAttendeeData.fromMap(data)).toList();
    return ClassProceedingAttendeeData.fromMap(response);
  }


  // 진행중 모임 정보관리
  // - 출석 인원 가져오기
  Future<ClassProceedingAttendeeData> getItemMembersAttendee(int roundId, String _id) async {

    final _callUri = '/api/item/$_id/$roundId/members/attendee';
    final response = await _api.get(_callUri);
    print('response : $response');
    // List<ClassProceedingAttendeeData> list =
    //     (response as List).map((data) => ClassProceedingAttendeeData.fromMap(data)).toList();
    return ClassProceedingAttendeeData.fromMap(response);
  }

  // 출석저장 하기
  Future<bool> saveItemAttendList(String classtype, dynamic data) async {
    String classTypeLow = classtype.toLowerCase();

    final _callUri = '/api/${classTypeLow.toString()}/attend';
    final response = await _api.post(_callUri, data.toMap());
    return response;
  }

// 진행중 모임 정보관리
  // - 출석 인원 가져오기
  Future<MeetingDetailData> getItemDetailInfo(String _id) async {
    // 사용자
    final _callUri = '/api/item/$_id/logined';
    final response = await _api.get(_callUri);
    print('response : $response');

    return MeetingDetailData.fromMap(response);
  }


}
