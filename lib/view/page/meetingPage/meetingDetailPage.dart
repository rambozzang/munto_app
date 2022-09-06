import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/item_recommend_data.dart';
import 'package:munto_app/model/meeting_DetailItem_Data.dart';
import 'package:munto_app/model/meeting_Detail_Data.dart';
import 'package:munto_app/model/meeting_itemRound_Data.dart';
import 'package:munto_app/model/order/bootpay_Data.dart';
import 'package:munto_app/model/order/order_basket_Data.dart';
import 'package:munto_app/model/order/order_isValid_Data.dart';
import 'package:munto_app/model/order/paymentid_Data.dart';
import 'package:munto_app/model/provider/Socialing_Pick_Return_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/item_playing_provider.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/model/simple_review_data.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/error_page.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util.dart';

class MeetingDetailPage extends StatefulWidget {
  final int id;
  final String title;

  final bool isMPASS;
  MeetingDetailPage({this.id, this.title, this.isMPASS = false});

  @override
  _MeetingDetailPageState createState() => _MeetingDetailPageState();
}

const _tabs = [
  '후기',
  '모임소개',
  '진행방법',
  '모임주제',
  '일시및장소',
];

class _MeetingDetailPageState extends State<MeetingDetailPage>
    with TickerProviderStateMixin {
  TabController tabController;
  ScrollController _scrollCtrl = new ScrollController();

  final StreamController<Response<MeetingDetailData>> _itemDetailCtrl =
      BehaviorSubject();

  final StreamController<Response<List<ItemData>>> _itemRecommendCtrl =
      BehaviorSubject();

  ItemProvider itemProvider = ItemProvider();
  OrderProver orderProvier = OrderProver();

  PlayingItemProvider recommendItemProvider = PlayingItemProvider();

  int _selectedValue;
  double he = 0.0;
  String mpassPrice = '0';
  List<String> _itemRounds = [];

  @override
  void initState() {
    super.initState();
    // _selectedValue = 0;

    tabController = TabController(
      vsync: this,
      length: 5,
    );
    _getMainData();
  }

  @override
  void dispose() {
    _itemDetailCtrl.close();
    _itemRecommendCtrl.close();

    super.dispose();
  }

  _getMainData() async {
    if (widget.id != null) {
      _itemDetailCtrl.sink.add(Response.loading());
      try {
        MeetingDetailData _meetingDetailData;
        _meetingDetailData =
            await itemProvider.getItemDetailInfo('${widget.id}');
        // _meetingDetailData = await itemProvider.getItemDetailInfo('5305');

        _itemDetailCtrl.sink.add(Response.completed(_meetingDetailData));
      } catch (e) {
        print('itemProvider.getItemDetailInfo 에러 발생 : ${e.toString()}');
        _itemDetailCtrl.sink.add(Response.error(e.toString()));
      }
    } else {
      _itemDetailCtrl.sink.add(Response.error('모임정보가 없습니다.'));
    }
  }

  Future<void> saveOrder() async {
    try {
      Map<String, dynamic> _map = Map();
      _map['classType'] = 'ITEM';
      _map['classId'] = widget?.id.toString();

      Map<String, dynamic> returnD = await orderProvier.postOrderBasket(_map);
      print('returnD : ${returnD.toString()}');
      int _id = returnD['itemId'];
      print('_id : $_id');
      // {id: 326, createdAt: 2020-12-27T12:13:07.823Z, updatedAt: 2020-12-27T12:13:07.824Z, deletedAt: null, userId: 23061, itemId: null, itemRoundId: null, socialingId: 171}
      if (_id != null) {
        List<OrderBasketData> _basketData = [];
        OrderBasketData item = OrderBasketData();
        item.classType = "ITEM";
        item.classId = int.parse(widget.id.toString());
        _basketData.add(item);
        Navigator.of(context).pushNamed('OrderPage', arguments: _basketData);
      } else {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '모임신청이 실패 되었습니다.');
      }
    } catch (e) {
      print(e.toString());
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '찜리스트들록이 실패 되었습니다. ${e.toString()}');
    }
  }

  // 하트 클릭시 찜리스 저장
  Future<void> _saveZzim() async {
    try {
      print('id : ' + widget?.id.toString());
      print('id : ' + widget?.id.toString());

      Map<String, dynamic> _map = Map();
      _map['classType'] = 'ITEM';
      _map['classId'] = widget?.id.toString();

      Map<String, dynamic> returnD = await orderProvier.postOrderBasket(_map);
      print('returnD : ${returnD.toString()}');
      int _id = returnD['itemId'];
      print('_id : $_id');
      // {id: 326, createdAt: 2020-12-27T12:13:07.823Z, updatedAt: 2020-12-27T12:13:07.824Z, deletedAt: null, userId: 23061, itemId: null, itemRoundId: null, socialingId: 171}
      if (_id != null) {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '찜리스트에 등록되었습니다.');
      } else {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '찜리스트들록이 실패 되었습니다.');
      }

      //  return socialingPickReturnData;
    } catch (e) {
      print(e.toString());
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '찜리스트들록이 실패 되었습니다. ${e.toString()}');
    }
  }

  // Mpass 사용 회차 선택시
  selectDropDownValue(MeetingItemRoundData value) async {
    try {
      List<String> _items = [];
      List<String> _socialings = [];
      _itemRounds.clear();
      _itemRounds.add(value.id.toString());

      OrderisValidData isvalidData =
          await orderProvier.getOrderisValid(_items, _socialings, _itemRounds);

      List<Invalid> _itemRoundsInvalidList = isvalidData.invalidItemRounds;
      List<Invalid> _itemRoundValidList = isvalidData.validItemRounds;

      if (_itemRoundValidList.length == 0) {
        _itemRounds.clear();
        setState(() {
          _selectedValue = null;
          mpassPrice = '0';
        });
        _showCancelDialog(context);
      } else {
        if (_itemRoundValidList.length > 0) {
          final isValidata = _itemRoundValidList
              .firstWhere((element) => element.id == value.id, orElse: () {
            return null;
          });

          if (isValidata.result) {
            setState(() {
              _selectedValue = value.round;
              mpassPrice = Util.getMoneyformat(value.mpassPrice ?? '0');
            });
          } else {
            print('결과값 : ${isValidata.message}');
            _itemRounds.clear();
            setState(() {
              _selectedValue = null;
              mpassPrice = '0';
            });

            _showCancelDialog(context);
          }
        } else {
          final isValidata = _itemRoundsInvalidList
              .firstWhere((element) => element.id == value.id, orElse: () {
            return null;
          });

          if (isValidata.result) {
            setState(() {
              _selectedValue = value.round;
              mpassPrice = Util.getMoneyformat(value.mpassPrice ?? '0');
            });
          } else {
            print('결과값 : ${isValidata.message}');
            _itemRounds.clear();

            setState(() {
              _selectedValue = null;
              mpassPrice = '0';
            });

            _showCancelDialog(context);
          }
        }
      }
    } catch (e) {
      _itemRounds.clear();
      print('orderProvier.getOrderisValid error : ${e.toString()}');
    }
  }

  // 회차 선택이후 찜리스트로 이동
  paymentMpass() async {
    if (_itemRounds.length == 0) {
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '신청할 회차를 선택해주세요!');
      return;
    }
    zzimSaveShowdialog(context);

    return;

    PaymentIdData result;
    try {
      // PaymentId 가져오기
      Map<String, dynamic> _map = Map();
      _map['items'] = [];
      _map['socialings'] = [];
      _map['itemRounds'] = _itemRounds;
      result = await orderProvier.getOrderPaymentId(_map);
      print('result : $result');
      if (result.paymentId == '' || result.paymentId == null) {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '결제ID 생성 실패!');
        return;
      }
    } catch (e) {
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '${e.toString()}');

      Future.delayed(Duration(milliseconds: 1500), () async {
        Navigator.of(context).pop();
      });

      return;
    }

    try {
      BootPayData _bootPayData = BootPayData();
      List<BootPayDetailData> itemRoundList = [];
      BootPayDetailData bData = BootPayDetailData();
      bData.id = _itemRounds[0];
      itemRoundList.add(bData);

      _bootPayData.paymentId = result.paymentId;
      _bootPayData.totalPrice = mpassPrice.toString();
      _bootPayData.reservesMoney = '0';
      _bootPayData.orderKind = 'CARD';

      _bootPayData.items = [];
      _bootPayData.socialings = [];
      _bootPayData.itemRounds = itemRoundList;

      // 결제금액이 없는 경우
      String paymentId =
          await orderProvier.getOrderClassNoPayment(_bootPayData);
      print('getOrderClassNoPayment paymentId : $paymentId');

      if (paymentId != "") {
        Navigator.of(context)
            .popAndPushNamed('OrderCampletedPage', arguments: paymentId);
      } else {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '결제ID 생성 실패!');
        return;
      }
    } catch (e) {
      print('orderProvier.getOrderClassNoPayment error : ${e.toString()}');
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '${e.toString()}');
      return;
    }
  }

  MeetingDetailData _meetingDetailData;

  @override
  Widget build(BuildContext context) {
    print('meetin detail page itemId = ${widget.id}');
    return Scaffold(
        appBar: _appbar(),
        body: StreamBuilder<Response<MeetingDetailData>>(
            stream: _itemDetailCtrl.stream,
            builder: (BuildContext context,
                AsyncSnapshot<Response<MeetingDetailData>> snapshot) {
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
                    // setState(() {
                    // });
                    _meetingDetailData = snapshot.data.data;
                    return Stack(
                      children: [
                        _buildBody(_meetingDetailData),
                        _buildBottomSheet(_meetingDetailData),
                        _buildBottom(context, _meetingDetailData)
                      ],
                    );

                    break;
                  case Status.ERROR:
                    print('ERROR');
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
            }));
  }

  Widget _buildBody(MeetingDetailData data) {
    return DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
            controller: _scrollCtrl,
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildCover(data),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    TabBar(
                      labelStyle: MTextStyles.bold14Tomato,
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 16.0),
                      // unselectedLabelStyle: MTextStyles.medium14PinkishGrey,
                      labelColor: MColors.tomato,
                      unselectedLabelColor: MColors.pinkish_grey,
                      indicatorColor: MColors.tomato,
                      indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 3.0, color: MColors.tomato),
                          insets: EdgeInsets.symmetric(horizontal: 12.0)),
                      tabs: _tabs.map((String name) => Text('$name')).toList(),
                    ),
                  ),
                ),
              ];
            },
            body: Builder(builder: (BuildContext context) {
              // final innerScrollController1 = PrimaryScrollController.of(context);
              // innerScrollController1.addListener(() {
              //   if (innerScrollController1.position.pixels == innerScrollController1.position.maxScrollExtent) {
              //     //    getDataList(DefaultTabController.of(context).index);
              //   }
              // });
              return _buildTabbarView(context, data);
            })));
  }

  Widget _buildTabbarView(BuildContext context, MeetingDetailData data) {
    return TabBarView(
      children: <Widget>[
        SafeArea(
            child: _scrollView(Column(children: [
          _tabbarView1(data),
          _tabbarView2(data),
          _tabbarView3(data),
          _tabbarView4(data),
          _tabbarView5(data),
        ]))),
        SafeArea(child: _scrollView(_tabbarView2(data))),
        SafeArea(child: _scrollView(_tabbarView3(data))),
        SafeArea(child: _scrollView(_tabbarView4(data))),
        SafeArea(child: _scrollView(_tabbarView5(data))),

        // SafeArea(child: _scrollView(Container())),
        // SafeArea(child: _scrollView(Container())),
        // SafeArea(child: _scrollView(Container())),
        // SafeArea(child: _scrollView(Container())),
      ],
    );
  }

  Widget _scrollView(child) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: child,
    );
  }

  Widget _buildBottomSheet(MeetingDetailData data) {
    print('data.item.ItemRound : ${data.item.ItemRound.length}');
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width,
          height: he,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        he = he == 0.0 ? 204.0 : 0.0;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 44),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('회차 선택', style: MTextStyles.regular13Grey06),
              ),
              const SizedBox(height: 13),
              Container(
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(color: MColors.greyish, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      value: _selectedValue != null ? _selectedValue : null,
                      hint: Text('회차를 선택하세요.',
                          style: MTextStyles.regular14Grey06),
                      icon: Icon(Icons.keyboard_arrow_down, size: 30),
                      isExpanded: true,
                      // items : map.forEach((k, v) => list.add(Customer(k, v)))
                      items: data.item.ItemRound.map((value) {
                        print(value.startDate);
                        return DropdownMenuItem<int>(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${value.id} [${value.round}회차] ',
                                style: MTextStyles.bold14BlackColor,
                              ),
                              TextSpan(
                                text:
                                    '${Util.getFormattedday1(value.startDate)} ${value.placeString}',
                                style: MTextStyles.regular14Grey05,
                              ),
                            ]),
                          ),
                          value: value.round ?? 0,
                        );
                      }).toList(),
                      onChanged: (value) {
                        print('value =>>>>>>>>>>>>> $value');

                        final itemround = data.item.ItemRound.firstWhere(
                            (element) => element.round == value, orElse: () {
                          return null;
                        });

                        selectDropDownValue(itemround);
                      },
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('시작 2일전', style: MTextStyles.medium13Tomato),
                    Text('$mpassPrice 원', style: MTextStyles.bold20Black),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget _buildBottom(context, data) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
          //  border: Border.fromBorderSide(side : top ,  width: 1, color: Colors.grey[600]),
          border: Border(
            top: BorderSide(
                color: Colors.grey[300], width: 1.3, style: BorderStyle.solid),
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
              //     //_showItemDialog('찜바구니에 담았습니다.');
              //     //    _saveZzim();
              //     if (data.isUserBasket) {
              //       Util.showCenterFlash(
              //           context: context,
              //           position: FlashPosition.bottom,
              //           style: FlashStyle.floating,
              //           text: '이미 찜바구니에 담겨있습니다!');
              //       return;
              //     } else {
              //       zzimSaveShowdialog(context);
              //     }
              //   },
              //   elevation: 2.0,
              //   fillColor: MColors.white_two,
              //   child: Icon(
              //     data.isUserBasket
              //         ? Icons.favorite
              //         : Icons.favorite_border_outlined,
              //     size: 24.0,
              //     color: MColors.tomato,
              //   ),
              //   padding: EdgeInsets.all(13.0),
              //   shape: CircleBorder(),
              // ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                //  margin: EdgeInsets.symmetric(vertical: 5),
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  color: MColors.tomato,
                ),
                child: TextButton(
                  // onPressed: () => displayBottomSheet(context),
                  onPressed: () {
                    if (widget.isMPASS) {
                      if (he == 300.0) {
                        //
                        paymentMpass();
                        return;
                      }

                      setState(() {
                        he = he == 0.0 ? 300.0 : 0.0;
                      });
                    } else {
                      saveShowdialog(context);
                    }

                    // setState(() {
                    //   he = he == 0.0 ? 300.0 : 0.0;
                    // });
                    // _notifier.value = _notifier.value == false ? true : false;
                    // Util.showSimpleDialog(context, '준비중 입니다.', '확인', () { });
                  },

                  child: Center(
                    child: Text(widget.isMPASS ? 'MPASS 신청하기 ' : '모임 신청하기',
                        style: MTextStyles.bold16White,
                        textAlign: TextAlign.center),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
      title: Text(
        widget.title != null ? widget.title : '.',
        style: MTextStyles.bold16Black,
      ),
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: MColors.barBackgroundColor,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(
          height: barBorderWidth,
          color: MColors.barBorderColor,
        ),
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 10.0),
        //   child: IconButton(
        //       onPressed: () {
        //       },
        //       icon: Icon(Icons.more_horiz)),
        // ),
      ],
    );
  }

  _buildCover(MeetingDetailData data) {
    // data.item.discountPrice = 230000;
    // data.item.discountPrice = 0;
    String name = data.item.ItemLeader?.User?.name ?? '';
    String grade = data.item.ItemLeader?.User?.grade ?? '';
    grade = Util.getGradeName(grade);

    if (name.length > 5) name = name.substring(0, 5);

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 195,
          //  decoration: new BoxDecoration(),
          child: Hero(
            tag: 'a_${widget.id}',
            child: CachedNetworkImage(
              imageUrl: data.item.cover ?? 'assets/mypage/no_img.svg',
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: SvgPicture.asset(
                    'assets/mypage/no_img.svg',
                    // width: 24,
                    // height: 24,
                    fit: BoxFit.scaleDown,
                  )),
              width: double.infinity,
              height: 195,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(children: [
                  if (data.item.itemSubject1 != null)
                    buildChip(Util.getCategoryName1(data.item.itemSubject1)),
                  if (data.item.itemSubject2 != null)
                    buildChip(Util.getCategoryName2(data.item.itemSubject2)),
                ]),
              ),
              const SizedBox(height: 18.0),
              TitleBold20BlackView(data.item?.name ?? '', ""),
              const SizedBox(height: 18.0),
              Text(
                data.item?.summary ?? '',
                textAlign: TextAlign.start,
                style: MTextStyles.regular16Grey06,
              ),
              const SizedBox(height: 18.0),
              Row(children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                      '${data.item?.ItemLeader?.profileUrl ?? ''}'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 11),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: MTextStyles.regular12Black),
                    Text(grade, style: MTextStyles.regular10WarmGrey)
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${data.item.locationString}  ・ ${data.item.startDateString}',
                      style: const TextStyle(
                          color: MColors.warm_grey,
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.62,
                          fontSize: 14.0),
                    )
                  ],
                ))
              ]),
              const SizedBox(height: 18.0),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (data.item.discountRate > 0)
                          Text(
                            '${data.item.discountRate}',
                            style: MTextStyles.bold28Tomato,
                          ),
                        if (data.item.discountRate > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              ' %할인',
                              style: MTextStyles.regular13Tomato_32,
                            ),
                          ),
                        const SizedBox(
                          width: 11,
                          height: 10.0,
                        ),
                        Text(
                          '월 ${data.item.pricePerMonth}원',
                          style: MTextStyles.bold22Black,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${data.item.durationInMonth}개월 멤버십 ',
                          style: MTextStyles.medium14PinkishGrey,
                        ),
                        Text(
                          '${data.item.priceString}원',
                          style: data.item.discountRate > 0
                              ? MTextStyles.medium14PinkishGreyStroke
                              : MTextStyles.medium14PinkishGrey,
                        ),
                        if (data.item.discountRate > 0)
                          Text(
                            ' ${data.item.discountPriceString}원',
                            style: MTextStyles.medium14PinkishGrey,
                          )
                      ],
                    )
                  ],
                ),
              ),
              //    _buildTabBody(),
            ],
          ),
        ),
      ],
    );
  }

  // Tab scrolll 시 발생하는 이벤트 제어
  void getDataList(tabindex) {
    print('getDataList : $tabindex');
    if (tabindex == 0) {
    } else if (tabindex == 1) {
    } else if (tabindex == 2) {
    } else if (tabindex == 3) {
    } else if (tabindex == 4) {}
  }

  Widget buildChip(String chip) {
    return Chip(
      label: Text(
        chip,
        style: MTextStyles.regular10Grey06,
      ),
      backgroundColor: MColors.white_two,
    );
  }

// 5번째 후기 탭 내용
  Widget _tabbarView5(MeetingDetailData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Divider1(),
                ),
                _redTitle('일정 및 장소'),
                Text(
                  '우리가 만나는 일정과 장소',
                  style: MTextStyles.bold22Black,
                ),
                const SizedBox(height: 25),
                Text(
                  '일시',
                  style: MTextStyles.bold16Black,
                ),
                const SizedBox(height: 10),
                // Text(
                //   '매월 격주 수요일 저녁 7시 30분 ~ 10시 30분',
                //   style: MTextStyles.medium14Grey06,
                // ),
              ] +
              _itemRoundText(data.item) +
              [
                const SizedBox(height: 25),
                Text(
                  '장소',
                  style: MTextStyles.bold16Black,
                ),
                const SizedBox(height: 10),
                Text(
                  data.item.locationString,
                  style: MTextStyles.medium14Grey06,
                ),
                const SizedBox(height: 25),
                Text(
                  '정원',
                  style: MTextStyles.bold16Black,
                ),
                const SizedBox(height: 10),
                Text(
                  '최소 ${data.item.minimumPerson ?? 0}명 ~ 최대 ${data.item.maximumPerson ?? 0}명',
                  style: MTextStyles.medium14Grey06,
                ),
                const SizedBox(height: 25),
                Text(
                  '멤버십 비용',
                  style: MTextStyles.bold16Black,
                ),
                const SizedBox(height: 10),
//         Row(
//           children: [
//             if(data.item.discountRate > 0)
//               Text(
//                 '${data.item.discountRate}%할인  ',
//                 style: MTextStyles.medium14Tomato,
//               ),
//             Text(
//               '월 ${data.item.pricePerMonth}원',
//               style: MTextStyles.medium14Grey06,
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//             Row( children: [
//               Text(
//                 '${data.item.durationInMonth}개월 멤버십 ',
//                 style: MTextStyles.medium14PinkishGrey,
//               ),
//
//               Text(
//                 '${data.item.priceString}원',
//                 style: data.item.discountRate > 0 ? MTextStyles.medium14PinkishGreyStroke :MTextStyles.medium14WarmGrey,
//               ),
//               if(data.item.discountRate > 0)
//                 Text(
//                   ' ${data.item.discountPriceString}원',
//                   style: MTextStyles.medium14WarmGrey,
//                 )
//             ],)
// ,
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Divider1(),
//         ),
//         _redTitle('달라지는 내 모습'),
//         Text(
//           '모임을 통해 우리는 이렇게',
//           style: MTextStyles.bold22Black,
//         ),
//         const SizedBox(height: 25),
//         Html(data: data.item.itemDetail4),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Divider1(),
//         ),
//         _redTitle('준비사항'),
//         Text(
//           '모임을 위해 준비해 주세요',
//           style: MTextStyles.bold22Black,
//         ),
//         const SizedBox(height: 25),
//         Text(
//           data.item.itemDetail5 ?? '',
//           style: MTextStyles.medium16Grey06,
//         ),

                const SizedBox(height: 25),
                // Container(
                //   height: 210,
                //   child: StreamBuilder<Response<MeetingDetailData>>(
                //       stream: _itemDetailCtrl.stream,
                //       builder: (BuildContext context, AsyncSnapshot<Response<MeetingDetailData>> snapshot) {
                //         if (snapshot.hasData) {
                //           switch (snapshot.data.status) {
                //             case Status.LOADING:
                //               return Center(
                //                   child: Padding(
                //                 padding: const EdgeInsets.all(68.0),
                //                 child: CircularProgressIndicator(),
                //               ));
                //               break;
                //             case Status.COMPLETED:
                //               MeetingDetailData items = snapshot.data.data;

                //               return ListView.builder(
                //                   shrinkWrap: true,
                //                   padding: EdgeInsets.only(left: 0),
                //                   scrollDirection: Axis.horizontal,
                //                   itemCount: 2,
                //                   itemBuilder: (BuildContext context, int index) {
                //               //      WritableReviewsData item = items;
                //                     ClassData classData = ClassData.fromMap(item.toMap());

                //                     return Container(
                //                         width: 201,
                //                         // height: 181,
                //                         padding: EdgeInsets.only(right: 10),
                //                         //  color: Colors.transparent,
                //                         child: InkWell(
                //                             onTap: () => Navigator.of(context).pushNamed('ReviewsWritePage'),
                //                             child: ClassBigBox(classData)));
                //                   });
                //               break;
                //             case Status.ERROR:
                //               return Error(
                //                 errorMessage: snapshot.data.message,
                //                 onRetryPressed: () => null,
                //               );
                //               break;
                //           }
                //         }
                //         return Center(
                //             child: Padding(
                //           padding: const EdgeInsets.all(48.0),
                //           child: CircularProgressIndicator(),
                //         ));
                //       }),
                // ),
                const SizedBox(height: 45),
              ]),
    );
  }

// 4번째 후기 탭 내용
  Widget _tabbarView4(MeetingDetailData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
        _redTitle('모임주제'),
        Text(
          '함께 나눌 주제',
          style: MTextStyles.bold22Black,
        ),
        const SizedBox(height: 25),
        Container(
          child: ListView.builder(
              itemCount: data.item.ItemRound?.length ?? 0, //+1 for progressbar
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final item = data.item.ItemRound[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              border:
                                  Border.all(color: MColors.tomato, width: 2),
                              color: Colors.white),
                          child: Center(
                            child: Text(
                              '${data.item.ItemRound[index].round}회차',
                              style: MTextStyles.bold14Tomato_60,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Text(
                          '${item.curriculumTitle}',
                          style: MTextStyles.bold16Grey06_99,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (item.curriculumThumbnail != null)
                      CachedNetworkImage(imageUrl: item.curriculumThumbnail),
                    if (item.curriculumThumbnail != null)
                      const SizedBox(height: 16),
                    Text('${item.curriculumDescription}',
                        style: MTextStyles.regular14Grey06_40),
                    const SizedBox(height: 25),
                  ],
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
        _redTitle('리더소개'),
        Text(
          data.item.ItemLeader?.careerSummary ?? '',
          style: MTextStyles.bold22Black,
        ),
        const SizedBox(height: 25),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 44,
                backgroundImage:
                    NetworkImage(data.item?.ItemLeader?.profileUrl ?? ''),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.item.ItemLeader?.User?.name ?? '',
                      style: MTextStyles.bold16Grey06_36),
                  const SizedBox(height: 10),
                  Text(
                    data.item.ItemLeader?.word ?? '',
                    style: MTextStyles.regular12Greyish,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(data.item.ItemLeader?.introduction ?? '',
            style: MTextStyles.regular14Grey06_40),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
        if (data.item.itemDetail3 != null) _redTitle('체크포인트'),
        if (data.item.itemDetail3 != null)
          Text(
            '우리 모임이 더 특별한 이유',
            style: MTextStyles.bold22Black,
          ),
        const SizedBox(height: 25),
        if (data.item.itemDetail3 != null)
          Container(
            height: 305,
            child: ListView.builder(
                shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 0),
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                        // margin: EdgeInsets.only(right: 10),
                        width: 250,
                        height: 242,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          border: Border.all(color: MColors.pinkishGrey10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: Column(
                            children: [
                              CachedNetworkImage(
                                  imageUrl:
                                      data.item.itemDetail3?.thumbnail ?? ''),
                              SizedBox(
                                height: 20,
                              ),
                              Text('123412341234'),
                            ],
                          )),
                        )),
                  );
                }),
          ),
      ]),
    );
  }

// 3번째 후기 탭 내용
  Widget _tabbarView3(MeetingDetailData data) {
    var howPlayingWidgetList = <Widget>[];

    if (data.item.itemHowPlaying != null) {
      //     print(
      //        'data.item.itemHowPlaying.length = ${data.item.itemHowPlaying.length}');
      data.item.itemHowPlaying.forEach((howPlayingData) {
        if (howPlayingData.title != null ||
            howPlayingData.description != null) {
          howPlayingWidgetList.add(CachedNetworkImage(
            imageUrl: howPlayingData?.thumbnail ?? '',
          ));
          howPlayingWidgetList.add(SizedBox(height: 16));
          howPlayingWidgetList.add(Text(
            howPlayingData?.title ?? '',
            style: MTextStyles.bold16Grey06_99,
          ));
          howPlayingWidgetList.add(SizedBox(height: 12));
          howPlayingWidgetList.add(Text(
            howPlayingData?.description ?? '',
            style: MTextStyles.regular14Grey06_40,
          ));
          //  print('howPlayingData?.title = ${howPlayingData?.title}');
          howPlayingWidgetList.add(SizedBox(height: 40.0));
          //  print('howPlayingData?.description = ${howPlayingData?.description}');
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                _redTitle('진행방법'),
                Text(
                  '모임은 어떻게 진행되나요?',
                  style: MTextStyles.bold22Black,
                ),
                const SizedBox(height: 25),
              ] +
              howPlayingWidgetList +
              [
                const SizedBox(height: 80),
              ]),
    );
  }

  // 2번째 후기 탭 내용
  Widget _tabbarView2(MeetingDetailData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _redTitle('모임소개'),
        Text(
          '어떤 모임인가요?',
          style: MTextStyles.bold22Black,
        ),
        const SizedBox(height: 15),
        Html(
          data: data.item.itemDetail1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
        _redTitle('모집대상'),
        Text(
          '이런 분들을 기다립니다',
          style: MTextStyles.bold22Black,
        ),
        const SizedBox(height: 25),
        Html(
          data: data.item.itemDetail2,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
      ]),
    );
  }

  // 1번째 후기 탭 내용
  Widget _tabbarView1(MeetingDetailData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (data.item.reviews.length > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '참여한 멤버들의 한마디',
                style: MTextStyles.bold20Black36,
              ),
              // Container(
              //   width: 82.0, height: 26.0,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(22.0)),
              //       border: Border.all(color: MColors.white_three, width: 1)),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 6),
              //         child: Text(
              //           '전체보기',
              //           style: MTextStyles.regular12WarmGrey,
              //         ),
              //       ),
              //       SvgPicture.asset('assets/icons/arrow_right.svg', color: MColors.warm_grey,),
              //     ],
              //   ),
              // ),
            ],
          ),
        Container(
          child: ListView.builder(
              itemCount: data.item.reviews.length, //+1 for progressbar
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _buildreviewcontents(data.item.reviews[index]);
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Divider1(),
        ),
      ]),
    );
  }

  Widget _buildreviewcontents(SimpleReviewData reviewData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        //  width: 320,
        //height: 120,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: MColors.pinkish_grey, width: 0.5),
            color: MColors.white_four),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(reviewData.userImage ?? ''),
                ),
                Text(reviewData.userName ?? '',
                    style: MTextStyles.regular12Black),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('', style: MTextStyles.regular12WarmGrey),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    color: MColors.grey_06,
                    width: 24,
                    height: 24,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
                child: Text(
                    '다양한 형식에 글을 써 볼 수 있는 기회였어요. 때때로는 막연하고 머리도 좀 아파왔지만 새로운 경험으로 인해 그만큼 유연해진 느낌입니다.',
                    style: const TextStyle(
                        color: MColors.grey_06,
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.35,
                        fontSize: 14.0)))
          ],
        ),
      ),
    );
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text("Welcome to AndroidVille!"),
            ),
          );
        });
  }

  // 취소시
  Future<Widget> _showCancelDialog(context) async {
    // 키보드 다운처리
    FocusScope.of(context).requestFocus(new FocusNode());

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)), //this right here
            child: Container(
              height: 150,
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 11.0, bottom: 0.0),
                      child: Text(
                        '😅신청불가',
                        textAlign: TextAlign.center,
                        style: MTextStyles.bold16Black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '모집인원이 초과하였거나, 시작된 모임입니다.\n다른 모임을 선택해 주세요.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                '확인',
                                style: MTextStyles.bold16Tomato,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _redTitle(String txt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(txt, style: MTextStyles.regular14Tomato),
    );
  }

  Future<Widget> saveShowdialog(context) async {
    // 모임 신청하기 클릭시
    // 키보드 다운처리
    FocusScope.of(context).requestFocus(new FocusNode());

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)), //this right here
            child: Container(
              height: 150,
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '이 모임을 신청하시겠습니까?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('아니오'),
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                saveOrder();
                              },
                              child: Text(
                                '네',
                                style: MTextStyles.bold16Tomato,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // 하트 클릭시
  Future<Widget> zzimSaveShowdialog(context) async {
    // 키보드 다운처리
    FocusScope.of(context).requestFocus(new FocusNode());

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)), //this right here
            child: Container(
              height: 150,
              width: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '이 모임을 찜리스트에 저장하시겠습니까?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('아니오'),
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                _saveZzim();
                              },
                              child: Text(
                                '네',
                                style: MTextStyles.bold16Tomato,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showItemDialog(String message) {
    String _content = message;

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
              color: Colors.white.withOpacity(0.4),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircleAvatar(
                //   backgroundImage: CachedNetworkImageProvider(''),
                //   radius: 30.0,
                // ),
                SizedBox(width: 15),
                Text(
                  _content ?? '-',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: MTextStyles.bold14Tomato,
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      print('showCenterFlash  Closed !!!!  ');
      if (_ != null) {
        print('showCenterFlash : ${_.toString()}');
      }
    });
  }

  List<Widget> _itemRoundText(MeetingDetailItemData item) {
    if (item == null || item.ItemRound == null || item.ItemRound.length == 0)
      return [];

    return List.generate(item.ItemRound.length, (index) {
      final round = item.ItemRound[index];
      return Padding(
        padding: EdgeInsets.only(top: 7.0),
        child: Text(round.toString(), style: MTextStyles.regular14WarmGrey),
      );
    });
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => 52; // tabbar 높이

  @override
  double get maxExtent => 52; // tabbar 높이

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: MColors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
