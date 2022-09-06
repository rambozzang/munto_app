import 'dart:convert';

import 'package:munto_app/model/fcm_message_data_data.dart';
import 'package:munto_app/model/fcm_message_notification_data.dart';

class FcmMessageMainData {
  FcmMessageData data ;
  FcmMessageNotification  notification;
  FcmMessageMainData({
    this.data,
    this.notification,
  });
  

  FcmMessageMainData copyWith({
    FcmMessageData data ,
    FcmMessageNotification notification,
  }) {
    return FcmMessageMainData(
      data : data ?? this.data,
      notification: notification ?? this.notification,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.toMap(),
      'notification': notification?.toMap(),
    };
  }

  factory FcmMessageMainData.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;
  
    return FcmMessageMainData(
      data: FcmMessageData.fromMap(map['data']),
      notification: FcmMessageNotification.fromMap(map['notification']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FcmMessageMainData.fromJson(String source) => FcmMessageMainData.fromMap(json.decode(source));

  @override
  String toString() => 'FcmMessageMainData(: $data, notification: $notification)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is FcmMessageMainData &&
      o.data ==  data &&
      o.notification == notification;
  }

  @override
  int get hashCode => data.hashCode ^ notification.hashCode;
}
