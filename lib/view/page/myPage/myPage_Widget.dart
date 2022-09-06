import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/util.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassBigBox extends StatelessWidget {
  final ClassData item;
  const ClassBigBox(
    this.item,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Ink(
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
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: new BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey[100]),
                            borderRadius: BorderRadius.circular(8)),
                        child: SvgPicture.asset(
                          'assets/mypage/no_img.svg',
                          // width: 24,
                          // height: 24,
                          fit: BoxFit.scaleDown,
                        )),
                    width: double.infinity,
                    height: (83 * size.width) / 360,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Container(
                        width: double.infinity,
                        height: 87,
                        decoration: new BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(width: 1, color: Colors.grey[100]),
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
                  height: 11,
                ),
                Text(Util.getClassTypeName(item.classType) ?? '', style: MTextStyles.regular12Grey06),
                SizedBox(
                  height: 2,
                ),
                Text(item.name ?? '', overflow: TextOverflow.ellipsis, style: MTextStyles.bold16Black2),
                SizedBox(
                  height: 13,
                ),
                Text('${Util.getDateYmd(item.startDate)} ~ ${Util.getDateYmd(item.finishDate)}',
                    overflow: TextOverflow.fade, style: MTextStyles.regular12Grey06),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClassMiddleBox extends StatelessWidget {
  final ClassData item;
  const ClassMiddleBox(
    this.item,
  );
  @override
  Widget build(BuildContext context) {
    double sizeWidth360 = MediaQuery.of(context).size.width / 360;

    return Row(
      children: [
        Container(
          width: 118 * sizeWidth360,
          height: 64 * sizeWidth360 + 4,
          decoration: new BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: item?.cover ?? '',
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
              height: 83 * sizeWidth360,
              fit: BoxFit.cover,
            ),
            // child: Image.network(
            //   item.imageUrl,
            //   fit: BoxFit.fill,
            // )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item?.classType ?? '', style: MTextStyles.regular12Grey06),
              Text(item?.name ?? '', style: MTextStyles.bold16Black2),
              const SizedBox(
                height: 6,
              ),
              // Text('${(item.startDate)} ~ ${item.finishDate}', style: MTextStyles.regular12Grey06),
              Text('${Util.getDateYmd(item?.startDate)} ~ ${Util.getDateYmd(item?.finishDate )}',
                  style: MTextStyles.regular12Grey06),
            ],
          ),
        ),
      ],
    );
  }
}

// 모임관리 미팅박스 수정버튼 추가 버젼
class ClassManageBox extends StatelessWidget {
  final ClassData item;
  final hideManageButton;
  const ClassManageBox(
    this.item,
    {this.hideManageButton = false}
  );

  @override
  Widget build(BuildContext context) {
    double sizeWidth360 = MediaQuery.of(context).size.width / 360;

    return new Container(
      width: 152 * sizeWidth360,
      // decoration: new BoxDecoration(
      //     // color: Colors.white,
      //     border: Border.all(width: 1, color: Colors.grey),
      //     borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 86 * sizeWidth360,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              child: item.cover != null
                  ? CachedNetworkImage(
                      imageUrl: item.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                          decoration: new BoxDecoration(
                              // color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey[600]),
                              borderRadius: BorderRadius.circular(8)),
                          child: SvgPicture.asset(
                            'assets/mypage/no_img.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.scaleDown,
                          )),
                      width: double.infinity,
                      height: 86,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Container(
                          width: double.infinity,
                          height: 83,
                          decoration: new BoxDecoration(
                              // color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey[600]),
                              borderRadius: BorderRadius.circular(8)),
                          child: SvgPicture.asset(
                            'assets/mypage/no_img.svg',
                            // width: 24,
                            // height: 24,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 6.0),
              height: 124,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Util.getClassTypeName(item.classType) ?? '', style: MTextStyles.regular12Grey06),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(item.name ?? '', overflow: TextOverflow.ellipsis, style: MTextStyles.bold16Black2),
                  const SizedBox(
                    height: 4,
                  ),
                  Text('${Util.getDateYmd(item.startDate)} ~ ${Util.getDateYmd(item.finishDate)}',
                      style: MTextStyles.regular12Grey06),
                  Container(
                    height: 8,
                  ),
                  if(!hideManageButton)
                    ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      child: OutlineButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("모임 정보관리", style: MTextStyles.regular14Grey06),
                            const SizedBox(
                              width: 3,
                            ),
                            SvgPicture.asset(
                              'assets/mypage/write.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.scaleDown,
                              color: Colors.red,
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29.0),
                        ),
                        borderSide: BorderSide(
                          color: MColors.grey_06,
                        ),
                        onPressed: () {
                          // Navigator.of(context).pushNamed('ClassProceedingPage', arguments:_map);
                          print('item.status  :  ${item.status}');
                          Map<String, String> _map = Map<String, String>();
                          _map['id'] = item.id.toString();
                          _map['itemId'] = item.id.toString();
                          _map['classType'] = item.classType.toString();

                          if (item.status == 'RECRUITING') {
                            Navigator.of(context).pushNamed('ClassRecruitingPage', arguments: _map);
                          } else {
                            Map<String, String> _map = Map<String, String>();
                            _map['id'] = item.id.toString();
                            _map['classType'] = item.classType.toString();
                            Navigator.of(context).pushNamed('ClassProceedingPage', arguments: _map);
                          }
                        },
                      ),
                    ),
                  const SizedBox(height: 1.0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleBold16BlackView extends StatelessWidget {
  final String title;
  final String val;

  const TitleBold16BlackView(this.title, this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        //  padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            new Text(
              title,
              style: MTextStyles.bold16Black,
            ),
            const SizedBox(
              width: 8,
            ),
            new Text(
              val,
              style: val == '0건' ? MTextStyles.bold16PinkishGrey : MTextStyles.bold16Tomato,
            ),
          ],
        ));
  }
}


class TitleBold20BlackView extends StatelessWidget {
  final String title;
  final String val;

  const TitleBold20BlackView(this.title, this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        //  padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            new Text(
              title,
              style: MTextStyles.bold20Black,
            ),
            const SizedBox(
              width: 8,
            ),
            new Text(
              val,
              style: val == '0건' ? MTextStyles.bold16PinkishGrey : MTextStyles.bold16Tomato,
            ),
          ],
        ));
  }
}


class TitleBold22BlackView extends StatelessWidget {
  final String title;
  final String val;

  const TitleBold22BlackView(this.title, this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        //  padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            new Text(
              title,
              style: MTextStyles.bold22Black,
            ),
            const SizedBox(
              width: 8,
            ),
            new Text(
              val,
              style: val == '0건' ? MTextStyles.bold16PinkishGrey : MTextStyles.bold16Tomato,
            ),
          ],
        ));
  }
}

class Divider1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1);
  }
}

// ignore: must_be_immutable
@override
// ignore: must_be_immutable
class NodataImage extends StatelessWidget {
  NodataImage({this.wid = 24, this.hei = 24, this.path = '', this.colors = Colors.grey});

  double wid;
  double hei;
  String path;
  Color colors;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path == '' ? 'assets/mypage/no_img.svg' : path,
        width: wid, height: hei, fit: BoxFit.fill, color: colors);
  }
}

class DividerGrey12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xfff4f4f4),
        border: Border(top: BorderSide(color: Color(0xffe8e8e8), width: 1)),
      ),
    );
  }
}

class DividerWhite12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        border: Border(top: BorderSide(color: Color(0xffffffff), width: 1)),
      ),
    );
  }
}

class ReViewCancelDialog_del {
  static void showCancelDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            height: 140,
            width: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '잠시만요',
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontFamily: "AppleSDGothicNeo",
                      fontStyle: FontStyle.normal,
                      fontSize: 17.0),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '삭제한 후기는 복구할 수 없습니다. \n정말 삭제하시겠습니까?',
                    style: TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "NotoSansCJKkr",
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0),
                  ),
                ),
                SizedBox(height: 20),
                Divider(height: 0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {},
                          child: Text(
                            '삭제',
                            style: MTextStyles.bold16Tomato,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
