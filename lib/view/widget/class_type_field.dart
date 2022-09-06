import 'package:flutter/material.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassTypeField extends StatelessWidget {
  const ClassTypeField({
    Key key,
    @required String selectedValue,
    @required List<String> typeOfMeetingList,
    this.selectDropDownValueFunc,
  })  : _selectedValue = selectedValue,
        _typeOfMeetingList = typeOfMeetingList,
        super(key: key);

  final String _selectedValue;
  final List<String> _typeOfMeetingList;
  final Function selectDropDownValueFunc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: MColors.pinkish_grey, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedValue,
                  items: _typeOfMeetingList.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectDropDownValueFunc(value);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
