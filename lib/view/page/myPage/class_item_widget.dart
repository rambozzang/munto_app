import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import '../../../util.dart';

class ClassBigItemWidget extends StatelessWidget {
  final ClassData item;
  const ClassBigItemWidget(
      this.item,
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Ink(
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
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child:
              item.cover != null
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
                      fit: BoxFit.scaleDown,
                    )),
                width: double.infinity,
                height: 83.0,
                fit: BoxFit.cover,
              ):
                Center(
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 88,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: Text(Util.getClassTypeName(item.classType) ?? '', style: MTextStyles.medium12BrownishGrey),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: Text(item.name ?? '', overflow: TextOverflow.ellipsis, style: MTextStyles.bold16Grey06_36),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:2.0),
                  child: Text('${Util.getDateYmd(item.startDate)} ~ ${Util.getDateYmd(item.finishDate)}',
                      overflow: TextOverflow.fade, style: MTextStyles.regular12Grey06_06),
                ),
                // SizedBox(height: 10,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ClassManageItemWidget extends StatelessWidget {
  final ClassData item;
  final hideManageButton;
  const ClassManageItemWidget(
      this.item,
      {this.hideManageButton = false}
      );

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            child:
            item.cover != null ? CachedNetworkImage(
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
            ) :
            Center(
              child: Container(
                  width: double.infinity,
                  height: 88,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[600]),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: SvgPicture.asset(
                    'assets/mypage/no_img.svg',
                    // width: 24,
                    // height: 24,
                    fit: BoxFit.scaleDown,
                  )),
            ),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12,),
              Text(Util.getClassTypeName(item.classType) ?? '', style: MTextStyles.medium11BrownishGrey_055),
              const SizedBox(height: 4,),
              Text(item.name ?? '', overflow: TextOverflow.ellipsis, style: MTextStyles.bold15GreyishBrown_036),
              const SizedBox(height: 4,),
              Text('${Util.getDateYmd(item.startDate)} ~ ${Util.getDateYmd(item.finishDate)}',
                  style: MTextStyles.medium12WarmGrey_092),
              const SizedBox(height: 10,),
              if(!hideManageButton)
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 36,
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
      ],
    );
  }
}
