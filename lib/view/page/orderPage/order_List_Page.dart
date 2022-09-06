import 'package:flutter/material.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class OrderListpage extends StatefulWidget {
  @override
  _OrderListpageState createState() => _OrderListpageState();
}

class _OrderListpageState extends State<OrderListpage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _buildbody(),
    );
  }

  Widget _buildbody() {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: [
          const SizedBox(
            height: 16,
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
        ]));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "결제 내역",
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
          onPressed: () {}),
      actions: [],
    );
  }
}
