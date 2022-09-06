import 'package:flutter/material.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class SelectMemberForm extends StatelessWidget {
  const SelectMemberForm({
    Key key,
    @required OtherUserProfileData selectedFollower,
    @required TextEditingController searchMemberController,
    @required FocusNode textFocusNode,
  })  : _selectedFollower = selectedFollower,
        _searchMemberController = searchMemberController,
        _textFocusNode = textFocusNode,
        super(key: key);

  final OtherUserProfileData _selectedFollower;
  final TextEditingController _searchMemberController;
  final FocusNode _textFocusNode;

  @override
  Widget build(BuildContext context) {
    Widget returnWidget;
    if (_selectedFollower != null) {
      returnWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text('받는 사람', style: MTextStyles.bold16Black2),
          SizedBox(height: 12),
          Container(
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: MColors.white_two,
            ),
            child: ListTile(
              onTap: () {},
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_selectedFollower.image),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedFollower.name,
                    style: MTextStyles.bold14Grey06,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    _selectedFollower.name,
                    maxLines: 1,
                    style: MTextStyles.regular12WarmGrey_underline,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      returnWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text('받는 사람', style: MTextStyles.bold16Black2),
          SizedBox(height: 12),
          Container(
            child: TextField(
              controller: _searchMemberController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                hintText: '검색하기',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 12, bottom: 10),
              ),
            ),
          ),
        ],
      );
    }
    return returnWidget;
  }
}
