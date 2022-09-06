
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/meeting_DetailItem_Data.dart';
import 'package:munto_app/model/review_Data.dart';

class MeetingDetailData {
  MeetingDetailItemData item;
  List<ReviewData> reviews;  //  "reviews": [],
  bool isUserBasket;
  bool isUserPicked;
  MeetingDetailData({
    this.item,
    this.reviews,
    this.isUserBasket,
    this.isUserPicked,
  });

  MeetingDetailData copyWith({
    MeetingDetailItemData item,
    List<String> reviews,
    bool isUserBasket,
    bool isUserPicked,
  }) {
    return MeetingDetailData(
      item: item ?? this.item,
      reviews: reviews ?? this.reviews,
      isUserBasket: isUserBasket ?? this.isUserBasket,
      isUserPicked: isUserPicked ?? this.isUserPicked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item?.toMap(),
      'reviews': reviews,
      'isUserBasket': isUserBasket,
      'isUserPicked': isUserPicked,
    };
  }

  factory MeetingDetailData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    print('map[reviews] = ${map['reviews'].toString()}');
    return MeetingDetailData(
      item: MeetingDetailItemData.fromMap(map['item']),
      reviews:map['reviews'] == null ? [] : (map['reviews'] as List).map((e) => ReviewData.fromMap(e)).cast<ReviewData>().toList(),
      // List<String>.from(map['reviews'])
      isUserBasket: map['isUserBasket'],
      isUserPicked: map['isUserPicked'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingDetailData.fromJson(String source) => MeetingDetailData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetingDetailData(item: $item, reviews: $reviews, isUserBasket: $isUserBasket, isUserPicked: $isUserPicked)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingDetailData &&
      o.item == item &&
      listEquals(o.reviews, reviews) &&
      o.isUserBasket == isUserBasket &&
      o.isUserPicked == isUserPicked;
  }

  @override
  int get hashCode {
    return item.hashCode ^
      reviews.hashCode ^
      isUserBasket.hashCode ^
      isUserPicked.hashCode;
  }
}




// {
//   "item": {
//     "name": "테스트 모임4",
//     "gatheringStartDate": null,
//     "option": "옵션",
//     "subUrl": "http://naver.com",
//     "minimumPerson": 5,
//     "maximumPerson": 10,
//     "maleLimit": 5,
//     "femaleLimit": 5,
//     "price": null,
//     "discountPrice": 0,
//     "cover": "http://naver.com",
//     "itemKind": "CLASS",
//     "itemSubject1": "CAREER",
//     "itemSubject2": "MARKETING",
//     "location": "HAPJEONG",
//     "startDate": null,
//     "finishDate": null,
//     "summary": null,
//     "status": "PLAYING",
//     "ItemRound": [
//       {
//         "id": 113,
//         "round": 1,
//         "place": "HAPJEONG",
//         "startDate": null,
//         "finishDate": null,
//         "howPlayingTitle": "1회차 제목",
//         "howPlayingDescription": "1회차 내용",
//         "howPlayingThumbnail": "naver.com",
//         "showHowPlaying": true,
//         "curriculumTitle": "1회차 커리큘럼 제목",
//         "curriculumDescription": "1회차 커리큘럼 내용",
//         "curriculumThumbnail": null,
//         "showCurriculum": true,
//         "mpassPrice": 40000
//       },
//       {
//         "id": 114,
//         "round": 2,
//         "place": "HAPJEONG",
//         "startDate": null,
//         "finishDate": null,
//         "howPlayingTitle": "2회차 제목",
//         "howPlayingDescription": "2회차 내용",
//         "howPlayingThumbnail": "https://munto-images.s3.ap-northeast-2.amazonaws.com/item/1601539860555-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20howPlayingThumbnail-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%202-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20round_how_playing_2.jpg",
//         "showHowPlaying": true,
//         "curriculumTitle": "2회차 커리큘럼 제목",
//         "curriculumDescription": "2회차 커리큘럼 내용",
//         "curriculumThumbnail": null,
//         "showCurriculum": true,
//         "mpassPrice": 45000
//       }
//     ],
//     "ItemLeader": {
//       "showItemLeaderInfo": false,
//       "careerSummary": "career 1000",
//       "word": "word 1",
//       "introduction": "introduction 1",
//       "profileUrl": "http://kakao.com12222222",
//       "User": {
//         "name": "방리더",
//         "image": "https://munto-images.s3.amazonaws.com/dev-user/1605510897591-image-21924-profileImage",
//         "grade": "LEADER"
//       }
//     },
//     "ItemPartner": {
//       "showItemPartnerInfo": false,
//       "careerSummary": " career pa 1000",
//       "word": " word partner 5",
//       "introduction": " introduction partner 5",
//       "profileUrl": "http://daum.net22222",
//       "User": {
//         "name": "최파터",
//         "image": "https://munto-images.s3.ap-northeast-2.amazonaws.com/user/default-profile-image.png",
//         "grade": "PARTNER"
//       }
//     },
//     "itemDetail1": "어떤 모임인가요?",
//     "itemDetail2": "이런 분들을 기다립니다.",
//     "itemDetail3": [
//       {
//         "title": "item detail3 title1 0번",
//         "description": "item detail3 description1 0번",
//         "thumbnail": "hello"
//       },
//       {
//         "title": "item detail3 title 1번",
//         "description": "item detail3 description 1번",
//         "thumbnail": "https://munto-images.s3.ap-northeast-2.amazonaws.com/item/1601539860676-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20itemDetail3Thumbnail-%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20item_detail3_2.jpg"
//       }
//     ],
//     "itemDetail4": "item detail 4",
//     "itemDetail5": "item detail5",
//     "itemHowPlaying": [],
//     "Order": [
//       {
//         "User": {
//           "sex": "MALE"
//         }
//       },
//       {
//         "User": {
//           "sex": "MALE"
//         }
//       },
//       {
//         "User": {
//           "sex": "MALE"
//         }
//       },
//       {
//         "User": {
//           "sex": "MALE"
//         }
//       },
//       {
//         "User": {
//           "sex": "MALE"
//         }
//       }
//     ],
//     "badge": "남성마감임박"
//   },
//   "reviews": [],
//   "isUserBasket": false
// }