import 'dart:convert';

class ImageData {
  String url;
  ImageData({
    this.url,
  });

  ImageData copyWith({
    String url,
  }) {
    return ImageData(
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }

  factory ImageData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ImageData(
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageData.fromJson(String source) => ImageData.fromMap(json.decode(source));

  @override
  String toString() => 'ImageData(url: $url)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ImageData &&
      o.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
