import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/reserver_money_provider.dart';
import 'package:munto_app/model/user_reserve_money_data.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:rxdart/rxdart.dart';

import 'package:munto_app/view/widget/error_page.dart';

import '../../../util.dart';

class ReserveMoneyPage extends StatefulWidget {
  @override
  _ReserveMoneyPageState createState() => _ReserveMoneyPageState();
}

class _ReserveMoneyPageState extends State<ReserveMoneyPage> {
  ReserveMoneyProvider provider = ReserveMoneyProvider();


  StreamController<double> _fabHeightCtrl = StreamController<double>.broadcast();
  StreamController<Response<List<UserReserveMoneyData>>> _moneyDataListCtrl = StreamController<Response<List<UserReserveMoneyData>>>.broadcast();
  List<UserReserveMoneyData> userReserveMoneyDataList;

  @override
  void dispose() {
    super.dispose();
    _moneyDataListCtrl.close();
    _fabHeightCtrl.close();
  }

  @override
  void initState() {
    super.initState();

    _getMoneyList();
  }

  _getMoneyList() async {
    try {
      _moneyDataListCtrl.sink.add(Response.loading());

      userReserveMoneyDataList = await provider.getUserReserveMoneyList();
        _moneyDataListCtrl.sink.add(Response.completed(userReserveMoneyDataList));
    } catch (e) {
      _moneyDataListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              _fundBox(),
              const SizedBox(
                height: 16,
              ),
              DividerGrey12(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TitleBold16BlackView("적립 내역", ""),
              ),
              const SizedBox(
                height: 20,
              ),
              _getStreamBuild(),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "적립금",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
    );
  }

  Widget _fundBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 156,
            height: 74,
            color: MColors.white_two,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '사용 가능한 적립금',
                    style: MTextStyles.medium12BrownishGrey,
                  ),
                  StreamBuilder<Response<List<UserReserveMoneyData>>>(
                      stream: _moneyDataListCtrl.stream,
                      builder: (BuildContext context, AsyncSnapshot<Response<List<UserReserveMoneyData>>> snapshot) {
                        print('asdfasdfasd :  ${snapshot.hasData}');


                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Center(
                                  child: Container(
                                      height: 24,
                                      width: 24,
                                      padding: EdgeInsets.all(4),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      )));
                              break;
                            case Status.COMPLETED:
                              final totalPrice = snapshot.data;

                              return _buildTotalPrice(snapshot.data.data);
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
                            child: Container(
                                height: 24,
                                width: 24,
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                )));
                      })
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            width: 156,
            height: 74,
            color: MColors.white_two,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '15일내 소멸 예정 적립금',
                    style: MTextStyles.medium12BrownishGrey,
                  ),
                  StreamBuilder<Response<List<UserReserveMoneyData>>>(
                      stream: _moneyDataListCtrl.stream,
                      // initialData: [],
                      builder: (BuildContext context, AsyncSnapshot<Response<List<UserReserveMoneyData>>> snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return Center(
                                  child: Container(
                                      height: 24,
                                      width: 24,
                                      padding: EdgeInsets.all(4),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                      )));
                              break;
                            case Status.COMPLETED:
                              return _buildDisappearPrice(snapshot.data.data);
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
                            child: Container(
                                height: 24,
                                width: 24,
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                )));
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getStreamBuild() {
    return StreamBuilder<Response<List<UserReserveMoneyData>>>(
        stream: _moneyDataListCtrl.stream,
        builder: (BuildContext context, AsyncSnapshot<Response<List<UserReserveMoneyData>>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
              child: Padding(
                padding: const EdgeInsets.only(top : 58.0),
                child: CircularProgressIndicator(
                
                ),
              ));
                break;
              case Status.COMPLETED:
                return snapshot.data.data.length > 0
                    ? _fundList(snapshot.data.data)
                    : _classNoDataWidget();
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
                padding: const EdgeInsets.only(top : 58.0),
                child: CircularProgressIndicator(
                
                ),
              ));
        });
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //NodataImage(wid: 80.0, hei: 80.0),
            Text('적립금 내역이 없습니다.', style: MTextStyles.medium16WarmGrey),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _fundList(List<UserReserveMoneyData> list) {
    if(list.length> 0){
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final item = list[index];
          String startDateTime = '';
          String disappearDateTime = '';

          try{
            startDateTime = Util.getDateYmd(item.createdAt);
            disappearDateTime = Util.getDateYmd(item.disappearDate);
          } catch (e){
            startDateTime = '';
            disappearDateTime = '';
          }

          return InkWell(
            onTap: null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(list[index].reason ?? '', style: MTextStyles.regular14Grey06),
                      const SizedBox(
                        width: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: '${list[index].money}', style: MTextStyles.bold16Black),
                            TextSpan(text: '원', style: MTextStyles.bold16Black),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${startDateTime}', style: MTextStyles.regular12WarmGrey),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('소멸 예정일 : $disappearDateTime', style: MTextStyles.regular12WarmGrey),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Container();
  }

  Widget _buildTotalPrice(List<UserReserveMoneyData> list) {

    if(list.length> 0 ){
      final totalPrice = list.map((e)=> e.money).reduce((a, b) => a+b);
      return Text(
        '${totalPrice > 0 ? totalPrice : 0}원',
        style: MTextStyles.bold16Tomato,
      );
    }
    return Text(
      '0 원',
      style: MTextStyles.bold16PinkishGrey,
    );
  }


  Widget _buildDisappearPrice(List<UserReserveMoneyData> list) {
    try {
      if(list.length > 0){
        return Text(
          '${list.map((e) {
            if(DateTime.parse(e.disappearDate).difference(DateTime.now()).inDays < 15)
              return e.money;
            else
              return 0;
          }).reduce((a, b) => a + b)}원',
          style: MTextStyles.bold16Tomato,
        );
      }

    } catch (e){}
    return Text(
      '0 원',
      style: MTextStyles.bold16PinkishGrey,
    );
  }
}
