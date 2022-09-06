import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/item_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/item_provider.dart';
import 'package:munto_app/model/provider/login_provider.dart';

import 'package:munto_app/view/widget/error_page.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/model/item_subject_data.dart';
import 'package:provider/provider.dart';

class MeetingMpassListPage extends StatefulWidget {
  @override
  _MeetingMpassListPageState createState() => _MeetingMpassListPageState();
}

class _MeetingMpassListPageState extends State<MeetingMpassListPage> {
  final StreamController<Response<List<ItemData>>> _dataListCtrl =
      StreamController();
  ItemProvider itemProvider = ItemProvider();
  List<ItemData> itemDataList = new List<ItemData>();
  int choiceChipSelectedIndex = 0;
  String _subject = '';

  final GlobalKey<RefreshIndicatorState> _refreshrKey =
      GlobalKey<RefreshIndicatorState>();
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    _getData(1, '');
    isGuest = Provider.of<LoginProvider>(context, listen: false).guestYn == 'Y'
        ? true
        : false;
  }

  _getData(int page, String subject) async {
    try {
      _dataListCtrl.sink.add(Response.loading());
      int skip = 0;
      int take = 10;
      if (page == 1) {
        itemDataList = [];
      } else {
        skip = page * 10;
      }
      String status = 'PLAYING';
      _subject = subject;

      List<ItemData> tempList = await itemProvider.getMeetingData(
          isGuest, skip, take, status, _subject);
      itemDataList.addAll(tempList);

      _dataListCtrl.sink.add(Response.completed(itemDataList));
    } catch (e) {
      print("meetingMpassListPage > Error : ${e.toString()}");
      _dataListCtrl.sink.add(Response.error(e.toString()));
    }
  }

  Future<void> getPullItemData() async {
    _getData(1, '');
  }

  @override
  void dispose() {
    _dataListCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appbar(), body: _buildPullItemPage());
  }

  Widget _buildPullItemPage() {
    return RefreshIndicator(
        key: _refreshrKey, onRefresh: getPullItemData, child: _getbody());
  }

  Widget _getbody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 195,
            //  decoration: new BoxDecoration(),
            child: Image.asset(
              'assets/agreement_image.png',
              width: double.infinity,
              height: 195,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text('일일 멤버 참여권 MPASS를 이용하여 \n궁금했던 바로 그 모임에 놀러가 보세요!',
                textAlign: TextAlign.left, style: MTextStyles.medium16Black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('전체 모임 둘러보기', style: MTextStyles.bold18Black),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: itemSubjectData.asMap().entries.map(
                      (entry) {
                        int idx = entry.key;
                        return buildChoiceChip(idx, entry);
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<Response<List<ItemData>>>(
              stream: _dataListCtrl.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      print('Loading');
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(),
                      ));
                      break;
                    case Status.COMPLETED:
                      return snapshot.data.data.length > 0
                          ? _buildGrid(snapshot.data.data)
                          : _classNoDataWidget();
                      break;
                    case Status.ERROR:
                      print('ERROR');
                      return Error(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () => null,
                      );
                      break;
                  }
                }
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: CircularProgressIndicator(),
                ));
              }),
          // _buildGrid(data)
        ],
      ),
    );
  }

  Widget _buildGrid(data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 20,
        childAspectRatio: 153 / 220,
        crossAxisCount: 2,
        children: List.generate(itemDataList.length, (index) {
          ItemData item = itemDataList[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('MeetingDetailPage',
                  arguments: [item.id, item.name, true]);
            },
            child: Ink(
              width: 152,
              // height: 171,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: MColors.white_three,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: item.cover != null
                        ? CachedNetworkImage(
                            imageUrl: item.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                                decoration: new BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(8)),
                                child: SvgPicture.asset(
                                  'assets/mypage/no_img.svg',
                                  // width: 24,
                                  // height: 24,
                                  fit: BoxFit.scaleDown,
                                )),
                            width: double.infinity,
                            height:
                                (83 * MediaQuery.of(context).size.width) / 360,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Container(
                                width: double.infinity,
                                height: 87,
                                decoration: new BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(8)),
                                child: SvgPicture.asset(
                                  'assets/mypage/no_img.svg',
                                  // width: 24,
                                  // height: 24,
                                  fit: BoxFit.scaleDown,
                                )),
                          ),
                  ),
                  Container(
                    // width: 152,
                    //  height: 86,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            if (item.itemSubject1 != null)
                              buildChip(_getValue(item.itemSubject1)),
                            if (item.itemSubject2 != null)
                              buildChip(_getValue(item.itemSubject2)),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(item.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: MTextStyles.bold14Grey06),
                        SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          height: 40.0,
                          child: Text(item.summary ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: MTextStyles.regular12Grey06),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 8.0,
                              backgroundImage: NetworkImage(
                                  '${item.itemLeader?.profileUrl}'),
                            ),
                            SizedBox(width: 3),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: item?.locationString ?? '',
                                  style: MTextStyles.regular10WarmGrey_44,
                                ),
                                TextSpan(
                                  text: "・ ",
                                  style: MTextStyles.regular10WarmGrey_44,
                                ),
                                TextSpan(
                                  text: item.startDate != null
                                      ? item.startDate.substring(5, 7) +
                                          '.' +
                                          item.startDate.substring(8, 10) +
                                          '(' +
                                          getWeekDay(DateFormat('EEEE').format(
                                              DateTime.parse(item.startDate))) +
                                          ')' +
                                          getTypeOfTime(
                                              DateTime.parse(item.startDate)) +
                                          getHour(
                                              DateTime.parse(item.startDate)) +
                                          '시'
                                      : '',
                                  style: MTextStyles.regular10WarmGrey_44,
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "진행중 모임",
        style: MTextStyles.bold16Black,
      ),
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
      actions: [],
    );
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //    NodataImage(wid: 80.0, hei: 80.0),
            const SizedBox(height: 32),
            Text('해당하는 모임이 없습니다.', style: MTextStyles.medium12PinkishGrey),
            const SizedBox(height: 4),
            Text('문토의 다양한 모임에 참여해 보세요! 😢',
                style: MTextStyles.medium12PinkishGrey),

            // FlatButton(
            //   padding: EdgeInsets.zero,
            //   child: Container(
            //     height: 43,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(28)),
            //       border: Border.all(color: MColors.tomato, width: 1),
            //       color: MColors.tomato,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("모임보기", style: MTextStyles.medium14White),
            //         Icon(Icons.check, size: 20, color: MColors.white),
            //       ],
            //     ),
            //   ),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }

  String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '-';
    }
  }

  _getValue(aa) {
    String vvv = '';
    itemSubjectData.forEach((element) {
      if (element['label'] == aa) {
        vvv = element['text'];
      }
    });
    return vvv;
  }

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  Widget buildChip(String chip) {
    return Padding(
      padding: EdgeInsets.only(right: 6),
      child: SizedBox(
        height: 22,
        child: Chip(
          padding: EdgeInsets.only(bottom: 10.0, left: 4.0, right: 4.0),
          label: Text(
            chip,
            style: MTextStyles.regular10WarmGrey,
          ),
          backgroundColor: MColors.white_two,
        ),
      ),
    );
  }

  Widget buildChoiceChip(int index, MapEntry<int, Map<String, String>> entry) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          entry.value['text'],
          style: choiceChipSelectedIndex == index
              ? MTextStyles.bold14White
              : MTextStyles.regular14Grey06,
        ),
        backgroundColor: MColors.white_two,
        selected: index == choiceChipSelectedIndex,
        selectedColor: MColors.tomato,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              choiceChipSelectedIndex = index;
              _getData(1, entry.value['label']);

              //   getItem(entry.value['label']);
            } else {
              choiceChipSelectedIndex = null;
            }
          });
        },
      ),
    );
  }
}
