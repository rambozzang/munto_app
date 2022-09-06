import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/model/order/order_History_Data.dart';
import 'package:munto_app/model/order/paymentHistory/payment_History_Data.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/model/provider/api_Response.dart' as api;
import 'package:munto_app/view/widget/error_page.dart';

class PaymentListDetailPage extends StatefulWidget {
  @override
  _PaymentListDetailPageState createState() => _PaymentListDetailPageState();
}

class _PaymentListDetailPageState extends State<PaymentListDetailPage> {
  final StreamController<api.Response<List<PaymentHistoryData>>> _mainCtrl =
      StreamController();

  List<PaymentHistoryData> _paymentDataList = [];

  OrderProver orderProver = OrderProver();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getNameOrderStatus(state) {
    switch (state) {
      case OrderStatus.COMPLETED_PAYMENT:
        return '결제완료';
      case OrderStatus.NONE:
        return '결제완료';
      case OrderStatus.FAILED_PAYMENT:
        return '결제완료';
      default:
        return '정기모임';
    }
  }

  getNameOrderKind(kind) {
    switch (kind) {
      case OrderKind.CARD:
        return '카드';
      case OrderKind.FREE:
        return '무료';
      case OrderKind.NO_PAYMENT:
        return '없음';
      default:
        return '결제';
    }
  }

  getData() async {
    try {
      _mainCtrl.sink.add(api.Response.loading());
      _paymentDataList = await orderProver.getOrderHistory();

      _mainCtrl.sink.add(api.Response.completed(_paymentDataList));
    } catch (e) {
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
        body: StreamBuilder<api.Response<List<PaymentHistoryData>>>(
            stream: _mainCtrl.stream,
            builder: (BuildContext context,
                AsyncSnapshot<api.Response<List<PaymentHistoryData>>>
                    snapshot) {
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
                    List<PaymentHistoryData> list = snapshot.data.data;
                    return list.length > 0
                        ? _getBody(list)
                        : _classNoDataWidget();
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
        "결제내역2",
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
            //  Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      actions: [],
    );
  }

  Widget _getBody(List<PaymentHistoryData> data) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          // Rectangle
          Container(
              width: double.infinity,
              height: 46,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '주문번호 : 2020100955024141 ',
                  style: MTextStyles.regular14BlackColor,
                ),
              ),
              decoration: BoxDecoration(color: const Color(0xffd8d8d8))),
          const SizedBox(
            height: 16,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                PaymentHistoryData item = data[index];
                return _paymentBox(item);
              }),
          DividerGrey12(),
          _orderInfoWidget(), //결제 정보

          //  _cardListBox(),
        ],
      ),
    );
  }

  Widget _orderInfoWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '결제 정보',
              style: MTextStyles.bold18BlackColor,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 186,
          decoration: BoxDecoration(color: MColors.white_two),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '합계 금액',
                      style: MTextStyles.regular12Grey06,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '2,400', //"22,000",
                          style: MTextStyles.bold16Grey06,
                        ),
                        TextSpan(
                          text: ' 원',
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
                      style: MTextStyles.regular12Grey06,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '400',
                          style: MTextStyles.bold16Grey06,
                        ),
                        TextSpan(
                          text: ' 원',
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
                    Text(
                      '합계 금액',
                      style: MTextStyles.regular12Grey06,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '2,400', //"22,000",
                          style: MTextStyles.bold16Grey06,
                        ),
                        TextSpan(
                          text: ' 원',
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
                      style: MTextStyles.regular12Grey06,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '400',
                          style: MTextStyles.bold16Grey06,
                        ),
                        TextSpan(
                          text: ' 원',
                          style: MTextStyles.regular12Grey06,
                        )
                      ]),
                    )
                  ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '총 결제금액',
                style: MTextStyles.bold18BlackColor,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '22,000',
                    style: MTextStyles.bold18BlackColor,
                  ),
                  TextSpan(
                    text: ' 원',
                    style: MTextStyles.regular14Grey06_,
                  )
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentBox(PaymentHistoryData data) {
    double rate = MediaQuery.of(context).size.width / 360;
    // 정기모임 , 소셜링
    String orderKindName = data.item != null ? '정기모임' : '소셜링';
    String orderName =
        data.item != null ? data.item?.name : data.socialing?.name;
    String orderCover =
        data.item != null ? data.item?.cover : data.socialing?.cover;
    String orderLocation =
        data.item != null ? data.item?.location : data.socialing?.location;
    DateTime orderStartDate =
        data.item != null ? data.item?.startDate : data.socialing?.startDate;

    return InkWell(
      onTap: () {
        if (data.item == null) {
          SocialingData socialingData = SocialingData();
          socialingData.id = data.socialing.id;
          Navigator.of(context)
              .pushNamed('SocialingDetailPage', arguments: socialingData);
        } else {
          Navigator.of(context).pushNamed('MeetingDetailPage',
              arguments: [data.item.id, data.item?.name, false]);
        }
      },
      child: Ink(
        width: double.infinity,
        // height: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
            //   color: Colors.red,
            //color: Color(0xffebebeb),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonTheme(
                minWidth: 62 * rate,
                //padding: const EdgeInsets.symmetric(horizontal: 20.0),
                height: 28 * rate,
                child: OutlineButton(
                    child: new Text("${getNameOrderStatus(data.orderStatus)}",
                        style: MTextStyles.bold14Tomato),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29.0),
                    ),
                    borderSide: BorderSide(
                      color: MColors.tomato,
                    ),
                    onPressed: () {}),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 118 * rate,
                      height: 64 * rate,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: CachedNetworkImage(
                          imageUrl: '${orderCover ?? ''}',
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                              decoration: new BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                      width: 1, color: Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(8)),
                              child: SvgPicture.asset(
                                '${data?.item?.cover}?? assets/mypage/no_img.svg',
                                width: 24,
                                height: 24,
                                fit: BoxFit.scaleDown,
                              )),
                          width: double.infinity,
                          height: 83 * rate,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$orderKindName',
                              style: MTextStyles.regular12Grey06),
                          Text('$orderName', style: MTextStyles.bold14Grey06),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              '$orderLocation ・ ${Util.getFormattedday1(orderStartDate.toString())}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: MTextStyles.medium12BrownGrey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 138,
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('결제 일시', style: MTextStyles.regular14WarmGrey),
                  ),
                  Container(
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        '${Util.getFormattedday3(data.orderDate.toString())}',
                        style: MTextStyles.regular14Grey06),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 138,
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('결제 수단', style: MTextStyles.regular14WarmGrey),
                  ),
                  Container(
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('${getNameOrderKind(data.orderKind)}',
                        style: MTextStyles.regular14Grey06),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 138,
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('결제 금액', style: MTextStyles.regular14WarmGrey),
                  ),
                  Container(
                    //  padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('${Util.getMoneyformat(data.orderPrice)}원',
                        style: MTextStyles.regular14Grey06),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 283,
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('환불 신청하기',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NodataImage(
              wid: 80.0,
              hei: 80.0,
              path: 'assets/mypage/empty_orderhistory_60_px.svg'),
          Text('결제 내역이 없습니다.\n취향에 꼭 맞는 모임에 참여해 보세요!',
              textAlign: TextAlign.center, style: MTextStyles.medium16WarmGrey),
          const SizedBox(height: 15),
          FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              height: 42,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                border: Border.all(color: MColors.tomato, width: 1),
                color: MColors.tomato,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("모임보기", style: MTextStyles.medium14White),
                  Icon(Icons.check, size: 20, color: MColors.white),
                ],
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
