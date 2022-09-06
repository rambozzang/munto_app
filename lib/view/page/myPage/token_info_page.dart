
import 'package:app_settings/app_settings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:munto_app/model/provider/user_Provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../../../util.dart';

bool marketingAllowed = false;

class TokenInfoPage extends StatefulWidget {
  @override
  _TokenInfoPageState createState() => _TokenInfoPageState();
}

class _TokenInfoPageState extends State<TokenInfoPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool pushAllowed = false;

  @override
  void initState() {
    super.initState();
    getPushAllowed();

  }
  getPushAllowed() async {
    String result = await Util.getSharedString(KEY_PUSH_ALLOWED);
    print('getPushAllowed : $result');
    setState(() {
      pushAllowed = result != null && result == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림 설정'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: MColors.barBackgroundColor ,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(barBorderWidth),
          child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
          child: Row(children: [
            Expanded(child: Text('알림 수신하기', style: MTextStyles.bold16Black,)),
            Switch(inactiveTrackColor: const Color(0x29787880), value: pushAllowed, onChanged: (value) async {

              if(value){
                await Util.setSharedString(KEY_PUSH_ALLOWED, 'true');
                _firebaseMessaging.getToken().then((String token) {
                  assert(token != null);
                  print('fcm token = $token');
                  savetoken(token);
                  setState((){
                    pushAllowed = value;
                  });
                });
              } else {
                Util.showNegativeDialog4(context, '중요한 소식을 놓칠 수 있어요!', '알림을 끄면 나와 관련된 알림과 모임 참여에 필요한 필수 공지사항을 받을 수 없게 됩니다. 그래도 알림을 끄시겠어요?','아니오', '예', () async {

                }, () async {
                  await Util.setSharedString(KEY_PUSH_ALLOWED, 'false');
                  _firebaseMessaging.deleteInstanceID();
                  UserInfo.pushToken = '';

                  setState((){
                    pushAllowed = value;
                  });
                });
              }



            })
          ],),
        ),
        // 기기 [설정 > 알림] 에서 MUNT
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20.0,),
          child: Text("기기 [설정 > 알림] 에서 MUNTO 앱을 허용해주세요",
              style: MTextStyles.regular14Grey06),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
          child: Row(children: [
            Expanded(child: Text('마케팅 알림 받기', style: MTextStyles.bold16Black,)),
            Switch(inactiveTrackColor: const Color(0x29787880), value: marketingAllowed, onChanged: (value){
              setState((){
                marketingAllowed = value;
              });
            })
          ],),
        ),
        // 기기 [설정 > 알림] 에서 MUNT
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20.0,),
          child: Text("추천 모임 및 다양한 문토 이벤트 알림을 받습니다.",
              style: MTextStyles.regular14Grey06),
        ),

        // Rectangle Copy 2
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
          child: InkWell(
            onTap: (){
              AppSettings.openAppSettings();
            },
            child: Container(
                height: 48,width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: MColors.white_three
                ),
              child: Center(child: Text('설정 바로가기', style: MTextStyles.bold14Grey06,)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 40.0),
          child: Center(child: Text('알림을 끄면 모임 참여에 필요한 필수 공지사항과 중요 알림을 받으실 수 없습니다.')),
        ),

        // Padding(
        //   padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0 ),
        //   child: Text(UserInfo.pushToken ?? ''),
        // ),
        // Builder(
        //   builder: (buildContext) => IconButton(
        //     icon: Icon(Icons.content_copy),
        //     onPressed: (){
        //       FlutterClipboard.copy(UserInfo.pushToken ?? '').then(( value ) =>
        //           Scaffold.of(buildContext).showSnackBar(SnackBar(content: Text('copied'),))
        //       );
        //     },
        //   ),
        // )
      ],),
    );
  }

  Future<void> savetoken(token) async {
    // token 과 uid 를 시크리티에 저장
    // 시크리티스토리지에 데이타가 있는 겨우 toket 만 업데이트 후
    // 최초이거나 토큰이 갱신이라면 서버 api put 처리
    var uuid = Uuid();
    var currentuuid = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    try {
      // 1. UUID 가 존재 하는지 체크
      final deviceUUID = await FlutterSecureStorage().read(key: "DEVICE_UUID");
      print('저장된 deviceUUID : $deviceUUID');
      // bool isSend = false;
      // 2. UUID 없을 경우   => 저장후 userpush 처리 '
      if (deviceUUID == null || deviceUUID == '') {
        print('FlutterSecureStorage 저장!');
        await FlutterSecureStorage().write(key: "DEVICE_UUID", value: currentuuid);
        await FlutterSecureStorage().write(key: "FIREBASE_TOKEN", value: token);
        print('currentuuid : $currentuuid');
        // isSend = true;
      } else {
        // 3. UUID 가 존재하는 경우 => userpush 처리
        final firebaseToken = await FlutterSecureStorage().read(key: "FIREBASE_TOKEN");
        if (token != firebaseToken) {
          await FlutterSecureStorage().write(key: "FIREBASE_TOKEN", value: token);
          // isSend = true;
        }
      }

      UserInfo.pushToken = token;
      // 4. api 호출한다.
      // if (isSend) {
      final muntoToken = await Util.getSharedString(KEY_TOKEN);
      print('UserUserPush Api 호출 !!  : $muntoToken');
      UserProvider userProvider = UserProvider();
      Map<String, dynamic> _map = Map();
      _map['pushId'] = token;
      _map['deviceId'] = currentuuid;
      final response = await userProvider.putUserUserPush(_map);
      print('response : ${response.toString()}');
      // }
    } catch (e) {
      print('API USERPUSH 호출시 오류 발생 : ${e.toString()}');
    }
  }

}
