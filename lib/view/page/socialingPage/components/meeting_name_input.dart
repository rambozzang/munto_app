import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingNameInput extends StatelessWidget {
  const MeetingNameInput({
    Key key,
    @required TextEditingController meetingNameController,
  })  : _meetingNameController = meetingNameController,
        super(key: key);

  final TextEditingController _meetingNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 54,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.pinkish_grey, width: 1)),
          child: TextFormField(
            controller: _meetingNameController,
            // onChanged: (value){
            //   if(value.length >15)
            //     _meetingNameController.text = value.substring(0,value.length);
            // },
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              hintText: "모임명을 입력해주세요..",
              hintStyle: MTextStyles.medium16WhiteThree,
              labelStyle: TextStyle(color: Colors.transparent),
              counterText: '',
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
