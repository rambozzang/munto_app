import 'dart:convert';

class FcmMessageData {
  String title;
  String content;
  String userId;
  String feedId;
  String feedCommentId;
  String classId;
  String classType;
  String groupKey;
  String kind;
  String click_action;
  FcmMessageData({
    this.title,
    this.content,
    this.userId,
    this.feedId,
    this.feedCommentId,
    this.classId,
    this.classType,
    this.groupKey,
    this.kind,
    this.click_action,
  });

  FcmMessageData copyWith({
    String title,
    String content,
    String userId,
    String feedId,
    String feedCommentId,
    String classId,
    String classType,
    String groupKey,
    String kind,
    String click_action,
  }) {
    return FcmMessageData(
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      feedId: feedId ?? this.feedId,
      feedCommentId: feedCommentId ?? this.feedCommentId,
      classId: classId ?? this.classId,
      classType: classType ?? this.classType,
      groupKey: groupKey ?? this.groupKey,
      kind: kind ?? this.kind,
      click_action: click_action ?? this.click_action,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'userId': userId,
      'feedId': feedId,
      'feedCommentId': feedCommentId,
      'classId': classId,
      'classType': classType,
      'groupKey': groupKey,
      'kind': kind,
      'click_action': click_action,
    };
  }

  factory FcmMessageData.fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return FcmMessageData(
      title: map['title'],
      content: map['content'],
      userId: map['userId'],
      feedId: map['feedId'],
      feedCommentId: map['feedCommentId'],
      classId: map['classId'],
      classType: map['classType'],
      groupKey: map['groupKey'],
      kind: map['kind'],
      click_action: map['click_action'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FcmMessageData.fromJson(String source) => FcmMessageData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FcmMessageData(title: $title, content: $content, userId: $userId, feedId: $feedId, feedCommentId: $feedCommentId, classId: $classId, classType: $classType, groupKey: $groupKey, kind: $kind, click_action: $click_action)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FcmMessageData &&
        o.title == title &&
        o.content == content &&
        o.userId == userId &&
        o.feedId == feedId &&
        o.feedCommentId == feedCommentId &&
        o.classId == classId &&
        o.classType == classType &&
        o.groupKey == groupKey &&
        o.kind == kind &&
        o.click_action == click_action;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        userId.hashCode ^
        feedId.hashCode ^
        feedCommentId.hashCode ^
        classId.hashCode ^
        classType.hashCode ^
        groupKey.hashCode ^
        kind.hashCode ^
        click_action.hashCode;
  }
}
