import 'dart:convert';

class FcmMessageNotification {
  String titel;
  String body;
  FcmMessageNotification({
    this.titel,
    this.body,
  });

  FcmMessageNotification copyWith({
    String titel,
    String body,
  }) {
    return FcmMessageNotification(
      titel: titel ?? this.titel,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titel': titel,
      'body': body,
    };
  }

  factory FcmMessageNotification.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;
  
    return FcmMessageNotification(
      titel: map['titel'],
      body: map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FcmMessageNotification.fromJson(String source) => FcmMessageNotification.fromMap(json.decode(source));

  @override
  String toString() => 'FcmMessageNotification(titel: $titel, body: $body)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is FcmMessageNotification &&
      o.titel == titel &&
      o.body == body;
  }

  @override
  int get hashCode => titel.hashCode ^ body.hashCode;
}
