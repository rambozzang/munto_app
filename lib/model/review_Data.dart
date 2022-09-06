import 'dart:convert';

class ReviewData {
  String createdAt;
  String updatedAt;
  String deletedAt;
  int id;
  int orderId;
  int userId;
  String status;
  String content;
  String photo;
  ReviewData({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.id,
    this.orderId,
    this.userId,
    this.status,
    this.content,
    this.photo,
  });

  ReviewData copyWith({
    String createdAt,
    String updatedAt,
    String deletedAt,
    int id,
    int orderId,
    int userId,
    String status,
    String content,
    String photo,
  }) {
    return ReviewData(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      content: content ?? this.content,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'status': status,
      'content': content,
      'photo': photo,
    };
  }

  factory ReviewData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ReviewData(
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      id: map['id'],
      orderId: map['orderId'],
      userId: map['userId'],
      status: map['status'],
      content: map['content'],
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewData.fromJson(String source) => ReviewData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewData(createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, id: $id, orderId: $orderId, userId: $userId, status: $status, content: $content, photo: $photo)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ReviewData &&
        o.createdAt == createdAt &&
        o.updatedAt == updatedAt &&
        o.deletedAt == deletedAt &&
        o.id == id &&
        o.orderId == orderId &&
        o.userId == userId &&
        o.status == status &&
        o.content == content &&
        o.photo == photo;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode ^
        id.hashCode ^
        orderId.hashCode ^
        userId.hashCode ^
        status.hashCode ^
        content.hashCode ^
        photo.hashCode;
  }
}
