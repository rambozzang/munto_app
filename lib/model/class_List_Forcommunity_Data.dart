import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:munto_app/model/class_communtiy_data.dart';
import 'package:munto_app/model/class_communtiy_data.dart';

class ClassListForCommuntiyData {
  
  List<CommuntiyData> playingClassList;
  List<CommuntiyData> managingClassList;
  ClassListForCommuntiyData({
    this.playingClassList,
    this.managingClassList,
  });

  ClassListForCommuntiyData copyWith({
    List<CommuntiyData> playingClassList,
    List<CommuntiyData> managingClassList,
  }) {
    return ClassListForCommuntiyData(
      playingClassList: playingClassList ?? this.playingClassList,
      managingClassList: managingClassList ?? this.managingClassList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playingClassList': playingClassList?.map((x) => x?.toMap())?.toList(),
      'managingClassList': managingClassList?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory ClassListForCommuntiyData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ClassListForCommuntiyData(
      playingClassList: List<CommuntiyData>.from(map['playingClassList']?.map((x) => CommuntiyData.fromMap(x))),
      managingClassList: List<CommuntiyData>.from(map['managingClassList']?.map((x) => CommuntiyData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassListForCommuntiyData.fromJson(String source) => ClassListForCommuntiyData.fromMap(json.decode(source));

  @override
  String toString() => 'ClassListForCommuntiyData(playingClassList: $playingClassList, managingClassList: $managingClassList)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ClassListForCommuntiyData &&
      listEquals(o.playingClassList, playingClassList) &&
      listEquals(o.managingClassList, managingClassList);
  }

  @override
  int get hashCode => playingClassList.hashCode ^ managingClassList.hashCode;
}
