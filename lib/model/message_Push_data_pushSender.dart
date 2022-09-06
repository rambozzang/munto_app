import 'dart:convert';

class MessagePushDataPushSender {

  String image;
  MessagePushDataPushSender({
    this.image,
  });

  MessagePushDataPushSender copyWith({
    String image,
  }) {
    return MessagePushDataPushSender(
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }

  factory MessagePushDataPushSender.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MessagePushDataPushSender(
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagePushDataPushSender.fromJson(String source) => MessagePushDataPushSender.fromMap(json.decode(source));

  @override
  String toString() => 'MessagePushDataPushSender(image: $image)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MessagePushDataPushSender &&
      o.image == image;
  }

  @override
  int get hashCode => image.hashCode;
  }
