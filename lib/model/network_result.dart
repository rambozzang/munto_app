
/*
20.09.21 이경준
구현방법 고민중....
* */
class NetworkResult {
  int statusCode;
  String error;
  String message;
  List<dynamic> errors;
  String timestamp;
  String path;

  dynamic _result;

  String get resultString {
    if(_result is String )
      return _result;
    return null;
  }
  int get resultInt {
    if(_result is int)
      return _result;
    return null;
  }

  double get resultDouble {
    if(_result is double)
      return _result;
    return null;
  }

}