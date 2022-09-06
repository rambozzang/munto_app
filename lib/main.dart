import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:connectivity/connectivity.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_flutter_sdk/all.dart' as kakao;
import 'package:munto_app/app_state.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/enum/loginProvier_Eum.dart';
import 'package:munto_app/model/fcm_message_data_data.dart';
import 'package:munto_app/model/fcm_message_main_data.dart';
import 'package:munto_app/model/fcm_message_notification_data.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/message_Provider.dart';
import 'package:munto_app/model/provider/message_list_provider.dart';
import 'package:munto_app/model/provider/socialing_create_provider.dart';
import 'package:munto_app/model/provider/user_Provider.dart';
import 'package:munto_app/model/provider/user_profile_provider.dart';
import 'package:munto_app/model/question_data.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/route.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/communityPage/community_list_page.dart';
import 'package:munto_app/view/page/feedPage/feed_page.dart';
import 'package:munto_app/view/page/galleryPage/guest_profile_page.dart';
import 'package:munto_app/view/page/loginPage/login_page.dart';
import 'package:munto_app/view/page/lounge_page.dart';
import 'package:munto_app/view/page/myPage/user_Modify_Page.dart';
import 'package:munto_app/view/page/userPage/my_profile_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/fade_stack.dart';
import 'package:munto_app/view/widget/guest_banner_widget.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'model/eventbus/feed_upload_finished.dart';
import 'model/meeting_data.dart';
import 'model/provider/login_provider.dart';
import 'model/provider/signup_provider.dart';
import 'model/provider/socialing_provider.dart';
import 'model/provider/tag_provider.dart';
import 'model/provider/tag_search_provider.dart';

enum Status { Login, Logout, Authenticating }
EventBus eventBus = EventBus();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await Util.getSharedString(KEY_TOKEN); // rest api token key

  final loginMethodProvider = await Util.getSharedString(KEY_LOGIN_PROVIDER);
  final accessToken = await Util.getSharedString(KEY_ACCESS_TOKEN);
  final loginProvider = await Util.getSharedString(KEY_LOGIN_PROVIDER);
  bool autoLogin = false;

  print('loginMethodProvider : $loginMethodProvider');

  String _key = '';
  LoginMethodProvider loginType;

  // loginMethodProvider 존재여부 판단
  if (loginMethodProvider == '' || loginMethodProvider == null || loginMethodProvider == 'NONE') {
    loginType = LoginMethodProvider.NONE;
  } else {
    // loginMethodProvider 존재할 경우 key 값 셋팅

    loginType = EnumToString.fromString(LoginMethodProvider.values, loginMethodProvider); // ENUM 를 반환
    if (loginMethodProvider == 'EMAIL') {
      _key = token;
    } else {
      _key = accessToken;
    }
  }

  runApp(App(loginType: loginType, token: _key));
}

//handling FCM 10.13. 경준
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}

class App extends StatelessWidget {
  App({this.loginType, this.token});

  final LoginMethodProvider loginType;
  final String token;


  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SignUpProvider>(
            create: (_) => SignUpProvider(),
          ),
          ChangeNotifierProvider<UserProfileProvider>(
            create: (_) => UserProfileProvider(),
          ),
          ChangeNotifierProvider<LoginProvider>(
            create: (_) => LoginProvider(),
          ),
          ChangeNotifierProvider<SocialingProvider>(
            create: (_) => SocialingProvider(),
          ),
          ChangeNotifierProvider<TagProvider>(
            create: (_) => TagProvider(),
          ),
          ChangeNotifierProvider<FeedProvider>(
            create: (_) => FeedProvider(),
          ),
          ChangeNotifierProvider<SocialingCreateProvider>(
            create: (_) => SocialingCreateProvider(),
          ),
          ChangeNotifierProvider<MessageListProvider>(
            create: (_) => MessageListProvider(),
          ),
          ChangeNotifierProvider<TagSearchProvider>(
            create: (_) => TagSearchProvider(),
          ),
          ChangeNotifierProvider<ItemProvider>(
            create: (_) => ItemProvider(),
          ),
          ChangeNotifierProvider<MessageProvider>(
            create: (_) => MessageProvider(),
          ),
          ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider(),
          ),
        ],
        child: MaterialApp(
          builder: (context, child){
            final MediaQueryData data = MediaQuery.of(context);
            final maxScaleFactor = 1.10;
            final minScaleFactor = kReleaseMode ? 0.90 : 1.10;
            // final minScaleFactor = 1.10;
            return MediaQuery(
              data: data.copyWith(
                  textScaleFactor: min(max(data.textScaleFactor, minScaleFactor), maxScaleFactor),
              ),
              child: child,
            );
          },
          title: 'Munto',
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: MColors.tomato,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: RootPage(loginType, token),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routers.generateRoute,
        ));
  }
}

class RootPage extends StatefulWidget {
  final LoginMethodProvider loginType;
  final String token;
  RootPage(this.loginType, this.token);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String ttkon = '';
  LoginProvider loginPro;
  String text = '';
  GlobalKey<ScaffoldState> rootScaffoldKey;


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      analytics = Amplitude.getInstance(instanceName: kReleaseMode ? 'munto' : 'munto(test)');
      analytics.setUseDynamicConfig(true);
      analytics.setServerUrl("https://api2.amplitude.com");
      analytics.init(amplitudeKey);
      analytics.enableCoppaControl();
      analytics.setUserId("notLoggedInUser");
      analytics.trackingSessionEvents(true);
      analytics.logEvent(OPEN_APP);
      // analytics.logEvent('MyApp startup', eventProperties: {
      //   'event_prop_1': 10,
      //   'event_prop_2': true
      // });
      Map<String, dynamic> userProps = {
        'buildNumber': '${packageInfo.version}  (${packageInfo.buildNumber})',
      };
      analytics.setUserProperties(userProps);
    });




    loginPro = Provider.of<LoginProvider>(context, listen: false);
    loginPro.setIsAuth(LoginStatus.Authenticating);

    //  Util.showToast(context, 'RootPage > widget.loginType : ${widget.loginType} , widget.token : ${widget.token}');
    if (widget.loginType != LoginMethodProvider.NONE && widget.token != '') {
      text += 'widget.loginType 1: ${widget.loginType}   ,widget.token : ${widget.token} \n';
      loginProcess();
    } else {
      text += 'widget.loginType 2: ${widget.loginType}   ,widget.token : ${widget.token} \n';
      // delay 걸지 실행
      Future.delayed(Duration(milliseconds: 200), () async {
        loginPro.setIsAuth(LoginStatus.Logout);
      });
    }
  }

  loginProcess() async {
    print('getData 실행!!!');

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if(connectivityResult == ConnectivityResult.none){
        loginPro.setIsAuth(LoginStatus.Logout);
        return;
      }
      text += 'widget.loginType :  ${widget.loginType}\n';

      String adminTest = await Util.getSharedString(KEY_ADMIN_TEST);
      if(adminTest == 'true')
        adminTestMode = true;

      if (widget.loginType == LoginMethodProvider.EMAIL) {
        // Email 로그인 처리
        final email = await Util.getSharedString(KEY_EMAIL);
        final password = await Util.getSharedString(KEY_PASSWORD);
        final pwDecrypted = Util.decodeAES(password);
        // Util.showToast(context, 'Email로 로그인 처리시작 !!');
        text += 'Email로 로그인 처리시작 !!  ${email}   \n';
        await loginPro.loginLocal(email, pwDecrypted);
      } else {
        final logintype = EnumToString.convertToString(widget.loginType);
        String token = widget.token;

        if(widget.loginType == LoginMethodProvider.KAKAO) {
          kakao.KakaoContext.clientId = '16d7bd065f6301a08b6ca0f7ac764b85';
          var storedToken = await kakao.AccessTokenStore.instance.fromStore();
          kakao.AccessTokenResponse response = await kakao.AuthApi.instance.refreshAccessToken(storedToken.refreshToken);
          token = response.accessToken;
        } else if(widget.loginType == LoginMethodProvider.FACEBOOK) {

        }

        print('$logintype 로 자동 로그인!!!!!!!');
        text += '$logintype 로 자동 로그인!!!!!!!\n';

        final result = await loginPro.login(logintype, token);
        print('result : $result');
        print('result : ${result.token}');
        text += 'result.token  : ${result.token} \n';

        if (result.token != null && result.token.isNotEmpty) {
          Util.setSharedString(KEY_LOGIN_PROVIDER, logintype);
          Util.setSharedString(KEY_ACCESS_TOKEN, token);
          Util.setSharedString(KEY_TOKEN, result.token);
          text += '로그인 loginPro.getUserProfile() 실행  \n';
          UserInfo.myProfile = await loginPro.getUserProfile();
          text += '로그인 성공 : ${UserInfo.myProfile.name} \n';
          loginPro.setIsAuth(LoginStatus.Login);
        } else if (result.token == 'no user') {
          text += '로그인 실패 result.token 1: ${result.token}  \n';
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   duration: Duration(milliseconds: 1500),
          //   content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
          // ));
          loginPro.setIsAuth(LoginStatus.Logout);
        } else {
          text += '로그인 실패 result.token 2 : ${result.token}  \n';
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   duration: Duration(milliseconds: 1500),
          //   content: Text('정상적으로 로그인되지 않았습니다.다시 시도 해 주세요'),
          // ));
          loginPro.setIsAuth(LoginStatus.Logout);
        }
      }
      print('_getCurrentBody() Call !!!!!!!!');
      setState(() {});
    } catch (e) {
      // 인증 오류시 로그인 화면으로 이동.
      text += 'loginProcess excaption 발생 : ${e.toString()}  \n';
      setState(() {});
      print(e.toString());
      loginPro.setIsAuth(LoginStatus.Logout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LoginProvider, LoginStatus>(
        selector: (_, loginProvider) => loginProvider.isAuthState,
        builder: (BuildContext context, isAuthState, final Widget child) {
          print('##############################');
          print('root.dart : $isAuthState');
          print('##############################');
          print(text);

          // return Scaffold(body: SingleChildScrollView(child: SafeArea(child: Text(text))));
          switch (isAuthState) {
            // 인증처리중 상태
            case LoginStatus.Authenticating:
              return Scaffold(
                  key: rootScaffoldKey,
                  body: Container(
                      color: MColors.tomato,
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: MColors.tomato,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      ))));
            // 로그인 완료된 상태
            case LoginStatus.Login:
              // WidgetsBinding.instance.addPostFrameCallback((_) => _alert(context));
              return Main();
            // 로그아웃 상태
            case LoginStatus.Logout:
              return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  PageController pageController;
  // int currentBottomIndex = 0;
  // int previousBottonIndex = 0;

  Map<int, GlobalKey> keyMap = {};
  //socialing or feed write page
  // default = socialing
  final group1 = MeetingGroup(MeetingHeader('소셜링', '서로의 취향과 생각을 나누는', HeaderStyle.STYLE2), null, meetingGroupAll);
  FcmMessageMainData fcmMessageData = FcmMessageMainData();

  List<Widget> pageList = List<Widget>();
  
  bool showGuestBanner = false;
  PageController questionCardController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300),(){
      try{
        AppStateSetUserId('${UserInfo.myProfile.id}');
        AppStateSetUserProperties({
          'Total Number of Followings': '${UserInfo.myProfile?.following?.length ?? 0})',
          'Gender': '${UserInfo.myProfile?.sex ?? ''})',
          'AGE': '${UserInfo.myProfile?.age ?? ''})',
          'member_ID': '${UserInfo.myProfile?.id ?? ''})',
          'member_Email': '${UserInfo.myProfile?.email ?? ''})',
        });
        AppStateLog(context, PAGEVIEW_LOUNGE);

        print('main initState no error');

      } catch (e){
        print('main initState ${e.toString()}');
      }

    });

    pageController = PageController();
    questionCardController = PageController(viewportFraction: 0.8);
    var loginPro = Provider.of<LoginProvider>(context, listen: false);

    pageList.add(_navigator(index: 0, initialRoute: 'LoungePage'));
    pageList.add(_navigator(index: 1, initialRoute: 'FeedPage'));
    pageList.add(SizedBox.shrink());
    pageList.add(_navigator(index: 3, initialRoute: 'CommunityListPage'));
    if (loginPro.guestYn == "Y") {
      pageList.add(_navigator(index: 4, initialRoute: 'GuestProfilePage'));
    } else {
      pageList.add(_navigator(index: 4, initialRoute: 'MyProfilePage'));
    }

    if (!kReleaseMode) {
      // _firebaseMessaging.subscribeToTopic('dev/test');
    }

    initFireBaseMessage();
  }

  Future<void> initFireBaseMessage() async {
    String result = await Util.getSharedString(KEY_PUSH_ALLOWED);

    if(result != null && result == 'false'){
      print('유저가 푸시 설정 꺼둠');
      return;
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage : $message');
        try {
          if (Platform.isIOS) {
            fcmMessageData.data = FcmMessageData.fromMap(message);
            fcmMessageData.notification = FcmMessageNotification.fromMap(message['notification']);
          } else {
            fcmMessageData = FcmMessageMainData.fromMap(message);
          }
          _showItemDialog(fcmMessageData);
        } catch (e) {
          print(e.toString());
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _fcmProcessing(message);
      },
      // 백그라운드시 발생후 상단바 노티를 클릭했을때 앰이 실행되면서  이벤트 발생
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _fcmProcessing(message);
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

    }

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print('fcm token = $token');

      savetoken(token);
      // final provider = Provider.of<LoginProvider>(context, listen: false);
      // setState(() {
      // _homeScreenText = "Push Messaging token: $token";
      // });
      // print(_homeScreenText);
    });
  }

  // fcm 메세지 처리
  Future<void> _fcmProcessing(message) async {
    if (Platform.isIOS) {
      fcmMessageData.data = FcmMessageData.fromMap(message);
      fcmMessageData.notification = FcmMessageNotification.fromMap(message['notification']);
    } else {
      fcmMessageData = FcmMessageMainData.fromMap(message);
    }
    _navigateToItemDetail(fcmMessageData);
  }

  // firebase token 저장
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final currentBottomIndex  = Provider.of<BottomNavigationProvider>(context).currentIndex;

    return WillPopScope(
      onWillPop: () {
        final GlobalKey<NavigatorState> currentKey = keyMap[currentBottomIndex];
        if (currentKey != null && currentKey.currentState.canPop()) {
          currentKey.currentState.pop();
          return Future.value(false);
        }
        if (currentBottomIndex != 0) {
          AppStateLog(context, PAGEVIEW_LOUNGE);

          Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
          return Future.value(false);
        }

        AppStateLog(context, CLOSE_APP);
        return Future.value(true);
      },
      child: Scaffold(
        // body: Stack(
        //   children: <Widget>[
        //     _offStageNavigator(index: 0, initialRoute: 'LoungePage'),
        //     _offStageNavigator(index: 1, initialRoute: 'FeedPage'),
        //     _offStageItem(index: 3, child: CommunityListPage()),
        //     _offStageNavigator(index: 4, initialRoute: 'MyProfilePage'),
        //   ],
        // ),
        body: _getCurrentBody1(currentBottomIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // color: MColors.tomato,
            boxShadow: [
              BoxShadow(
                color: MColors.white_three,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: MColors.white_two,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentBottomIndex,
              showUnselectedLabels: true,
              onTap: (index) {
                print('index = $index');

                if (index == 2) {
                  final loginPro = Provider.of<LoginProvider>(context, listen: false);
                  if (loginPro.guestYn == "Y")
                    _showGuestDialog();
                  else if(loginPro.isGeneralUser)
                    Util.showGeneralUserDialog(context);
                  else if(loginPro.isSnsTempUser)
                    _showGuestBanner();
                  else{
                    _settingModalBottomSheet(context, index);
                  }
                } else {
                  if(index == 0)
                    AppStateLog(context, PAGEVIEW_LOUNGE);
                  if(index == 4)
                    AppStateLog(context, PAGEVIEW_MY_PROFILE);

                  Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(index);
                  // bottomProvider.setIndex(index);
                }
              },
              fixedColor: MColors.tomato,
              unselectedItemColor: MColors.pinkish_grey,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              items: [
                BottomNavigationBarItem(
                    icon: currentBottomIndex == 0
                        ? SvgPicture.asset('assets/icons/home_enabled.svg')
                        : SvgPicture.asset('assets/icons/home_disabled.svg'),
                    // ignore: deprecated_member_use
                    title: Text('라운지')),
                BottomNavigationBarItem(
                    icon: currentBottomIndex == 1
                        ? SvgPicture.asset('assets/icons/feed_enabled.svg')
                        : SvgPicture.asset('assets/icons/feed_disabled.svg'),
                    title: Text('피드')),
                BottomNavigationBarItem(
                    icon: Builder(
                      builder: (buildContext) =>
                          //서버개발쪽 푸시테스트 위한 임시기능
                          GestureDetector(
                        child: SvgPicture.asset('assets/icons/write_disabled.svg'),
                        onLongPress: () {
                          print('long press');
                          FlutterClipboard.copy(UserInfo.pushToken ?? '')
                              .then((value) => Scaffold.of(buildContext).showSnackBar(SnackBar(
                                    content: Text('copied'),
                                  )));
                        },
                      ),
                    ),
                    title: Container(height: 0.0)),
                BottomNavigationBarItem(
                    icon: currentBottomIndex == 3
                        ? SvgPicture.asset('assets/icons/community_enabled.svg')
                        : SvgPicture.asset('assets/icons/community_disabled.svg'),
                    title: Text('커뮤니티')),
                BottomNavigationBarItem(
                    icon: currentBottomIndex == 4
                        ? SvgPicture.asset('assets/icons/my_enabled.svg')
                        : SvgPicture.asset('assets/icons/my_disabled.svg'),
                    title: Text('프로필'))
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  // 글쓰기 bottom sheet 부분
  void _settingModalBottomSheet(parentContext, index) {

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
      context: parentContext,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 60.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
              ),
              SizedBox(height: 20.0,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                ),
                height: SizeConfig.screenHeight * 0.18,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() async {
                            Navigator.pop(context);
                            final loginPro = Provider.of<LoginProvider>(context, listen:false);
                            if(loginPro.isSnsTempUser || loginPro.isGeneralUser){
                              return;
                            }
                            final result = await Navigator.of(context).pushNamed('OpenSocialingPage');
                            if (result) {
                              // setState(() {
                              //   currentBottomIndex = 0;
                              // });
                              Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
                            }
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/socialing_open.svg'),
                            Text(
                              '소셜링 열기',
                              style: MTextStyles.medium14Grey06,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenHeight * 0.14,
                      width: 2,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: MColors.white_three,
                      )),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          _showQuestionCards(parentContext);

                          // Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);
                          //
                          // final result = await Navigator.of(context).pushNamed('FeedWritePage');
                          // print(result ? '피드쓰기 성공' : '피드쓰기 실패');
                          //
                          // if (result) {
                          //   Provider.of<BottomNavigationProvider>(context, listen: false).refreshLoungeFeed();
                          //   // final feedProvider = Provider.of<FeedProvider>(context, listen: false);
                          //   // feedProvider.fectchLoungPage(1);
                          //
                          //   AppStateLog(context, UPOAD_FEED);
                          //
                          // }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/feed_write.svg'),
                            Text(
                              '피드 쓰기',
                              style: MTextStyles.medium14Grey06,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showQuestionCards(context){
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        context: context,
        builder: (buildContext){
          final tempList = List.generate(QUESTION_FILE_LIST.length, (index) => index);
          var indexList = tempList.sublist(1,tempList.length);
          indexList.shuffle();
          indexList = [0] + indexList;

      return Container(
        child: Column(
          children: [
            SizedBox(height: 100.0,),
            Expanded(
                child: PageView.builder(
                  controller: questionCardController,
                  itemCount: QUESTION_FILE_LIST.length,
                  itemBuilder: (context, i){
                    final randomIndex = indexList[i];
                    String filePath = QUESTION_FILE_LIST[randomIndex];


                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap:() async {
                          Navigator.pop(context);

                          Provider.of<BottomNavigationProvider>(context, listen: false).setIndex(0);

                          final result = await Navigator.of(context).pushNamed('FeedWritePage', arguments: {
                            'tags': QUESTION_TAG_LIST[randomIndex]
                          });
                          print(result ? '피드쓰기 성공' : '피드쓰기 실패');

                          if (result) {
                            // Provider.of<BottomNavigationProvider>(context, listen: false).refreshLoungeFeed();
                            // final feedProvider = Provider.of<FeedProvider>(context, listen: false);
                            // feedProvider.fectchLoungPage(1);

                            AppStateLog(context, UPLOAD_FEED);

                          }
                        },
                        child: Image.asset(
                          filePath,
                          fit: BoxFit.fitWidth,
                          // color: index == 0 ? Colors.yellow : Colors.purple,
                        ),
                      ),
                    );
                  },
                )
            ),
            IconButton(icon: SvgPicture.asset('assets/icons/basket_delete.svg', width: 24.0, height: 24.0,), onPressed: ()=> Navigator.pop(context)),
            SizedBox(height: 100.0,),

          ],
        ),
      );
    });
  }

  _showGuestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            height: 466,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    height: 235,
                    width: 300,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                      image: new DecorationImage(
                        image: new NetworkImage(
                            'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1600423581514_2500.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ))
                ]),
                SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('로그인이 필요합니다.', textAlign: TextAlign.left, style: MTextStyles.regular14Grey06)),
                SizedBox(height: 6),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('취향이 통하는 사람들과\n함께 소통해보세요', style: MTextStyles.bold20Grey06)),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.of(context).pushNamed('LoginPage');
                      Provider.of<LoginProvider>(context, listen: false).setIsAuth(LoginStatus.Logout);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(38)),
                        color: Color(0xfffed820),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/kakao.svg'),
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                          ),
                          Text('카카오톡으로 나의 취향 시작하기', style: MTextStyles.regular14Grey06, textAlign: TextAlign.center),
                        ],
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Provider.of<LoginProvider>(context, listen: false).setIsAuth(LoginStatus.Logout);
                  },
                  child: Text(
                    '다른 방법으로 로그인',
                    style: MTextStyles.regular14Grey06_,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showGuestBanner (){
    setState(() {
      showGuestBanner = true;
    });
  }


  Navigator _navigator({int index, String initialRoute}) {
    GlobalKey key = keyMap[index];
    if (key == null) {
      key = GlobalKey<NavigatorState>();
      keyMap[index] = key;
    }
    return Navigator(
      key: key,
      onGenerateRoute: Routers.generateRoute,
      initialRoute: initialRoute,
    );
  }

  Widget _getCurrentBody(int currentBottomIndex) {
    var loginPro = Provider.of<LoginProvider>(context, listen: false);
    switch (currentBottomIndex) {
      case 1:
        return _navigator(index: 1, initialRoute: 'FeedPage');
        break;
      case 3:
        // if (kReleaseMode)
        //   return _navigator(index: 3, initialRoute: 'GuidePage');
        // else

        return _navigator(index: 3, initialRoute: 'CommunityListPage');
        break;
      case 4:
        if (loginPro.guestYn == "Y") {
          return _navigator(index: 4, initialRoute: 'GuestProfilePage');
        } else {
          return _navigator(index: 4, initialRoute: 'MyProfilePage');
          //  return _navigator(index: 4, initialRoute: 'SocialingDetailPage');
        }
        break;
      default:
        return _navigator(index: 0, initialRoute: 'LoungePage');
    }
  }

  Widget _getCurrentBody1(int currentBottomIndex) {
    return Stack(
      children: [
        FadeIndexedStack(
          index: currentBottomIndex,
          children: pageList,
        ),
        showGuestBanner ? GuestBannerWidget(
          onPositive:() async {
            setState(() {
              showGuestBanner = false;
            });
            await Navigator.of(context).push(MaterialPageRoute(builder:(_)=> CustomerModifyPage()));
          },
          onCancel: (){
            setState(() {
              showGuestBanner = false;
            });
        },) : SizedBox.shrink(),
        // Rectangle
      ],
    );
  }

  // fcm 메세지 팝업중인 여부 확인
  bool msgNotificating = false;

  void _showItemDialog(FcmMessageMainData message) {
    String _title = message.data.title; // +''+ message.data.content;
    String _content = message.data.content;
    // String _buttonText = '확인하러가기';
    // if (Platform.isIOS) {
    //    _title =  message.notification.titel;
    //    _content = message.notification.body;
    // }

    // 2020.11.05 alertdialog 에서 상단 snackbar 로 변경 작업
    //Util.showNegativeDialog2(context, _title, _content, _buttonText, () => _navigateToItemDetail(message));
    print('msgNotificating : $msgNotificating');
    if (msgNotificating) {
      return;
    }

    msgNotificating = true;
    showFlash(
      context: context,
      duration: Duration(milliseconds: 3200),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.0),
          borderColor: MColors.black_three.withOpacity(0.1),
          position: FlashPosition.top,
          style: FlashStyle.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
          enableDrag: false,
          onTap: () => null, // _navigateToItemDetail(message),
          child: Container(
            // width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(''),
                  radius: 30.0,
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title ?? '',
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: MTextStyles.regular14Grey06,
                    ),
                    Text(
                      _content ?? '-',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: MTextStyles.regular12Grey06,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      msgNotificating = false;
      print('showCenterFlash  Closed !!!!  ');
      if (_ != null) {
        print('showCenterFlash : ${_.toString()}');
      }
    });
  }

  // 아래 함수 수정시 동일 하게  notification_page.dart 도 수정해야함
  // context 때문에 util에 둘수 없어 각 페이지마다 존재함.
  void _navigateToItemDetail(FcmMessageMainData fcmMessageMainData) async {
    // 0.라우터 셋팅
    final _kind = fcmMessageMainData.data.kind;
    final _feedId = fcmMessageMainData.data.feedId;
    final _userId = fcmMessageMainData.data.userId;
    // 1. route dlfma 가져오기
    String routeName = Util.getNavibyFirebaseKind(_kind);
    // 2. Navigator parameter 존재여부
    bool isArguments = false;
    dynamic arguments;
    Map<dynamic, dynamic> argumentsMap = Map();
    // 2.페이지별 파라메터가 생성
    // 2.1 GO_TO_FEED 인경우 feedData Data 가 필요.
    if (_kind == 'GO_TO_FEED') {
      isArguments = true;
      FeedData feed = await Provider.of<FeedProvider>(context, listen: false).getFeedById(_feedId);
      argumentsMap['feed'] = feed;
    }

    if (_kind == 'GO_TO_FEED_COMMENT') {
      isArguments = true;
      FeedData feed = await Provider.of<FeedProvider>(context, listen: false).getFeedById(_feedId);
      final scrollOffset = MediaQuery.of(context).size.width + 210;
      argumentsMap['feed'] = feed;
      argumentsMap['scrollOffset'] = scrollOffset;
    }
    print('routeName : $routeName');
    // 2.2
    if (_kind == 'GO_TO_PROFILE') {
      isArguments = true;
      arguments = _userId;
    }

    // 2.2 GO_TO_MESSAGE_ROOM
    if (isArguments && arguments != null) {
      Navigator.of(context).pushNamed(routeName, arguments: arguments);
    } else if (isArguments && argumentsMap != null) {
      Navigator.of(context).pushNamed(routeName, arguments: argumentsMap);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }
}

class MyAnimation extends AnimatedWidget {
  MyAnimation({key, animation, this.child})
      : super(
          key: key,
          listenable: animation,
        );
  final Widget child;
  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Opacity(
      opacity: animation.value,
      child: child,
    );
  }
}

