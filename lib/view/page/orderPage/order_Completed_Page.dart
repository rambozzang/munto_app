import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/order/item_Round_Data.dart';
import 'package:munto_app/model/order/order_basket_Data.dart';
import 'package:munto_app/model/order/order_item_data.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import 'package:munto_app/model/provider/api_Response.dart' as api;
import 'package:munto_app/view/widget/error_page.dart';

import 'package:munto_app/model/order/order_History_Data.dart';

class OrderCampletedPage extends StatefulWidget {
  final String paymentId;

  OrderCampletedPage(this.paymentId);

  @override
  _OrderCampletedPageState createState() => _OrderCampletedPageState();
}

class _OrderCampletedPageState extends State<OrderCampletedPage> {
  final StreamController<api.Response<OrderHistoryData>> _mainCtrl =
      StreamController();

  String pg;

  List<String> items = [];
  List<String> socialings = [];
  List<String> itemRounds = [];
  List<OrderBasketData> dataList = [];

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    try {
      _mainCtrl.sink.add(api.Response.loading());

      OrderHistoryData orderHistoryData =
          await Provider.of<OrderProver>(context, listen: false)
              .getOrderHistoryDetail(widget.paymentId.toString());
// 20201227SLBHS51
// 20201227SLZUO82
      print('orderItemsData : $orderHistoryData');
      _mainCtrl.sink.add(api.Response.completed(orderHistoryData));
      //
      // int tmpAmt = 0;
      // orderHistoryData.items.forEach((OrderItemData data) {
      //   tmpAmt += data.price;
      // });
      // orderHistoryData.socialings.forEach((OrderSocialingData data) {
      //   tmpAmt += data.price;
      // });
      // orderHistoryData.itemRounds.forEach((data) {});

      // 총 결제금액 셋팅
      // orderProver.setBenefitAmt(0);
      // orderProver.setTotalAmt(tmpAmt);
      // orderProver.setReserveMoney(0);
      // orderProver.setPayTotalAmt(tmpAmt);
    } catch (e) {
      print(e.toString());
      _mainCtrl.sink.add(api.Response.error(e.toString()));
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
        body: StreamBuilder<api.Response<OrderHistoryData>>(
            stream: _mainCtrl.stream,
            builder: (BuildContext context,
                AsyncSnapshot<api.Response<OrderHistoryData>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case api.Status.LOADING:
                    return Center(
                        child: Container(
                            height: 24,
                            width: 24,
                            padding: EdgeInsets.all(4),
                            child: CircularProgressIndicator()));
                    break;
                  case api.Status.COMPLETED:
                    return snapshot.data.data != null
                        ? _buildBody(context, snapshot.data.data)
                        : Text(
                            '데이타가 없습니다.',
                            style: MTextStyles.bold16PinkishGrey,
                          );
                    break;
                  case api.Status.ERROR:
                    return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => getData(),
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
        "결제하기",
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
            Navigator.of(context).pop();
          }),
      actions: [],
    );
  }

  Widget _buildItemList(OrderHistoryData data) {
    double size = MediaQuery.of(context).size.width / 360;

    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.Order.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          OrderItemData item = data.Order[index].Item;
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
                        imageUrl: '${item?.cover ?? ''}',
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
                        Text('정기모임', style: MTextStyles.regular12Grey06),
                        Text('${item.name}', style: MTextStyles.bold14Grey06),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${item.ItemRound[0].place == 'HAPJEONG' ? '합정' : item.ItemRound[0].place}  ・ ${Util.getFormattedday1(item.startDate)}',
                            style: MTextStyles.medium12BrownGrey),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '${Util.getMoneyformat(item.price ?? 0)}',
                              style: MTextStyles.bold16Tomato,
                            ),
                            TextSpan(
                              text: '원',
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
                            '장소',
                            style: MTextStyles.regular12Grey06,
                          ),
                          Text(
                            '${item.ItemRound[0].place == 'HAPJEONG' ? '합정' : item.ItemRound[0].place}',
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
                              '일시',
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
                                      '[${item1.round}회차] ${Util.getFormattedday1(item1.startDate)}',
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
  // 소셜링 List
  //=====================================
  Widget _buildSocialingList(OrderHistoryData data) {
    double size = MediaQuery.of(context).size.width / 360;

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.Order.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          dynamic item = data.Order[index].Socialing;
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
                        imageUrl: '${item?.cover ?? ''}',
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
                        Text('소셜링', style: MTextStyles.regular12Grey06),
                        Text('${item?.name}', style: MTextStyles.bold14Grey06),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                            '${item?.location} ・ ${Util.getFormattedday1(item?.startDate)}',
                            style: MTextStyles.medium12BrownGrey),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text:
                                  '${Util.getMoneyformat(data.Order[index].orderPrice ?? 0)}',
                              style: MTextStyles.bold16Tomato,
                            ),
                            TextSpan(
                              text: '원',
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
                            '장소',
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
                            '일시',
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

  Widget _buildBody(context, OrderHistoryData data) {
    double rate = MediaQuery.of(context).size.width / 360;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 147 * rate,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://specials-images.forbesimg.com/imageserve/1184016689/960x0.jpg?fit=scale',
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
              ),
              Positioned(
                top: 100 * rate,
                left: 20,
                right: 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      //  width: 320,
                      alignment: Alignment.center,
                      height: 106 * rate,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text("모임신청이 완료되었습니다.\n취향이 통하는 사람들을 만나보세요!",
                            style: MTextStyles.bold18BlackColor),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x4d000000),
                                offset: Offset(0, 2),
                                blurRadius: 30,
                                spreadRadius: -10)
                          ],
                          color: Colors.white)),
                ),
              ),
              Positioned(
                top: 90 * rate,
                left: 35,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        width: 85,
                        height: 26,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '신청완료',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            border: Border.all(color: Colors.white, width: 2),
                            color: MColors.tomato))),
              ),
              const SizedBox(
                height: 260,
              ),
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: new Text(
                "신청하신 모임",
                style: MTextStyles.bold18Grey06,
              )),
          const SizedBox(
            height: 16,
          ),
          Divider1(),
          if (data.Order[0].Socialing != null) _buildSocialingList(data),
          const SizedBox(
            height: 16,
          ),
          if (data.Order[0].Item != null) _buildItemList(data),
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
              "결제 정보",
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
                        '합계 금액',
                        style: MTextStyles.regular14Grey06,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${Util.getMoneyformat(data.price)}',
                            style: MTextStyles.bold16Grey06,
                          ),
                          TextSpan(
                            text: '원',
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
                        '혜택 금액',
                        style: MTextStyles.regular14Grey06,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${Util.getMoneyformat(0)}',
                            style: MTextStyles.bold16Grey06,
                          ),
                          TextSpan(
                            text: '원',
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
                        width: 105,
                        child: Text(
                          '적립금 사용',
                          style: MTextStyles.regular14Grey06,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '0원 사용',
                        style: MTextStyles.regular12Grey06,
                      )
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 75,
                        child: Text(
                          '쿠폰',
                          style: MTextStyles.regular14Grey06,
                        ),
                      ),
                      SizedBox(
                        width: 105,
                        child: Text(
                          '쿠폰명 표기',
                          style: MTextStyles.regular12Grey06,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '0 원 사용',
                        style: MTextStyles.regular12Grey06,
                      )
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
                new Text("총 결제금액",
                    style: const TextStyle(
                        color: MColors.tomato,
                        fontWeight: FontWeight.w700,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0)),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '${Util.getMoneyformat(data.price)}',
                        style: const TextStyle(
                            color: MColors.tomato,
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0)),
                    TextSpan(
                      text: '원',
                      style: MTextStyles.bold16Tomato,
                    )
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          DividerGrey12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    color: MColors.tomato,
                    child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed('PaymentListDetailPage'),
                      //  onPressed: ()=> Navigator.of(context).pushNamed('PaymentListPage'),
                      child: Text(
                        '결제내역보기',
                        style: MTextStyles.bold14White,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    color: MColors.tomato,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('ClassListPage'),
                      child: Text(
                        '모임내역 보기',
                        style: MTextStyles.bold14White,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
