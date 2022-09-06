import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/interest_data.dart';
import 'package:munto_app/model/other_userprofile_data.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';

class HotUserWidget extends StatefulWidget {
  final List<OtherUserProfileData> userList;
  bool isGuest;
  HotUserWidget(this.userList, {this.isGuest = false});

  @override
  _HotUserWidgetState createState() => _HotUserWidgetState();
}

class _HotUserWidgetState extends State<HotUserWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.userList == null || widget.userList.length == 0)
      return Container(
        height: 0,
      );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
        child: Text(
          '✨문토의 추천 멤버',
          style: MTextStyles.bold18Black,
        ),
      ),
      // bg
      SizedBox(
        height: 236,
        child: PageView.builder(
          itemCount: widget.userList.length,
          itemBuilder: (context, index){
            final userData = widget.userList[index];
            final interestList = userData.interestList.length > 5 ? userData.interestList.sublist(0, 5) : userData.interestList;

            final _onTapFeedUser1 = () {
              if (widget.isGuest) return;
              Navigator.of(context).pushNamed('UserProfilePage', arguments: userData.id);
            };

            // return Container(color: Colors.yellow, width: 200, height: 100,);

            return GestureDetector(
              onTap: _onTapFeedUser1,
              child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 24),
                      child: Container(
                        height: 232,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: MColors.very_light_pink, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: MColors.pinkish_grey,
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                  spreadRadius: -5)
                            ],
                            color: const Color(0xffffffff)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 24,
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(userData.image),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 9,
                                    right: 6,
                                  ),
                                  child: Text(
                                    userData?.name ?? '',
                                    style: MTextStyles.bold18Black,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                      '',
                                      style: MTextStyles.regular12WarmGrey,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Container(
                                      width: 80.0,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: userData.isFollow ? MColors.tomato : MColors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(18)),
                                        border: Border.all(color: MColors.tomato, width: 1),
                                      ),
                                      child: FlatButton(
                                        padding: EdgeInsets.zero,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          Text(
                                            (userData?.isFollow ?? false) ? '팔로잉' : '팔로우',
                                            style: userData.isFollow ? MTextStyles.regular12White : MTextStyles.regular12Tomato,
                                          )
                                        ]),
                                        onPressed: () async {
                                          final feedProvider = Provider.of<FeedProvider>(context, listen: false);

                                          bool result = false;
                                          if (userData.isFollow)
                                            result = await feedProvider.deleteFollow(userData.id);
                                          else{
                                            AppStateLog(context, FOLLOW_MEMBER, properties: {
                                              'sourceId':'${userData.id}',
                                            });
                                            result = await feedProvider.postFollow(userData.id);
                                          }
                                          if (result)
                                            setState(() {
                                              userData.isFollow = !userData.isFollow;
                                            });
                                        },
                                      )),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12, top: 22),
                              child: Text(
                                userData?.introduce ?? '-',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: MTextStyles.regular14Grey06,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 24),
                              child: Wrap(
                                children: List.generate(
                                    interestList.length,
                                        (index) => Container(
                                      margin: EdgeInsets.only(right: 8),
                                      width: 52,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4)), color: MColors.white_two),
                                      child: Center(
                                          child: Text(
                                            Interest.getNameByValue(interestList[index]),
                                            style: MTextStyles.regular12Grey06,
                                          )),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            );
                }
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 16),
      ),
//          Padding(
//            padding: EdgeInsets.only(left: 20, right: 20, top: 24),
//            child: Container(
//              height: 232,
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(
//                      Radius.circular(10)
//                  ),
//                  border: Border.all(
//                      color: MColors.very_light_pink,
//                      width: 1
//                  ),
//                  boxShadow: [BoxShadow(
//                      color: MColors.pinkish_grey,
//                      offset: Offset(0,0),
//                      blurRadius: 10,
//                      spreadRadius: -5
//                  )] ,
//                  color: const Color(0xffffffff)
//              ),
//              child: Column(children: <Widget>[
//                Row(crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(left: 12, top: 24,),
//                    child: CircleAvatar(radius: 40,backgroundImage: NetworkImage('https://www.gannett-cdn.com/-mm-/b2b05a4ab25f4fca0316459e1c7404c537a89702/c=0-0-1365-768/local/-/media/2019/02/05/USATODAY/usatsports/gettyimages-935715664.jpg?width=660&height=372&fit=crop&format=pjpg&auto=webp'),),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 9, right: 6,),
//                    child: Text('이주용', style: MTextStyles.bold18Black,),
//                  ),
//                  Expanded(child: Text('문지기', style: MTextStyles.regular12WarmGrey,)),
//                  Padding(
//                    padding: const EdgeInsets.only(right:12.0),
//                    child: Container(
//                        width: 80.0,
//                        height: 36,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(
//                              Radius.circular(18)
//                          ),
//                          border: Border.all(
//                              color: MColors.tomato,
//                              width: 1
//                          ),
//                        ),
//                        child:
//                        FlatButton(
//                          padding: EdgeInsets.zero,
//                          child: Row(mainAxisAlignment: MainAxisAlignment.center,children:[
//                            Text('팔로우', style: MTextStyles.regular12Tomato,)
//                          ]),
//                          onPressed: (){
//                          },
//                        )
//                    ),
//                  )
//                ],),
//                Padding(
//                  padding: const EdgeInsets.only(left: 12, right: 12, top: 22),
//                  child: Text('재즈를 좋아합니다. 그중 쿨, 하드밥 스타일 연주를 주로 즐겨듣습니다. 아, 그리고 재잘알이 되고 싶습니다.',overflow: TextOverflow.ellipsis, maxLines: 2, style: MTextStyles.regular14Grey06,),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(left: 12, top: 24),
//                  child: Row(
//                    children: List.generate(3, (index) =>
//                        Container(
//                          margin: EdgeInsets.only(right: 8),
//                          width: 52,
//                          height: 24,
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(4)),
//                              color: MColors.white_two
//                          ),
//                          child: Center(child: Text(index == 0 ? '글쓰기': index == 1 ?'브랜드' :'커피', style: MTextStyles.regular12Grey06,)),
//                        )
//                    ),
//                  ),
//                )
//              ],),
//            ),
//          )
    ]);
  }
}
