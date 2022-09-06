
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/view/style/textstyles.dart';

class TextOverflowDemo extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<TextOverflowDemo> {
  var controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        mytext = controller.text;
      });
    });
    controller.text = "This is a long overflowing text!!!";
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String mytext = "";

  @override
  Widget build(BuildContext context) {
    mytext =
            '''
            잎새에 이는 바람에도
            나는 괴로와했다.
            별을 노래하는 마음으로
            모든 죽어가는 것을 사랑해야지
            그리고 나에게 주어진 길을
            걸어가야겠다.
            ''';
    // mytext = controller.text;

    int maxLines = 5;
    double fontSize = 12.0;

    return Scaffold(
      appBar: AppBar(title: Text('text overflow demo'),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, size) {
              // Build the textspan
              var span = TextSpan(
                text: mytext,
                style: TextStyle(fontSize: fontSize),
              );

              // Use a textpainter to determine if it will exceed max lines
              var tp = TextPainter(
                maxLines: maxLines,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                text: span,
              );

              // trigger it to layout
              tp.layout(maxWidth: size.maxWidth);

              // whether the text overflowed or not
              var exceeded = tp.didExceedMaxLines;

              // return RichText(
              //     maxLines: 5,
              //     overflow: TextOverflow.ellipsis,
              //     text: TextSpan(children: [
              //       TextSpan(
              //         style: MTextStyles.cjkRegular14Grey06,
              //         text: mytext,
              //       ),
              //       TextSpan(style: MTextStyles.cjkRegular14WarmGrey, text: "더 보기")
              //     ]));

              return Column(children: <Widget>[
                Text.rich(
                  span,

                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                ),

                Text(exceeded ? "더 보기" : "")
              ]);
            }),
            TextField(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}