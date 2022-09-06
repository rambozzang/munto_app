import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/board_data.dart';
import 'package:munto_app/model/feed_image_list_data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/photos_data.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class GalleryDetail extends StatefulWidget {
//  final BoardItem item;
  FeedImageListData item;
  int index;
  GalleryDetail(this.item, this.index);

  @override
  _GalleryDetailState createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  PageController pageController;
  int currentIndex;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.blackColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: pageController,
              itemCount: widget.item.photos.length,
              itemBuilder: (context, position) {
                PhotosData _data = widget.item.photos[position];
                return _buildItem(_data);
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            Navigator.of(context).pushNamed('UserProfilePage', arguments: widget.item.user.id);
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.item.user.image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap:(){
                              Navigator.of(context).pushNamed('UserProfilePage', arguments: widget.item.user.id);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.item.user.name,
                                  style: MTextStyles.regular12White,
                                ),
                                Text(
                                  widget.item.createdAt.substring(5, 7) +
                                      '.' +
                                      widget.item.createdAt.substring(8, 10) +
                                      '(' +
                                      getWeekDay(DateFormat('EEEE').format(DateTime.parse(widget.item.createdAt).toLocal())) +
                                      ')' +
                                      getTypeOfTime(DateTime.parse(widget.item.createdAt).toLocal()) +
                                      getHour(DateTime.parse(widget.item.createdAt).toLocal()) +
                                      '시' +
                                      (DateTime.parse(widget.item.createdAt).toLocal()).minute.toString() +
                                      '분 ' +
                                      (DateTime.parse(widget.item.createdAt).toLocal()).second.toString() +
                                      '초',
                                  style: MTextStyles.regular12WarmGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/ico_comment.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          final feedData = FeedData.fromFeedImageListData(widget.item);
                          Navigator.of(context).pushNamed('FeedDetailPage', arguments: {'feed':feedData});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: MColors.grey_05,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(
                  '${currentIndex + 1} / ${widget.item.photos.length}',
                  style: MTextStyles.medium16Grey06,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.file_download,
                      // color: MColors.grey_05,
                      color: Colors.transparent,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(PhotosData _item) {
    // final item = galleryItemList[index];
    // return Image.network(item.imageUrl(index), fit: BoxFit.fitWidth,);

    return CachedNetworkImage(
      imageUrl: _item.photo,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
          decoration: new BoxDecoration(
              // color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(8)),
          child: SvgPicture.asset(
            'assets/mypage/no_img.svg',
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          )),
      width: double.infinity,
      //  height: 83 * sizeWidth360,
      fit: BoxFit.cover,
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

  String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  Widget buildChip(String chip) {
    return Chip(
      label: Text(
        chip,
        style: MTextStyles.regular10Grey06,
      ),
      backgroundColor: MColors.white_two,
    );
  }
}
