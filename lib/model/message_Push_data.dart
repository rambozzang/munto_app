import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/fcm_message_data_data.dart';
import 'package:munto_app/model/message_Push_data_data_del.dart';
import 'package:munto_app/model/message_Push_data_pushSender.dart';

class MessagePushData {
  int id;
  String createdAt;
  String title;
  String content;
  FcmMessageData data;
  String status;
  MessagePushData({
    this.id,
    this.createdAt,
    this.title,
    this.content,
    this.data,
    this.status,
    this.pushSenderImage,
  });
  String pushSenderImage;

  MessagePushData copyWith({
    int id,
    String createdAt,
    String title,
    String content,
    FcmMessageData data,
    String status,
    String pushSenderImage,
  }) {
    return MessagePushData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      content: content ?? this.content,
      data: data ?? this.data,
      status: status ?? this.status,
      pushSenderImage: pushSenderImage ?? this.pushSenderImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'title': title,
      'content': content,
      'data': data?.toMap(),
      'status': status,
    };
  }

  factory MessagePushData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    final image = map['PushSender'] != null ? map['PushSender']['image'] : '';
    return MessagePushData(
      id: map['id'],
      createdAt: map['createdAt'],
      title: map['title'],
      content: map['content'],
      data: FcmMessageData.fromMap(map['data']),
      status: map['status'],
      pushSenderImage: image ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagePushData.fromJson(String source) => MessagePushData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessagePushData(id: $id, createdAt: $createdAt, title: $title, content: $content, data: $data, status: $status)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MessagePushData &&
      o.id == id &&
      o.createdAt == createdAt &&
      o.title == title &&
      o.content == content &&
      o.data == data &&
      o.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      title.hashCode ^
      content.hashCode ^
      data.hashCode ^
      status.hashCode;
  }
}
