import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/meeting_detail_howplaying_data.dart';

import 'package:munto_app/model/meeting_itemLeader_Data.dart';
import 'package:munto_app/model/meeting_itemRound_Data.dart';
import 'package:munto_app/model/meeting_itemdetail_Data.dart';
import 'package:munto_app/model/review_Data.dart';
import 'package:munto_app/model/simple_review_data.dart';

import '../util.dart';

class MeetingDetailItemData {
  String name;
  String gatheringStartDate;
  String option;
  String subUrl;
  int minimumPerson;
  int maximumPerson;
  int maleLimit;
  int femaleLimit;
  int price;
  String get priceString{
    if(price != null && price >0)
      return NumberFormat("#,##0", "ko_KR").format(price);
    return '';
  }

  String get pricePerMonth {

    final value = discountRate > 0 ? discountPrice : price;
    if(value == null)
      return '';
    if(durationInMonth > 1)
      return NumberFormat("#,##0", "ko_KR").format(value.toDouble() / durationInMonth);
    return NumberFormat("#,##0", "ko_KR").format(value);
  }
  int discountPrice;
  String get discountPriceString{
    if(discountPrice != null && discountPrice >0)
      return NumberFormat("#,##0", "ko_KR").format(discountPrice);
    return '';
  }
  String cover;
  String itemKind;
  String itemSubject1;
  String itemSubject2;
  String location;
  String get locationString{
    if(location != null && location.toUpperCase() == 'HAPJEONG')
      return '합정';
    return location ?? '';
  }
  String startDate;
  String finishDate;

  int get durationInDays{

    if(startDate == null)
      return 0;

    try{
      final startDateTime= DateTime.parse(startDate);
      final finishDateTime= DateTime.parse(finishDate);

      return finishDateTime.difference(startDateTime).inDays;
    } catch (e){

    }
    return 0;
  }
  int get durationInMonth{
    // if(!kReleaseMode)
    //   return 3;
    if(durationInDays > 30)
      return durationInDays ~/ 30;
    return 1;
  }

  int get discountRate{
    if(discountPrice != null && discountPrice > 0 && discountPrice < price){
      return ((price - discountPrice).toDouble() /  price.toDouble() * 100).toInt();
    }
    return 0;
  }

  String summary;
  String status;
  List<MeetingItemRoundData> ItemRound;
  MeetingItemLeaderData ItemLeader;
  String itemDetail1;
  String itemDetail2;
  MeetingItemDetailData itemDetail3;
  String itemDetail4;
  String itemDetail5;
  List<HowPlayingData> itemHowPlaying;
  List<Map<String, dynamic>> Order;
  String badge;
  List<SimpleReviewData> reviews;

  String get startDateString{
    if(startDate != null && startDate.isNotEmpty){
      final date = DateTime.parse(startDate);
      return '${date.month} ${date.day} (${Util.getWeekDayInt(date.weekday)}) ${Util.getTypeOfTime(date)} ${Util.getHour(date)}시 첫모임 ';
    }
    return '';
  }

  MeetingDetailItemData({
    this.name,
    this.gatheringStartDate,
    this.option,
    this.subUrl,
    this.minimumPerson,
    this.maximumPerson,
    this.maleLimit,
    this.femaleLimit,
    this.price,
    this.discountPrice,
    this.cover,
    this.itemKind,
    this.itemSubject1,
    this.itemSubject2,
    this.location,
    this.startDate,
    this.finishDate,
    this.summary,
    this.status,
    this.ItemRound,
    this.ItemLeader,
    this.itemDetail1,
    this.itemDetail2,
    this.itemDetail4,
    this.itemDetail5,
    this.itemHowPlaying,
    this.Order,
    this.badge,
    this.reviews,
  });

  MeetingDetailItemData copyWith({
    String name,
    String gatheringStartDate,
    String option,
    String subUrl,
    int minimumPerson,
    int maximumPerson,
    int maleLimit,
    int femaleLimit,
    int price,
    int discountPrice,
    String cover,
    String itemKind,
    String itemSubject1,
    String itemSubject2,
    String location,
    String startDate,
    String finishDate,
    String summary,
    String status,
    List<MeetingItemRoundData> ItemRound,
    MeetingItemLeaderData ItemLeader,
    String itemDetail1,
    String itemDetail2,
    String itemDetail4,
    String itemDetail5,
    List<String> itemHowPlaying,
    List<Map<String, dynamic>> Order,
    String badge,
    List<SimpleReviewData> reviews,
  }) {
    return MeetingDetailItemData(
      name: name ?? this.name,
      gatheringStartDate: gatheringStartDate ?? this.gatheringStartDate,
      option: option ?? this.option,
      subUrl: subUrl ?? this.subUrl,
      minimumPerson: minimumPerson ?? this.minimumPerson,
      maximumPerson: maximumPerson ?? this.maximumPerson,
      maleLimit: maleLimit ?? this.maleLimit,
      femaleLimit: femaleLimit ?? this.femaleLimit,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      cover: cover ?? this.cover,
      itemKind: itemKind ?? this.itemKind,
      itemSubject1: itemSubject1 ?? this.itemSubject1,
      itemSubject2: itemSubject2 ?? this.itemSubject2,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      ItemRound: ItemRound ?? this.ItemRound,
      ItemLeader: ItemLeader ?? this.ItemLeader,
      itemDetail1: itemDetail1 ?? this.itemDetail1,
      itemDetail2: itemDetail2 ?? this.itemDetail2,
      itemDetail4: itemDetail4 ?? this.itemDetail4,
      itemDetail5: itemDetail5 ?? this.itemDetail5,
      itemHowPlaying: itemHowPlaying ?? this.itemHowPlaying,
      Order: Order ?? this.Order,
      badge: badge ?? this.badge,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gatheringStartDate': gatheringStartDate,
      'option': option,
      'subUrl': subUrl,
      'minimumPerson': minimumPerson,
      'maximumPerson': maximumPerson,
      'maleLimit': maleLimit,
      'femaleLimit': femaleLimit,
      'price': price,
      'discountPrice': discountPrice,
      'cover': cover,
      'itemKind': itemKind,
      'itemSubject1': itemSubject1,
      'itemSubject2': itemSubject2,
      'location': location,
      'startDate': startDate,
      'finishDate': finishDate,
      'summary': summary,
      'status': status,
      'ItemRound': ItemRound?.map((x) => x?.toMap())?.toList(),
      'ItemLeader': ItemLeader?.toMap(),
      'itemDetail1': itemDetail1,
      'itemDetail2': itemDetail2,
      'itemDetail4': itemDetail4,
      'itemDetail5': itemDetail5,
      'itemHowPlaying': itemHowPlaying,
      'Order': Order,
      'badge': badge,
      'reviews': reviews,
    };
  }

  factory MeetingDetailItemData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MeetingDetailItemData(
      name: map['name'],
      gatheringStartDate: map['gatheringStartDate'],
      option: map['option'],
      subUrl: map['subUrl'],
      minimumPerson: map['minimumPerson'],
      maximumPerson: map['maximumPerson'],
      maleLimit: map['maleLimit'],
      femaleLimit: map['femaleLimit'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      cover: map['cover'],
      itemKind: map['itemKind'],
      itemSubject1: map['itemSubject1'],
      itemSubject2: map['itemSubject2'],
      location: map['location'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      summary: map['summary'],
      status: map['status'],
      ItemRound: List<MeetingItemRoundData>.from(map['ItemRound']?.map((x) => MeetingItemRoundData.fromMap(x))),
      ItemLeader: MeetingItemLeaderData.fromMap(map['ItemLeader']),
      // ItemRound: null,
      // ItemLeader: null,
      itemDetail1: map['itemDetail1'],
      itemDetail2: map['itemDetail2'],
      itemDetail4: map['itemDetail4'],
      itemDetail5: map['itemDetail5'],
      itemHowPlaying: map['itemHowPlaying'] != null ? (map['itemHowPlaying'] as List).map((x) => HowPlayingData.fromMap(x)).toList() : [],
      Order: List<Map<String, dynamic>>.from(map['Order']?.map((x) => x)),
      // itemHowPlaying: null,
      badge: map['badge'],
      reviews: map['reviews'] != null ? (map['reviews'] as List).map((x) => SimpleReviewData.fromMap(x)).toList() : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory MeetingDetailItemData.fromJson(String source) => MeetingDetailItemData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MeetingDetailItemData(name: $name, gatheringStartDate: $gatheringStartDate, option: $option, subUrl: $subUrl, minimumPerson: $minimumPerson, maximumPerson: $maximumPerson, maleLimit: $maleLimit, femaleLimit: $femaleLimit, price: $price, discountPrice: $discountPrice, cover: $cover, itemKind: $itemKind, itemSubject1: $itemSubject1, itemSubject2: $itemSubject2, location: $location, startDate: $startDate, finishDate: $finishDate, summary: $summary, status: $status, ItemRound: $ItemRound, ItemLeader: $ItemLeader, itemDetail1: $itemDetail1, itemDetail2: $itemDetail2, itemDetail4: $itemDetail4, itemDetail5: $itemDetail5, itemHowPlaying: $itemHowPlaying, Order: $Order, badge: $badge)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is MeetingDetailItemData &&
      o.name == name &&
      o.gatheringStartDate == gatheringStartDate &&
      o.option == option &&
      o.subUrl == subUrl &&
      o.minimumPerson == minimumPerson &&
      o.maximumPerson == maximumPerson &&
      o.maleLimit == maleLimit &&
      o.femaleLimit == femaleLimit &&
      o.price == price &&
      o.discountPrice == discountPrice &&
      o.cover == cover &&
      o.itemKind == itemKind &&
      o.itemSubject1 == itemSubject1 &&
      o.itemSubject2 == itemSubject2 &&
      o.location == location &&
      o.startDate == startDate &&
      o.finishDate == finishDate &&
      o.summary == summary &&
      o.status == status &&
      listEquals(o.ItemRound, ItemRound) &&
      o.ItemLeader == ItemLeader &&
      o.itemDetail1 == itemDetail1 &&
      o.itemDetail2 == itemDetail2 &&
      o.itemDetail4 == itemDetail4 &&
      o.itemDetail5 == itemDetail5 &&
      listEquals(o.itemHowPlaying, itemHowPlaying) &&
      listEquals(o.Order, Order) &&
      o.badge == badge;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      gatheringStartDate.hashCode ^
      option.hashCode ^
      subUrl.hashCode ^
      minimumPerson.hashCode ^
      maximumPerson.hashCode ^
      maleLimit.hashCode ^
      femaleLimit.hashCode ^
      price.hashCode ^
      discountPrice.hashCode ^
      cover.hashCode ^
      itemKind.hashCode ^
      itemSubject1.hashCode ^
      itemSubject2.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      finishDate.hashCode ^
      summary.hashCode ^
      status.hashCode ^
      ItemRound.hashCode ^
      ItemLeader.hashCode ^
      itemDetail1.hashCode ^
      itemDetail2.hashCode ^
      itemDetail4.hashCode ^
      itemDetail5.hashCode ^
      itemHowPlaying.hashCode ^
      Order.hashCode ^
      badge.hashCode;
  }
}
