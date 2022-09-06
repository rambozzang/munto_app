
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/liker_provider.dart';
import 'package:munto_app/model/user_data.dart';
import 'package:munto_app/model/userinfo.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

import '../../../app_state.dart';


class LikerPage extends StatefulWidget {
  @override
  _LikerPageState createState() => _LikerPageState();
}

class _LikerPageState extends State<LikerPage> {
  FeedData feedData;
  int selectedIndex = 0;

  List<UserData> likerList = [];
  LikerProvider likerProvider;


  @override
  void initState() {
    super.initState();
    likerProvider = LikerProvider();
    Future.delayed(Duration(milliseconds: 200), ()async{
      if(feedData != null){
        likerList = await likerProvider.getLikerList(feedData.id);
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;

    if(map != null && map['feedData'] != null){
      // print('map ${map.toString()}');
      feedData = map['feedData'];
    }

    return Scaffold(
      backgroundColor: MColors.white,
        appBar: AppBar(
          title: Text(
            "좋아요",
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
        ),
        body: feedData != null ? SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(
                height: 17,
              ),
              _userList(likerList),
            ],
          ),
        ): Container ());
  }

  Widget _userList(List<UserData> list) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final item = list[index];
          return Container(
            color: MColors.whiteColor,
            child: ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('UserProfilePage', arguments: item.id);
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.image),
              ),
              title: Text(item.name, style: MTextStyles.bold14Black,),
              subtitle: Text(item.introduce ?? '', style: MTextStyles.cjkMedium12PinkishGrey,),
              trailing: // Rectangle Copy
              item.id != UserInfo.myProfile.id ? Container(
                width: 60,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  border: Border.all(color: MColors.tomato, width: 1),
                  color: item.isFollow ? MColors.white : MColors.tomato,
                ),
                child:  FlatButton(
                  padding: EdgeInsets.zero,
                  child: item.isFollow
                      ? Text("팔로잉", style: MTextStyles.regular14Tomato)
                      : Text("팔로우", style: MTextStyles.medium14White,
                        ),
                  onPressed: () async{
                    print('${item.name} isFollowing = ${item.isFollow}');

                    bool result = false;
                    if (item.isFollow)
                      result = await likerProvider.deleteFollow(item.id);
                    else{
                      AppStateLog(context, FOLLOW_MEMBER, properties: {
                        'sourceId':'${item.id}',
                      });
                      result = await likerProvider.postFollow(item.id);
                    }
                    print('result = ${result}');
                    if(result)
                      setState(() {
                        item.isFollow = !item.isFollow;
                      });
                  },
                ) ,
              ) : SizedBox.shrink(),
            ),
          );
        });
  }
}
