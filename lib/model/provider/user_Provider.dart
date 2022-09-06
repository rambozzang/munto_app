import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/parent_provider.dart';

class UserProvider extends ParentProvider {
  ApiService _api = ApiService();

  // Method    : POST
  // url       : /api/user/find/email
  Future<Map<String, dynamic>> getUserFindEmail(_name , _tel ) async {
    final _callUri = '/api/user/find/email?name=$_name&phoneNumber=$_tel';
    final response = await _api.get(_callUri);
    print(response.toString());
    return response;
  }

  // Method    : POST
  // url       : /api​/user​/reset​/password​/code"
  // 인증번호 발송
  Future<Map<String, dynamic>> postUserResetPasswordCode(Map<String, dynamic> _map) async {
    final _callUri = '/api/user/reset/password/code';
    final response = await _api.post(_callUri, _map);
    print(response.toString());
    // List<ClassData> list = (response as List).map((data) => ClassData.fromMap(data)).toList();
    return response;
  }

  // Method    : POST
  // url       : /api/user/reset/password/code/isValid'
  // 인증번호 인증 처리
  Future<Map<String, dynamic>> postUserResetPasswordCodeisValid(Map<String, dynamic> _map) async {
    final _callUri = '/api/user/reset/password/code/isValid';
    final response = await _api.post(_callUri, _map);
    print(response.toString());
    //  List<ClassData> list =
    //     (response as List).map((data) => ClassData.fromMap(data)).toList();
    return response;
  }

  // Method    : POST
  // url       : /api/user/reset/password
  Future<Map<String, dynamic>> postUserResetPassword(Map<String, dynamic> _map) async {
    final _callUri = '/api/user/reset/password';
    final response = await _api.post(_callUri, _map);
    print(response.toString());
    //  List<ClassData> list =
    //     (response as List).map((data) => ClassData.fromMap(data)).toList();
    return response;
  }

  // Method    : POST
  // url       : /api/user/userPush
  // 서버에 토큰 및 전송
  Future<Map<String, dynamic>> putUserUserPush(Map<String, dynamic> _map) async {

    // deviceId : UUID 기기별 식별키  ,  pushId : firebase token
    
    final _callUri = '/api/user/userPush';
    final response = await _api.put(_callUri, _map);
    print(response.toString());
    //  List<ClassData> list =
    //     (response as List).map((data) => ClassData.fromMap(data)).toList();
    return response;
  }


}
