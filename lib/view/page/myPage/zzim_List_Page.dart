import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/order/order_basket_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/model/socialing_data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:provider/provider.dart';

class ZzimListPage extends StatefulWidget {
  @override
  _ZzimListPageState createState() => _ZzimListPageState();
}

class _ZzimListPageState extends State<ZzimListPage> {
  final StreamController<Response<List<OrderBasketData>>> _mainCtrl =
      StreamController();
  OrderProver orderProver;
  List<OrderBasketData> isCheckedList = []; // 선택된 id 리스트
  List<OrderBasketData> allCheckedList = []; // 전체 id 리스트
  bool isAllChecked = false; // 전체 선택 여부
  List<OrderBasketData> list = [];
  int totalAmt = 0;

  @override
  void initState() {
    super.initState();
    getDate();
  }

  Future<void> getDate() async {
    try {
      _mainCtrl.sink.add(Response.loading());
      orderProver = Provider.of<OrderProver>(context, listen: false);
      List<OrderBasketData> listData = await orderProver.getOrderBasket();
      _mainCtrl.sink.add(Response.completed(listData));
    } catch (e) {
      _mainCtrl.sink.add(Response.error(e.toString()));
      print('error : ${e.toString()}');
    }
  }

  // 단건 삭제
  Future<void> deleteOneData(String basketId) async {
    print('deleteOneData : $basketId ');
    totalAmt = 0;

    allCheckedList = [];
    isAllChecked = false;

    if (allCheckedList.contains(basketId)) {
      allCheckedList.remove(basketId);
    }

    try {
      _mainCtrl.sink.add(Response.loading());

      Map<String, dynamic> _data = Map();
      List<String> list = [];
      list.add(basketId.toString());
      _data['basketId'] = list;

      var returnData = await orderProver.deleteOrderBasket2(_data);
      print('returnData : $returnData ');

      List<OrderBasketData> listData = await orderProver.getOrderBasket();
      _mainCtrl.sink.add(Response.completed(listData));
      setState(() {});
    } catch (e) {
      _mainCtrl.sink.add(Response.error(e.toString()));
      print('error : ${e.toString()}');
    }
  }

  // 선택사항 삭제
  Future<void> deleteData() async {
    if (isCheckedList.length == 0) {
      return;
    }
    totalAmt = 0;

    allCheckedList = [];
    isAllChecked = false;

    try {
      _mainCtrl.sink.add(Response.loading());

      Map<String, dynamic> _data = Map();
      List<String> list = [];
      isCheckedList.forEach((element) {
        list.add(element.basketId.toString());
      });
      _data['basketId'] = list;

      var returnData = await orderProver.deleteOrderBasket2(_data);
      print('returnData : $returnData ');

      List<OrderBasketData> listData = await orderProver.getOrderBasket();
      _mainCtrl.sink.add(Response.completed(listData));
      setState(() {});
    } catch (e) {
      _mainCtrl.sink.add(Response.error(e.toString()));
      print('error : ${e.toString()}');
    }
  }

  void allCheck(value) {
    if (value) {
      allCheckedList.forEach((element) {
        print(element);
        if (isCheckedList.contains(element) == false) {
          isCheckedList.add(element);

          list.forEach((OrderBasketData data) {
            print('data.basketId  : ${data.basketId}');
            if (data == element) {
              totalAmt += data?.price ?? 0;
            }
            return true;
          });
        }
      });
      isAllChecked = value;
    } else {
      isCheckedList.clear();
      isAllChecked = value;
      totalAmt = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _mainCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder<Response<List<OrderBasketData>>>(
          stream: _mainCtrl.stream,
          builder: (BuildContext context,
              AsyncSnapshot<Response<List<OrderBasketData>>> snapshot) {
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
                  list = snapshot.data.data;
                  return _buildBody(list);
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
          }),
    );
  }

  Widget _buildBody(list) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: isAllChecked,
                onChanged: (bool newValue) {
                  allCheck(newValue);
                },
              ),
              Expanded(
                child: Text(
                  '전체 선택',
                  style: MTextStyles.bold14Grey06,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isCheckedList.length == 0) {
                    Util.showCenterFlash(
                        context: context,
                        position: FlashPosition.bottom,
                        style: FlashStyle.floating,
                        text: '삭제할 모임을 선택해주세요!');
                    return;
                  }

                  _showDeleteDialog(context);
                },
                child: Text(
                  '선택 삭제',
                  style: MTextStyles.regular13Grey06,
                ),
              ),
              SizedBox(width: 10)
            ],
          ),
        ),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xfff4f4f4),
            border: Border(top: BorderSide(color: Color(0xffe8e8e8), width: 1)),
          ),
        ),
        if (list.length == 0) _classNoDataWidget(),
        if (list.length > 0) _buildCheckboxList(list),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xfff4f4f4),
            border: Border(top: BorderSide(color: Color(0xffe8e8e8), width: 1)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 181,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color(0x0d000000),
                offset: Offset(0, -2),
                blurRadius: 6,
                spreadRadius: 0)
          ], color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('선택 모임 수', style: MTextStyles.regular14Grey06),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${isCheckedList.length}',
                        style: MTextStyles.bold14Grey06,
                      ),
                      TextSpan(
                        text: ' 개',
                        style: MTextStyles.regular14Grey06,
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총 금액', style: MTextStyles.regular14Grey06),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${Util.getMoneyformat(totalAmt)}',
                        style: MTextStyles.bold14Grey06,
                      ),
                      TextSpan(
                        text: ' 원',
                        style: MTextStyles.regular14Grey06,
                      )
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 24),
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed('PaymentListPage');
                  // return;

                  if (isCheckedList.length == 0) {
                    Util.showCenterFlash(
                        context: context,
                        position: FlashPosition.bottom,
                        style: FlashStyle.floating,
                        text: '신청할 모임을 선택해주세요!');
                    return;
                  }
                  Navigator.of(context)
                      .pushNamed('OrderPage', arguments: isCheckedList);
                },
                child: Ink(
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: MColors.tomato),
                    child: Center(
                      child: Text(
                        '선택한 모임 신청하기',
                        style: MTextStyles.bold16White,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _classNoDataWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height - 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 65),
            Image.asset('assets/mypage/basket.png'),
            const SizedBox(height: 15),
            // Icon(Icons.backspace_outlined),
            Text('앗! 찜한 모임이 없어요\n마음에 드는 모임을 찾으러 가볼까요?',
                textAlign: TextAlign.center,
                style: MTextStyles.medium16WarmGrey),
            const SizedBox(height: 25),
            FlatButton(
              padding: EdgeInsets.zero,
              child: Container(
                height: 43,
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
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios,
                        size: 17, color: MColors.white),
                  ],
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 65),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxList(list) {
    allCheckedList.clear();
    return ListView.builder(
        itemCount: list.length, // < 5 ? list.length : 5, //+1 for progressbar
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          OrderBasketData item = list[index]; // list[index];
          allCheckedList.add(item);

          return labeledCheckbox(
            item: item,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            value: isCheckedList.contains(item),
            onChanged: (bool value) {
              print('3333 $value');
              if (value) {
                setState(() {
                  totalAmt = totalAmt + (item.price ?? 0);
                  isCheckedList.add(item);
                });
              } else {
                setState(() {
                  isCheckedList.remove(item);
                  totalAmt = totalAmt - (item.price ?? 0);
                });
              }
            },
          );
        });
  }

  Widget labeledCheckbox({OrderBasketData item, padding, value, onChanged}) {
    double sizeWidth360 = MediaQuery.of(context).size.width / 360;
    //  print('item : ${item.basketId} , value : $value');

    return InkWell(
      onTap: () {
        if (item.classType == 'SOCIALING') {
          SocialingData socialingData = SocialingData();
          socialingData.id = item.classId;
          Navigator.of(context)
              .pushNamed('SocialingDetailPage', arguments: socialingData);
        } else {
          Navigator.of(context).pushNamed('MeetingDetailPage',
              arguments: [item.classId, item.name, false]);
        }
      },
      child: Container(
        padding: padding,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 13,
                  child: Checkbox(
                    value: value,
                    onChanged: (bool newValue) {
                      print('Checkbox : $newValue');
                      onChanged(newValue);
                    },
                  ),
                ),
                Expanded(
                  flex: 87,
                  child: Stack(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 118 * sizeWidth360,
                                  height: 64 * sizeWidth360 + 4,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: CachedNetworkImage(
                                      imageUrl: item.cover ?? '',
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              decoration: new BoxDecoration(
                                                  // color: Colors.white,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey[300]),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: SvgPicture.asset(
                                                'assets/mypage/no_img.svg',
                                                width: 24,
                                                height: 24,
                                                fit: BoxFit.scaleDown,
                                              )),
                                      width: double.infinity,
                                      height: 83 * sizeWidth360,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${item.classType == 'ITEM' ? '정기모임' : '소셜링'}',
                                          style: MTextStyles.regular12Grey06),
                                      Text('${item.name}',
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: MTextStyles.bold16Black2),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      // Text('${item.location}  ・  12.31(토) 오후 8시', style: MTextStyles.regular12Grey06),
                                      Text(
                                          '${item.location == 'HAPJEONG' ? '합정' : item.location} ・ ${Util.getFormattedday1(item.startDate)}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: MTextStyles.medium12BrownGrey),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            InkWell(
                              onTap: () {
                                //  isCheckedList
                                List<OrderBasketData> aa = [];
                                aa.add(item);
                                Navigator.of(context)
                                    .pushNamed('OrderPage', arguments: aa);
                              },
                              child: Ink(
                                height: 43,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(27)),
                                    border: Border.all(
                                        color: MColors.white_three, width: 1),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      new Text("모임 바로 신청",
                                          style: MTextStyles.regular14Grey06),
                                      Container(
                                          width: 16,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          )),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text("금액",
                                            style: MTextStyles
                                                .medium12BrownishGrey),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  '${Util.getMoneyformat(item.price ?? 0)}',
                                              style: MTextStyles.bold16Grey06,
                                            ),
                                            TextSpan(
                                              text: '원',
                                              style:
                                                  MTextStyles.regular14Grey06,
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                            onPressed: () {
                              _showDeleteDialog2(context, item.basketId);
                            },
                            icon: Icon(Icons.close_outlined, size: 18)),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Divider(height: 1)
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "찜리스트",
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
    );
  }

  // 삭제 시
  Future<Widget> _showDeleteDialog(context) async {
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
                        '선택하신 ${isCheckedList.length}개의 모임을 장바구니에서\n삭제하실껀가요?',
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
                              child: Text('취소'),
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
                                deleteData();
                              },
                              child: Text(
                                '삭제',
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

  // 삭제 시
  Future<Widget> _showDeleteDialog2(context, basketid) async {
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
                        '해당 모임을 장바구니에서\n삭제하실껀가요?',
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
                              child: Text('취소'),
                            ),
                          ),
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: SizedBox.expand(
                            child: FlatButton(
                              onPressed: () async {
                                //  Navigator.of(context, rootNavigator: false).pop();

                                deleteOneData(basketid.toString());

                                Navigator.pop(context);
                              },
                              child: Text(
                                '삭제',
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

  Future<Widget> _showResultDialog(context, text) async {
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
                        text,
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
                    height: 55,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('확인'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
