import 'dart:convert';

class MessagePushDataData {

  String kind;
  String title;
  String userId;
  String clickaction;
  MessagePushDataData({
    this.kind,
    this.title,
    this.userId,
    this.clickaction,
  });

  MessagePushDataData copyWith({
    String kind,
    String title,
    String userId,
    String clickaction,
  }) {
    return MessagePushDataData(
      kind: kind ?? this.kind,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      clickaction: clickaction ?? this.clickaction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kind': kind,
      'title': title,
      'userId': userId,
      'clickaction': clickaction,
    };
  }

  factory MessagePushDataData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MessagePushDataData(
      kind: map['kind'],
      title: map['title'],
      userId: map['userId'],
      clickaction: map['clickaction'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagePushDataData.fromJson(String source) => MessagePushDataData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessagePushDataData(kind: $kind, title: $title, userId: $userId, clickaction: $clickaction)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MessagePushDataData &&
      o.kind == kind &&
      o.title == title &&
      o.userId == userId &&
      o.clickaction == clickaction;
  }

  @override
  int get hashCode {
    return kind.hashCode ^
      title.hashCode ^
      userId.hashCode ^
      clickaction.hashCode;
  }
}
