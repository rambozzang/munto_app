
import 'package:flutter/material.dart';
import 'package:munto_app/model/meeting_data.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';


class InvitationPage extends StatefulWidget {
  @override
  _InvitationPageState createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    //내 프로필 url나중에 가져와야함
    final myProfileUrl = meetingGroupAll[3].getLeaderProfileUrl();
    final followerList = meetingGroupAll[0].applicantList;

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        SizedBox(
          height: 52,
          child: Row(children: <Widget>[
            Expanded(child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('모임초대', style: MTextStyles.bold18Black,),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(icon: Icon(Icons.close, size: 20,), onPressed: ()=> Navigator.pop(context),),
            ),
            // Rectangle
          ],),
        ),
        Container(
          height: 278,
          decoration: BoxDecoration(
              color: MColors.white_two
          ),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 18),
              child: Row(children: <Widget>[
                Text("활동중인 모임", style: MTextStyles.bold16Black),
                Padding(padding: EdgeInsets.only(right: 8),),
                Text("5건", style: MTextStyles.bold16Tomato),
              ],),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5 + 1,
                    itemBuilder: (context, index){
                      final item = meetingGroupAll[index+5];
                      if(index == 5)
                        return Container(width: 40,);
                      return Transform.translate(
                        offset: Offset(20, 0),
                        child: Container(
                          margin: EdgeInsets.only(right: 10,),
                          width: 154,
                          child: Column(
                            children: <Widget>[
                              Expanded(child:
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  height:110,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8)
                                      ),
                                      border: Border.all(
                                          color: MColors.white_three,
                                          width: 1
                                      ),
                                      color: MColors.white
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                        ),
                                        child: Image.network(item.imageUrl,width: double.infinity,
                                          height: 83,
                                          fit: BoxFit.cover,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 11),
                                        child: Text(item.meetingType,
                                            style: MTextStyles
                                                .medium12BrownishGrey),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 10),
                                        child: Text(item.title,
                                            style: MTextStyles.bold16Grey06),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text("2020.02.03 ~ 2020.04.16",
                                            style: MTextStyles.medium12BrownGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),),
                              Container(height: 47,
                                child: Radio(value: selectedIndex == index, onChanged: (bool value) {
                                  print('value$index = $value');
                                  setState(() {
                                    selectedIndex = index;
                                  });

                                }, groupValue: true,),)
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(myProfileUrl),),
            Padding(padding: EdgeInsets.only(right: 13),),
            Expanded(child: TextField(decoration: InputDecoration(
              hintText: "메시지를 입력하세요…",
              hintStyle: MTextStyles.regular16Warmgrey,
            ),))
          ],),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 37, bottom: 19),
          child: Text("251 팔로잉", style: MTextStyles.bold14Black,),
        ),
        Expanded(child: ListView.builder(
          itemCount: followerList.length,
          itemBuilder: (context, index){
            final follower = followerList[index];
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(follower.profileUrl),radius: 18,),
              title: Text(follower.name, style: MTextStyles.bold14BlackColor,),
              subtitle: Text(follower.memo, style: MTextStyles.cjkMedium12PinkishGrey,),
              trailing: // Rectangle Copy
              Container(
                  width: 60,
                  height: 36,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(18)
                      ),
                      color: MColors.tomato_10
                  ),
                child: FlatButton(child: // 초대
                Text(
                    "초대",
                    style: MTextStyles.medium14Tomato,
                    textAlign: TextAlign.center,
                ),onPressed: (){},),
              ),
            );
          },
        ))
      ],
      ),
    );
  }
}
