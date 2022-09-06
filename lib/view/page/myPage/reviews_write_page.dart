import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/review_Data.dart';
import 'package:munto_app/model/urls.dart';
import 'package:munto_app/model/writableReviews_Data.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ReviewsWritePage extends StatefulWidget {
  final ReviewData reviewData;
  final WritableReviewsData writableReviewsData;
  final bool isEdit;
  @override
  _ReviewsWritePageState createState() => _ReviewsWritePageState();

  const ReviewsWritePage({
    Key key,
    this.writableReviewsData,
    this.reviewData,
    this.isEdit,
  }) : super(key: key);

}

class _ReviewsWritePageState extends State<ReviewsWritePage> {

  File _postImageFile;
  String contents;

  ClassProvider classService = ClassProvider();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final StreamController<bool> _processing = StreamController();

  TextEditingController writingTextController = TextEditingController();
  FocusNode writingTextFocus = FocusNode();

  bool _autoValidate = false;


  @override
  void initState() { 
    super.initState();
     writingTextController.text =  this.widget?.reviewData?.content != null ? this.widget.reviewData.content : '';
    
  }

  Future<void> _getImageAndCrop() async {
    PickedFile imageFileFromGallery = await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFileFromGallery != null) {
      File cropImageFile =
          await _cropImageFile(File(imageFileFromGallery.path)); //await cropImageFile(imageFileFromGallery);
      if (cropImageFile != null) {
        setState(() {
          _postImageFile = cropImageFile;
        });
      }
    }
  }

  Future<File> _cropImageFile(File image) async {
    return await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Munto - 이미지 자르기',
            toolbarColor: Colors.blue[800],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Munto - 이미지 자르기',
        ));
  }

  saveReview(context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool isEdit = widget.isEdit != null && widget.isEdit;

      //  _postImageFile
      Map<String, dynamic> _map = new Map();
      _map['orderId'] = widget.writableReviewsData.orderId;
      _map['classType'] = widget.writableReviewsData.classType;
      _map['content'] = writingTextController.text;
      if(isEdit)
        _map['reviewId'] = writingTextController.text;
      _processing.sink.add(true);

      if(_postImageFile != null) {
        await _saveMultipart(_map, _postImageFile, isEdit).then((result) {
          print('mmmmmm >>>>>  $result');
          _processing.sink.add(false);
          if (result) {
            _showResultDialog(context, '후기가 작성되었습니다!');
            Navigator.of(context).pop();
          } else {
            _showResultDialog(context, '후기 작성 실패!');
          }
        });
      } else {

        await classService.saveReview(_map,  isEdit).then((result) {
          print('mmmmmm >>>>>  $result');
          _processing.sink.add(false);
          if (result) {
            _showResultDialog(context, '후기가 작성되었습니다!');
            Navigator.of(context).pop();
          } else {
            _showResultDialog(context, '후기 작성 실패!');
          }
        });
      }

    } else {
      setState(() => _autoValidate = true);
    }
  }

  Future<bool> _saveMultipart(Map<String, dynamic> _map, File imageFile, bool isEdit) async {
    Dio dio = new Dio();
    final token = await Util.getSharedString(KEY_TOKEN);
    print(token);

    try {
      final formData = FormData.fromMap(_map);

      String fileName = imageFile?.path?.split('/')?.last ?? '';
      formData.files.add(MapEntry(
        'photo',
        await MultipartFile.fromFile(imageFile.path, filename: fileName),
      ));
      dio.options.headers["Authorization"] = "Bearer $token";
      Response response =
            isEdit
          ? await dio.put('$hostUrl/api/class/review', data: formData)
          : await dio.post('$hostUrl/api/class/review', data: formData);

      print(response.data.toString());
      return response?.data['result'] ?? false;
    } catch (e) {
      print(e.toString());

      Exception(e);
      return false;
    } finally {
      dio.close();
    }
  }

  modifyData() {}

  closePage() => Navigator.of(context).pop();

  @override
  void dispose() {
    _processing.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sizeWidth = size.width * 0.9;
    double sizeHeight = 191;

    print('widget.writableReviewsData : ${widget.writableReviewsData.toString()}');


    return Scaffold(
        appBar: _appBar(),
        body: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: StreamBuilder<Object>(
              stream: _processing.stream,
              initialData: false,
              builder: (context, snapshot) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          _meetingBox(),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TitleBold16BlackView('어떤 모임이 되셨나요?', ''),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.all(new Radius.circular(10.0))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: _postImageFile != null
                                        ? Stack(
                                            children: [
                                              Positioned(
                                                child: Container(
                                                    width: sizeWidth,
                                                    height: sizeHeight,
                                                    child: Image.file(
                                                      _postImageFile,
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                              Positioned(
                                                  top: -3,
                                                  right: -20,
                                                  child: FlatButton(
                                                      padding: EdgeInsets.zero,
                                                      child: SvgPicture.asset(
                                                        'assets/mypage/rectangle.svg',
                                                        width: 30,
                                                        height: 30,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _postImageFile = null;
                                                        });
                                                      }))
                                            ],
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                  TextFormField(
                                    focusNode: writingTextFocus,
                                    controller: writingTextController,
                                    keyboardType: TextInputType.multiline,
                                    minLines:
                                        _postImageFile == null ? 15 : null, //Normal textInputField will be displayed
                                    maxLines: null, // when user presses enter it will adapt to it
                                    decoration: InputDecoration(
                                      hintText: "멤버님의 이야기를 남겨주세요..",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "이야기 내용을 입력해주세요!";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              // child:
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                                width: 160,
                                height: 40,
                                child: ButtonTheme(
                                  minWidth: 120,
                                  height: 42,
                                  child: OutlineButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(width: 30, child: Icon(Icons.photo_camera)),
                                        new Text("사진 첨부하기", style: MTextStyles.regular14Grey06),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => _getImageAndCrop(), //_loadAssets(),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    snapshot.data
                        ? Container(
                            color: Color.fromRGBO(100, 100, 100, 0.5),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        // ? Positioned.fill(
                        //     child: IgnorePointer(
                        //         child: Container(
                        //             width: MediaQuery.of(context).size.width, // double.infinity ,
                        //             height: MediaQuery.of(context).size.height,
                        //             child: Center(
                        //                 child: SizedBox(width: 33, height: 33, child: CircularProgressIndicator())))))
                        : SizedBox.shrink()
                  ],
                );
              }),
        ));
  }

  Widget _appBar() {
    return new AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () => _showCancelDialog(context), // Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
          Center(
            child: Text(
              '후기 작성',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            child: Text(
              '완료',
              style: MTextStyles.bold14Tomato,
            ),
            onPressed: () => saveReview(context),
          ),
        ],
      ),
    );
  }

  Widget _meetingBox() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
         // ClassMiddleBox(meetingGroupAll[3]),
        ],
      ),
    );
  }

  // 취소시
  Future<Widget> _showCancelDialog(context) async {
    // 키보드 다운처리
    FocusScope.of(context).requestFocus(new FocusNode());

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
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
                        '작성중인 내용이 사라지게 됩니다.\n정말 취소하시겠습니까?',
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
                                closePage();
                              },
                              child: Text(
                                '확인',
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
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
