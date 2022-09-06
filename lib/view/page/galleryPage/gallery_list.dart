import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/model/feed_image_list_data.dart';
import 'package:munto_app/model/photos_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'gallery_detail.dart';
import 'package:munto_app/view/widget/error_page.dart';

class GalleryList extends StatefulWidget {
  final String classType;
  final int itemId;
  //final ScrollController scrollController;
  GalleryList({Key key, this.classType, this.itemId }) : super(key: key);

  @override
  _GalleryListState createState() => _GalleryListState();
}

class _GalleryListState extends State<GalleryList> with AutomaticKeepAliveClientMixin<GalleryList> {
  FeedProvider feedProvider = FeedProvider();
  ScrollController _scrollCtrl = new ScrollController();
  bool dataPageListisMoreBool = false;
  int page = 1;

  final StreamController<Response<List<Map<String, dynamic>>>> _galleryCtrl = StreamController();
  List<FeedImageListData> list = [];
  List<Map<String, dynamic>> imageList = [];

  @override
  void initState() {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print('@@   gallery_list.dart  initState() 실행 !!!!@@@@@@@@@@@@@@@@@@@@@@@@@');
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    super.initState();
    getData(1);

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (dataPageListisMoreBool) {
          print('gallery_listgallery_listgallery_listgallery_list');
          getData(page);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> getData(int page) async {
    if (page == 1) imageList = [];

    try {
      _galleryCtrl.sink.add(Response.loading());

      List<FeedImageListData> currentlist =
          await feedProvider.getCommunitiPictureList(widget.classType, widget.itemId, page);

      list.addAll(currentlist);
      currentlist.asMap().forEach((index, value) {
        currentlist[index].photos.forEach((val) {
          Map<String, dynamic> _item = Map();
          _item['item'] = currentlist[index];
          _item['photos'] = val;
          imageList.add(_item);
        });
      });

      _galleryCtrl.sink.add(Response.completed(imageList));
    } catch (e) {
      print(e.toString());
      _galleryCtrl.sink.add(Response.error('gallery_list.dart 77 line : ${e.toString()}'));
    }

    //  if (_take > cnt) {
    //     dataPageListisMoreBool = false;
    //   } else {
    //     dataPageListisMoreBool = true;
    //   }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _galleryCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('gallery_llist.dart 실행 @@@@@@ ');
    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollCtrl,
          child: StreamBuilder<Response<List<Map<String, dynamic>>>>(
              stream: _galleryCtrl.stream,
              builder: (BuildContext context, AsyncSnapshot<Response<List<Map<String, dynamic>>>> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(68.0),
                        child: CircularProgressIndicator(),
                      ));
                      break;
                    case Status.COMPLETED:
                      List<Map<String, dynamic>> list = snapshot.data.data;
                      return list.length > 0 ? _buildGradView(list) : _noDataWidget();
                      break;
                    case Status.ERROR:
                      return Error(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () => getData(1),
                      );
                      break;
                  }
                }
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: CircularProgressIndicator(),
                ));
              })),
    );
  }

  Widget _buildGradView(map) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: map.length,
        itemBuilder: (context, index) {
          FeedImageListData item = map[index]['item'];
          PhotosData photo = map[index]['photos'];

          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) => GalleryDetail(item, index)));
              },
              child: _getImage(photo.photo));
        });
  }

  _getImage(String photo) {
    return CachedNetworkImage(
      imageUrl: photo,
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
  // _getChild(String img) {
  //   if (item.photos[0].isNotEmpty)
  //     return Image.network(
  //       item.photos[0],
  //       fit: BoxFit.cover,
  //     );
  //   else
  //     return Container();
  // }

  // 전체 데이타 없을 경우
  Widget _noDataWidget() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NodataImage(wid: 80.0, hei: 80.0, path: 'assets/mypage/empty_orderhistory_60_px.svg'),
          Center(child: Text('등록 된 내용이없습니다.\n취향에 꼭 맞는 모임에 참여해 보세요!', style: MTextStyles.medium16WarmGrey)),
          const SizedBox(height: 15),
          FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              height: 42,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                border: Border.all(color: MColors.tomato, width: 1),
                color: MColors.tomato,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("모임보기", style: MTextStyles.medium14White),
                  Icon(Icons.check, size: 20, color: MColors.white),
                ],
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
