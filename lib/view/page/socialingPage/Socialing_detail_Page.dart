import 'dart:async';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/provider/Socialing_Pick_Return_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/model/provider/socialing_free_return_data.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/model/socialing_Detail_data.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/communityPage/community_detail.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/page/socialingPage/socialing_userList.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/socialing_grid_widget.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app_state.dart';

class SocialingDetailPage extends StatefulWidget {
  SocialingData socialingData;
  SocialingDetailPage({Key key, this.socialingData}) : super(key: key);

  @override
  _SocialingDetailPageState createState() => _SocialingDetailPageState();
}

class _SocialingDetailPageState extends State<SocialingDetailPage> {
  double sizeWidth;
  bool _isBottom;
  ScrollController _hideBottomCtrl;

  // /api/socialing/{socialingId}
  final StreamController<Response<SocialingDetailData>> _socialingCtrl =
      StreamController.broadcast();
  OrderProver orderProver = OrderProver();
  SocialingProvider socialingProvider;
  List<SocialingData> howAboutSocialingList = [];

  //참여금액
  int paymentAmt = 0;

  final StreamController<Response<List<UserData>>> _memberListCtrl =
      BehaviorSubject();
  ClassProvider classProvider = ClassProvider();
  final ValueNotifier<bool> _notifier = new ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () {
      AppStateLog(context, PAGEVIEW_SOSIALING);
    });

    _isBottom = true;
    _hideBottomCtrl = new ScrollController();
    _hideBottomCtrl.addListener(() {
      if (_hideBottomCtrl.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isBottom)
          setState(() {
            _isBottom = false;
            print("up");
          });
      }
      if (_hideBottomCtrl.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isBottom)
          setState(() {
            _isBottom = true;
            print("down");
          });
      }
    });

    //  Provider.of<SocialingProvider>(context, listen: false).fetch(0, 10);

    socialingProvider = Provider.of<SocialingProvider>(context, listen: false);

    _getData();
    _getMemebers();
  }

  _getData() async {
    try {
      _socialingCtrl.sink.add(Response.loading());
      int randomNumber = Random().nextInt(70);
      String socialId = widget.socialingData?.id?.toString();
      if (socialId == null || socialId == '') {
        socialId = randomNumber.toString();
      }
      print('socialId : $socialId');

      SocialingDetailData socialingData =
          await socialingProvider.detailData(socialId);

      print('111 => ${socialingData.name}');
      _socialingCtrl.sink.add(Response.completed(socialingData));
    } catch (e) {
      _socialingCtrl.sink.add(Response.error(e.toString()));
    }
  }

  // 상단 장바구니 클릭시
  _saveBox() {
    _showCenterFlash(
        position: FlashPosition.top,
        style: FlashStyle.floating,
        text: '찜바구니에 담았습니다.');
  }

  // 하트 클릭시
  _heartClick(context) async {
    // POST ​/api​/order​/socialing
    //Util.showToast(context , 'asdfasdfasdf');
    SocialingPickReturnData socialingPickReturnData;
    try {
      print('widget.socialingData.id : ${widget.socialingData?.id}');
      Map<String, dynamic> _map = Map();
      _map['socialingId'] = widget.socialingData?.id?.toString();
      socialingPickReturnData = await socialingProvider.savePick(_map);
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '즐겨찾기에 등록되었습니다.');
      return socialingPickReturnData;
    } catch (e) {
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '즐겨찾기 들록이 실패 되었습니다. ${e.toString()}');
    }
  }

  // 소셜링 참여하기
  _socialingIncome() async {
    if (widget.socialingData != null) {
      SocialingFreeReturnData returnData = SocialingFreeReturnData();
      try {
        print('widget.socialingData.id : ${widget.socialingData?.id}');

        AppStateLog(context, JOIN_SOCIALING);
        // returnData = await socialingProvider.saveSocialingAttend('${widget.socialingData.id}');
        print('paymentAmt : $paymentAmt');

        // 금액이 0원인 경우 호출
        if (paymentAmt > 0) {
          try {
            Map<String, dynamic> _map = Map();
            _map['classType'] = 'SOCIALING';
            _map['classId'] = widget.socialingData?.id.toString();
            Map<String, dynamic> returnD =
                await orderProver.postOrderBasket(_map);
            print('returnD : ${returnD.toString()}');
            // {id: 326, createdAt: 2020-12-27T12:13:07.823Z, updatedAt: 2020-12-27T12:13:07.824Z, deletedAt: null, userId: 23061, itemId: null, itemRoundId: null, socialingId: 171}
            returnData.result = true;
          } catch (e) {
            print('erorr basket ${e.toString()}');

            Util.showCenterFlash(
                //alignment: Alignment.bottomCenter ,
                context: context,
                position: FlashPosition.bottom,
                style: FlashStyle.floating,
                text: '${e.toString()}');
            return;
          }
          // Navigator.of(context).pop();
          // Navigator.of(context).pushNamed('ZzimListPage');
          // return;
        } else {
          returnData = await socialingProvider
              .saveOrderSocialingFree('${widget.socialingData.id}');
        }

        if (returnData != null) {
          if (returnData.result) {
            _getData();
            Util.showOneButtonDialog(context, '소셜링 참여 신청 완료!',
                '특별한 일상을 준비하셨군요.\n취향이 통하는 사람들과 만나보세요!', '확인', () {
              Navigator.of(context).pop();

              // Provider.of<BottomNavigationProvider>(context, listen: false)
              //     .setIndex(3);
              Provider.of<BottomNavigationProvider>(context, listen: false)
                  .refreshCommunity();
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => CommunityDetailPage('SOCIALING', widget.socialingData.id, widget.socialingData.name)));
            });
          } else {
            String message = returnData.message;
            if (returnData.message == 'ALREADY_ORDERED')
              message = '이미 참가 신청한 소셜링입니다,\n커뮤니티 탭을 확인해 주세요';

            Util.showCenterFlash(
                //alignment: Alignment.bottomCenter ,
                context: context,
                position: FlashPosition.bottom,
                style: FlashStyle.floating,
                text: '$message');
          }
        }
        return returnData;
      } catch (e) {
        print(e.toString());
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    _socialingCtrl.close();
    _memberListCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeWidth = MediaQuery.of(context).size.width / 360;
    return Scaffold(
        appBar: _appbar(),
        body: Stack(
          children: [
            StreamBuilder<Response<SocialingDetailData>>(
                stream: _socialingCtrl.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<Response<SocialingDetailData>> snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        print('Loading');
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(68.0),
                          child: CircularProgressIndicator(),
                        ));
                        break;
                      case Status.COMPLETED:
                        SocialingDetailData item = snapshot.data.data;
                        print(item.name);
                        return _buidlBody(item);
                        break;
                      case Status.ERROR:
                        print('ERROR');
                        return Error(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => _getMemebers(),
                        );
                        break;
                    }
                  }
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(),
                  ));
                }),

            // StreamBuilder<Response<SocialingDetailData>>(
            //     stream: _socialingCtrl.stream,
            //     builder: (BuildContext context, AsyncSnapshot<Response<SocialingDetailData>> snapshot) {
            //       if (snapshot.hasData) {
            //         switch (snapshot.data.status) {
            //           case Status.LOADING:
            //             print('Loading');
            //             return SizedBox.shrink();
            //           case Status.COMPLETED:
            //             SocialingDetailData item = snapshot.data.data;
            //             print(item.name);
            //             return _buildBottom(context, snapshot.data.data);
            //           case Status.ERROR:
            //             print('ERROR');
            //             return Error(
            //               errorMessage: snapshot.data.message,
            //               onRetryPressed: () => null,
            //             );
            //         }
            //       }
            //       return SizedBox.shrink();
            //     }),
            _buildBottom(context)
          ],
        ));
  }

  Widget _buidlBody(SocialingDetailData socialingDetailData) {
    paymentAmt = socialingDetailData.price - socialingDetailData.discountPrice;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _hideBottomCtrl,
      child: Column(children: [
        _buildHeader(socialingDetailData), // 헤더 부분 이미지 및 빈자리 표시
        _buildClassIntro(socialingDetailData), // 모임 소개
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider1(),
        ),
        _buildPreparations(socialingDetailData), // 준비 사항
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider1(),
        ),
        _buildHostIntro(socialingDetailData), // 호스트 소개
        _buildInformation(socialingDetailData), // 안내 사항
        _buildMembers(socialingDetailData),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border(top: BorderSide(color: Color(0xffffffff), width: 1)),
          ),
        ),
        // _buildHowAboutSocialing(socialingDetailData), // 이런 소셜링 어때요?
        // _buildNewLife(socialingDetailData), // 새로운 일상의 시작
        Container(
          height: 100,
        ), //하단 여백
      ]),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return StreamBuilder<Response<SocialingDetailData>>(
        stream: _socialingCtrl.stream,
        builder: (BuildContext context,
            AsyncSnapshot<Response<SocialingDetailData>> snapshot) {
          SocialingDetailData item = SocialingDetailData();
          if (!snapshot.hasData || snapshot.data.status != Status.COMPLETED) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ));
          }

          item = snapshot.data.data;
          final isExceeded = (item.maximumPerson - item.totalMember) < 1;

          String location = item.location;
          if (location.contains(' ')) location = location.split(' ')[0];

          String introduce = item.introduce ?? '';
          if (introduce.length > 20)
            introduce = '${introduce.substring(0, 19)}...';

          String name = item.name ?? '';

          return Positioned(
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                //항상 떠있게 해달라고 요청해서 수정함.
                height: 66 * sizeWidth,
                // height: _isBottom ? 0.0 : 66 * sizeWidth,

                child: Container(
                  height: 66 * sizeWidth,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    //  border: Border.fromBorderSide(side : top ,  width: 1, color: Colors.grey[600]),
                    border: Border(
                      top: BorderSide(
                          color: Colors.grey[300],
                          width: 1.3,
                          style: BorderStyle.solid),
                      // left: BorderSide(color: Colors.green, width: 1, style: BorderStyle.solid),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // RawMaterialButton(
                        //   onPressed: () {
                        //     _heartClick(context);
                        //   },
                        //   elevation: 2.0,
                        //   fillColor: MColors.white_two,
                        //   child: Icon(
                        //     item.isPick ? Icons.favorite : Icons.favorite_border,
                        //     size: 22.0,
                        //     color: MColors.tomato,
                        //   ),
                        //   padding: EdgeInsets.all(15.0),
                        //   shape: CircleBorder(),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          //  margin: EdgeInsets.symmetric(vertical: 5),
                          height: 48 * sizeWidth,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(35)),
                            color: isExceeded
                                ? MColors.white_three
                                : MColors.tomato,
                          ),
                          child: FlatButton(
                            onPressed: () {
                              if (isExceeded) return;
                              if(!kReleaseMode){
                                Util.showOneButtonDialog(context, '소셜링 참여 신청 완료!',
                                    '특별한 일상을 준비하셨군요.\n취향이 통하는 사람들과 만나보세요!', '확인', () {
                                      Navigator.of(context).pop();

                                      // Provider.of<BottomNavigationProvider>(context, listen: false)
                                      //     .setIndex(3);
                                      Provider.of<BottomNavigationProvider>(context, listen: false)
                                          .refreshCommunity();
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(builder: (_) => CommunityDetailPage('SOCIALING', widget.socialingData.id, widget.socialingData.name)));
                                    });
                                return;
                              }

                              if (item.user.id == UserInfo.myProfile.id) {
                                Util.showOneButtonDialog(
                                    context,
                                    '자신이 만든 소셜링에는 참여신청을 할 수 없습니다',
                                    '',
                                    '확인',
                                    () {});
                                return;
                              }

                              Util.showNegativeDialog3(
                                  context,
                                  '$location ・ ' +
                                      '${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                      '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}시',
                                  '일상 속 새로움을 함께 할 수 있는 소셜링에 참여하시겠어요?',
                                  '참여하기', () {
                                _socialingIncome();
                              });
                            },
                            child: Center(
                              child: Text(isExceeded ? '모집완료' : '소셜링 참여하기',
                                  style: isExceeded
                                      ? MTextStyles.bold16PinkishGrey
                                      : MTextStyles.bold16White,
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  // 헤더 부분 이미지 및 빈자리 표시
  Widget _buildHeader(SocialingDetailData socialingDetailData) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 195 * sizeWidth,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: socialingDetailData
                    .cover, //'https://specials-images.forbesimg.com/imageserve/1184016689/960x0.jpg?fit=scale',
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                    decoration: new BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey[600]),
                        borderRadius: BorderRadius.circular(8)),
                    child: SvgPicture.asset(
                      'assets/mypage/no_img.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.scaleDown,
                    )),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 10,
                left: 11,
                child: RaisedButton(
                  color: Color(0xffff5252), //MColors.tomato,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(29.0),
                  ),
                  child: Text(
                    '잔여 ${socialingDetailData.maximumPerson - socialingDetailData.totalMember}자리',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => print('aaa'),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: (){
                if (UserInfo.myProfile.id == socialingDetailData.user.id) {
                  final provider = Provider.of<BottomNavigationProvider>(context,listen:false);
                  AppStateLog(context, PAGEVIEW_MY_PROFILE);
                  provider.setIndex(4);
                } else {
                  // 다른이면 유저프로필
                  Navigator.of(context)
                      .pushNamed('UserProfilePage', arguments: socialingDetailData.user.id.toString());
                }
              },
              child: Container(
                    width: double.infinity,

                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0, top: 30.0),
                  decoration: BoxDecoration(
                    color: MColors.white_two,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    //   border: Border.all(color: MColors.white_three, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${socialingDetailData.name} ',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          // overflow: TextOverflow.ellipsis,
                          style: MTextStyles.bold16Grey06,
                        ),
                      ),
                      Container(
                        width: 120 * sizeWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${socialingDetailData.user.name}',
                              style: MTextStyles.regular14Grey06,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${Util.getGradeName(socialingDetailData.user.grade)}',
                              style: MTextStyles.regular12Grey06,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: 10,
              left: (MediaQuery.of(context).size.width / 2) - 20,
              child: GestureDetector(
                onTap: (){
                  if (UserInfo.myProfile.id == socialingDetailData.user.id) {
                    final provider = Provider.of<BottomNavigationProvider>(context,listen:false);
                    AppStateLog(context, PAGEVIEW_MY_PROFILE);
                    provider.setIndex(4);
                  } else {
                    // 다른이면 유저프로필
                    Navigator.of(context)
                        .pushNamed('UserProfilePage', arguments: socialingDetailData.user.id.toString());
                  }
                },
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    '${socialingDetailData.user.image}',
                    //  'https://i.pinimg.com/originals/e5/c9/a8/e5c9a8884bc64d8b5c65564eb33b793b.jpg'
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Wrap(
          // mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runSpacing: 3.0,
          spacing: 8.0,
          children: [
            socialingDetailData.subject1 != null &&
                    socialingDetailData.subject1 != ''
                ? buildChip2(socialingDetailData.subject1)
                : SizedBox.shrink(),
            socialingDetailData.subject2 != null &&
                    socialingDetailData.subject2 != ''
                ? buildChip2(socialingDetailData.subject2)
                : SizedBox.shrink(),
            socialingDetailData.subject3 != null &&
                    socialingDetailData.subject3 != ''
                ? buildChip2(socialingDetailData.subject3)
                : SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 43.0),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: socialingDetailData?.location ?? '',
                          style: MTextStyles.regular14Grey06,
                        ),
                        TextSpan(
                          text: "・ ",
                          style: MTextStyles.regular14Grey06,
                        ),
                        TextSpan(
                          text: socialingDetailData.startDateTime != null
                              ? '${socialingDetailData.startDateTime.month}.${socialingDetailData.startDateTime.day} (${Util.getWeekDayInt(socialingDetailData.startDateTime.weekday)})' +
                                  '${getTypeOfTime(socialingDetailData.startDateTime)} ${getHour(socialingDetailData.startDateTime)}시'
                              : '',
                          style: MTextStyles.regular14Grey06,
                        ),
                        TextSpan()
                      ]),
                    ),
                  ],
                ),
                //const SizedBox(width: 5),
                Row(
                  children: [
                    Icon(
                      Icons.group_rounded,
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: socialingDetailData?.totalMember.toString() +
                                  '명 참여중' ??
                              '0명 참여중',
                          style: MTextStyles.regular14Grey06,
                        ),
                      ]),
                    ),
                  ],
                ),
              ],
            )),
        const SizedBox(height: 13.0),
        // Container(
        //   width: double.infinity,
        //   height: 48 * sizeWidth,
        //   margin: EdgeInsets.symmetric(horizontal: 20),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(35)),
        //     color: MColors.tomato,
        //   ),
        //   child: FlatButton(
        //     onPressed: () => _socialingIncome(),
        //     child: Center(
        //       child: Text('소셜링 참여하기', style: MTextStyles.bold16White, textAlign: TextAlign.center),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 13.0),
      ],
    );
  }

  Widget _buildCommonTitle(Widget child) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: child);
  }

  // 모임 소개
  Widget _buildClassIntro(SocialingDetailData socialingDetailData) {
    final photoList = <String>[];
    if (socialingDetailData.photo1 != null &&
        socialingDetailData.photo1.isNotEmpty)
      photoList.add(socialingDetailData.photo1);
    if (socialingDetailData.photo2 != null &&
        socialingDetailData.photo2.isNotEmpty)
      photoList.add(socialingDetailData.photo2);

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '모임소개',
          style: MTextStyles.regular14Tomato,
        ),
        Text(
          '어떤 모임인가요?',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 28.0),
        if (photoList != null && photoList.length > 0)
          Container(
            width: double.infinity,
            height: 213 * sizeWidth,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: new CachedNetworkImageProvider('${photoList[0]}'
                    // 'https://specials-images.forbesimg.com/imageserve/1184016689/960x0.jpg?fit=scale'
                    ),
              ),
            ),
          )
        else
          Container(),
        const SizedBox(height: 18.0),
        Text(
          socialingDetailData.introduce ?? '',
          textAlign: TextAlign.start,
          style: MTextStyles.regular16Grey06,
        ),
        const SizedBox(height: 20.0),
        // Text(
        //   '글쓰기를 좀 더 대수롭지 않게 생각해보는 모임입니다. 무언가를 쓰고 싶은데 뭘 써야할 지 모를 때, 쓰고 싶은 것이 있는데  어떻게 써야 할 지 모를 때, 조금은 의지해 볼 수 있는 모임입니다.',
        //   textAlign: TextAlign.start,
        //   style: MTextStyles.regular16Grey06,
        // ),
      ],
    );
    return _buildCommonTitle(child);
  }

  // 준비 사항
  Widget _buildPreparations(SocialingDetailData socialingDetailData) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '준비사항',
          style: MTextStyles.regular14Tomato,
        ),
        Text(
          '함께 준비하면 좋아요',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 28.0),
        Text(
          '• ${socialingDetailData.preparation ?? ''}',
          textAlign: TextAlign.start,
          style: MTextStyles.regular16Grey06,
        ),
        // const SizedBox(height: 20.0),
        // Text(
        //   '• 페스티벌을 즐길 수 있는 여유로운 마음',
        //   textAlign: TextAlign.start,
        //   style: MTextStyles.regular16Grey06,
        // ),
      ],
    );

    return _buildCommonTitle(child);
  }

  // 호스트 소개
  Widget _buildHostIntro(SocialingDetailData socialingDetailData) {
    final goUserProfile = () {

      if (UserInfo.myProfile.id == socialingDetailData.user.id) {
        final provider = Provider.of<BottomNavigationProvider>(context,listen:false);
        AppStateLog(context, PAGEVIEW_MY_PROFILE);
        provider.setIndex(4);
      } else {
        // 다른이면 유저프로필
        Navigator.of(context)
            .pushNamed('UserProfilePage', arguments: socialingDetailData.user.id.toString());
      }
    };

    List careerlist = socialingDetailData.user.career;
    Widget child = GestureDetector(
      onTap: goUserProfile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '호스트소개',
            style: MTextStyles.regular14Tomato,
          ),
          Text(
            '우리 반갑게 만나요!',
            style: MTextStyles.bold20Black36,
          ),
          const SizedBox(height: 28.0),
          Container(
              width: double.infinity,
              //     height: 236 * sizeWidth,
              padding: EdgeInsets.all(15.0),
              // margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                //  color: MColors.white_two,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(color: MColors.white_three, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            '${socialingDetailData.user.image}',
                          ),
                          radius: 40.0,
                        ),
                        // new Container(
                        //   width: 80.0 * sizeWidth,
                        //   height: 80.0 * sizeWidth,
                        //   decoration: new BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     // color: Colors.yellow,
                        //     image: new DecorationImage(
                        //       fit: BoxFit.cover,
                        //       image: socialingDetailData.user.image == null
                        //           ? SvgPicture.asset(
                        //               'assets/mypage/no_img.svg',
                        //               // width: 24,
                        //               // height: 24,
                        //               fit: BoxFit.scaleDown,
                        //             )
                        //           :  NetworkImage(socialingDetailData.user.image)
                        //       // new CachedNetworkImageProvider('${socialingDetailData.user.image}'
                        //       //         ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${socialingDetailData.user.name}',
                                    style: MTextStyles.bold18Black,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    '${Util.getGradeName(socialingDetailData.user.grade)}',
                                    style: MTextStyles.regular10WarmGrey,
                                  )
                                ],
                              ),
                              SizedBox(width: 15),
                              socialingDetailData.user.id != UserInfo.myProfile.id
                                  ?
                              InkWell(
                                  child: Container(
                                    width: 80,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        color: socialingDetailData.user.isFollow ? MColors.white : MColors.tomato,
                                        borderRadius: BorderRadius.all(Radius.circular(18)),
                                        border: Border.all(color: MColors.tomato, width: 1)),
                                    child: // 팔로우
                                    Center(
                                      child: Text(socialingDetailData.user.isFollow ? '팔로잉' : '팔로우',
                                          style: socialingDetailData.user.isFollow ? MTextStyles.regular14Tomato : MTextStyles.regular14White,
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                  onTap: () async {
                                    bool result = false;
                                    if (socialingDetailData.user.isFollow) {
                                      result = await socialingProvider.deleteFollow(
                                          socialingDetailData.user.id);
                                    } else {
                                      result = await socialingProvider.postFollow(
                                          socialingDetailData.user.id);
                                    }
                                    if (result) {
                                      setState(() {
                                        socialingDetailData.user.isFollow =
                                        !socialingDetailData.user.isFollow;
                                      });
                                    }
                                  }
                              )

                              // ButtonTheme(
                              //         minWidth: 70,
                              //         child: OutlineButton(
                              //           child: new Text(socialingDetailData.user.isFollow ? "팔로잉" : "팔로우",
                              //               style: socialingDetailData.user.isFollow ? MTextStyles.regular14Tomato : MTextStyles.regular14White),
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(29.0),
                              //
                              //           ),
                              //           borderSide: BorderSide(
                              //             color: MColors.tomato,
                              //           ),
                              //           color: MColors.salmon,
                              //
                              //           // color: socialingDetailData.user.isFollow ? MColors.tomato : MColors.white,
                              //           onPressed: () async {
                              //             bool result = false;
                              //             if(socialingDetailData.user.isFollow){
                              //               result = await socialingProvider.deleteFollow(socialingDetailData.user.id);
                              //
                              //             } else {
                              //               result = await socialingProvider.postFollow(socialingDetailData.user.id);
                              //             }
                              //             if(result){
                              //               setState(() {
                              //                 socialingDetailData.user.isFollow = !socialingDetailData.user.isFollow;
                              //               });
                              //             }
                              //
                              //           },
                              //         ),
                              //       )
                                  : Container(
                                width: 70,
                                height: 48,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.loose,
                    child: Text(
                      '${socialingDetailData.user.introduce ?? '자기소개가 없습니다.'}',
                      //  '재즈를 좋아합니다. 그중 쿨, 하드밥 스타일 연주를 주로 즐겨듣습니다. 아, 그리고 재잘알…',
                      textAlign: TextAlign.start,
                      style: MTextStyles.regular16Grey06,
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  Flexible(
                    flex: careerlist.length == 0 ? 0 : 2,
                    child: Wrap(
                      children: List.generate(careerlist.length,
                              (index) => buildChip(careerlist[index])),
                    ),
                  )
                ],
              )),
        ],
      ),
    );

    return _buildCommonTitle(child);
  }

  // 안내 사항
  Widget _buildInformation(SocialingDetailData socialingDetailData) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안내사항',
          style: MTextStyles.regular14Tomato,
        ),
        Text(
          '자세한 정보를 알려드릴게요',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 23.0),
        Row(
          children: [
            Icon(
              Icons.group,
              size: 23,
              color: MColors.warm_grey,
            ),
            const SizedBox(
              width: 11,
            ),
            Text(
              '최소 ${socialingDetailData.minimumPerson}명 ~  최대 ${socialingDetailData.maximumPerson}명',
              style: MTextStyles.regular16Grey06,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 23,
              color: MColors.warm_grey,
            ),
            const SizedBox(
              width: 11,
            ),
            Text(
              // '경춘선 가평역 1번출구',
              '${socialingDetailData.location}',
              style: MTextStyles.regular16Grey06,
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            SvgPicture.asset('assets/icons/calendar.svg',
                color: MColors.warm_grey),
            const SizedBox(
              width: 11,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: socialingDetailData.startDateTime != null
                      ? '${socialingDetailData.startDateTime.month}.${socialingDetailData.startDateTime.day} (${Util.getWeekDayInt(socialingDetailData.startDateTime.weekday)})' +
                          '${getTypeOfTime(socialingDetailData.startDateTime)} ${getHour(socialingDetailData.startDateTime)}시'
                      : '',
                  style: MTextStyles.regular16Grey06,
                ),
                TextSpan()
              ]),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        // Row(
        //   children: [
        //     Container(
        //       width: 21,
        //       height: 21,
        //       child: Stack(
        //         children: [
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 10),
        //             height: 24,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.all(Radius.circular(12)),
        //               border: Border.all(color: MColors.warm_grey, width: 1),
        //               color: MColors.warm_grey,
        //             ),
        //           ),
        //           Center(
        //             child: Text(
        //               '₩',
        //               style: TextStyle(
        //                   fontSize: 12,
        //                   fontWeight: FontWeight.bold,
        //                   color: Colors.white),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 11,
        //     ),
        //     Text(
        //       NumberFormat('###,###,###,###')
        //               .format(socialingDetailData?.price ?? '0')
        //               .replaceAll(' ', '') +
        //           '원'
        //       // '${socialingDetailData?.price == 0 ? '무료' : socialingDetailData.price}',
        //       ,
        //       style: MTextStyles.regular16Grey06,
        //     ),
        //   ],
        // ),
      ],
    );

    return _buildCommonTitle(child);
  }

  Widget _buildMembers(SocialingDetailData socialingDetailData) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '멤버소개',
          style: MTextStyles.regular14Tomato,
        ),
        Text(
          '함께하게 될 멤버들',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 23.0),
        StreamBuilder<Response<List<UserData>>>(
            stream: _memberListCtrl.stream,
            builder: (context, snapshot) {
              return _getStreamBuild(snapshot);
            }),
      ],
    );

    return _buildCommonTitle(child);
  }

  Widget _getStreamBuild(snapshot) {
    print('snapshot = ${snapshot.toString()}');
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
          List<UserData> list = snapshot.data.data;
          return list.length > 0
              ? _buildattendeeList(list)
              : Container(
                  height: 160,
                  child: Center(
                      child: Text(
                    '참여중인 멤버가 없습니다.',
                    style: MTextStyles.regular14WarmGrey,
                  )));
          break;
        case Status.ERROR:
          return Error(
            errorMessage: snapshot.data.message,
            onRetryPressed: () => null,
          );
          break;
      }
    }
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildattendeeList(List<UserData> list) {
    print('list = ${list.length}');

    // if(!kReleaseMode){
    //   list.add(list[0]);list.add(list[0]);list.add(list[0]);list.add(list[0]);list.add(list[0]);list.add(list[0]);list.add(list[0]);list.add(list[0]);
    // }

    int len = list.length;
    int displayLen = 0;
    len = len > 6? 6 : len;
    displayLen = len - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(len, (index) {
        if (index == displayLen && index > 4) {
          return Flexible(child: _buildAvatarMore(list[index], list));
        } else {
          return Flexible(child: _buildAvatar(list[index]));
        }
      }),
    );
  }

  // 상단 맴버 아바타
  Widget _buildAvatar(UserData item) {
    return InkWell(
      onTap: () {
        // 본인이면 마이프로필
        if (UserInfo.myProfile.id == item.id) {
          final provider = Provider.of<BottomNavigationProvider>(context,listen:false);
          AppStateLog(context, PAGEVIEW_MY_PROFILE);
          provider.setIndex(4);
        } else {
          // 다른이면 유저프로필
          Navigator.of(context)
              .pushNamed('UserProfilePage', arguments: item.id.toString());
        }
      },
      child: Ink(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            item.image != '' || item.image != null
                ? CircleAvatar(
                    //     backgroundColor: MColors.white_three,
                    backgroundImage: NetworkImage(item.image),
                    radius: 30,
                  )
                : CircleAvatar(
                    backgroundColor: MColors.white_three,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: MColors.white,
                      size: 50,
                    ),
                  ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text('${item.name}',
                  softWrap: false, overflow: TextOverflow.clip,
                style: MTextStyles.medium10Grey06,
              ),

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarMore(UserData item, List<UserData> list) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) => SocialingUserList(widget.socialingData.name, widget.socialingData.id)));
      },
      child: Ink(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: MColors.white_three,
              radius: 30,
              child: SvgPicture.asset(
                'assets/groups-24px.svg',
                width: 35,
                height: 35,
                color: Colors.black,
                //fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(height: 6),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '모두보기',
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: MTextStyles.medium10Grey06,
                )),
          ],
        ),
      ),
    );
  }

  // 이런 소셜링 어때요?
  Widget _buildHowAboutSocialing(SocialingDetailData socialingDetailData) {
    //  final socialingProvider = Provider.of<SocialingProvider>(context);
    print(socialingProvider.dataList.length);
    double rate = MediaQuery.of(context).size.width / 360;

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 소셜링은 어때요?',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 28.0),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 0),
              scrollDirection: Axis.horizontal,
              itemCount: socialingProvider.dataList.length,
              itemBuilder: (BuildContext context, int index) {
                SocialingData item = socialingProvider.dataList[index];

                return Container(
                    width: 238 * rate,
                    padding: EdgeInsets.only(right: 12),
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print('click');
                      },
                      child: Ink(
                        // margin: EdgeInsets.only(right: 10),
                        height: 342 * rate,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: MColors.pinkishGrey10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: 342 * 104 / 311,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                        child: item.cover == null
                                            ? Container()
                                            : Image.network(
                                                item.cover,
                                                fit: BoxFit.cover,
                                              )),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                                'assets/icons/likeit_disabled_shadow.svg'),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 6,
                                // runSpacing: 6,
                                children: [
                                  if (item.subject1 != "" &&
                                      item.subject1 != null)
                                    buildChip(item.subject1),
                                  if (item.subject2 != "" &&
                                      item.subject2 != null)
                                    buildChip(item.subject2),
                                  if (item.subject3 != "" &&
                                      item.subject2 != null)
                                    buildChip(item.subject3),
                                  if ((item.subject1 == "" ||
                                          item.subject1 == null) &&
                                      (item.subject1 == "" ||
                                          item.subject1 == null) &&
                                      (item.subject1 == "" ||
                                          item.subject1 == null))
                                    SizedBox(
                                      height: 44,
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                item.name,
                                style: MTextStyles.bold14Grey06,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 22 * rate),
                            Container(
                              //   color: Colors.yellow,
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: item?.location ?? '',
                                        style: MTextStyles.regular10Grey06,
                                      ),
                                      TextSpan(
                                        text: "・ ",
                                        style: MTextStyles.regular10Grey06,
                                      ),
                                      TextSpan(
                                        text: item.startDateTime != null
                                            ? '${item.startDateTime.month}.${item.startDateTime.day} (${Util.getWeekDayInt(item.startDateTime.weekday)})' +
                                                '${getTypeOfTime(item.startDateTime)} ${getHour(item.startDateTime)}시'
                                            : '',
                                        style: MTextStyles.regular10Grey06,
                                      ),
                                      TextSpan()
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group_rounded,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: item?.totalMember.toString() ??
                                            '0' + '명 참여중',
                                        style: MTextStyles.regular10Grey06,
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(
                                                color: MColors.warm_grey,
                                                width: 1),
                                            color: MColors.white,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '₩',
                                            style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: NumberFormat('###,###,###,###')
                                                .format(item?.price ?? '0')
                                                .replaceAll(' ', '') +
                                            '원',
                                        style: MTextStyles.regular10Grey06,
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14),
                            Divider(
                              height: 1,
                              indent: 12,
                              endIndent: 12,
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                      item.user?.image ?? '',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(item.user?.name ?? '',
                                      style: MTextStyles.regular12Grey06),
                                  SizedBox(width: 8),
                                  Text(item.user?.grade ?? '',
                                      style: MTextStyles.regular10WarmGrey),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              }),
        ),
      ],
    );

    return Container(
        height: 452,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: child);
  }

  // 새로운 일상의 시작
  Widget _buildNewLife(SocialingDetailData socialingDetailData) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '새로운 일상의 시작',
          style: MTextStyles.regular14Tomato,
        ),
        Text(
          '문토 멤버십 혜택을 즐기세요',
          style: MTextStyles.bold20Black36,
        ),
        const SizedBox(height: 28.0),
        new Container(
          width: double.infinity,
          height: 213 * sizeWidth,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: new CachedNetworkImageProvider(
                  'https://specials-images.forbesimg.com/imageserve/1184016689/960x0.jpg?fit=scale'),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        Text(
          '글쓰기를 좀 더 대수롭지 않게 생각해보는 모임입니다. 무언가를 쓰고 싶은데 뭘 써야할 지 모를 때, 쓰고 싶은 것이 있는데  어떻게 써야 할 지 모를 때, 조금은 의지해 볼 수 있는 모임입니다.',
          textAlign: TextAlign.start,
          style: MTextStyles.regular16Grey06,
        ),
        const SizedBox(height: 20.0),
      ],
    );

    return _buildCommonTitle(child);
  }

  AppBar _appbar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(
          height: barBorderWidth,
          color: MColors.barBorderColor,
        ),
      ),
      //todo:애플심사후 복구
      actions: [
        // IconButton(
        //     onPressed: () => print('a'),
        //     icon: SvgPicture.asset(
        //       'assets/mypage/share.svg',
        //       width: 25,
        //       height: 25,
        //     )),
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0),
        //   child: Badge(
        //       badgeColor: MColors.grapefruit, // Colors.deepPurple,
        //       shape: BadgeShape.circle,
        //       position: BadgePosition.topEnd(top: 5.0, end: 5.0),
        //       animationDuration: Duration(milliseconds: 300),
        //       animationType: BadgeAnimationType.scale,
        //       toAnimate: true,
        //       badgeContent: Padding(
        //         padding: const EdgeInsets.only(bottom: 1.0),
        //         child: Text('3', style: MTextStyles.bold10White),
        //       ),
        //       child: IconButton(
        //           onPressed: () => _saveBox(),
        //           icon: Image.asset(
        //             'assets/mypage/basket.png',
        //             color: Colors.black,
        //             width: 24,
        //             height: 24,
        //           ))),
        // )
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (modalContext) {
                      return CupertinoTheme(
                        data: CupertinoThemeData(
                            primaryColor: Colors.blue,
                            brightness: Brightness.light),
                        child: CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(
                                '소셜링 신고하기',
                                style: MTextStyles.regular16Tomato,
                              ),
                              onPressed: () async {
                                Navigator.of(modalContext).pop();
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('신고가 접수되었습니다.'),
                                ));
                              },
                              isDestructiveAction: true,
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child:
                                Text('취소', style: MTextStyles.regular16Grey06),
                            onPressed: () {
                              Navigator.of(modalContext).pop();
                            },
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.more_horiz)),
        ),
      ],
    );
  }

  void _showCenterFlash({
    FlashPosition position,
    FlashStyle style,
    Alignment alignment,
    String text,
  }) {
    showFlash(
      context: context,
      duration: Duration(seconds: 3),
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Flash(
            controller: controller,
            backgroundColor: MColors.white_two,
            borderRadius: BorderRadius.circular(0.2),
            borderColor: MColors.white_three,
            position: position,
            style: style,
            alignment: alignment,
            enableDrag: false,
            onTap: () => controller.dismiss(),
            child: Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                color: Color(0xfffdfdfd),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x66000000),
                      offset: Offset(0, 2),
                      blurRadius: 15,
                      spreadRadius: -5)
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: MTextStyles.regular16Tomato,
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        _showMessage(_.toString());
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            style: FlashStyle.grounded,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              message: Text(message),
            ),
          );
        });
  }

  String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '-';
    }
  }

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  // Widget buildChip(String chip) {
  //   return Chip(
  //     label: Text(
  //       Interest.getNameByValue(chip),
  //       style: MTextStyles.regular10Grey06,
  //     ),
  //     backgroundColor: MColors.white_two,
  //   );
  // }

  Widget buildChip(String chip) {
    return SizedBox(
      height: 22,
      child: Chip(
        padding: EdgeInsets.only(bottom: 10.0, left: 2.0, right: 2.0),
        label: Text(Interest.getNameByValue(chip), style: MTextStyles.regular10Grey06,),
        backgroundColor: MColors.white_two,
      ),
    );
  }

  Widget buildChip2(String chip) {

    return SizedBox(
      height: 24 * sizeWidth,
      child: Chip(
        padding: EdgeInsets.only(bottom: 4.0, left: 10.0, right: 10.0),
        label: Text(chip,
            style: MTextStyles.bold12Grey06,
            textAlign: TextAlign.center),
        backgroundColor: MColors.white_two,
      ),
    );
  }


  Future<void> _getMemebers() async {
    try {
      _memberListCtrl.sink.add(Response.loading());
      Map<String, dynamic> _map = Map();
      String socialId = '${widget.socialingData.id}';
      _map['itemId'] = socialId;
      print('==== 맴버 가져오기 시작 ====================================');
      List<UserData> memberList = await classProvider.getSocialingmembers(_map);
      print('==== 맴버 가져오기 완료 ==================================+=');

      if (memberList.length == 0) {
        _notifier.value = false;
        _memberListCtrl.sink.add(Response.completed([]));
      } else {
        _notifier.value = true;
        _memberListCtrl.sink.add(Response.completed(memberList));
      }
    } catch (e) {
      print(e.toString());
      _memberListCtrl.sink.add(Response.error(e.toString()));
    }
  }
}
