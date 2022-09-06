import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

List<MessageData> list;

class MessageGetProvider extends ParentProvider {
  ApiService _api = ApiService();
  // 모임 목록 가져오기
  // status : PLANNING, PRESTART, RECRUITING, PLAYING, CLOSED

  Future<List<MessageData>> getMessageDatas(
      String target, int skip, int take) async {
    setStateBusy();

    if (skip == 0) {
      list = [];
    }
    print('skip : $skip , take : $take');

    final _callUri = "/api/message/$target/$skip/$take";
    final response = await _api.get(_callUri);
    list.addAll(
        (response as List).map((data) => MessageData.fromMap(data)).toList());
    setStateIdle();
    return list;
  }

  // 서버에서 가져온 마지막 데이터만 리턴함.
  Future<List<MessageData>> getMessageData(
      String target, int skip, int take) async {
    setStateBusy();

    print('skip : $skip , take : $take');

    final _callUri = "/api/message/$target/$skip/$take";
    final response = await _api.get(_callUri);
    list.insert(
        0, (response as List).map((data) => MessageData.fromMap(data)).first);
    setStateIdle();
    return list;
  }
}

class MessageData {
  String createdAt;
  String updateAt;
  DateTime get createdDate{
    if(createdAt != null)
      return DateTime.parse(createdAt);
    return null;
  }
  DateTime get updatedDate{
    if(updateAt != null)
      return DateTime.parse(updateAt);
    return null;
  }
  int senderId;
  int receiverId;
  String content;
  MessageData({
    this.createdAt,
    this.updateAt,
    this.senderId,
    this.receiverId,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updateAt': updateAt,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    };
  }

  factory MessageData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MessageData(
      createdAt: map['createdAt'],
      updateAt: map['updateAt'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageData.fromJson(String source) =>
      MessageData.fromMap(json.decode(source));
}
