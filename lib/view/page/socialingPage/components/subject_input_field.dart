import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class SubjectInputField extends StatelessWidget {
  const SubjectInputField({
    Key key,
    @required TextEditingController subject1Controller,
    @required TextEditingController subject2Controller,
    @required TextEditingController subject3Controller,
  })  : _subject1Controller = subject1Controller,
        _subject2Controller = subject2Controller,
        _subject3Controller = subject3Controller,
        super(key: key);

  final TextEditingController _subject1Controller;
  final TextEditingController _subject2Controller;
  final TextEditingController _subject3Controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 82,
          padding: EdgeInsets.only(
            left: 16,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          child: TextField(
            controller: _subject1Controller,
            decoration: InputDecoration(
              hintText: "주제1",
              hintStyle: MTextStyles.medium16WhiteThree,
              labelStyle: TextStyle(color: Colors.transparent),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 12,
          ),
          child: Container(
            height: 44,
            width: 82,
            padding: EdgeInsets.only(
              left: 16,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: MColors.pinkish_grey, width: 1)),
            child: TextField(
              controller: _subject2Controller,
              decoration: InputDecoration(
                hintText: "주제2",
                hintStyle: MTextStyles.medium16WhiteThree,
                labelStyle: TextStyle(color: Colors.transparent),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(
        //     left: 12,
        //   ),
        //   child: Container(
        //     height: 44,
        //     width: 82,
        //     padding: EdgeInsets.only(
        //       left: 16,
        //     ),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(8)),
        //         border: Border.all(color: MColors.pinkish_grey, width: 1)),
        //     child: TextField(
        //       controller: _subject3Controller,
        //       decoration: InputDecoration(
        //         hintText: "주제3",
        //         hintStyle: MTextStyles.medium16WhiteThree,
        //         labelStyle: TextStyle(color: Colors.transparent),
        //         border: UnderlineInputBorder(
        //           borderSide: BorderSide.none,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
