import 'package:flutter/material.dart';
import 'package:munto_app/model/following_Data.dart';
import 'package:munto_app/model/member_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/page/messagePage/components/select_member_form.dart';
import 'package:munto_app/utils/text_search.dart';

import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class MessageNewPage extends StatefulWidget {
  @override
  _MessageNewPageState createState() => _MessageNewPageState();
}

class _MessageNewPageState extends State<MessageNewPage> {
  TextEditingController _searchTextEditController = new TextEditingController();
  FocusNode _textFocusNode = FocusNode();
  OtherUserProfileData _selectedFollower;
  int _selectedIndex = -1;

  // List<FollowingData> _selectedFollowerList = new List<FollowingData>();
  List<OtherUserProfileData> _followUserDataList =
      new List<OtherUserProfileData>();
  List<OtherUserProfileData> _searchedFollowUserDataList =
      new List<OtherUserProfileData>();

  @override
  void initState() {
    _searchTextEditController.addListener(textListener);
    getFollowerList();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextEditController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  getFollowerList() async {
    List<OtherUserProfileData> followerList = List<OtherUserProfileData>();
    for (FollowingData f in UserInfo.myProfile.following) {
      OtherUserProfileProvider provider =
          new OtherUserProfileProvider(f.followedUserId.toString());
      await provider.fetchProfile();
      _followUserDataList.add(provider.otherUserProfileData);
    }
    setState(() {
      _searchedFollowUserDataList = _followUserDataList;
    });
  }

  textListener() async {
    List<OtherUserProfileData> searchFollowerList =
        List<OtherUserProfileData>();
    for (OtherUserProfileData follower in _followUserDataList) {
      bool result = await searchFollowerName(follower.name);
      if (result == true) searchFollowerList.add(follower);
    }

    setState(() {
      _searchedFollowUserDataList = searchFollowerList;
    });
  }

  searchFollowerName(String followerName) async {
    if (TextSearcher.matchString(
        followerName, _searchTextEditController.text)) {
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      title: Center(
          child: Text(
        "새 쪽지",
        style: MTextStyles.bold16Black,
      )),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            if (_selectedFollower != null) {
              Navigator.of(context).pushNamed(
                'MessageDetailPage',
                arguments: _selectedFollower,
              );
            }
          },
          child: Text(
            '대화',
            style: MTextStyles.bold14Tomato,
          ),
        )
      ],
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectMemberForm(
              selectedFollower: _selectedFollower,
              searchMemberController: _searchTextEditController,
              textFocusNode: _textFocusNode),
          SizedBox(height: 10),
          Text('팔로우', style: MTextStyles.bold16Black2),
          SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: _searchedFollowUserDataList.length,
              itemBuilder: (context, index) {
                final item = _searchedFollowUserDataList[index];
                return Container(
                  height: 72,
                  child: ListTile(
                    onTap: () {
                      // Navigator.of(context).pushNamed(
                      //   'MessageDetailPage',
                      //   arguments: _selectedMemberList,
                      // );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          _searchedFollowUserDataList[index].image),
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _searchedFollowUserDataList[index].name,
                          style: MTextStyles.bold14Grey06,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                    trailing: Radio(
                      value: index,
                      groupValue: _selectedIndex,
                      toggleable: true,
                      onChanged: (newVal) {
                        setState(() {
                          _selectedIndex = newVal;
                          _selectedIndex != null
                              ? _selectedFollower =
                                  _searchedFollowUserDataList[newVal]
                              : _selectedFollower = null;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
