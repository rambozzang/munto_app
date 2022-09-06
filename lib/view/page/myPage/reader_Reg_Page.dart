import 'package:flutter/material.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ReaderRegPage extends StatefulWidget {
  @override
  _ReaderRegPageState createState() => _ReaderRegPageState();
}

class _ReaderRegPageState extends State<ReaderRegPage> {
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

              //  _cardListBox(),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "리더/파트너 신청",
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
}
