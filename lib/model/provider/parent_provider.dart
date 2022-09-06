

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:http/http.dart' as http;

import '../exceptions.dart';

const DEFAULT_TIMEOUT_SEC = 10;

class ParentProvider with ChangeNotifier{

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  setStateBusy(){
    _state = ViewState.Busy;
    notifyListeners();
  }
  setStateIdle(){
    _state = ViewState.Idle;
    notifyListeners();
  }

  bool isSuccess(int responseCode){
    return responseCode != null && 200 <= responseCode && responseCode < 300;
  }

  dynamic throwException(http.Response response){
    setStateIdle();
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}