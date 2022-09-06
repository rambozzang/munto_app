import 'package:flutter/material.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingScheduleDialog {
  static void showCancelDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            height: 140,
            width: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '잠시만요',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontFamily: "AppleSDGothicNeo",
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0),
                ),
                SizedBox(height: 2),
                Text(
                  '임시등록 하지 않은 내용은 사라지게 됩니다.\n 소셜링 열기를 취소 하시겠습니까?',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKkr",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
                SizedBox(height: 20),
                Divider(height: 0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('다시입력'),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            '열기취소',
                            style: MTextStyles.bold16Tomato,
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
      },
    );
  }
}
