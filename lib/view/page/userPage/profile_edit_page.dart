import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:munto_app/model/const_data.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/model/provider/user_profile_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

import '../../../app_state.dart';
import '../../../util.dart';

class ProfileEditPage extends StatefulWidget {
  bool isFirstEdit;
  ProfileEditPage({this.isFirstEdit = false});
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController introduceController = TextEditingController();
  TextEditingController instaController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  // int shoClassIndex = 0;
  String coverPath;
  String imagePath;
  int currentLength = 0;

  List<String>  selectedAllList = [];


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async {
      final provider = Provider.of<UserProfileProvider>(context, listen:false);
      await provider.fetchProfile();
      final profileData = provider.userProfileData;
      setState(() {
        // shoClassIndex = profileData.showClass ? 0 : 1;
        introduceController.text = profileData.introduce;
        if(profileData.introduce != null)
          currentLength = profileData.introduce.length;

        instaController.text = profileData.instagramId;
        facebookController.text = profileData.facebookId;
        urlController.text = profileData.snsId;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);
    final userProfileData = provider.userProfileData;
    selectedAllList = userProfileData?.interestList ?? [];
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: MColors.barBackgroundColor ,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(barBorderWidth),
            child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left:20.0),
            child: SizedBox(
              width: 100,
              child: FlatButton(
                padding: EdgeInsets.zero,
                  onPressed: () {
                    if(widget.isFirstEdit){
                      Navigator.of(context).pop();
                      Provider.of<LoginProvider>(context, listen: false).logout();
                      Provider.of<BottomNavigationProvider>(context, listen: false).clearIndex();
                      return;
                    }
                    Navigator.pop(context);
                  },
                  child: Text('취소', style: MTextStyles.medium14WarmGrey,)
              ),
            ),
          ),
        actions: [
          FlatButton(
            child: Text('저장', style: MTextStyles.bold14WarmGrey,),
            onPressed: () async {
              if(introduceController.text.isEmpty){
                Util.showSimpleDialog(context, '취향이 통하는 사람들과 더 쉽게 연결될 수 있도록 자기소개 작성을 완료해 주세요 :)',  '확인', () { });
                return;
              }
              if(userProfileData.image == null || userProfileData.image.isEmpty)
                if(imagePath == null || imagePath.isEmpty){
                  Util.showSimpleDialog(context, '취향이 통하는 사람들과 더 쉽게 연결될 수 있도록 프로필 이미지 설정을 완료해 주세요 :)',  '확인', () { });
                  return;
                }

              if(userProfileData.cover == null || userProfileData.cover.isEmpty)
                if(coverPath == null || coverPath.isEmpty){
                  Util.showSimpleDialog(context, '취향이 통하는 사람들과 더 쉽게 연결될 수 있도록 배경 이미지 설정을 완료해 주세요 :)',  '확인', () { });
                  return;
                }

              if(selectedAllList == null || selectedAllList.length == 0){
                Util.showSimpleDialog(context, '취향이 통하는 사람들과 더 쉽게 연결될 수 있도록 관심사 설정을 완료해 주세요 :)',  '확인', () { });
                return;
              }


              AppStateLog(context, EDIT_PROFILE);

              final provider = Provider.of<UserProfileProvider>(context, listen:false);
              final profileData = provider.userProfileData;

              profileData.cover = coverPath;
              profileData.image = imagePath;

              if(introduceController.text.length > 0)
                profileData.introduce = introduceController.text;

              profileData.instagramId = instaController.text;
              profileData.facebookId = facebookController.text;
              profileData.snsId = urlController.text;

              // profileData.career = selectedCareerList;
              // profileData.cultureArt = selectedCultureArtList;
              // profileData.write = selectedWriteList;
              // profileData.lifeStyle1 = selectedLifeStyle1List;
              // profileData.food = selectedFoodList;
              // profileData.lifeStyle2 = selectedLifeStyle2List;
              // profileData.beautyHealth = selectedBeautyHealthList;
              // profileData.artCraft = selectedArtCraftList;


              final result = await provider.updateProfile(profileData);
              if(result)
                Navigator.of(context).pop();


            },
          )
        ],
          title: Text('프로필 수정', style: MTextStyles.bold16Black2,),
          centerTitle: true,
        ),

      body: userProfileData == null ? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(height: 139.0,width: double.infinity, color: MColors.white_three,
            child: Stack(children: [
              if (coverPath != null)
                Positioned.fill(
                    child: Image.file(File(coverPath), fit: BoxFit.cover,)
                )
              else if (userProfileData?.cover != null)
                Positioned.fill(
                child: CachedNetworkImage(imageUrl: userProfileData.cover, fit: BoxFit.cover,)
                ),
              Positioned(
                left: 20, bottom: 16,
                child: Container(width: 78, height: 22,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: MColors.white, width: 1),
                      color: const Color(0x66ffffff)
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                        SvgPicture.asset('assets/icons/profile_background_camera.svg',
                          width: 12, height: 12, color: MColors.white,),
                        Padding(padding: EdgeInsets.only(right: 4),),
                        Text("배경 설정", style: MTextStyles.regular12White),

                      ],),
                      Transform.translate(
                          offset: Offset(5, -5),
                          child: Badge(padding: EdgeInsets.all(2.0),)
                      )
                    ],
                  ),
                ),
              ),
              Positioned.fill(child: InkWell(
                  onTap: () async{
                    if(!kReleaseMode){
                      if(userProfileData.cover != null){
                        setState(() {
                          userProfileData.cover = null;
                        });
                        return;
                      }
                      if(coverPath != null){
                        setState(() {
                          coverPath = null;
                        });
                        return;
                      }
                    }
                    final path = await _loadAssetPath(compress:  true);
                    File cropImageFile = await _cropImageFile(File(path), isCover: true);
                    if(cropImageFile != null)
                      setState(() {
                        coverPath = cropImageFile.path;

                      });

                  }
              )),
            ],) ,
          ),
          Transform.translate(
            offset: Offset(0,-40),
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  if(!kReleaseMode){
                    if(userProfileData.image != null){
                      setState(() {
                        userProfileData.image = null;
                      });
                      return;
                    }

                    if(imagePath != null){
                      setState(() {
                        imagePath = null;
                      });
                      return;
                    }
                  }
                  final path = await _loadAssetPath();
                  if(path != null){
                    File cropImageFile = await _cropImageFile(File(path));

                    if (cropImageFile != null) {
                      setState(() {
                        imagePath = cropImageFile.path;
                      });
                    }
                  }
                },
                child: SizedBox(width: 80, height: 80,
                    child: Stack(alignment: Alignment.bottomRight,children: [
                      CircleAvatar(backgroundImage:
                        imagePath != null ? FileImage(File(imagePath)) :
                        userProfileData?.image != null ? NetworkImage(userProfileData.image) : NetworkImage(''),
                      radius: 40,
                      ),
                      SvgPicture.asset('assets/icons/profile_image_camera.svg',
                        width: 30, height: 30, ),
                      Positioned(
                          bottom: 30, right: 0,
                          child: Badge(padding: EdgeInsets.all(2.0),)
                      )
                    ],),),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: [
              // 자기소개
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:5.0),
                    child: Text("좋아하는 것으로 나를 소개해주세요.\n(최대 2줄)", style: MTextStyles.bold16Black2),
                  ),
                  Positioned(
                    top: 0, right: 0,
                      child: Badge(padding: EdgeInsets.all(2.0),)
                  )

                ],
              ),
              Expanded(child:Text('')),
              //
              RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(style: MTextStyles.regular14Grey06, text: "$currentLength/"),
                        TextSpan(style: MTextStyles.regular14PinkishGrey, text: "50")
                      ]
                  )
              )
            ],),
          ),
          // form
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Container(
                height: 162,
                padding: EdgeInsets.only( left: 16, right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(8)
                    ),
                    border: Border.all(
                        color: MColors.white_three,
                        width: 1
                    )
                ),
              child: TextField(
                maxLines: 2,
                controller: introduceController,
                keyboardType: TextInputType.multiline,
                onChanged: (value){
                  if(value.length > 180){
                    introduceController.text = introduceController.text.substring(0, 180);
                  }
                  setState(() {
                    currentLength = value.length;
                  });
                },
                decoration: InputDecoration(
                  hintText: "자신을 소개하는 내용을 입력해주세요.",
                  hintStyle: MTextStyles.regular14Warmgrey,
                  //                    labelText: "Email",
                  labelStyle: TextStyle(color: Colors.transparent),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          //   child: Row(children: [
          //     Expanded(child: Text("모임 활동 공개", style: MTextStyles.bold16Black2)),
          //     Radio(value: shoClassIndex == 0, onChanged: (bool value) {
          //       setState(() => shoClassIndex = 0);
          //
          //     }, groupValue: true,),
          //     // 공개
          //     Text("공개", style: MTextStyles.regular12Black),
          //     Radio(value: shoClassIndex == 1, onChanged: (bool value) {
          //       setState(() => shoClassIndex = 1);
          //
          //     }, groupValue: true,),
          //     Text("공개하지 않음", style: MTextStyles.regular12Black),
          //
          //   ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("SNS", style: MTextStyles.bold16Black2)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Row(children: [
              SvgPicture.asset('assets/icons/insta.svg',
                width: 30, height: 30,),
              Padding(padding: EdgeInsets.only(right: 16.0),),
              Expanded(
                child: Container(
                  height: 46, padding: EdgeInsets.only(left: 14.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: MColors.white_three, width: 1)
                  ),
                  child: TextField(
                    maxLines: 1,
                    controller: instaController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "인스타그램 아이디",
                      hintStyle: MTextStyles.regular14Warmgrey,
                      //                    labelText: "Email",
                      labelStyle: TextStyle(color: Colors.transparent),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            ],),

          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Row(children: [
              SvgPicture.asset('assets/icons/facebook.svg',
                width: 30, height: 30,),
              Padding(padding: EdgeInsets.only(right: 16.0),),
              Expanded(
                child: Container(
                  height: 46, padding: EdgeInsets.only(left: 14.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: MColors.white_three, width: 1)
                  ),
                  child: TextField(
                    maxLines: 1,
                    controller: facebookController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "페이스북 아이디",
                      hintStyle: MTextStyles.regular14Warmgrey,
                      //                    labelText: "Email",
                      labelStyle: TextStyle(color: Colors.transparent),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            ],),

          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Row(children: [
              SvgPicture.asset('assets/icons/url.svg',
                width: 30, height: 30,),
              Padding(padding: EdgeInsets.only(right: 16.0),),
              Expanded(
                child: Container(
                  height: 46, padding: EdgeInsets.only(left: 14.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: MColors.white_three, width: 1)
                  ),
                  child: TextField(
                    maxLines: 1,
                    controller: urlController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "브런치, 블로그, 개인사이트 등",
                      hintStyle: MTextStyles.regular14Warmgrey,
                      //                    labelText: "Email",
                      labelStyle: TextStyle(color: Colors.transparent),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            ],),
          ),



          Padding(
            padding: const EdgeInsets.only(left: 20, top: 40),
            child:
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:5.0),
                  child: Text("관심사 설정 (최대 5개 선택 가능)", style: MTextStyles.bold16Black2),
                ),
                Positioned(
                    top: 0, right: 0,
                    child: Badge(padding: EdgeInsets.all(2.0),)
                )

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("커리어", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.carrierNames, userProfileData.career), runSpacing: 10.0,
              alignment: WrapAlignment.start,),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("문화예술", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.cultureNames, userProfileData.cultureArt), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("글쓰기", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.writingNames, userProfileData.write), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("라이프스타일", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.lifestyle1Names, userProfileData.lifeStyle1), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("푸드&드링크", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.foodNames, userProfileData.food), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("아웃도어", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.lifeStyle2Names, userProfileData.lifeStyle2), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("뷰티&헬스", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.beautyNames, userProfileData.beautyHealth), runSpacing: 10.0,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("미술&공예", style: MTextStyles.regular14Grey06)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
            child: Wrap(children: buildRoundedItem(Interest.artCraftNames, userProfileData.artCraft), runSpacing: 10.0,
            ),
          ),
        ],),
      ),
    );
  }

  List<Widget> buildRoundedItem(List<String> nameList, List<String> selectedList){
    return List.generate(nameList.length, (index) {
      final name = nameList[index];
      final value = Interest.getValueByName(name);
      if(name == '마케팅'){

        print('marketing value = $value');
      }
      final isSelected = selectedList.contains(value);
      return     Padding(
        padding: const EdgeInsets.only(right:10.0),
        child: InkWell(
          onTap: (){
            setState(() {
              if(isSelected)
                selectedList.remove(value);
              else if(selectedAllList.length < 5)
                selectedList.add(value);

            });
          },
          child: Container(
            height: 34,width: getItemWidth(name.length),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(17)),
                border: Border.all(color: MColors.tomato, width: 0.5
                ),
                color: isSelected ? MColors.tomato : MColors.white
            ),
            child: // 행아웃
            Center(
              child: Text(nameList[index],
                style: isSelected ? MTextStyles.regular14White : MTextStyles.regular14Tomato,),
            ),
          ),
        ),
      );
    });
  }

  double getItemWidth (int length){
    switch(length){
      case 1:
        return 50.0;
      case 2:
        return 60.0;
      case 3:
        return 80.0;
      case 4:
        return 90.0;
      case 5:
        return 110.0;
    }
    return 150.0;
  }

  Future<String> _loadAssetPath({bool compress = false}) async {
    
    List<Asset> _tempList = List<Asset>();
    try {
      _tempList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: [],
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: "#e73331",
          selectionTextColor: "#ffffff",
        ),
        materialOptions: MaterialOptions(
          actionBarTitle: "사진 선택",
          allViewTitle: "전체 사진",
          actionBarColor: "#e73331",
          actionBarTitleColor: "#ffffff",
          lightStatusBar: true,
          statusBarColor: '#e73331',
          startInAllView: false,
          selectCircleStrokeColor: "#ffffff",
          selectionLimitReachedText: "사진은 1장 까지만 선택가능 합니다.",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }


    if (!mounted) return null;
    if(_tempList.length > 0){
      final asset =  _tempList[0];
      String filePath = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);


      print('original size = ${asset.originalWidth} / ${asset.originalHeight}');
      if(asset.originalWidth > 1080 ){
        final int resizePercent = (1080.0 / asset.originalWidth * 100).toInt();

        File compressedFile = await FlutterNativeImage.compressImage(filePath,
            quality: 85, percentage: resizePercent);

        filePath = compressedFile.path;
        print('resize Percent = $resizePercent');
      }

      if (filePath.toLowerCase().endsWith(".heic") ||
          filePath.toLowerCase().endsWith(".heif")) {
        filePath = await HeicToJpg.convert(filePath);
      }
      return filePath;
    }
    
    return null;
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
            toolbarTitle: '프로필 이미지 자르기',
            toolbarColor: MColors.tomato,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '프로필 이미지 자르기',
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



}
