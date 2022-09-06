import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

class MessageSendProvider extends ParentProvider {
  ApiService _api = ApiService();

  Future<bool> sendMessage(SendMessageData sendMessageData) async {
    setStateBusy();
    final _callUri = "/api/message";
    final response = await _api.post(_callUri, sendMessageData);

    setStateIdle();
    ResponseJsonObject responseJsonObject =
        ResponseJsonObject.fromMap(response);

    return responseJsonObject.result;
  }
}

class SendMessageData {
  String receiverId;
  String content;
  SendMessageData({
    this.receiverId,
    this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'content': content,
    };
  }

  factory SendMessageData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SendMessageData(
      receiverId: map['receiverId'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessageData.fromJson(String source) =>
      SendMessageData.fromMap(json.decode(source));
}

class ResponseJsonObject {
  bool result;
  ResponseJsonObject({
    this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
    };
  }

  factory ResponseJsonObject.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResponseJsonObject(
      result: map['result'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseJsonObject.fromJson(String source) =>
      ResponseJsonObject.fromMap(json.decode(source));
}
