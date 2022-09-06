import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/class_List_Forcommunity_Data.dart';
import 'package:munto_app/model/class_communtiy_data.dart';
import 'package:munto_app/model/class_Proceeding_Attendee_data.dart';
import 'package:munto_app/model/class_Proceeding_Rounds_Data.dart';
import 'package:munto_app/model/class_Proceeding_State_Data.dart';
import 'package:munto_app/model/class_members_data.dart';
import 'package:munto_app/model/enum/class_Enum.dart';
import 'package:munto_app/model/fund_Data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:munto_app/model/reviews_Data.dart';
import 'package:munto_app/model/survey_Data.dart';
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/user_data.dart';

class ClassProvider extends ParentProvider {
  ApiService _api = ApiService();

  // Method    : GET
  // url       : /api/class/forFeed
  Future<List<dynamic>> getClassForFeed() async {
    final _callUri = "/api/class/forFeed";
    final response = await _api.get(_callUri);
    print(response.toString());
    //  List<ClassData> list =
    //     (response as List).map((data) => ClassData.fromMap(data)).toList();
    return response;
  }

  // Method    : GET
  // url       : /api/class/forFeed
  Future<List<ClassData>> getAllClassList() async {
    final _callUri = "/api/class/list/forMember";
    final response = await _api.get(_callUri);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }

  // Method    : GET
  // url       : /api/class/forAdministrator
  Future<List<ClassData>> getClassListForAdminstrator() async {
    final _callUri = "/api/class/list/forAdministrator";
    final response = await _api.get(_callUri);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }

  // Method    : GET
  // url       : /api/class/forCommunity
  Future<List<ClassData>> getClassListForCommunity() async {
    final _callUri = "/api/class/list/forCommunity";
    final response = await _api.get(_callUri);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }

  // Method    : GET
  // url       : /api/class/list
  // classEnum : PLANNING, PRESTART, RECRUITING, PLAYING, CLOSED
  Future<List<ClassData>> getClassList(ClassEnum classEnum) async {
    final _callUri = "/api/class/list/" + classEnum.toString().split('.').last;
    final response = await _api.get(_callUri);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }

  // Method    : GET
  // url       : ​/api​/class​/members​/{classType}​/{classId}
  //    "id": 21948,
    // "name": "게스트",
    // "image": "https://munto-images.s3.ap-northeast-2.amazonaws.com/user/default-profile-image.png",
    // "introduce": null,
    // "isFollowed": false
  Future<List<UserData>> getClassmembers(Map<String, dynamic> _map) async {

    String classTypeUp = _map['classType'].toString().toUpperCase();
    String itemId = _map['itemId'];

    final _callUri = '/api/class/members/$classTypeUp/$itemId';

    final response = await _api.get(_callUri);
    print(response.toString());
    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }


  Future<List<UserData>> getSocialingmembers(Map<String, dynamic> _map) async {

    String itemId = _map['itemId'];

    final _callUri = '/api/v2/socialing/$itemId/members/';

    final response = await _api.get(_callUri);
    print(response.toString());
    List<UserData> list = (response as List).map((data) => UserData.fromMap(data)).toList();
    return list;
  }



  // Method    : GET
  // url       : ​/api​/class​/members​/{classType}​/{classId}
  Future<List<SurveyData>> getClassSurveyAvailabe() async {
    final _callUri = "/api/class/survey/available";
    final response = await _api.get(_callUri);
    print(response.toString());
    List<SurveyData> list = (response as List).map((data) => SurveyData.fromMap(data)).toList();
    return list;
  }

  // Method    : POST
  // url       : ​/api​/class​/survey
  Future<List<ClassData>> postClassSurvey(Map<String, dynamic> _data) async {
    final _callUri = "/api/class/survey";
    final response = await _api.post(_callUri, _data);
    print(response.toString());
    List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return list;
  }

  // Method    : GET
  // url       : ​/api/class/survey/result?surveyId=33&classType=333
  Future<SurveyData> getClassSurveyResult(Map<String, dynamic> _map) async {
    final _callUri = "/api/class/survey/result?surveyId=" + _map['surveyId'] + "&classType=" + _map["classType"];
    final response = await _api.get(_callUri);
    print(response.toString());
    return SurveyData.fromMap(response);
  }

  // Method    : GET
  // url       : ​/api​/class​/reviews
  Future<ReviewsData> getClassReviews() async {
    final _callUri = "/api/class/reviews";
    final response = await _api.get(_callUri);
    print(response.toString());
    return ReviewsData.fromMap(response);
  }

  // Method    : POST
  // url       : ​/api​/class​/survey
  Future<Map<String, dynamic>> postClassReview(Map<String, dynamic> _data) async {
    final _callUri = "/api/class/review";
    final response = await _api.post(_callUri, _data);
    print(response.toString());
    return response;
  }

  // Method    : DELETE
  // url       : ​/api​/class​/review
  Future<Map<String, dynamic>> deleteClassReview(Map<String, dynamic> _data) async {
    final _callUri = "/api/class/review";
    final response = await _api.delete(_callUri, _data);
    print(response.toString());
    return response;
  }

  // Method   : PUT
  // url       : ​/api​/class​/review
  Future<Map<String, dynamic>> putClassReview(Map<String, dynamic> _data) async {
    final _callUri = "/api/class/review";
    final response = await _api.put(_callUri, _data);
    print(response.toString());
    return response;
  }

  // Method   : POST
  // url       : ​/api​/class​/invite
  Future<Map<String, dynamic>> postClassInvite(Map<String, dynamic> _data) async {
    final _callUri = "/api/class/invite";
    final response = await _api.post(_callUri, _data);
    print(response.toString());
    return response;
  }

/////////////////////////////////////////////////////////

  //사용자 정보 가져오기
  Future<UserProfileData> getUserProfile() async {
    final _callUri = "/api/user/profile";
    final response = await _api.get(_callUri);
    return UserProfileData.fromMap(response);
  }

  //사용자 정보 수정
  Future<dynamic> putUser(Map<String, dynamic> _map) async {
    final _callUri = "/api/user";
    final response = await _api.put(_callUri, _map);
    return response['result'] != null && response['result'] ;
  }

  // 후기 저장 하기
  Future<bool> saveReview(Map<String, dynamic> _map, isEdit) async {
    final _callUri = "/api/class/review";

    print('isEdit = ${isEdit.toString()}');
    bool response = isEdit
      ? await _api.put(_callUri, _map)
      : await _api.multipart(_callUri, _map, []);
    return response;
  }

  // 커뮤니티 리스트 가져오기
  // communtify_list_page.dart 기본 목록 가져오기
  Future<ClassListForCommuntiyData> getClassListForcommunity() async {
    final _callUri = '/api/class/list/forCommunity';
    final response = await _api.get(_callUri);
    ClassListForCommuntiyData result = ClassListForCommuntiyData();

    result.managingClassList =
        (response['playingClassList'] as List).map((data) => CommuntiyData.fromMap(data)).toList();
    result.playingClassList =
        (response['managingClassList'] as List).map((data) => CommuntiyData.fromMap(data)).toList();

    // List<ClassListForCommuntiyData> list = (response as List).map((data) => ClassListForCommuntiyData.fromMap(data)).toList();

    return result;
  }

  // 정산 조회 하기
  Future<FundData> getFundData() async {
    final _callUri = "/api/user/calculate";
    FundData response = await _api.get(_callUri);
    return response;
  }

  // 정산 삭제 하기
  Future<bool> saveFundData(Map<String, dynamic> map) async {
    final _callUri = "/api/user/calculate";
    bool response = await _api.post(_callUri, map);
    return response;
  }

  Future<ClassData> getClassClasstypebyId(String classtype, String id) async {
    // 대문자
    String classTypeLow = classtype.toUpperCase();

    final _callUri = '/api/class/$classTypeLow/$id';
    final response = await _api.get(_callUri);
    return ClassData.fromMap(response);
  }
}
