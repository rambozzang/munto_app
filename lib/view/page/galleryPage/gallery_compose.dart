import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munto_app/model/board_data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class GalleryCompose extends StatefulWidget {
  GalleryCompose();

  @override
  _GalleryComposeState createState() => _GalleryComposeState();
}

class _GalleryComposeState extends State<GalleryCompose> {
  File _file;

  final _textController = TextEditingController();
  FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final time = DateTime(2020, 7, 21);
    getImage();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            _file != null
                ? Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image.file(
                      _file,
                      fit: BoxFit.cover,
                    ))
                : SizedBox.shrink(),
            _devider(),
            GestureDetector(
              onTap: () {
                print('let\'s focus');
                FocusScope.of(context).requestFocus(_textFocusNode);
              },
              child: Container(
                height: 150,
                color: MColors.whiteColor,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    focusNode: _textFocusNode,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '내용을 입력해주세요',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(200, 200, 200, 1.0),
                        fontSize: 14,
                      ),
                    ),
                    controller: _textController,
                    style: MTextStyles.regular14Grey05,
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 18, left: 23.0, right: 25, bottom: 40),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                      border: Border.all(color: MColors.tomato, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.white),
                  child: MaterialButton(
                    child: Text(
                      '작성 완료',
                    ),
                    onPressed: () {
                      final boardItem = BoardItem(
                          '',
                          _textController.text,
                          DateTime.now(),
                          [],
                          [],
                          Applicant.name(UserInfo.myProfile.name),
                          '',
                          '',
                          _file);
                      // galleryItemList.insert(0, boardItem);
                      Navigator.of(context).pop();
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _devider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Color.fromRGBO(209, 209, 209, 1.0),
      ),
    );
  }

  void getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null)
      setState(() {
        _file = File(pickedFile.path);
      });
    else
      Navigator.of(context).pop();
  }
}
