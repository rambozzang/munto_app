import 'dart:convert';

import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

class MessageListProvider extends ParentProvider {
  ApiService _api = ApiService();
  // 모임 목록 가져오기
  // status : PLANNING, PRESTART, RECRUITING, PLAYING, CLOSED
  Future<List<MessageListData>> getMessageListData() async {
    setStateBusy();
    final _callUri = "/api/message/list/0/10";
    final response = await _api.get(_callUri);
    List<MessageListData> list = (response as List)
        .map((data) => MessageListData.fromMap(data))
        .toList();
    setStateIdle();
    return list;
  }
}

class MessageListData {
  String updatedAt;
  String content;
  String roomId;
  Receiver receiver;
  Sender sender;
  MessageListData({
    this.updatedAt,
    this.content,
    this.roomId,
    this.receiver,
    this.sender,
  });

  Map<String, dynamic> toMap() {
    return {
      'updatedAt': updatedAt,
      'content': content,
      'roomId': roomId,
      'Receiver': receiver?.toMap(),
      'Sender': sender?.toMap(),
    };
  }

  factory MessageListData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MessageListData(
      updatedAt: map['updatedAt'],
      content: map['content'],
      roomId: map['roomId'],
      receiver: Receiver.fromMap(map['Receiver']),
      sender: Sender.fromMap(map['Sender']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageListData.fromJson(String source) =>
      MessageListData.fromMap(json.decode(source));
}

class Receiver {
  int id;
  String name;
  String image;
  Receiver({
    this.id,
    this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory Receiver.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Receiver(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Receiver.fromJson(String source) =>
      Receiver.fromMap(json.decode(source));
}

class Sender {
  int id;
  String name;
  String image;
  Sender({
    this.id,
    this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory Sender.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Sender(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Sender.fromJson(String source) => Sender.fromMap(json.decode(source));
}
