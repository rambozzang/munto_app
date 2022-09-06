import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/provider/parent_provider.dart';
import 'package:munto_app/util.dart';

import '../socialing_data.dart';
import '../urls.dart';

class SocialingCreateProvider extends ParentProvider {
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Future<SocialingData> createSocialing(SocialingCreateData socialingCreateData) async {
    final token = await Util.getSharedString(KEY_TOKEN);
    _headers['Authorization'] = 'Bearer $token';
    final _callUri = "/api/socialing";
    final result = await multipart(
        _callUri,
        socialingCreateData.toMap(),
        socialingCreateData.photo1,
        socialingCreateData.photo2,
        socialingCreateData.cover);
    return result;
  }

  Future<SocialingData> multipart(String _path, Map map, String photo1Path,
      String photo2Path, String coverPath) async {
    final token = await Util.getSharedString(KEY_TOKEN);
    final formData = FormData.fromMap(map);

    if (photo1Path != null && photo1Path.isNotEmpty)
      formData.files.add(
        MapEntry(
          "photo1",
          MultipartFile.fromFileSync(photo1Path),
        ),
      );
    if (photo2Path != null && photo2Path.isNotEmpty)
      formData.files.add(
        MapEntry(
          "photo2",
          MultipartFile.fromFileSync(photo2Path),
        ),
      );
    if (coverPath != null && coverPath.isNotEmpty)
      formData.files.add(
        MapEntry(
          "cover",
          MultipartFile.fromFileSync(coverPath),
        ),
      );

    final response = await Dio().post(
      '$hostUrl$_path',
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    print('dio response = ${response.toString()}');
    return SocialingData.fromMap(response?.data);
  }
}

class SocialingCreateData {
  // String userId;
  String name;
  String type;
  String startDate;
  String finishDate;
  String location;
  String subject1;
  String subject2;
  String subject3;
  String introduce;
  String preparation;
  String minimumPerson;
  String maximumPerson;
  String status;
  String photo1;
  String photo2;
  String cover;
  int price;

  SocialingCreateData({
    this.name,
    this.type,
    this.startDate,
    this.finishDate,
    this.location,
    this.subject1,
    this.subject2,
    this.subject3,
    this.introduce,
    this.preparation,
    this.minimumPerson,
    this.maximumPerson,
    this.status,
    this.photo1,
    this.photo2,
    this.cover,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'startDate': startDate,
      'finishDate': finishDate,
      'location': location,
      'subject1': subject1,
      'subject2': subject2,
      'subject3': subject3,
      'introduce': introduce,
      'preparation': preparation,
      'minimumPerson': minimumPerson,
      'maximumPerson': maximumPerson,
      'status': status,
      'price' : price ?? 0,
      // 'photo1': photo1,
      // 'photo2': photo2,
      // 'cover': cover,
    };
  }

  factory SocialingCreateData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SocialingCreateData(
      name: map['name'],
      type: map['type'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      location: map['location'],
      subject1: map['subject1'],
      subject2: map['subject2'],
      subject3: map['subject3'],
      introduce: map['introduce'],
      preparation: map['preparation'],
      minimumPerson: map['minimumPerson'],
      maximumPerson: map['maximumPerson'],
      status: map['status'],
      price: map['price'],
      // photo1: map['photo1'],
      // photo2: map['photo2'],
      // cover: map['cover'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialingCreateData.fromJson(String source) =>
      SocialingCreateData.fromMap(json.decode(source));
}
