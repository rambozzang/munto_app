import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/message_Push_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';

class MessageProvider with ChangeNotifier {
  ApiService _api = ApiService();

  List<MessagePushData> messagePushDataList = [];
  List<MessagePushData> get getMessagePushDataList => messagePushDataList;
  bool isMoreMessagePushData = true;

  //안읽은 알람메세지 갯수
  int unreadCnt = 0;

  int get getUnreadCnt => unreadCnt;

  addUnReadCnt(int cnt) {
    unreadCnt = unreadCnt + cnt;
    notifyListeners();
  }

  subtractUnReadCnt(int cnt) {
    unreadCnt = unreadCnt - cnt;
    notifyListeners();
  }

  setUnReadCnt(int cnt) {
    unreadCnt = cnt;
    notifyListeners();
  }

  setgetMessagePushDataList(data) {
    messagePushDataList.addAll(data);
    notifyListeners();
  }

  // 알림 리스트 가져오기
  //
  Future<List<MessagePushData>> getPushMessageList(int page) async {
    int _take = 10;
    int _skip = ((page ?? 1) - 1) * _take;

    final _callUri = "/api/message/push/$_skip/$_take";
    final response = await _api.get(_callUri);
    print(response.toString());

    List<MessagePushData> list = (response as List).map((data) => MessagePushData.fromMap(data)).toList();

    return list;
  }
}
