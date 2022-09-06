import 'dart:convert';

class SocialingPickReturnData {
  // {"id":52,"createdAt":"2020-10-18T15:24:56.973Z","updatedAt":"2020-10-18T15:24:56.974Z","deletedAt":null,"userId":21924,"itemId":null,"socialingId":105,"orderStatus":"COMPLETE_PAYMENT","orderClaim":null}

  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String userId;
  String itemId;
  String socialingId;
  String updatedAtupdatedAt;
  String orderStatus;
  String orderClaim;
  SocialingPickReturnData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userId,
    this.itemId,
    this.socialingId,
    this.updatedAtupdatedAt,
    this.orderStatus,
    this.orderClaim,
  });

  SocialingPickReturnData copyWith({
    int id,
    String createdAt,
    String updatedAt,
    String deletedAt,
    String userId,
    String itemId,
    String socialingId,
    String updatedAtupdatedAt,
    String orderStatus,
    String orderClaim,
  }) {
    return SocialingPickReturnData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      socialingId: socialingId ?? this.socialingId,
      updatedAtupdatedAt: updatedAtupdatedAt ?? this.updatedAtupdatedAt,
      orderStatus: orderStatus ?? this.orderStatus,
      orderClaim: orderClaim ?? this.orderClaim,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'userId': userId,
      'itemId': itemId,
      'socialingId': socialingId,
      'updatedAtupdatedAt': updatedAtupdatedAt,
      'orderStatus': orderStatus,
      'orderClaim': orderClaim,
    };
  }

  factory SocialingPickReturnData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return SocialingPickReturnData(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      userId: map['userId'],
      itemId: map['itemId'],
      socialingId: map['socialingId'],
      updatedAtupdatedAt: map['updatedAtupdatedAt'],
      orderStatus: map['orderStatus'],
      orderClaim: map['orderClaim'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingPickReturnData.fromJson(String source) => SocialingPickReturnData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialingPickReturnData(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, itemId: $itemId, socialingId: $socialingId, updatedAtupdatedAt: $updatedAtupdatedAt, orderStatus: $orderStatus, orderClaim: $orderClaim)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SocialingPickReturnData &&
      o.id == id &&
      o.createdAt == createdAt &&
      o.updatedAt == updatedAt &&
      o.deletedAt == deletedAt &&
      o.userId == userId &&
      o.itemId == itemId &&
      o.socialingId == socialingId &&
      o.updatedAtupdatedAt == updatedAtupdatedAt &&
      o.orderStatus == orderStatus &&
      o.orderClaim == orderClaim;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode ^
      userId.hashCode ^
      itemId.hashCode ^
      socialingId.hashCode ^
      updatedAtupdatedAt.hashCode ^
      orderStatus.hashCode ^
      orderClaim.hashCode;
  }
}
