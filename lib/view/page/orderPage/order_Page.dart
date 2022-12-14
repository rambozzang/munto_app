import 'dart:async';
import 'dart:convert';

import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/bio_payload.dart';
import 'package:bootpay_api/model/bio_price.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/bootpay_PayModel_Data.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/order/bootpay_Data.dart';
import 'package:munto_app/model/order/item_Round_Data.dart';
import 'package:munto_app/model/order/order_basket_Data.dart';
import 'package:munto_app/model/order/order_item_data.dart';
import 'package:munto_app/model/order/order_items_data.dart';
import 'package:munto_app/model/order/order_socialing_data.dart';
import 'package:munto_app/model/order/paymentId_Detail_Data.dart';
import 'package:munto_app/model/order/paymentid_Data.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/model/provider/user_profile_provider.dart';
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:requests/requests.dart';

import 'package:munto_app/model/provider/api_Response.dart' as api;
import 'package:munto_app/view/widget/error_page.dart';
import 'package:url_launcher/url_launcher.dart';

String applicationId = '5f31f4212fa5c2001eeecbc1';
String androidApplicationId = '5f31f4212fa5c2001eeecbc1';
String iosApplicationId = '5f31f4212fa5c2001eeecbc2';

//???????????? ????????? id
// String applicationId = '5b8f6a4d396fa665fdc2b5e8';
// String androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
// String iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

// ignore: must_be_immutable
class OrderPage extends StatefulWidget {
  List<OrderBasketData> orderDataList = [];
  OrderPage(this.orderDataList);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderProver orderProver;

  final StreamController<api.Response<OrderItemsData>> _mainCtrl =
      StreamController();

  BootpayPayModelData bootpayPayModelData = BootpayPayModelData();
  UserProfileData userProfileData = UserProfileData();
  Payload payload = Payload();
  BioPayload biopayload = BioPayload();

  final TextEditingController _controller = TextEditingController();

  FocusNode f1 = FocusNode();

  String pg;

  List<String> items = [];
  List<String> socialings = [];
  List<String> itemRounds = [];
  List<OrderBasketData> dataList = [];

  //?????????
  String reserveMoney = '0';
  @override
  void initState() {
    super.initState();
    // orderProver = Provider.of<OrderProver>(context, listen: false);

    getData();
  }

  Future<void> getData() async {
    try {
      _mainCtrl.sink.add(api.Response.loading());
      await Provider.of<UserProfileProvider>(context, listen: false)
          .fetchProfile();

      dataList = widget.orderDataList;

      dataList.forEach((val) {
        OrderBasketData item = val;
        if (item.classType == 'ITEM') {
          items.add(item.classId.toString());
        } else {
          socialings.add(item.classId.toString());
        }

        if ((item.round ?? '') != '' || item.round != null) {
          itemRounds.add(item.round.toString());
        }
      });
      print('--------------------');
      // api ????????? array ??????????????? ?????? ??????
      if (items.length == 1) items.add('0');
      if (socialings.length == 1) socialings.add('0');
      if (itemRounds.length == 1) itemRounds.add('0');

      print('--------------------');
      items.forEach((w) {
        print('items : ' + w);
      });
      socialings.forEach((w) {
        print('socialings : ' + w);
      });
      itemRounds.forEach((w) {
        print('itemRounds : ' + w);
      });

      orderProver = Provider.of<OrderProver>(context, listen: false);
      OrderItemsData orderItemsData =
          await orderProver.getOrderInfo(items, socialings, itemRounds);

      print('orderItemsData : $orderItemsData');
      _mainCtrl.sink.add(api.Response.completed(orderItemsData));
      // ??? ???????????? ??????
      int tmpAmt = 0;
      tmpAmt = orderItemsData.items.fold(0, (sum, item) => sum + item.price);
      tmpAmt = orderItemsData.socialings
          .fold(tmpAmt, (sum, item) => sum + item.price);
      // orderItemsData.items.forEach((OrderItemData data) {
      //   tmpAmt += data?.price ?? 0;
      // });
      // orderItemsData.socialings.forEach((OrderSocialingData data) {
      //   tmpAmt += data?.price ?? 0;
      // });
      // orderItemsData.itemRounds.forEach((data) {});

      // ??? ???????????? ??????
      orderProver.setBenefitAmt(0);
      orderProver.setTotalAmt(tmpAmt);
      orderProver.setReserveMoney(0);
      orderProver.setPayTotalAmt(tmpAmt);

      // ????????? ????????????
      var userProvider =
          Provider.of<UserProfileProvider>(context, listen: false)
              .userProfileData;
      reserveMoney =
          NumberFormat("#,##0", "ko_KR").format(userProvider.reserveMoney ?? 0);
    } catch (e) {
      print(e.toString());
      _mainCtrl.sink.add(api.Response.error(e.toString()));
    }
  }

  savePayment(payTotalAmt) async {
    print('savePayment($payTotalAmt)');

    if ((pg == '' || pg == null) && payTotalAmt > 0) {
      Util.showCenterFlash(
          context: context,
          position: FlashPosition.bottom,
          style: FlashStyle.floating,
          text: '?????? ????????? ??????????????????!');
      return;
    }
    PaymentIdData result;
    try {
      // PaymentId ????????????
      Map<String, dynamic> _map = Map();
      _map['items'] = items;
      _map['socialings'] = socialings;
      _map['itemRounds'] = itemRounds;
      result = await orderProver.getOrderPaymentId(_map);
      print('result : $result');
      if (result.paymentId == '' || result.paymentId == null) {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '??????ID ?????? ??????!');
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

    //?????? ????????? ?????? ?????? ??????
    BootPayData _bootPayData = BootPayData();
    BootPayDetailData _datadetail = BootPayDetailData();
    List<BootPayDetailData> itemList = [];
    List<BootPayDetailData> socialingList = [];
    List<BootPayDetailData> itemRoundList = [];
    int finalPayTotalAmount = 0;

    result.items.forEach((PaymentIdDetailData w) {
      if (w.result) {
        _datadetail.id = w.id.toString();
        _datadetail.couponId = '';
        itemList.add(_datadetail);
        finalPayTotalAmount += w.price;
      }
    });

    result.socialings.forEach((PaymentIdDetailData w) {
      if (w.result) {
        _datadetail.id = w.id.toString();
        _datadetail.couponId = '';
        socialingList.add(_datadetail);
        finalPayTotalAmount += w.price;
      }
    });
    result.itemRounds.forEach((PaymentIdDetailData w) {
      if (w.result) {
        _datadetail.id = w.id.toString();
        _datadetail.couponId = '';
        itemRoundList.add(_datadetail);
        finalPayTotalAmount += w.price;
      }
    });

    _bootPayData.paymentId = result.paymentId;
    _bootPayData.totalPrice = finalPayTotalAmount.toString();
    _bootPayData.reservesMoney = '0';
    _bootPayData.orderKind = 'CARD';

    _bootPayData.items = itemList;
    _bootPayData.socialings = socialingList;
    _bootPayData.itemRounds = itemRoundList;

    if (finalPayTotalAmount > 0) {
      print('_bootPayData : ${_bootPayData.toString()}');
      BootpayPayModelData bootpayPayModelData = setPaymentData();
      if (pg == "bio") {
        goBootpayRequestBio(
            context, bootpayPayModelData, finalPayTotalAmount, _bootPayData);
      } else {
        goBootpayRequest(
            context, bootpayPayModelData, finalPayTotalAmount, _bootPayData);
      }
    } else {
      // ??????????????? ?????? ??????
      String paymentId = await orderProver.getOrderClassNoPayment(_bootPayData);
      print('getOrderClassNoPayment paymentId : $paymentId');

      if (paymentId != "") {
        Navigator.of(context)
            .popAndPushNamed('OrderCampletedPage', arguments: paymentId);
      } else {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '??????ID ?????? ??????!');
        return;
      }
    }
  }

  // ???????????? ?????? ????????? ??????!!!!
  bootPaySuccess(BootPayData bootPayData) async {
    try {
      String paymentId = await orderProver.getOrderClassBootpay(bootPayData);

      print('getOrderClassBootpay paymentId : $paymentId');
      if (paymentId != "") {
        Navigator.of(context)
            .popAndPushNamed('OrderCampletedPage', arguments: paymentId);
      } else {
        Util.showCenterFlash(
            context: context,
            position: FlashPosition.bottom,
            style: FlashStyle.floating,
            text: '??????ID ?????? ??????!');
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _mainCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: StreamBuilder<api.Response<OrderItemsData>>(
            stream: _mainCtrl.stream,
            builder: (BuildContext context,
                AsyncSnapshot<api.Response<OrderItemsData>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case api.Status.LOADING:
                    return Center(
                        child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(4),
                            child: CircularProgressIndicator(
                                //   strokeWidth: 1.5,
                                )));
                    break;
                  case api.Status.COMPLETED:
                    return snapshot.data.data != null
                        ? _buildBody(snapshot.data.data)
                        : Text(
                            '???????????? ????????????.',
                            style: MTextStyles.bold16PinkishGrey,
                          );
                    break;
                  case api.Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => null,
                    );
                    break;
                }
              }
              return Center(
                  child: Container(
                      height: 24,
                      width: 24,
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                          //   strokeWidth: 1.5,
                          )));
            }));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "????????????",
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
            // Icons.arrow_back_ios,
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            canclePayment(context);
            //  Navigator.of(context).pop();
          }),
      actions: [],
    );
  }

  Widget _buildItemList(List<OrderItemData> data) {
    double size = MediaQuery.of(context).size.width / 360;
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          OrderItemData item = data[index];
          return Column(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 118 * size,
                    height: 64 * size,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: '${item.cover ?? ''}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                            decoration: new BoxDecoration(
                                // color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.grey[300]),
                                borderRadius: BorderRadius.circular(8)),
                            child: SvgPicture.asset(
                              'assets/mypage/no_img.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.scaleDown,
                            )),
                        width: double.infinity,
                        height: 83 * size,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('????????????', style: MTextStyles.regular12Grey06),
                        Text('${item.name}', style: MTextStyles.bold14Grey06),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${item.ItemRound[0].place == 'HAPJEONG' ? '??????' : item.ItemRound[0].place}  ??? ${Util.getFormattedday1(item.startDate)}',
                            style: MTextStyles.medium12BrownGrey),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${Util.getMoneyformat(item.price ?? 0)}',
                              style: MTextStyles.bold16Tomato,
                            ),
                            TextSpan(
                              text: '???',
                              style: MTextStyles.regular14Tomato,
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              //    height: 49,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  color: MColors.white_two,
                  border: Border.all(color: MColors.pinkish_grey, width: 0.5)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 118 * size,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '??????',
                            style: MTextStyles.regular12Grey06,
                          ),
                          Text(
                            '${item.ItemRound[0].place == 'HAPJEONG' ? '??????' : item.ItemRound[0].place}',
                            style: MTextStyles.bold12Grey06,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '??????',
                              style: MTextStyles.regular12Grey06,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: item.ItemRound.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  ItemRounData item1 = item.ItemRound[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      '[${item1.round}??????] ${Util.getFormattedday1(item1.startDate)}',
                                      style: MTextStyles.bold12Grey06,
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ]);
        });
  }

  //=====================================
  // ????????? List
  //=====================================
  Widget _buildSocialingList(List<OrderSocialingData> data) {
    double size = MediaQuery.of(context).size.width / 360;

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          OrderSocialingData item = data[index];
          return Column(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 118 * size,
                    height: 64 * size,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: '${item.cover ?? ''}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                            decoration: new BoxDecoration(
                                // color: Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.grey[300]),
                                borderRadius: BorderRadius.circular(8)),
                            child: SvgPicture.asset(
                              'assets/mypage/no_img.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.scaleDown,
                            )),
                        width: double.infinity,
                        height: 83,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('?????????', style: MTextStyles.regular12Grey06),
                        Text('${item.name}', style: MTextStyles.bold14Grey06),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                            '${item.location} ??? ${Util.getFormattedday1(item.startDate)}',
                            style: MTextStyles.medium12BrownGrey),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${Util.getMoneyformat(item.price ?? 0)}',
                              style: MTextStyles.bold16Tomato,
                            ),
                            TextSpan(
                              text: '???',
                              style: MTextStyles.regular14Tomato,
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //height: 49,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: MColors.white_two,
                  border: Border.all(color: MColors.pinkish_grey, width: 0.5)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 118 * size,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '??????',
                            style: MTextStyles.regular12Grey06,
                          ),
                          Text(
                            '${item.location}',
                            style: MTextStyles.bold12Grey06,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '??????',
                            style: MTextStyles.regular12Grey06,
                          ),
                          Text(
                            '${Util.getFormattedday2(item.startDate)}',
                            style: MTextStyles.bold12Grey06,
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ]);
        });
  }

  Widget _buildBody(OrderItemsData data) {
    var orderProver2 = Provider.of<OrderProver>(context);
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
                "???????????? ??????",
                style: MTextStyles.bold18Grey06,
              )),
          const SizedBox(
            height: 16,
          ),
          Divider1(),
          _buildSocialingList(data.socialings),
          const SizedBox(
            height: 16,
          ),
          _buildItemList(data.items),
          const SizedBox(
            height: 16,
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "?????? ??????",
                    style: MTextStyles.bold18Grey06,
                  ),
                  Row(children: [
                    Text(
                      "${data.user?.name ?? '-'}",
                      style: MTextStyles.medium14Grey06,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${data.user?.phoneNumber ?? '-'}",
                      style: MTextStyles.medium14Grey06,
                    ),
                    Spacer(),
                    Container(
                      height: 20,
                    ),
                    // Container(
                    //   width: 64,
                    //   child: OutlineButton(
                    //     onPressed: null,
                    //     // padding : EdgeInsets.all(0.0),
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    //     shape: new RoundedRectangleBorder(
                    //         borderRadius: new BorderRadius.circular(22.0)),
                    //     child: Text(
                    //       "??????",
                    //       style: MTextStyles.medium14Grey06,
                    //     ),
                    //   ),
                    // ),
                  ])
                ],
              )),
          const SizedBox(
            height: 6,
          ),
          DividerGrey12(),
          const SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: new Text(
              "?????? ??????",
              style: MTextStyles.bold18Grey06,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            //    height: 49,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            decoration: BoxDecoration(
                color: MColors.white_two,
                border: Border.all(color: MColors.pinkish_grey, width: 0.5)),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '?????? ??????',
                        style: MTextStyles.regular12Grey06,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                '${Util.getMoneyformat(orderProver2.getTotalAmt)}', //"22,000",
                            style: MTextStyles.bold16Grey06,
                          ),
                          TextSpan(
                            text: ' ???',
                            style: MTextStyles.regular12Grey06,
                          )
                        ]),
                      )
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '?????? ??????',
                        style: MTextStyles.regular12Grey06,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                '${Util.getMoneyformat(orderProver2.getBenefitAmt)}',
                            style: MTextStyles.bold16Grey06,
                          ),
                          TextSpan(
                            text: ' ???',
                            style: MTextStyles.regular12Grey06,
                          )
                        ]),
                      )
                    ]),
                SizedBox(height: 10),
                Divider1(),
                SizedBox(height: 10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 45,
                        child: Text(
                          '?????????',
                          style: MTextStyles.medium14Grey06,
                        ),
                      ),
                      SizedBox(width: 10),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            style: MTextStyles.medium14Grey06,
                            text: "${reserveMoney}"),
                        TextSpan(
                            style: MTextStyles.medium14WarmGrey, text: " ??? ??????")
                      ])),
                      Spacer(),
                      Container(
                        width: 102,
                        height: 37,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              enabled: int.parse('$reserveMoney') == 0
                                  ? false
                                  : true,
                              controller: _controller,
                              focusNode: f1,
                              textAlignVertical: TextAlignVertical.bottom,
                              style: MTextStyles.regular14BlackColor,
                              maxLength: 10,
                              onChanged: (String val) {
                                print(
                                    'var : $val  > reserveMoney : $reserveMoney');
                                int tmp1 = int.parse(val.replaceAll(',', ''));
                                int tmp2 = int.parse('$reserveMoney');
                                print('tmp1 : $tmp1  > tmp2 : $tmp2');
                                if (tmp1 < tmp2) {
                                  print('????????????!');
                                } else {
                                  print('?????? ??????!');
                                  _controller.text =
                                      Util.getMoneyformat(tmp2.toString());
                                  Util.showCenterFlash(
                                      context: context,
                                      position: FlashPosition.bottom,
                                      style: FlashStyle.floating,
                                      text: '????????? $reserveMoney ?????? ?????? ??? ??? ????????????');
                                  f1.unfocus();

                                  return false;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '0',
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                hintStyle: MTextStyles.regular14Warmgrey,
                                labelStyle:
                                    TextStyle(color: Colors.transparent),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                //WhitelistingTextInputFormatter.digitsOnly,
                                NumericTextFormatter()
                              ],
                            )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: MColors.pinkish_grey, width: 1),
                            color: Colors.white),
                      ),
                      SizedBox(width: 2),
                      Text(
                        '??? ??????',
                        style: MTextStyles.regular12Grey06,
                      )
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 45,
                        child: Text(
                          '??????',
                          style: MTextStyles.medium14Grey06,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '?????? ${data.user.UserCoupon.length ?? 0} ???',
                        style: MTextStyles.medium14Grey06,
                      ),
                    ]),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text(
                  "??? ????????????",
                  style: MTextStyles.bold18Grey06,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text:
                          '${Util.getMoneyformat(orderProver2.getPayTotalAmt)}',
                      style: MTextStyles.bold16Tomato,
                    ),
                    TextSpan(
                      text: '???',
                      style: MTextStyles.regular12Tomato,
                    )
                  ]),
                ),
                // StreamBuilder<String>(
                //     stream: _totalAmtCtrl.stream,
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) {
                //         return CircularProgressIndicator();
                //       }
                //       return RichText(
                //         text: TextSpan(children: [
                //           TextSpan(
                //             text: '${snapshot.data}',
                //             style: MTextStyles.bold16Tomato,
                //           ),
                //           TextSpan(
                //             text: '???',
                //             style: MTextStyles.regular12Tomato,
                //           )
                //         ]),
                //       );
                //     }),
              ],
            ),
          ),
          SizedBox(height: 16),
          DividerGrey12(),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: new Text(
              "?????? ??????",
              style: MTextStyles.bold18Grey06,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pg = 'card';
                });
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    //  border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
                    border: Border.all(
                        color:
                            pg == 'card' ? MColors.tomato : Colors.transparent),
                    color: Colors.white),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    new Text(
                      "?????? ??????",
                      style: MTextStyles.bold14Grey06,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '????????? ?????? ??????',
                      style: MTextStyles.regular11WarmGrey_049,
                    )
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          //   child: Container(
          //     width: double.infinity,
          //     height: 44,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(4)),
          //         border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
          //         color: Colors.white),
          //     child: Row(
          //       children: [
          //         SizedBox(width: 16),
          //         new Text(
          //           "????????? ??????",
          //           style: MTextStyles.bold14Grey06,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          //   child: Container(
          //     width: double.infinity,
          //     height: 44,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(4)),
          //         border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
          //         color: Colors.white),
          //     child: Row(
          //       children: [
          //         SizedBox(width: 16),
          //         new Text(
          //           "????????? ??????",
          //           style: MTextStyles.bold14Grey06,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pg = 'kakao';
                });
              },
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    // border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
                    border: Border.all(
                        color: pg == 'kakao'
                            ? MColors.tomato
                            : Colors.transparent),
                    color: Colors.white),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    new Text(
                      "????????? ??????",
                      style: MTextStyles.bold14Grey06,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         pg = 'bio';
          //       });
          //     },
          //     child: Container(
          //       width: double.infinity,
          //       height: 44,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(4)),
          //           // border: Border.all(color: const Color(0xffd1d1d1), width: 0.5),
          //           border: Border.all(
          //               color:
          //                   pg == 'bio' ? MColors.tomato : Colors.transparent),
          //           color: Colors.white),
          //       child: Row(
          //         children: [
          //           SizedBox(width: 16),
          //           new Text(
          //             "?????? ??????",
          //             style: MTextStyles.bold14Grey06,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                savePayment(orderProver2.getPayTotalAmt);
              },
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      '${Util.getMoneyformat(orderProver2.getPayTotalAmt)}??? ????????????',
                      style: MTextStyles.bold14White,
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: MColors.tomato)),
            ),
          ),
          SizedBox(height: 16),
          RichText(
              text: new TextSpan(children: [
            new TextSpan(
              text: "????????? ?????? ??? ?????????",
              style: MTextStyles.regular13Grey06,
            ),
            new TextSpan(
                text: "????????????",
                style: MTextStyles.bold14Grey06,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://www.munto.co.kr/policy');
                  }),
            new TextSpan(
              text: "???",
              style: MTextStyles.regular13Grey06,
            ),
            new TextSpan(
                text: "???????????? ????????????",
                style: MTextStyles.bold14Grey06,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://www.munto.kr/privacy');
                  }),
            new TextSpan(
              text: "??? ???????????????.",
              style: MTextStyles.regular13Grey06,
            ),
          ])),
          SizedBox(height: 36),
        ],
      ),
    );
  }

  BootpayPayModelData setPaymentData() {
    BootpayPayModelData returnMap = BootpayPayModelData();

    // 1. ????????? ??????
    User user = User();
    user.username = userProfileData.name; // "????????? ??????";
    user.email = userProfileData.email; // "user1234@gmail.com";
    user.area = "????????????";
    user.phone = userProfileData.phoneNumber ??
        '010-0000-0000'; // "010-4033-4678"; // ????????????
    user.addr = userProfileData.birthDay; // '????????? ????????? ????????? 222';
    returnMap.user = user;

    List<Item> itemList = [];

    dataList.forEach((val) {
      OrderBasketData item = val;
      Item itemtmp = Item();
      // if ((item.round ?? '') != '' || item.round != null) {
      //   itemRounds.add(item.round.toString());
      // }
      itemtmp.itemName = item.classType == 'ITEM' ? '????????????' : '?????????';
      itemtmp.qty = 1; // ?????? ????????? ?????? ??????
      itemtmp.unique = item.classId.toString(); // ?????? ????????? ?????? ???
      itemtmp.price = item.price.toDouble(); // ????????? ??????
      itemList.add(itemtmp);
    });
    returnMap.itemList = itemList;

    // ??? PG?????? ????????? ?????? ???????????? ???????????? ?????????
    // ?????? extra ?????? ???????????? ????????? ??????????????????.
    Extra extra = Extra();
    extra.appScheme = 'Munto ??????';
    extra.quotas = [0, 2, 3];
    returnMap.extra = extra;
    returnMap.payload = Payload();
    returnMap.biopayload = BioPayload();

    return returnMap;
  }

  void goBootpayRequest(
      BuildContext context,
      BootpayPayModelData bootpayPayModelData,
      int payTotalAmt,
      BootPayData bootPayData) async {
    Payload payload = Payload(); // bootpayPayModelData.payload;

    // ???????????? ????????? id
    payload.applicationId = applicationId;
    payload.androidApplicationId = androidApplicationId;
    payload.iosApplicationId = iosApplicationId;

    payload.pg =
        'nicepay'; //  pg == 'kakao' ? 'nicepay' : 'nicepay'; // nicepay , kakao , danal  kakao??? inicis
    print(payload.pg);
    if (pg == 'kakao') {
      payload.method = 'kakao';
    } else {
      payload.methods = ['card', 'phone', 'vbank', 'bank']; // ????????????
    }

    payload.name = '??????';
    payload.price = payTotalAmt.toDouble(); //??????????????? 0 ?????? ??????
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    payload.params = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    };
    Map<String, dynamic> returnMap = Map();
    BootpayApi.request(
      context,
      payload,
      extra: bootpayPayModelData.extra,
      user: bootpayPayModelData.user,
      items: bootpayPayModelData.itemList,
      onDone: (String _data) {
        //  --- onDone: {"action":"BootpayDone","amount":10000,"phone":null,"params":{"callbackParam1":"value12","callbackParam3":"value56","callbackParam2":"value34","callbackParam4":"value78"},"item_name":"??????","receipt_id":"5fe0b2a05ade16004f392764","order_id":"1608561316290","url":"https://app.bootpay.co.kr","price":10000,"tax_free":0,"payment_name":"?????????????????????","pg_name":"?????????????????????","pg":"nicepay","method":"phone","method_name":"?????????????????????","payment_group":"phone","payment_group_name":"????????????","requested_at":"2020-12-21 23:35:12","purchased_at":"2020-12-21 23:37:04","status":1}

// I/flutter ( 9009): --- onDone: {"action":"BootpayDone","receipt_id":"5fe190542fa5c2003bafd45d","price":10000,"card_no":"****","card_code":"40","card_name":"???????????????","card_quota":"00","receipt_url":"https://app.bootpay.co.kr/bill/dklTM3l6Sm4rY2lwUWp2Mkt2OEJOSmNlMitWZ1Vrb0x0M3dQQkl2OWNKVGRz%0AUT09LS1JTSs2SVZtSDZwZW42Qjc4LS1ySThmZU5nOUNVREZ2SFpabUQyeTRR%0APT0%3D%0A","params":{"callbackParam1":"value12","callbackParam3":"value56","callbackParam2":"value34","callbackParam4":"value78"},"item_name":"??????","order_id":"1608618073298","url":"https://app.bootpay.co.kr","tax_free":0,"payment_name":"???????????????","pg_name":"?????????????????????","pg":"nicepay","method":"kakao","method_name":"???????????????","payment_group":"kakao_money","payment_group_name":"???????????????","requested_at":"2020-12-22 15:21:08","purchased_at":"2020-12-22 15:21:29","status":1}
// I/flutter ( 9009): --- onDone: 5fe190542fa5c2003bafd45d

// ( 9009): onMessage : {notification: {title: ???????????? ???????????? ??????????????? ????????? ?????????????????????!, body: ????????????????????? ??????????????? ????????? ??? ????????????.}, data: {classType: ITEM, kind: GO_TO_ORDER_LIST, title: ???????????? ???????????? ??????????????? ????????? ?????????????????????!, click_action: FLUTTER_NOTIFICATION_CLICK, classId: 5336, content: ????????????????????? ??????????????? ????????? ??? ????????????.}}

        print('--- onDone: ${_data}');
        Map<String, dynamic> map = json.decode(_data);
        print('--- onDone: ${map['receipt_id']}');
        // onDone: 5fe0b2a05ade16004f392764

        bootPayData.receiptId = map['receipt_id'].toString();
        bootPaySuccess(bootPayData);
      },
      onCancel: (String json) {
        print('--- onCancel: $json');
      },
      onError: (String json) {
        print(' --- onError: $json');
      },
    );
  }

  void goBootpayRequestBio(
      BuildContext context,
      BootpayPayModelData bootpayPayModelData,
      int payTotalAmt,
      BootPayData bootPayData) async {
    String accesstoken = await getRestToken(context);
    if (accesstoken == "") {
      print("token ?????? ??????!!!");
    } else {
      print("bootpay accesstoken : " + accesstoken);

      String usertoken = await getUserToken(accesstoken);
      if (usertoken == "") {
        print("usertoken ?????? ??????!!!");
        return;
      }
      // item, item Round(1?????? mpsss) , sociaoing (1??????)
      print("bootpay usertoken : " + usertoken);

      BioPayload biopayload = BioPayload();

      biopayload.applicationId = applicationId;
      biopayload.androidApplicationId = androidApplicationId;
      biopayload.iosApplicationId = iosApplicationId;
      biopayload.userToken = usertoken;

      biopayload.pg = 'nicepay'; // danal, kcp, inicis
      biopayload.methods = ['card', 'phone', 'vbank', 'bank'];
      biopayload.name = '??????';
      biopayload.price = payTotalAmt.toDouble(); //??????????????? 0 ?????? ??????
      biopayload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
      biopayload.params = {
        "callbackParam1": "value12",
        "callbackParam2": "value34",
        "callbackParam3": "value56",
        "callbackParam4": "value78",
      };

      BioPrice price1 = BioPrice();
      price1.name = "????????????";
      price1.price = 89000;

      BioPrice price2 = BioPrice();
      price2.name = "????????????";
      price2.price = -2500;

      BioPrice price3 = BioPrice();
      price3.name = "?????????";
      price3.price = 2500;
      biopayload.prices = [price1, price2, price3];
      biopayload.names = ["?????????????????? ??????????????????", "?????? (COLOR)", "55 (SIZE)"];
      //    payload.us

      BootpayApi.requestBio(
        context,
        biopayload,
        extra: bootpayPayModelData.extra,
        user: bootpayPayModelData.user,
        items: bootpayPayModelData.itemList,
        onConfirm: (String _data) {
          print('--- onDone: ${_data}');
          Map<String, dynamic> map = json.decode(_data);
          print('--- onDone: ${map['receipt_id']}');
          bootPayData.receiptId = map['receipt_id'].toString();
          bootPaySuccess(bootPayData);
        },
        onDone: (String json) {
          print('--- onDone: $json');
        },
        onCancel: (String json) {
          print('--- onCancel: $json');
        },
        onError: (String json) {
          print(' --- onError: $json');
        },
      );
    }
  }

  //(????????? ????????? ???????????????.) ??????????????? <-> ??????????????? ??????????????? ????????????.
  //?????? <-> ???????????? ????????? ?????? ???, ????????? userToken ??????
  //??????????????? <-> ????????? ??????????????? ??????????????? ?????????.
  // rest_pk : ???????????? ????????? ????????? ?????? ??????

  // Access Token : ???????????? Access Token??? ?????? ????????? ??? ?????? ???????????? ?????? 30??? ??? ???????????????
  Future<String> getRestToken(BuildContext context) async {
    // String rest_applicationId = "5b8f6a4d396fa665fdc2b5ea";
    // String rest_pk = "n9jO7MxVFor3o//c9X5tdep95ZjdaiDvVB4h1B5cMHQ=";

    // Map<String, dynamic> params = {"application_id": rest_applicationId, "private_key": rest_pk};

    // final response = await Requests.post("https://api.bootpay.co.kr/request/token", body: params);
    // if (response.statusCode == 200) {
    //   var res = json.decode(response.content());
    //   String token = res['data']['token'];
    //   return token;
    // } else {
    //   print(response.content());
    //   return "";
    // }
    String token = await orderProver.getOrderTokenBootpay();
    return token;
  }

  Future<String> getUserToken(String restToken) async {
    Map<String, dynamic> body = {
      "user_id": "12342134567",
//      "user_id": Uuid().v1(),
      "email": "test1234@gmail.com",
      "name": "????????? ??????",
      "gender": 0,
      "birth": "861014",
      "phone": "01012345678"
    };

    final response =
        await Requests.post("https://api.bootpay.co.kr/request/user/token",
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": restToken
            },
            body: body);
    if (response.statusCode == 200) {
      var res = json.decode(response.content());
      String token = res['data']['user_token'];
      return token;
      // goBootpayRequestBio(token);
    } else {
      print(response.content());
      return "";
    }
  }

  canclePop() {
    Navigator.pop(context);
  }

  // ?????? ???
  Future<Widget> canclePayment(context) async {
    // ????????? ????????????
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
                        '????????? ????????? ?????????????????????????',
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
                              child: Text('?????????'),
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () async {
                                //  Navigator.of(context, rootNavigator: false).pop();
                                Navigator.pop(context);
                                canclePop();
                                //   deleteData();
                              },
                              child: Text(
                                '???',
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
}
