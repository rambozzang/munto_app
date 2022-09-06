import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';

import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

class CouponItem {
  String couponDisplayTitle;
  String couponTitle;
  String couponDesc;
  String couponExpire;
  CouponItem(
    this.couponDisplayTitle,
    this.couponTitle,
    this.couponDesc,
    this.couponExpire,
  );
}

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  List<CouponItem> listitem = [
    CouponItem('MPASS', '맴버십 20,000원 할인', '쿠폰 주의사항에 대해서 안내할 사항 들', '2020년 18월 17일 23:59까지'),
    CouponItem('20,000원 할인', '맴버십 20,000원 할인', '쿠폰 주의사항에 대해서 안내할 사항 들', '2020년 8월 7일 23:59까지'),
    CouponItem('50,000원 할인', '맴버십 50,000원 할인', '쿠폰 주의사항에 대해서 안내할 사항 들', '2020년 12월 7일 23:59까지'),
    CouponItem('200,000원 할인', '맴버십 200,000원 할인', '쿠폰 주의사항에 대해서 안내할 사항 들', '2020년 11월 7일 23:59까지'),
    CouponItem('2,000원 할인', '맴버십 2,000원 할인', '쿠폰 주의사항에 대해서 안내할 사항 들', '2020년 9월 7일 23:59까지'),
  ];

  List<CouponItem> _couponDataList = []; // 시작전 모임

  ClassProvider classService = ClassProvider();

  final StreamController<Response<List<CouponItem>>> _couponDataListCtrl = StreamController();
  
  @override
  void initState() {
    super.initState();
    _getData();

    
  }

  _getData(){
    _couponDataListCtrl.sink.add(Response.loading());

    try {
      Future.delayed(const Duration(milliseconds: 2500), () {
        // _couponDataList = classService
         _couponDataListCtrl.sink.add(Response.completed(listitem));
     });
    } catch(e){
         _couponDataListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _couponDataListCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              _couponReg(),
              const SizedBox(
                height: 24,
              ),
              DividerGrey12(),
              const SizedBox(
                height: 24,
              ),
            
              _getStreamBuild(),

              //  _cardListBox(),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "쿠폰",
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

  Widget _couponReg() {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Text(
            '쿠폰등록',
            style: MTextStyles.medium13Black_three,
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            //  autofocus: true,
            //  controller: _destNameController,
            validator: (String arg) {
              if (arg.length <= 1) {
                // alert("받는분 이름을 정확히 입력하세요!");
                return '받는분 이름을 정확히 입력하세요!';
              } else {
                return null;
              }
            },
            onChanged: (txt) {
              print(txt.length);
              if (txt.length > 1) {
                return null;
              }
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              // fieldFocusChange(context, _destNameFocus, _destTelFocus);
            },
            style: TextStyle(fontSize: 19),
            maxLength: 50,
            //  focusNode: _destNameFocus,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: new EdgeInsets.all(
                7.0,
              ),
              hintText: '쿠폰 번호를 입력해주세요',
              hintStyle: MTextStyles.medium16WhiteThree,
              counterText: "",
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: MColors.greyish,
                ),
              ),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ButtonTheme(
          minWidth: MediaQuery.of(context).size.width - 40,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 42,
          child: OutlineButton(
              child: new Text("등록 하기", style: MTextStyles.regular14Tomato),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23.0),
              ),
              borderSide: BorderSide(
                color: MColors.tomato,
              ),
              onPressed: () {}),
        )
      ],
    );
  }


  Widget _getStreamBuild(){
    return StreamBuilder<Response<List<CouponItem>>>(
          stream: _couponDataListCtrl.stream,
          builder: (BuildContext context, AsyncSnapshot<Response<List<CouponItem>>> snapshot) {
            if (snapshot.hasData) {
                switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Center(child: Padding(
                        padding: const EdgeInsets.all(68.0),
                        child: CircularProgressIndicator(),
                      ));
                      break;
                    case Status.COMPLETED:
                      List<CouponItem> list = snapshot.data.data;
                      return list.length > 0 ? _couponGridView(list) : _classNoDataWidget();
                      break;
                    case Status.ERROR:
                      return Error(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () => null,
                      );
                      break;
                  }
              }
              return Center(child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ));
            });
  }
  


  Widget _couponGridView(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 20.0),
      child:   Column(
        children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TitleBold16BlackView("보유한 쿠폰", "${data.length}장"),
              ),
              const SizedBox(
                height: 10,
              ),
          GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 167 / 199,
                crossAxisCount: 2,
                children: List.generate(data.length, (index) {
                  return couponGridBox(data[index]);
                }),
              ),
        ],
      )
      
    );
  }

  Widget couponGridBox(CouponItem item) {
    return InkWell(
      onTap: () {
        print('click');
      },
      child: new Container(
        width: 160,
        height: 188,
        decoration: new BoxDecoration(
            //color: Colors.white,
            border: Border.all(width: 1, color: MColors.white_two),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                // width: 140,
                height: 80,
                //   padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: MColors.tomato_10,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                    child: Text(item.couponDisplayTitle,
                        overflow: TextOverflow.ellipsis, style: MTextStyles.bold16Tomato)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.couponTitle, overflow: TextOverflow.ellipsis, style: MTextStyles.bold12Black),
                  Text(item.couponDesc, style: MTextStyles.regular12Grey06),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(item.couponExpire, style: MTextStyles.regular12Grey06),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 45.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_bill_60_px.svg',),
            Text('사용 가능한 쿠폰이 없습니다.', style: MTextStyles.medium16WarmGrey),
            const SizedBox(height: 15),
            // FlatButton(
            //   padding: EdgeInsets.zero,
            //   child: Container(
            //     height: 43,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(28)),
            //       border: Border.all(color: MColors.tomato, width: 1),
            //       color: MColors.tomato,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("모임보기", style: MTextStyles.medium14White),
            //         Icon(Icons.check, size: 20, color: MColors.white),
            //       ],
            //     ),
            //   ),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }

}
