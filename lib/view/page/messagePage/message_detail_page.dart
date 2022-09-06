import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/message_get_provider.dart';
import 'package:munto_app/model/provider/message_send_provider.dart';

import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class MessageDetailPage extends StatefulWidget {
  final OtherUserProfileData userProfileData;

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
  const MessageDetailPage({
    Key key,
    @required this.userProfileData,
  }) : super(key: key);
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  TextEditingController _sendMessageEditController =
      new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  FocusNode _textFocusNode = FocusNode();
  MessageGetProvider _messageGetProvider;
  StreamController<List<MessageData>> _messageDataListStream =
      StreamController();

  static int skip;
  static int take; // 20개씩 가져올 것
  bool hasMoreData = true;

  @override
  void initState() {
    skip = 0;
    take = 20;
    _messageGetProvider = new MessageGetProvider();
    // _messageGetProvider =
    //     Provider.of<MessageGetProvider>(context, listen: false);
    getServerMessageDatas();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (hasMoreData) {
          getServerMessageDatas();
        }
      }
    });

    super.initState();
  }

  getServerMessageDatas() async {
    await _messageGetProvider
        .getMessageDatas(widget.userProfileData.id.toString(), skip, take)
        .then((value) {
      _messageDataListStream.add(value);
      if (value.length < take )
        hasMoreData = false;
      else
        hasMoreData = true;
      skip = value.length;
    }); // ID 가 target인지??
  }

  getNewMessageDataFromServer() async {
    await _messageGetProvider
        .getMessageData(widget.userProfileData.id.toString(), 0, 1)
        .then((value) {
      _messageDataListStream.add(value);
      skip = value.length;
    });
  }

  @override
  void dispose() {
    _sendMessageEditController.dispose();
    _scrollController.dispose();
    _textFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      toolbarHeight: 76,
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            // radius: 20,
            backgroundImage: NetworkImage(widget.userProfileData?.image),
          ),
          SizedBox(height: 6),
          Text(widget.userProfileData.name, style: MTextStyles.bold14Grey06),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: MColors.grey_06,
          ),
          iconSize: 24,
          onPressed: () {
            getServerMessageDatas();

            _sendMessageEditController.clear();
          },
        ),
      ],
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messageDataListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return getMessages(snapshot);
                } else {
                  return Center(
                    child: SizedBox.shrink(),
                  );
                }
              },
            ),
          ),
          Container(
            height: 58,
            width: SizeConfig.screenWidth,
            child: sendOfMessageField(),
          ),
        ],
      ),
    );
    // 가져오는 데이터가 시간데이터, 메세지, 사람
    // 1. 날짜순으로 정렬하고
    // 2. listview에 데이터 넣을때 날짜확인하고,
    //    처음이면 날짜 listtile,
    //    같은 날짜면 message listTile
  }

  Widget getMessages(snapshot) {
    // Listview 가 bottom 에서 시작해야하니까 역으로 데이터 넣기
    List<MessageData> reverseMessageDataList = snapshot.data;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
      child: ListView.builder(
        controller: _scrollController,
        reverse: true,
        itemCount: reverseMessageDataList.length + 1,
        itemBuilder: (context, index) {
          if (index == reverseMessageDataList.length) {
            if (hasMoreData == true) {
              return _buildProgressIndicator();
            } else {
              return SizedBox.shrink();
            }
          } else {
            MessageData item = reverseMessageDataList[index];
            MessageData nextItem;
            if (reverseMessageDataList.length == index + 1) {
              nextItem = item;
            } else {
              nextItem = reverseMessageDataList[index + 1];
            }

            return Column(
              children: [
                drawingTopDivideDate(item, nextItem),
                drawingDivideDate(item, nextItem),
                // 맨 윗줄 표시를 위해 사용

                Container(
                  child: UserInfo.myProfile.id.toString() ==
                          item.senderId.toString()
                      ? getMyMessageListTile(context, item, index)
                      : getYourMessageListTile(context, item, index),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
        padding: const EdgeInsets.all(38.0),
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }

  Widget getDivideDate(MessageData item) {

    final date = item.updatedDate == null ? item.createdDate.toLocal() : item.updatedDate.toLocal();

    return Text('${date.year}년 ${date.month}월 ${date.day}일',
      style: MTextStyles.bold10PinkishGrey,
    );
  }

  // 내 메세지면 이미지 없고 오른쪽 정렬
  Widget getMyMessageListTile(
      BuildContext context, MessageData item, int index) {

    final date = item.updatedDate == null ? item.createdDate : item.updatedDate;
    var formatter = new DateFormat.Hm();
    String formattedTime = formatter.format(date.toLocal());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text(
                    formattedTime ?? '',
                    style: MTextStyles.regular10PinkishGrey),
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.6),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color(0xffff8482)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:
                        Text(item.content, style: MTextStyles.regular14White),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 상대만 메세지면 이미지 추가에 왼쪽 정렬
  Widget getYourMessageListTile(
      BuildContext context, MessageData item, int index) {

    final date = item.updatedDate == null ? item.createdDate : item.updatedDate;
    var formatter = new DateFormat.Hm();
    String formattedTime = formatter.format(date.toLocal());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userProfileData.image),
              ),
              SizedBox(width: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.6),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: MColors.white_two),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          item.content,
                          style: MTextStyles.regular14BlackColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: MTextStyles.regular10PinkishGrey,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  sendOfMessageField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: SvgPicture.asset('assets/icons/invite.svg'),
        ),
        Expanded(
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(17)),
              border: Border.all(color: MColors.warm_grey, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sendMessageEditController,
                    focusNode: _textFocusNode,
                    decoration: InputDecoration(
                      hintText: '멤버에게 쪽지를 보내보세요.',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 12, bottom: 10),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() async {
                      if (_sendMessageEditController.text != '') {
                        SendMessageData newMessageData = new SendMessageData(
                            receiverId: widget.userProfileData.id.toString(),
                            content: _sendMessageEditController.text);

                        MessageSendProvider messageSendProvider =
                            new MessageSendProvider();
                        bool result = await messageSendProvider
                            .sendMessage(newMessageData);

                        getNewMessageDataFromServer();

                        _sendMessageEditController.clear();
                      }
                    });
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: MColors.tomato,
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawingTopDivideDate(MessageData item, MessageData nextItem) {
    Widget divideDateWidget;
    String itemRefDate;
    String nextItemRefDate;
    item.updateAt == null
        ? itemRefDate = item.createdAt
        : itemRefDate = item.updateAt;
    nextItem.updateAt == null
        ? nextItemRefDate = nextItem.createdAt
        : nextItemRefDate = nextItem.updateAt;

    // 맨 윗줄
    if (itemRefDate != nextItemRefDate) {
      divideDateWidget = SizedBox.shrink();
    } else
      divideDateWidget = getDivideDate(item);

    return divideDateWidget;
  }

  Widget drawingDivideDate(MessageData item, MessageData nextItem) {
    Widget divideDateWidget;
    String itemRefDate;
    String nextItemRefDate;
    item.updateAt == null
        ? itemRefDate = item.createdAt
        : itemRefDate = item.updateAt;
    nextItem.updateAt == null
        ? nextItemRefDate = nextItem.createdAt
        : nextItemRefDate = nextItem.updateAt;
    // 맨 윗줄
    if (itemRefDate.substring(0, 10) == nextItemRefDate.substring(0, 10)) {
      divideDateWidget = SizedBox.shrink();
    } else
      divideDateWidget = getDivideDate(item);

    return divideDateWidget;
  }
}
