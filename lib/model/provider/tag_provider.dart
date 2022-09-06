import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/exceptions.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:http/http.dart' as http;
import 'package:munto_app/view/widget/hot_tag_widget.dart';
import 'dart:convert';

import '../../util.dart';
import '../urls.dart';
import '../member_data.dart';
import '../user_data.dart';

class TagProvider extends ParentProvider {
  List<TagData> dataList = [];

  Map<String, String> _loginBody(email, password) {
    return {
      'email': email ?? '',
      'password': password ?? '',
    };
  }
}

class TagData {
  int id;
  String name;
  String image;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  TagData({
    @required this.id,
    @required this.name,
    @required this.image,
  });

  TagData copyWith({
    int id,
    String name,
    String image,
  }) {
    return new TagData(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'TagData{id: $id, name: $name, image: $image}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ image.hashCode;

  factory TagData.fromMap(Map<String, dynamic> map) {
    return new TagData(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
