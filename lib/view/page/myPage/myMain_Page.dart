import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/app_state.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/api_Service.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  ClassProvider mSvc = ClassProvider();
  UserProfileData userProfileData = UserProfileData();

  final StreamController<Response<UserProfileData>> _userProfileDataSteam = StreamController();

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    _getUserProfileData();
    _getVersionName();
  }

  void _getUserProfileData() async {
    try {
      _userProfileDataSteam.sink.add(Response.loading());

      userProfileData = await mSvc.getUserProfile();
      _userProfileDataSteam.sink.add(Response.completed(userProfileData));
    } catch (e) {
      _userProfileDataSteam.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _userProfileDataSteam.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: StreamBuilder<Response<UserProfileData>>(
            stream: _userProfileDataSteam.stream,
            builder: (BuildContext context, AsyncSnapshot<Response<UserProfileData>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(68.0),
                      child: CircularProgressIndicator(),
                    ));
                    break;
                  case Status.COMPLETED:
                    UserProfileData item = snapshot.data.data;

                    return item != null ? _getBody(item) : _noDataWidget();
                    break;
                  case Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _getUserProfileData(),
                    );
                    break;
                }
              }
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ));
            }));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "???????????????",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(
          height: barBorderWidth,
          color: MColors.barBorderColor,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        //todo:?????????????????? ??? ??????
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0),
        //   child: Badge(
        //     badgeColor: MColors.grapefruit, // Colors.deepPurple,
        //     shape: BadgeShape.circle,
        //     position: BadgePosition.topEnd(top: 5.0, end: 5.0),
        //     animationDuration: Duration(milliseconds: 300),
        //     animationType: BadgeAnimationType.scale,
        //     toAnimate: true,
        //     badgeContent: Padding(
        //       padding: const EdgeInsets.only(bottom: 1.0),
        //       child: Text('3', style: MTextStyles.bold10White),
        //     ),
        //     child: IconButton(
        //       iconSize: 26,
        //       icon: SvgPicture.asset('assets/icons/basket.svg'),
        //       onPressed: () {
        //         // Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>NotificationPage()));
        //       },
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget _getBody(data) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: new Text(
                "${data.name}???, ???????????????!",
                style: MTextStyles.bold16Black,
              )),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              iconBtn('assets/mypage/meeting.png', '????????????', 'ClassListPage'),
              iconBtn('assets/mypage/research.png', '????????? ??????', 'SurveyPage'),
              iconBtn('assets/mypage/rectangle.png', '??????', 'ReviewsPage'),
              iconBtn('assets/mypage/invite.png', '????????????', 'InvitePage'),
            ],
          ),
          const SizedBox(
            height: 16,
            //todo:?????????????????? ??? ??????
          ),
          DividerGrey12(),

          Divider1(),
          linkContainer('?????????', 'ReserveMoneyPage',
              valueData: '${NumberFormat("#,##0", "ko_KR").format(userProfileData.reserveMoney)}???'),
          Divider1(),
          // linkContainer('??????', 'CouponPage', valueData: '6???'),
          DividerGrey12(),
          // eventImg(),
          // DividerGrey12(),
          // linkContainer('????????????', 'PaymentListPage'),
          // Divider1(),
          // linkContainer('??????/????????? ??????', 'ReaderRegPage'),
          // Divider1(),
          linkContainer('????????????', 'ClassManagePage'),
          // Divider1(),
          // linkContainer('????????????', 'ZzimListPage'),
          // Divider1(),
          // linkContainer('????????????', 'OrderPage'),
          Divider1(),
          linkContainer('????????????', 'ZzimListPage'),
          //  Divider1(),

          // Divider1(),
          //  linkContainer('????????????', 'BudgetManagePage'),
          // Divider1(),
          // linkContainer('????????? ???????????? ??????', 'ClassProceedingPage'),
          // Divider1(),
          //linkContainer('????????? ???????????? ??????', 'ClassRecruitingPage'),
          // Divider1(),
          // linkContainer('?????? ?????? ??????', 'CustomerModifyPage'),
          DividerGrey12(),
          linkContainer('?????? ??????', 'https://www.munto.kr/', isUrl: true),
          Divider1(),
          linkContainer('????????????', 'https://www.munto.kr/', isUrl: true),
          Divider1(),
          linkContainer('?????? ?????? ??????', 'https://www.munto.kr/faq', isUrl: true),
          Divider1(),
          linkContainer('????????????', 'TokenInfoPage'),
          Divider1(),
          linkContainer('????????????', 'LOGOUT'),
          Divider1(),
          versionContainer(),
          DividerGrey12(),
        ],
      ),
    );
  }

  // ????????? ?????????  4??? ?????? ??????
  Widget iconBtn(String iconData, String textData, String linkData) {
    return InkWell(
      onTap: () {
        if (textData == '????????????')
          Util.showOneButtonDialog(context, '???????????? ??????????????????.', '', '??????', () {});
        else
          Navigator.of(context).pushNamed(linkData);
      },
      child: Container(
        height: 86,
        width: 80,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0.0),
              //  iconSize: 40,
              width: 50,
              child: Image.asset(iconData),
            ),
            Text(
              textData,
              style: MTextStyles.bold12Grey06,
            )
          ],
        ),
      ),
    );
  }

  // ?????? ?????? ?????????
  Widget linkContainer(String textData, String linkData, {String valueData, bool isUrl = false}) {
    return InkWell(
      onTap: () async {
        if (linkData == null)
          return;
        else if (isUrl)
          await launch(linkData);
        else if ('ReaderRegPage' == linkData) {
          openLinkPage(context);
        } else if ('LOGOUT' == linkData) {
          openLogOut(context);
        } else {
          await Navigator.of(context).pushNamed(linkData);
          _userProfileDataSteam.sink.add(Response.completed(UserInfo.myProfile));
        }
      },
      child: Container(
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              textData,
              style: MTextStyles.medium14Grey06,
            ),
            valueData != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(valueData),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 13,
                      )
                    ],
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 13,
                  )
          ],
        ),
      ),
    );
  }

  Widget eventImg() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Container(
        height: 54,
        child: Image.asset('assets/mypage/mypageEvent.png'),
      ),
    );
  }

  openLinkPage(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoTheme(
            data: CupertinoThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
            child: CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text(
                    '?????? ????????????',
                    style: MTextStyles.regular16Grey06,
                  ),
                  onPressed: () async {
                    await launch('https://www.munto.kr/leaders');
                    // Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('????????? ????????????', style: MTextStyles.regular16Grey06),
                  onPressed: () async {
                    await launch('https://www.munto.kr/partner');
                    //  Navigator.of(context).pop();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('??????', style: MTextStyles.regular16Grey06),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        });
  }

  openLogOut(buildContext) {
    showCupertinoModalPopup(
        context: buildContext,
        builder: (modalContext) {
          return CupertinoTheme(
            //   data: CupertinoThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
            data: CupertinoThemeData(
              primaryColor: Colors.blue,
              brightness: Brightness.light,
              primaryContrastingColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              barBackgroundColor: Colors.white,
              // barBackgroundColor: CupertinoDynamicColor.withBrightness(
              //   color: Colors.white, // Color.fromRGBO(0, 100, 100, 1.0),
              //   darkColor: Colors.white,
              // )
            ),
            child: CupertinoActionSheet(
              title: Text('????????????????????????????', style: MTextStyles.regular14Grey05),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text('????????????', style: MTextStyles.bold16Tomato),
                  onPressed: () async {
                    AppStateLog(context, LOG_OUT);
                    print('logout excute');
                    Navigator.of(modalContext).pop();
                    Provider.of<LoginProvider>(context, listen: false).logout();
                    Provider.of<BottomNavigationProvider>(context, listen: false).clearIndex();
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('??????', style: MTextStyles.regular16Grey06),
                onPressed: () {
                  Navigator.of(modalContext).pop();
                },
              ),
            ),
          );
        });
  }

  Widget _noDataWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_survey_60_px.svg', colors: Colors.grey),
              const SizedBox(height: 15),
              Text('?????? ????????? ???????????? ???????????????.', style: MTextStyles.medium16WarmGrey),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget versionContainer() {
    return InkWell(
      onTap: () {
        if (Platform.isAndroid) launch('https://play.google.com/store/apps/details?id=kr.munto.app');
      },
      child: Container(
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '????????????',
              style: MTextStyles.medium14Grey06,
            ),
            Text(
              '$version  ($buildNumber)',
              style: MTextStyles.regular14PinkishGrey,
            ),
          ],
        ),
      ),
    );
  }

  void _getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}

// class Loading extends StatelessWidget {
//   final String loadingMessage;

//   const Loading({Key key, this.loadingMessage}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             loadingMessage,
//             textAlign: TextAlign.center,
//             style: TextStyle(
// //              color: Colors.lightGreen,
//               fontSize: 24,
//             ),
//           ),
//           SizedBox(height: 24),
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
//           ),
//         ],
//       ),
//     );
//   }
// }
