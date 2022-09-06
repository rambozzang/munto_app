import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:munto_app/model/enum/viewstate.dart';
import 'package:munto_app/model/eventbus/feed_upload_finished.dart';

import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/feed_write_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/etcPage/write_tag_page.dart';
import 'package:munto_app/view/style/colors.dart';

import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../../main.dart';
import '../../style/textstyles.dart';

class FeedWritePage extends StatefulWidget {
  final List<String> tags;
  FeedWritePage({this.tags});
  @override
  _FeedWritePageState createState() => _FeedWritePageState();
}

class _FeedWritePageState extends State<FeedWritePage> {
  FocusNode _textFocusNode = FocusNode();
  final _feedTextController = TextEditingController();

  List<Asset> _selectedImageList = new List<Asset>();
  List<String> _prevFiles = new List<String>();
  List<String> _files = new List<String>();

  List<String> _selectedTagList = new List<String>();
  FeedData feedEditData;
  bool isBinding = false;

  // 전체인경우 '' 아니면 
  String _socialingId = '';
  String _itemId = '';
  String _classTitle;

  @override
  void initState() {
    super.initState();
    _textFocusNode.requestFocus();
    _selectedTagList = widget.tags == null ? [] : widget.tags;
    AppStateLog(context, CLICK_WRITE_BUTTON);
  }

  @override
  void dispose() {
    _feedTextController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final map = ModalRoute.of(context).settings.arguments as Map;

    if (map != null && map['feedData'] != null && !isBinding) {
      isBinding = true;
      feedEditData = map['feedData'];

      print(map.toString());
      _feedTextController.text = feedEditData.content;
      _prevFiles = feedEditData.photos;
      _selectedTagList = feedEditData.tags.map((e) => e.name).toList();
      _classTitle = map['title'];
      _socialingId =  map['socialingId'];
      _itemId =  map['itemId'];
    } else if (map != null && (map['socialingId'] != null || map['itemId'] != null) && !isBinding){
      isBinding = true;
      _classTitle = map['title'];
      _socialingId =  map['socialingId'];
      _itemId =  map['itemId'];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build id = $_socialingId, $_itemId');
    final feedWriteProvider = Provider.of<FeedWriteProvider>(context);
    SizeConfig().init(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: _appBar1(context),
          body: _body(context),
        ),
        if (feedWriteProvider.state == ViewState.Busy)
          Container(
            color: Color.fromRGBO(100, 100, 100, 0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  //일부기기에서 앱바가 안보이는 현상때문에 수정 10.03 경준
  AppBar _appBar1(context) {
    return new AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
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
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
        ),
        child: SizedBox(
          child: FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
        ),
      ),
      title: Text(
        '피드 쓰기',
        style: MTextStyles.bold16Black2,
      ),
      actions: [
        FlatButton(
          child: Text(
            '올리기',
            style: MTextStyles.bold14WarmGrey,
          ),
          onPressed: () async {

            if (_feedTextController.text.length > 0 || _files.length > 0) {
              final feedWriteProvider = Provider.of<FeedWriteProvider>(context, listen: false);
              bool result = false;

              //수정모드
              if (feedEditData != null) {
                var map = {
                  "feedId": feedEditData.id,
                  "content": _feedTextController.text,
                  "tags": _selectedTagList,
                  "prevPhotos": _prevFiles,
                  "socialingId": _socialingId ?? '',
                  "itemId": _itemId ?? '',
                };
                await feedWriteProvider.updateFeed(map, _files).then((value) {
                  print('update success!');
                  result = true;
                });
              } else {
                FeedWriteData feedWriteData = new FeedWriteData(
                    photos: _files,
                    content: _feedTextController.text,
                    tags: _selectedTagList,
                    itemId: _itemId ?? '',
                    socialingId: _socialingId ?? '',
                    );

                await feedWriteProvider.createFeed(feedWriteData).then((value) {
                  if (value == true) {
                    print('create success!');
                    result = true;
                  } else {
                    print('create fail!');
                  }
                });
              }
              eventBus.fire(FeedUploadFinished());
              Navigator.pop(context, result);
            }
          },
        )
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // 1. user info
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 16.0, right: 20.0),
            child: Row(
              children: <Widget>[
                InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        UserInfo.myProfile.image,
                      ),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {},
                            child: Text(
                              UserInfo.myProfile.name,
                              style: MTextStyles.bold14BlackColor,
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: 6),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: SvgPicture.asset('assets/icons/earth.svg'),
                            ),
                            Text(
                              _classTitle ?? '전체',
                              style: MTextStyles.cjkMedium12PinkishGrey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 2, right: 20),
            child: Container(
              height: SizeConfig.screenHeight * 0.2,
              child: TextField(
                maxLines: 5,
                focusNode: _textFocusNode,
                onChanged: (value) {},
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '멤버님의 이야기를 들려주세요...',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 1.0),
                    fontSize: 14,
                  ),
                ),
                controller: _feedTextController,
                style: MTextStyles.regular14Grey05,
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          // 3. image 추가부분
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              height: 94,
              width: double.infinity,
              child: Row(
                children: [
                  getAddPhotoBtn(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _prevFiles.length + _selectedImageList.length,
                          itemBuilder: (context, index) {
                            if (index < _prevFiles.length)
                              return getPrevImages(index);
                            else
                              return getImages(index - _prevFiles.length);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
          ),

          InkWell(
            onTap: () {
              _navigateAndDisplayTag(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _selectedTagList.length > 0
                      ? Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children: _selectedTagList.asMap().entries.map((entry) {
                            int index = entry.key;
                            return buildChip(index);
                          }).toList(),
                        )
                      : Container(
                          height: 48,
                          alignment: Alignment.centerLeft,
                          child: Text('태그를 추가해 주세요.', style: MTextStyles.regular14WarmGrey),
                        )),
            ),
          ),

          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget buildChip(int index) {
    return Chip(
      label: Text(
        '#${_selectedTagList[index]}',
        style: MTextStyles.regular12Tomato,
      ),
      // deleteIcon: Icon(
      //   Icons.close,
      //   color: MColors.tomato,
      // ),
      // onDeleted: () {
      //   setState(() {
      //     _selectedTagList.removeAt(index);
      //   });
      // },
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: MColors.tomato, width: 1)),
    );
  }

  Widget getPrevImages(index) {
    return RawMaterialButton(
      onPressed: () {
        // 클릭했을때 list 에 추가하고, 순서하고
        setState(() {
          _prevFiles.removeAt(index);
          getFileList();
        });
      },
      child: Stack(
        children: [
          Container(
            height: 70,
            width: 70,
            child: Image.network(
              _prevFiles[index],
              height: 70,
              width: 70,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: _getSelectedPhotoEraseCircle(),
          )
        ],
      ),
    );
  }

  Widget getImages(index) {
    return RawMaterialButton(
      onPressed: () {
        // 클릭했을때 list 에 추가하고, 순서하고
        setState(() {
          _selectedImageList.removeAt(index);
          getFileList();
        });
      },
      child: Stack(
        children: [
          Container(
            height: 70,
            width: 70,
            child: AssetThumb(
              asset: _selectedImageList[index],
              height: 70,
              width: 70,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: _getSelectedPhotoEraseCircle(),
          )
        ],
      ),
    );
  }

  Widget _getSelectedPhotoEraseCircle() {
    return Container(
      height: 24,
      width: 24,
      child: CircleAvatar(
        child: Icon(
          Icons.close,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
    );
  }

  Widget getAddPhotoBtn() {
    return InkWell(
      onTap: () async {
        await loadAssets();
        getFileList();
        setState(() {
          _textFocusNode.nextFocus();
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Stack(children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Color.fromRGBO(200, 200, 200, 1.0), width: 1),
                color: Colors.white),
          ),
          Positioned(
            left: 11,
            child: SvgPicture.asset('assets/icons/add_image.svg'),
          ),
          Positioned(
            top: 48,
            child: Container(
              width: 70,
              alignment: Alignment.center,
              child: Text(
                _selectedImageList.length.toString() + '/' + '10',
                style: MTextStyles.medium10PinkishGrey,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _navigateAndDisplayTag(BuildContext context) async {
    print('_selectedTagList.length = ${_selectedTagList?.length ?? 0}');

    final result = await Navigator.of(context).push(CupertinoPageRoute(builder: (_) => WriteTagPage(_selectedTagList)))
        as List<String>;
    if (result != null && result.length > 0) {
      setState(() {
        _selectedTagList = result;
      });
    }
  }

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _selectedImageList,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#e73331",
          selectionTextColor: "#ffffff",
        ),
        // andorid 용 UI 변경해야함
        materialOptions: MaterialOptions(
          actionBarTitle: "사진 선택",
          allViewTitle: "전체 사진",
          actionBarColor: "#e73331",
          actionBarTitleColor: "#ffffff",
          lightStatusBar: true,
          statusBarColor: '#e73331',
          startInAllView: false,
          selectCircleStrokeColor: "#ffffff",
          selectionLimitReachedText: "사진은 10장 까지만 선택가능 합니다.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    if(resultList != null && resultList.length > 0)
      _selectedImageList = resultList;
    // _error = error;
    return;
  }

  void getFileList() async {
    _files.clear();
    for (Asset asset in _selectedImageList) {
      var filePath = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      print('original size = ${asset.originalWidth} / ${asset.originalHeight}');

      if(asset.originalWidth > 1080 && asset.originalHeight > 1080){
        final int shorterSide = asset.originalWidth < asset.originalHeight ? asset.originalWidth : asset.originalHeight;
        final int resizePercent = (1080.0 / shorterSide * 100).toInt();

        File compressedFile = await FlutterNativeImage.compressImage(filePath,
            quality: 85, percentage: resizePercent);


        print('resize Percent = $resizePercent');
        print('compressed File = ${compressedFile.toString()}');

        filePath = compressedFile.path;
      }
      try {
        if (filePath.toLowerCase().endsWith(".heic") || filePath.toLowerCase().endsWith(".heif")) {
          String jpgPath = await HeicToJpg.convert(filePath);
          _files.add(jpgPath);
        } else {
          _files.add(filePath);
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    }
  }
}
