import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/message_list_provider.dart';
import 'package:munto_app/model/provider/other_user_profile_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  MessageListProvider _messageListProvider;

  Future<List<MessageListData>> _messageDataList;

  @override
  void initState() {
    _messageListProvider = new MessageListProvider();

    _messageDataList = _messageListProvider.getMessageListData();
    super.initState();
  }

  Future<List<MessageListData>> getMessageListData() async {
    List<MessageListData> messageDataList;
    messageDataList = await _messageListProvider.getMessageListData();

    return messageDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  _appbar() {
    return AppBar(
      title: Center(
          child: Text(
        "쪽지",
        style: MTextStyles.bold16Black,
      )),
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
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
            icon: SvgPicture.asset('assets/icons/newmessage.svg'),
            onPressed: () {
              //TODO 새창 페이지 연결
              Navigator.of(context).pushNamed('MessageNewPage');
            })
      ],
    );
  }

  _body() {
    return Container(
      child: _messageList(),
    );
  }

  Widget _messageList() {
    return FutureBuilder<List<MessageListData>>(
      future: _messageDataList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MessageDataListView(snapshot: snapshot);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class MessageDataListView extends StatelessWidget {
  const MessageDataListView({
    Key key,
    this.snapshot,
  }) : super(key: key);

  final snapshot;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          MessageListData item = snapshot.data[index];
          int otherUserId = checkOtherUserId(item);

          final date = DateTime.parse(item.updatedAt).toLocal();

          return Container(
            height: 72,
            child: ListTile(
              onTap: () async {
                final userProfileProvider =
                    OtherUserProfileProvider(otherUserId.toString());
                await userProfileProvider.fetchProfile();
                final userProfileData =
                    userProfileProvider.otherUserProfileData;
                Navigator.of(context).pushNamed(
                  'MessageDetailPage',
                  arguments: userProfileData,
                );
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.receiver.id == otherUserId
                    ? item.receiver.image
                    : item.sender.image),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.receiver.id == otherUserId
                        ? item.receiver.name
                        : item.sender.name,
                    style: MTextStyles.bold14Grey06,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    item.content,
                    maxLines: 1,
                    style: MTextStyles.regular12WarmGrey_underline,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${date.month}월 ${date.day}일',
                    style: MTextStyles.medium10PinkishGrey,
                  ),
                ],
              ),
            ),
          );
        });
  }

  checkOtherUserId(MessageListData item) {
    if (item.receiver.id == UserInfo.myProfile.id) {
      return item.sender.id;
    } else {
      return item.receiver.id;
    }
  }

  Future<void> getOtherUserData(otherUserId) async {
    final userProfileProvider = OtherUserProfileProvider(otherUserId);
    await userProfileProvider.fetchProfile();
    return userProfileProvider.otherUserProfileData;
  }
}
