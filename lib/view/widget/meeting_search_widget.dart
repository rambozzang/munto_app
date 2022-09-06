import 'package:flutter/material.dart';

import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';

class MeetingSearchWidget extends StatelessWidget {
  const MeetingSearchWidget({
    Key key,
    @required TextEditingController searchMeetingEditController,
    @required imageUrl,
  })  : _searchMeetingEditController = searchMeetingEditController,
        _imageUrl = imageUrl,
        super(key: key);

  final TextEditingController _searchMeetingEditController;
  final String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: 145,
      child: Stack(
        children: [
          // Container(
          //   width: SizeConfig.screenWidth,
          //   height: 145,
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //   ),
          // ),

          // Image.network(
          //   _imageUrl,
          //   fit: BoxFit.fitWidth,
          //   width: SizeConfig.screenWidth,
          // ),
          Positioned(
            top: 16,
            left: 20,
            child: Container(
              width: SizeConfig.screenWidth - 40,
              height: 40,
              decoration: BoxDecoration(
                color: MColors.white_four,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: MColors.white_four, width: 1),
              ),
              child: Row(
                children: [
                  SizedBox(width: 21),
                  Icon(
                    Icons.search,
                    size: 19,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchMeetingEditController,
                      decoration: InputDecoration(
                        hintStyle: MTextStyles.regular14WarmGrey,
                        hintText: '어떤 모임을 찾고 있나요?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 12, bottom: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 84,
            left: 20,
            child: Text(
              '어떤 모임에 갈지 고민되나요?',
              style: MTextStyles.regular14Grey06,
            ),
          ),
          Positioned(
            top: 106,
            left: 20,
            child: Text('이주용 님에게 딱 맞는 모임 찾아보기', style: MTextStyles.bold16Black),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: Image.asset('assets/icons/funnel.png'),
          ),
        ],
      ),
    );
  }
}
