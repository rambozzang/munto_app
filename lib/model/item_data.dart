import 'dart:convert';


// {
// "startDate": "2020-11-27T00:00:00.000Z",
// "id": 5305,
// "cover": "https://munto-images.s3.amazonaws.com/dev-item/1606466757885-cover-thumb.jpg",
// "status": "CONFIRM_PLAYING",
// "itemKind": "CLASS",
// "itemSubject1": "MOVIE",
// "itemSubject2": "MOVIE_DISCUSSION",
// "name": "5회차 모임 기림님과 테스트",
// "itemDetail1": "<p><br></p>",
// "finishDate": "2020-12-03T00:00:00.000Z",
// "location": "HAPJEONG",
// "summary": "요약",
// "ItemRound": [
// {
// "id": 9022,
// "place": "HAPJEONG",
// "startDate": "2020-12-03T00:00:00.000Z",
// "finishDate": "2020-12-03T00:00:00.000Z"
// }
// ],
// "ItemLeader": {
// "profileUrl": null,
// "User": {
// "image": "https://munto-images.s3.amazonaws.com/dev-user/1606325162358-image-21917-%25EC%2597%25A3%25EC%25B7%25BD.JPG"
// }
// },
// "ItemPartner": null,
// "isPick": false,
// "badge": null
// },

class ItemData {

  String startDate;
  String finishDate;
  int id;
  String cover;
  String popularCover;
  String status;
  String itemKind;
  String itemSubject1;
  String itemSubject2;
  String name;
  String itemDetail1;
  List<ItemRound> itemRound;
  ItemLeader itemLeader;
  bool isPick;
  String badge;

  String summary;
  String location;
  String get locationString{
    if(location != null && location.toUpperCase() == 'HAPJEONG')
      return '합정';
    return location;
  }
  DateTime get startDateTime {
    try{
      return DateTime.parse(startDate).toLocal();
    } catch (e){}
    return null;
  }


  ItemData({
    this.id,
    this.cover,
    this.popularCover,
    this.status,
    this.itemKind,
    this.itemSubject1,
    this.itemSubject2,
    this.name,
    this.itemDetail1,
    this.itemRound,
    this.itemLeader,
    this.isPick,
    this.badge,
    this.startDate,
    this.finishDate,
    this.summary,
    this.location,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'popularCover' : popularCover,
      'cover': cover,
      'status': status,
      'itemKind': itemKind,
      'itemSubject1': itemSubject1,
      'itemSubject2': itemSubject2,
      'name': name,
      'itemDetail1': itemDetail1,
      'itemRound':  itemRound?.map((x) => x?.toMap())?.toList(),
      'itemLeader': itemLeader?.toMap(),
      'isPick': isPick,
      'badge': badge,
      'startDate': startDate,
      'finishDate': finishDate,
      'summary': summary,
      'location': location,
    };
  }

  factory ItemData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ItemData(
      id: map['id'],
      cover: map['cover'],
      popularCover : map['popularCover'] ?? '',
      status: map['status'],
      itemKind: map['itemKind'],
      itemSubject1: map['itemSubject1'],
      itemSubject2: map['itemSubject2'],
      name: map['name'],
      itemDetail1: map['itemDetail1'],
      itemRound: map['ItemRound'] != null ? (map['ItemRound'] as List).map((e)=> ItemRound.fromMap(e)).toList() : [],
      itemLeader: ItemLeader.fromMap(map['ItemLeader']),
      isPick: map['isPick'],
      badge: map['badge'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      summary: map['summary'],
      location: map['location'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemData.fromJson(String source) =>
      ItemData.fromMap(json.decode(source));
}

class ItemRound {
  int id;
  String place;
  String startTime;
  String finishTime;
  ItemRound({
    this.id,
    this.place,
    this.startTime,
    this.finishTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place': place,
      'startTime': startTime,
      'finishTime': finishTime,
    };
  }

  factory ItemRound.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ItemRound(
      id: map['id'],
      place: map['place'],
      startTime: map['startTime'],
      finishTime: map['finishTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemRound.fromJson(String source) =>
      ItemRound.fromMap(json.decode(source));
}

class ItemLeader {
  String get image => user?.image ?? '';
  String profileUrl;
  User user;
  ItemLeader({
    this.user,
    this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'User': user?.toMap(),
    };
  }

  factory ItemLeader.fromMap(Map<String, dynamic> map) {
    if (map == null) return ItemLeader(
      user: User.fromMap(null),
    );

    return ItemLeader(
      user: User.fromMap(map['User']),
      profileUrl: map['profileUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemLeader.fromJson(String source) =>
      ItemLeader.fromMap(json.decode(source));
}

class User {
  String image;
  User({
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return User(
      image: '',
    );

    return User(
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
