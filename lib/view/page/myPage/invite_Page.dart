import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/enum/class_Enum.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';
class FollowerItem {
  String followName;
  String followtitle;

  FollowerItem(
    this.followName,
    this.followtitle,
  );
}

class InvitePage extends StatefulWidget {
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  List list = meetingGroupAll[0].applicantList;
  int selectedIndex = 0;
  List<Applicant> followingList = [];

  final StreamController<Response<List<ClassData>>> _classDataListSteam = StreamController();
  final StreamController<Response<List<Applicant>>> _followingListSteam = StreamController();


  ClassProvider classService = ClassProvider();
  List<ClassData> _classDataList = [];
  @override
  void initState() {
    super.initState();
    _getClassList();
  }

  void _getClassList() async {
      _classDataListSteam.sink.add(Response.loading());
      _followingListSteam.sink.add(Response.loading());
    try {
      _classDataList = await classService.getClassList(ClassEnum.PRESTART);
     //_classDataListSteam.sink.add(Response.completed(_classDataList));
      _classDataListSteam.sink.add(Response.completed([]));

     // _followingListSteam.sink.add(Response.completed(list));
      _followingListSteam.sink.add(Response.completed(followingList));
    }catch(e){
        _classDataListSteam.sink.add(Response.error(e.toString()));
        _followingListSteam.sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _classDataListSteam.close();
    _followingListSteam.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              _mainTitle('초대하고 싶은 모임을 선택해주세요'),
              const SizedBox(
                height: 16,
              ),
              _reviewListView(),
              const SizedBox(
                height: 19,
              ),
              //_subTitle('251 팔로잉 ', ''),
              
              _followListView(),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "모임초대",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
      backgroundColor: MColors.barBackgroundColor ,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barBorderWidth),
        child: Container(height: barBorderWidth, color: MColors.barBorderColor,),
      ),
    );
  }

  Widget _mainTitle(String title) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            new Text(
              title,
              style: MTextStyles.bold18BlackColor,
            ),
            const SizedBox(
              width: 13,
            ),
          ],
        ));
  }

  // 상단 활동적인 모임
  Widget _reviewListView() {
    return Container(
      decoration: BoxDecoration(
        color: MColors.white_two,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 265,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<Response<List<ClassData>>>(
                stream: _classDataListSteam.stream,
                builder: (BuildContext context, AsyncSnapshot<Response<List<ClassData>>> snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Center(child: Padding(
                            padding: const EdgeInsets.all(68.0),
                            child: CircularProgressIndicator(),
                          ));
                          break;
                        case Status.COMPLETED:
                          List<ClassData> list = snapshot.data.data;
                          return list.length > 0 ? _classList(list) : _classNoDataWidget();
                          break;
                        case Status.ERROR:
                          return Error(
                            errorMessage: snapshot.data.message,
                            onRetryPressed: () => null,
                          );
                          break;
                      }
                  }
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(),
                  ));
                }),
          ),
        ],
      ),
    );
  }
  Widget _classNoDataWidget(){
    return  Column(
          mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20.0),
            child: TitleBold16BlackView('활동적인 모임', '0건'),
          ),
          const SizedBox(height: 25),
          NodataImage(wid: 80.0, hei: 80.0),
          Text('활동적인 모임이 없습니다.', style: MTextStyles.medium16WarmGrey),
          //  const SizedBox(height: 15),
        ]
    );
  }
  Widget _classList( List<ClassData> list ) {
    return Container(
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 2.0),
            child: TitleBold16BlackView('활동적인 모임', '${list.length}건'),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    width: 167,
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              print('click');
                            },
                            child: Container(height: 170, child: ClassBigBox(list[i]))),
                        Container(
                          height: 49,
                          child: Radio(
                            value: selectedIndex == i,
                            onChanged: (bool value) {
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                            groupValue: true,
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
  Widget _followListView() {
    return StreamBuilder<Response<List<Applicant>>>(
                stream: _followingListSteam.stream,
                builder: (BuildContext context, AsyncSnapshot<Response<List<Applicant>>> snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Center(child: Padding(
                            padding: const EdgeInsets.all(68.0),
                            child: CircularProgressIndicator(),
                          ));
                          break;
                        case Status.COMPLETED:
                          List<Applicant> list = snapshot.data.data;
                          return list.length > 0 ? _followList(list) : _followNoDataWidget();
                          break;
                        case Status.ERROR:
                          return Error(
                            errorMessage: snapshot.data.message,
                            onRetryPressed: () => null,
                          );
                          break;
                      }
                  }
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(),
                  ));
                });
  }

  Widget _followList(List<Applicant> list) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TitleBold16BlackView('${list.length} 팔로잉 ', ''),
        ),
        const SizedBox(
          height: 17,
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                color: MColors.whiteColor,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.profileUrl),
                  ),
                  title: Row(
                    children: [
                      Text(
                        item.name,
                        style: MTextStyles.regular14Grey06,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.memberType,
                        style: MTextStyles.regular12WarmGrey_underline,
                      )
                    ],
                  ),
                  trailing: // Rectangle Copy
                      Container(
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border.all(color: MColors.tomato, width: 1),
                      color: followingList.contains(item) ? MColors.tomato : MColors.white,
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      child: followingList.contains(item)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, size: 20, color: MColors.white),
                                Text("초대", style: MTextStyles.medium14White),
                              ],
                            )
                          : Text(
                              "모임초대",
                              style: MTextStyles.regular14Tomato,
                            ),
                      onPressed: () {
                        setState(() {
                          if (followingList.contains(item))
                            followingList.remove(item);
                          else
                            followingList.add(item);
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

    Widget _followNoDataWidget(){
    return  Column(
          mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20.0, left:20 ),
            child: TitleBold16BlackView('0 팔로잉', ''),
          ),
          const SizedBox(height: 25),
          NodataImage(wid: 80.0, hei: 80.0),
          Text('팔로잉 없습니다.', style: MTextStyles.medium16WarmGrey),
          //  const SizedBox(height: 15),
        ]
    );
  }
}
