import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingPurposeInputField extends StatelessWidget {
  const MeetingPurposeInputField({
    Key key,
    @required TextEditingController meetingPurposeController,
    @required List<Asset> selectedImageList,
    @required this.getFileListFunc,
    @required this.loadAssetFunc,
    this.selectPhotoInListViewFunc,
  })  : _meetingPurposeController = meetingPurposeController,
        _selectedImageList = selectedImageList,
        super(key: key);

  final TextEditingController _meetingPurposeController;
  final List<Asset> _selectedImageList;
  final Function getFileListFunc;
  final Function loadAssetFunc;
  final Function selectPhotoInListViewFunc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('어떤 모임인가요?', style: MTextStyles.bold16Black),
        SizedBox(height: 16),
        Container(
          height: 230,
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          child: TextField(
            controller: _meetingPurposeController,
            maxLines: 20,
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
        SizedBox(height: 16),
        Container(
          height: 94,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          //width: SizeConfig.screenWidth - 40,
          child: Row(
            children: [
              SizedBox(width: 16),
              InkWell(
                onTap: () async {
                  await loadAssetFunc();
                  getFileListFunc();
                },
                child: Container(
                  height: 44,
                  width: 120,
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
                          Text('사진 추가',
                              style: MTextStyles.medium12BrownishGrey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              //사진 추가 listview

              Expanded(
                child: ListView.builder(
                  itemCount: _selectedImageList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return RawMaterialButton(
                      onPressed: () {
                        // 클릭했을때 list 에 추가하고, 순서하고
                        selectPhotoInListViewFunc(index);
                        getFileListFunc();
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
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
}
