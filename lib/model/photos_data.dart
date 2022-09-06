import 'dart:convert';

class PhotosData {
  String photo;
  PhotosData({
    this.photo,
  });

  PhotosData copyWith({
    String photo,
  }) {
    return PhotosData(
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'photo': photo,
    };
  }

  factory PhotosData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PhotosData(
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PhotosData.fromJson(String source) => PhotosData.fromMap(json.decode(source));

  @override
  String toString() => 'PhotosData(photo: $photo)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PhotosData &&
      o.photo == photo;
  }

  @override
  int get hashCode => photo.hashCode;
}
