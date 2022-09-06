import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:munto_app/model/provider/socialing_create_provider.dart';
import 'package:munto_app/model/provider/socialing_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/util.dart';

import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/munto_text_field.dart';

import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../app_state.dart';
import 'components/cancel_Dialog.dart';
import 'components/meeting_name_input.dart';
import 'components/meeting_type_input_field.dart';
import 'components/schedule_Dialog.dart';
import 'components/schedule_Dialog2.dart';
import 'components/subject_input_field.dart';
import 'components/meeting_purpose_input_field.dart';

const freeClassType = '  무료  ';
const nonFreeClassType = '  유료  ';

class OpenSocialingPage extends StatefulWidget {
  @override
  _OpenSocialingPageState createState() => _OpenSocialingPageState();
}

class _OpenSocialingPageState extends State<OpenSocialingPage> {
  TextEditingController _meetingNameController = new TextEditingController();
  TextEditingController _subject1Controller = new TextEditingController();
  TextEditingController _subject2Controller = new TextEditingController();
  TextEditingController _subject3Controller = new TextEditingController();
  TextEditingController _meetingPurposeController = new TextEditingController();
  TextEditingController _preparationsController = new TextEditingController();
  TextEditingController _joinPersonCountController1 =
      new TextEditingController();
  TextEditingController _joinPersonCountController2 =
      new TextEditingController();
  TextEditingController _locationFieldController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  // File _file;

  List<String> _files = new List<String>(); // mulit image picker 용
  String _coverFile;

  List<String> _typeOfMeetingList = [freeClassType, nonFreeClassType];
  String _selectedTypeOfMeeting = freeClassType;
  List<Asset> _selectedImageList;
  List<Asset> _coverImageList;

  // 일단 저장한다음 열기 할때 class
  String _meetingStartTime;
  // String _meetingEndTime;
  String _meetingTime;

  DateTime get startDate{
    try{

    } catch (e){}
    return null;
  }

  String _location;

  @override
  void initState() {
    _selectedImageList = new List<Asset>();
    _coverImageList = new List<Asset>();
    super.initState();
  }

  @override
  void dispose() {
    _meetingNameController.dispose();
    _subject1Controller.dispose();
    _subject2Controller.dispose();
    _subject3Controller.dispose();
    _meetingPurposeController.dispose();
    _preparationsController.dispose();
    _joinPersonCountController1.dispose();
    _joinPersonCountController2.dispose();
    _locationFieldController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  bool showPriceInfo = false;
  bool firstNonfreeSelected = true;
  int a = 0;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialingCreateProvider>(context);

    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(provider),
      body: Stack(children:[
        _body(),
        // showPriceInfo ?
        //     Positioned(
        //       left: 20, top:20, right:20, bottom: 20,
        //       child: GestureDetector(
        //         onTap: (){
        //           setState(() {
        //             showPriceInfo = false;
        //           });
        //         },
        //         child: Container(
        //           color: Colors.yellow,
        //         ),
        //       ),
        //     )
        //     : SizedBox.shrink()
      ] ),
    );
  }

  AppBar _appBar(provider) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor ,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              // 취소하면 어디로 가야되지?  navigator 가 갈곳이 없다...
              // onPressed: () => showCancelDialog(context),
              onPressed: () async {
                // result : false = 다시작성, true = 닫기
                CancelDialog.showCancelDialog(context).then((value) {
                  setState(() {
                    if (value == true) Navigator.pop(context);
                  });
                });
                //
              },
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
          Center(
            child: Text(
              '소셜링 열기',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            onPressed: () async {

              // if(!kReleaseMode){
              //   Util.showNegativeDialog4(context, '🥳소셜링 열기 완료', '특별한 일상을 준비하셨군요. 내가 만든 소셜링 확인해 보시겠어요?',
              //       '라운지로 이동', '소셜링 확인', (){
              //         Navigator.pop(context, true);
              //       },() {
              //         Navigator.pop(context, true);
              //         Navigator.of(context).pushNamed('SocialingDetailPage',
              //             arguments: null);
              //       });
              //   return;
              // }
              if(_meetingNameController.text == null || _meetingNameController.text == ''){
                print('_meetingPurposeController.text = ${_meetingPurposeController.text}');
                Util.showOneButtonDialog(context, '모든 정보를 입력해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              // if(_meetingStartTime == null || _meetingEndTime == null){
              //   Util.showOneButtonDialog(context, '모든 정보를 입력해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
              //   return;
              // }
              if(_subject1Controller.text == '' && _subject2Controller.text == '' && _subject3Controller.text == '' ){
                Util.showOneButtonDialog(context, '모든 정보를 입력해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              if(_meetingPurposeController.text == null || _meetingPurposeController.text == ''){
                Util.showOneButtonDialog(context, '모든 정보를 입력해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }

              if(_files == null || _files.length == 0){
                Util.showOneButtonDialog(context, '사진 정보를 입력해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              if(_joinPersonCountController1.text == '' || _joinPersonCountController2.text == ''){
                Util.showOneButtonDialog(context, '정확한 참여인원을 설정해 주세요', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              if(!isNumeric(_joinPersonCountController1.text) || !isNumeric(_joinPersonCountController2.text)){
                Util.showOneButtonDialog(context, '정확한 참여인원을 설정해 주세요', '참여인원은 숫자만 입력해 주세요!', '확인', () { });
                return;
              }
              if(int.parse(_joinPersonCountController1.text) == 0){
                Util.showOneButtonDialog(context, '정확한 참여인원을 설정해 주세요', '최소1명 이상의 인원을 모집해 주세요', '확인', () { });
                return;
              }
              if(int.parse(_joinPersonCountController1.text) > int.parse(_joinPersonCountController2.text)){
                Util.showOneButtonDialog(context, '정확한 참여인원을 설정해 주세요', '최대인원은 최소인원보다 많아야 합니다.', '확인', () { });
                return;
              }
              if(_coverFile == null){
                Util.showOneButtonDialog(context, '커버 사진을 선택해주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              if(_meetingStartTime == null || _meetingStartTime.isEmpty){
                Util.showOneButtonDialog(context, '날짜를 설정해 주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }
              if(_location == null || _location.isEmpty){
                Util.showOneButtonDialog(context, '장소를 설정해 주세요!', '즐겁고 원활한 소셜링이 될 수 있도록\n빠짐없이 작성해 주세요!', '확인', () { });
                return;
              }






              int _price = 0;
              // if(_selectedTypeOfMeeting == nonFreeClassType){
              //   if(_priceController.text == '')
              //     _price = 0;
              //   else if(!isNumeric(_priceController.text)){
              //     Util.showOneButtonDialog(context, '잘못된 가격', '정확한 가격을 입력해 주세요!', '확인', () { });
              //     return;
              //   }
              //   _price = _priceController.text == null || _priceController.text.isEmpty ? 0 : int.parse(_priceController.text);
              // }

              print('_price = $_price');
              await createSocialingFunc('RECRUITING', _price);


            },
            child: Container(
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: MColors.tomato, width: 1),
                  color: MColors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  '열기',
                  style: MTextStyles.bold14Tomato,
                ),
              ),
            ),
            // onPressed: () {},
          ),
        ],
      ),
    );
  }

  Future createSocialingFunc(String status,int price) async {

    AppStateLog(context, UPLOAD_FEED);

    SocialingCreateData socialingCreateData = new SocialingCreateData(
      name: _meetingNameController.text,
      type: _selectedTypeOfMeeting == "온라인"
          ? 'ONLINE'
          : "OFFLINE", //  ONLINE, OFFLINE, NONE
      startDate: _meetingStartTime.substring(0, 19),
      finishDate: _meetingStartTime.substring(0, 19),
      location: _location,
      subject1: _subject1Controller.text,
      subject2: _subject2Controller.text,
      subject3: _subject3Controller.text,
      introduce: _meetingPurposeController.text,
      preparation: _preparationsController.text,
      minimumPerson: _joinPersonCountController1.text,
      maximumPerson: _joinPersonCountController2.text,
      status:
          status, //PLANNING, STOPPING_RECRUITMENT, RECRUITING, PLAYING, CLOSE
      photo1: _files.length > 0 ? _files[0] : '',
      photo2: _files.length > 1 ? _files[1] : '',
      cover: _coverFile != null || _coverFile != '' ? _coverFile : '',
      price: price
    );

    SocialingCreateProvider provider = new SocialingCreateProvider();

    await provider.createSocialing(socialingCreateData).then((data) {
      if (data != null) {
        print('create success!');
        SocialingProvider _socialingProvider =
            Provider.of<SocialingProvider>(context, listen: false);

        _socialingProvider.fetch(0, 30);
        Util.showNegativeDialog4(context, '🥳소셜링 열기 완료', '특별한 일상을 준비하셨군요. 내가 만든 소셜링 확인해 보시겠어요?',
            '라운지로 이동', '소셜링 확인', (){
              Navigator.pop(context, true);
            },() {
              Navigator.pop(context, true);
              Navigator.of(context).pushNamed('SocialingDetailPage',
                  arguments: data);
            });
      } else {
        print('create fail!');
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('소셜링 생성에 실패하였습니다.')),
        );
      }
    });
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: new ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 27),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:9.0),
                  child: Text('모임명', style: MTextStyles.bold16Black),
                ),
                // Padding(
                //     padding: EdgeInsets.only(right: 0),
                //     child: Tooltip(
                //       message: '임시등록 소셜링은 마이 메뉴에서 확인할 수 있어요.',
                //       textStyle: MTextStyles.bold14Grey06,
                //       // height: 54,
                //       decoration: BoxDecoration(
                //           color: MColors.white,
                //           // border:
                //           //     Border.all(color: MColors.pinkish_grey, width: 1),
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       showDuration: Duration(seconds: 2),
                //       child: RawMaterialButton(
                //         onPressed: () {
                //           createSocialingFunc('PLANNING');
                //         },
                //         child: Text('임시등록',
                //             style: MTextStyles.regular16Pinkish_grey),
                //       ),
                //     )),
              ],
            ),
            MeetingNameInput(meetingNameController: _meetingNameController),
            SizedBox(height: 40),
            // PriceSection(),
            // SizedBox(height: 16),
            // MeetingTypeField(
            //     selectedValue: _selectedTypeOfMeeting,
            //     typeOfMeetingList: _typeOfMeetingList,
            //     selectDropDownValueFunc: selectDropDownValue),
            // SizedBox(height: 46),

            Row(
              children: [
                Text('모임 일정&장소', style: MTextStyles.bold16Black),
                InkWell(
                  onTap: () {
                    // 설정 창 띄우기
                    showScheduleInputDialog(context);
                    // _locationFieldController.clear();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border:
                              Border.all(color: MColors.warm_grey, width: 1),
                          color: MColors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Center(
                          child:
                              Text('설정', style: MTextStyles.regular12WarmGrey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset('assets/icons/calendar.svg'),
                SizedBox(
                  width: 8,
                ),
                Text(
                  setMeetingTime(),
                  style: MTextStyles.regular16Pinkish_grey,
                ),
              ],
            ),
            SizedBox(height: 16),
            // 구분줄
            Container(
              height: 1,
              width: SizeConfig.screenWidth - 40,
              decoration: BoxDecoration(
                  border: Border.all(
                color: MColors.white_three,
              )),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                SvgPicture.asset('assets/icons/location_24_px.svg'),
                SizedBox(width: 8),
                Text(
                  _location ?? '장소',
                  style: MTextStyles.regular16Pinkish_grey,
                ),
              ],
            ),
            SizedBox(height: 16),
            // 구분줄
            Container(
              height: 1,
              width: SizeConfig.screenWidth - 40,
              decoration: BoxDecoration(
                  border: Border.all(
                color: MColors.white_three,
              )),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "모임 주제 ",
                        style: MTextStyles.bold16Black,
                      ),
                      TextSpan(
                        text: "최대 3개 지정",
                        style: MTextStyles.regular12PinkishGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // 모임 주제 page
            SubjectInputField(
                subject1Controller: _subject1Controller,
                subject2Controller: _subject2Controller,
                subject3Controller: _subject3Controller),
            SizedBox(height: 40),

            // 어떤 모임인가요 page
            MeetingPurposeInputField(
              meetingPurposeController: _meetingPurposeController,
              selectedImageList: _selectedImageList,
              getFileListFunc: getFileList,
              loadAssetFunc: loadAssets,
              selectPhotoInListViewFunc: _selectPhotoInListView,
            ),
            SizedBox(height: 40),

            Text('준비사항', style: MTextStyles.bold16Black),
            SizedBox(height: 16),
            Container(
              height: 54,
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: MColors.pinkish_grey, width: 1)),
              child: TextField(
                controller: _preparationsController,
                decoration: InputDecoration(
                  hintText: "내용을 입력해 주세요.",
                  hintStyle: MTextStyles.medium16WhiteThree,
                  labelStyle: TextStyle(color: Colors.transparent),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text('참여인원', style: MTextStyles.bold16Black),
            SizedBox(height: 16),
            Row(
              children: [
                Text('최소', style: MTextStyles.regular14Grey06),
                SizedBox(width: 8),
                Container(
                  height: 44,
                  width: 62,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: MColors.pinkish_grey, width: 1)),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _joinPersonCountController1,
                    decoration: InputDecoration(
                      hintText: "명",
                      hintStyle: MTextStyles.medium16WhiteThree,
                      labelStyle: TextStyle(color: Colors.transparent),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Text('최대', style: MTextStyles.regular14Grey06),
                SizedBox(width: 8),
                Container(
                  height: 44,
                  width: 62,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: MColors.pinkish_grey, width: 1)),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _joinPersonCountController2,
                    decoration: InputDecoration(
                      hintText: "명",
                      hintStyle: MTextStyles.medium16WhiteThree,
                      labelStyle: TextStyle(color: Colors.transparent),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('커버사진', style: MTextStyles.bold16Black),
            SizedBox(height: 16),
            Container(
              height: 180,
              width: SizeConfig.screenWidth - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: MColors.pinkish_grey, width: 1)),
              //width: SizeConfig.screenWidth - 40,
              child: Center(
                child: InkWell(
                  onTap: () async {
                    await getImage();
                  },
                  child: getCoverPictureContainer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectDropDownValue(String value) {
    setState(() {
      _selectedTypeOfMeeting = value;
    });
  }

  Future<void> getImage() async {
    String error = 'No Error Dectected';
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: _coverImageList,
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
          selectionLimitReachedText: "사진은 2장 까지만 선택가능 합니다.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    _coverImageList = resultList;
    for (Asset asset in _coverImageList) {
      _coverFile = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);

    }
    final cropFile = await _cropImageFile(File(_coverFile), isCover: true);

    setState(() {
      _coverFile = cropFile.path;
    });
  }

  Future<File> _cropImageFile(File image, {bool isCover = false}) async {
    double ratioX = 1.0;
    double ratioY = 1.0;
    if(isCover){
      ratioX = 1.0;
      ratioY = 1.0 / 2.5899280576;
    }
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],

        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '커버 이미지 자르기',
            toolbarColor: MColors.tomato,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '커버 이미지 자르기',
        ));

    if(croppedFile != null){
      var decodedImage = await decodeImageFromList(croppedFile.readAsBytesSync());
      print('cropped Size ${decodedImage.width} / ${decodedImage.height}');
      if(decodedImage.width > 250 && decodedImage.height > 250){
        final int shorterSide = decodedImage.width < decodedImage.height ? decodedImage.width : decodedImage.height;
        final int resizePercent = (250.0 / shorterSide.toDouble() * 100).toInt();

        File compressedFile = await FlutterNativeImage.compressImage(croppedFile.path,
            quality: 85, percentage: resizePercent);


        decodedImage = await decodeImageFromList(compressedFile.readAsBytesSync());
        print('resize Percent = $resizePercent');
        print('compressed size = ${decodedImage.width} / ${decodedImage.height}');

        return compressedFile;
      }

      return null;
    }
  }


  Future<void> loadAssets() async {
    String error = 'No Error Dectected';
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
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
          selectionLimitReachedText: "사진은 2장 까지만 선택가능 합니다.",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    _selectedImageList = resultList;
    setState(() {});
  }

  void getFileList() async {
    _files.clear();
    for (Asset asset in _selectedImageList) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      _files.add(filePath);
    }
  }

  void _selectPhotoInListView(int index) {
    setState(() {
      _selectedImageList.remove(_selectedImageList[index]);
    });
  }

  Widget getCoverPictureContainer() {
    Widget contentsWidget;
    if (_coverFile == null) {
      contentsWidget = Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            border: Border.all(color: MColors.white_three, width: 1),
            color: MColors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/camera_g.svg'),
                SizedBox(
                  width: 6,
                ),
                Text('사진 첨부하기', style: MTextStyles.medium12BrownishGrey),
              ],
            ),
          ),
        ),
      );
    } else {
      contentsWidget = RawMaterialButton(
        onPressed: () {
          setState(() {
            _coverFile = null;
            _coverImageList= [];
          });
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(_coverFile),
                fit: BoxFit.cover,
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
    return contentsWidget;
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

  void showScheduleInputDialog(BuildContext context) async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScheduleDialog2(
          locationFieldController: _locationFieldController,
          function: returnDialogDateFunction,
          snackBarFunc: showAndHideSnackBar,
        );
      },
    );
  }

  void returnDialogDateFunction(
      String startDate,  String location) {
    setState(() {
      _meetingStartTime = startDate;
      _location = location;
    });
  }

  void showAndHideSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(content)),
    );
    Future.delayed(Duration(seconds: 1), () {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    });
  }

  String setMeetingTime() {
    if (_meetingStartTime == null ) {
      _meetingTime = '00월 00일 오후 00:00';
    } else {
      DateTime startDt = DateTime.parse(_meetingStartTime);
      // DateTime endDt = DateTime.parse(_meetingEndTime);

      int startHour;
      String startType;

      if (startDt.hour > 12) {
        startHour = startDt.hour - 12;
        startType = '오후';
      } else {
        startHour = startDt.hour;
        startType = '오전';
      }

      // if (endDt.hour > 12) {
      //   endHour = endDt.hour - 12;
      //   endType = '오후';
      // } else {
      //   endHour = endDt.hour;
      //   endType = '오전';
      // }

      _meetingTime = startDt.year.toString() +
          '년 ' +
          startDt.month.toString().padLeft(2, '0') +
          '월 ' +
          startDt.day.toString().padLeft(2, '0') +
          '일 ' +
          startType.toString() +
          ' ' +
          startHour.toString().padLeft(2, '0') +
          ':' +
          startDt.minute.toString().padLeft(2, '0');
          // +
          // ' ~ ' +
          // endType.toString() +
          // ' ' +
          // endHour.toString().padLeft(2, '0') +
          // ':' +
          // endDt.minute.toString().padLeft(2, '0');
    }
    return _meetingTime;
  }

  Widget PriceSection() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
                child: Text('모임 구분', style: MTextStyles.bold16Black)),
            Text('가격', style: MTextStyles.bold16Black),
            Padding(
              padding: const EdgeInsets.only(top:2.0, left: 2.0),
              child: GestureDetector(
                child: SvgPicture.asset('assets/icons/info_24_px.svg', color: MColors.brown_grey, width: 22.0, height: 22.0,),
                onTap: () => setState(()=> showPriceInfo = true),
              ),
            ),
          ],
        ),
        SizedBox(height:16.0),
        SizedBox(height: 78, child:
        showPriceInfo ?
        Positioned.fill(child:
        GestureDetector(
          onTap: ()=> setState(()=> showPriceInfo = false),
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
              child: Center(
                child: Text('금액은 PG사 이용 수수료 3.4%만 공제 후 지급해 드립니다.정산 내역은 [모임 관리 > 모임 정보 관리]에서 확인하실 수 있습니다.', style: MTextStyles.medium14Grey06_60,),
              ),
            ),
          ),
        ))  : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100, height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: MColors.pinkish_grey, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTypeOfMeeting,
                    items: _typeOfMeetingList.map((value) {

                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeOfMeeting = value ;
                        if(_selectedTypeOfMeeting == freeClassType){
                          _priceController.clear();
                        } else {
                          if(firstNonfreeSelected){
                            firstNonfreeSelected = false;
                            showPriceInfo = true;
                          }
                        }
                      });



                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 40.0,),
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffd1d1d1), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: MColors.white_two,
                    ),
                    child: MTextField(
                      enabled: _selectedTypeOfMeeting == nonFreeClassType,
                      controller: _priceController,
                      validator: (String arg) {
                        return null;
                      },
                      onChanged: (txt) {
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                      },
                      style: MTextStyles.regular14BlackColor,
                      maxLength: 8,
                      // focusNode: _txtPassword2Focus,
                      hintText: '',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:10.0, top: 4.0),
                    child: Text('원', style: MTextStyles.regular14WarmGrey,),
                  ),
                ],
              ),
            )
          ],)
          ,)
      ],
    );
  }
}
