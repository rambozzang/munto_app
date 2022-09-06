import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class GuestProfilePage extends StatefulWidget {
  @override
  _GuestProfilePageState createState() => _GuestProfilePageState();
}

class _GuestProfilePageState extends State<GuestProfilePage>
    with TickerProviderStateMixin {
  TabController tabController;

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appbar(), body: _body());
  }

  AppBar _appbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [],
      elevation: 0.0,
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(children: [
        GestureDetector(
            onTap: () {
              _openshowDialog();
            },
            child: Image.asset('assets/guest.png')),
        // _buildHeader(),
        // _buildIntro(),
      ]),
    );
  }

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문토앱에 로그인하면 문토에  다양한 취향을 가진 사람들을 만나 함께 소통하고 모임에 참여할 수 있어요!',
            style: MTextStyles.regular14Grey06,
          ),
          const SizedBox(height: 15),
          Container(
            width: 55,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: MColors.white_two,
            ),
            child: Text('문토',
                style: MTextStyles.bold12Grey06, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 30),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    '팔로잉',
                    style: MTextStyles.regular10Grey06,
                  ),
                  Text('0', style: MTextStyles.medium14Grey06)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 25),
              ),
              Column(
                children: <Widget>[
                  Text('팔로워', style: MTextStyles.regular10Grey06),
                  Text('0', style: MTextStyles.medium14Grey06)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 25),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('피드', style: MTextStyles.regular10Grey06),
                    Text(
                      '0',
                      style: MTextStyles.medium14Grey06,
                    )
                  ],
                ),
              ),
              // Oval
              InkWell(
                child: SvgPicture.asset(
                  'assets/icons/message_profile.svg',
                  color: MColors.warm_grey,
                ),
                onTap: () {
                  //  Navigator.of(context).pushNamed('MessageListPage');
                  _openshowDialog();
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
              ),
              InkWell(
                child: Container(
                  width: 80,
                  height: 36,
                  decoration: BoxDecoration(
                      color: MColors.tomato,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border.all(color: MColors.tomato, width: 1)),
                  child: // 팔로우
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '팔로우',
                        textAlign: TextAlign.center,
                        style: MTextStyles.bold14White,
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  _openshowDialog();
                },
              )
            ],
          ),
          SizedBox(height: 20),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 42,
            child: OutlineButton(
                child: new Text("마이페이지", style: MTextStyles.regular14Grey06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                borderSide: BorderSide(
                  color: MColors.grey_06,
                ),
                onPressed: () {
                  _openshowDialog();
                }),
          ),
          SizedBox(height: 20),
          Container(
            color: MColors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 50,
                //   child: TabBar(
                //     controller: tabController,
                //     indicatorColor: MColors.blackColor,
                //     indicatorWeight: 2.0,
                //     labelStyle: MTextStyles.bold14Grey06,
                //     unselectedLabelStyle: MTextStyles.regular14PinkishGrey,
                //     onTap: (index) {
                //       setState(() {
                //         selectedTabIndex = index;
                //       });
                //     },
                //     tabs: [
                //       Tab(text: "피드"),
                //       Tab(text: "모임"),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            //Add this to give height
            height: 350,
            child: TabBarView(controller: tabController, children: [
              _buildFeedBottom(8),
              _buildClassBottom() // 정산내역
            ]),
          ),
        ],
      )),
    );
  }

  Widget _buildFeedBottom(length) {
    return Container(
      color: MColors.white,
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      style: const TextStyle(
                          color: MColors.black,
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      text: "0"),
                  TextSpan(
                      style: const TextStyle(
                          color: MColors.warm_grey,
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansKR",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      text: "피드")
                ])),
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset('assets/icons/view_grid.svg',
                      color: MColors.grey_06),
                  onPressed: () => null,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset('assets/icons/view_list.svg',
                      color: MColors.grey_06),
                  onPressed: () => null,
                ),
              )
            ],
          ),
          errorFeed()
        ],
      ),
    );
  }

  Widget _buildClassBottom() {
    return Container(
      color: MColors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: Container(
                  width: 144,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: MColors.pinkish_grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: '활동중인 모임',
                        items: ['활동중인 모임', '종료된 모임'].map((value) {
                          return DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) => null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          errorClass()
        ],
      ),
    );
  }

  Widget errorFeed() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 28),
          SvgPicture.asset('assets/icons/empty_feed.svg',
              width: 45,
              height: 45,
              fit: BoxFit.scaleDown,
              color: MColors.warm_grey),
          SizedBox(height: 8),
          Text(
            '좋아하는 것들을 공유하고\n취향이 통하는 사람들과 소통해 보세요.',
            textAlign: TextAlign.center,
            style: MTextStyles.regular14WarmGrey,
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: MColors.tomato,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0),
            ),
            child: SizedBox(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '첫번째 피드쓰기',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.white)
                ],
              ),
            ),
            onPressed: () => _openshowDialog(),
          ),
        ],
      ),
    );
  }

  Widget errorClass() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 28),
          SvgPicture.asset('assets/icons/empty_class.svg',
              width: 45,
              height: 45,
              fit: BoxFit.scaleDown,
              color: MColors.warm_grey),
          SizedBox(height: 8),
          Text(
            '아직 참여한 모임이 없습니다.\n문토의 다양한 모임에 참여해 보세요!',
            textAlign: TextAlign.center,
            style: MTextStyles.regular14WarmGrey,
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: MColors.tomato,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0),
            ),
            child: SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '모임 보기',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.white)
                ],
              ),
            ),
            onPressed: () => _openshowDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            height: 135,
            width: double.infinity,
            color: MColors.white,
          ),
        ),
        Positioned(
          // top: 0,
          child: Container(
            height: 95,
            width: double.infinity,
            color: MColors.tomato,
            // child: Text('MUNTO')
          ),
        ),
        Positioned(
            top: 40,
            right: 0,
            child: SvgPicture.asset(
              'assets/mypage/munto_white.svg',
              width: 24,
              height: 24,
              color: Colors.white,
              fit: BoxFit.scaleDown,
            )),
        Positioned(
          bottom: 0,
          left: 20,
          child: Container(
            width: 80.0,
            height: 80.0,
            child: Icon(Icons.person, size: 60, color: MColors.grey_05),
            // child: SvgPicture.asset(
            //   'assets/mypage/profile_none_80_px.svg',
            //   // color: MColors.grey_05,
            // ),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: MColors.white_two,
              // image: new DecorationImage(
              //   fit: BoxFit.fill,
              //   image: SvgPicture.asset(
              //     'assets/icons/message_profile.svg',
              //     color: MColors.warm_grey,
              //   ),
            ),
            // ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 112,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '반갑습니다.',
                style: MTextStyles.bold16Black,
              ),
              Text(
                '게스트',
                style: MTextStyles.regular10WarmGrey,
              ),
            ],
          ),
        )
      ],
    );
  }

  _openshowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here
          child: Container(
            height: 466,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    height: 235,
                    width: 300,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      image: new DecorationImage(
                        image: new NetworkImage(
                            'https://contents.sixshop.com/thumbnails/uploadedFiles/24016/default/image_1600423581514_2500.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ))
                ]),
                SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('로그인이 필요합니다.',
                        textAlign: TextAlign.left,
                        style: MTextStyles.regular14Grey06)),
                SizedBox(height: 6),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('취향이 통하는 사람들과\n함께 소통해보세요',
                        style: MTextStyles.bold20Grey06)),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.of(context).pushNamed('LoginPage');
                      Provider.of<LoginProvider>(context, listen: false)
                          .setIsAuth(LoginStatus.Logout);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(38)),
                        color: Color(0xfffed820),
                      ),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/kakao.svg'),
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                          ),
                          Text('카카오톡으로 나의 취향 시작하기',
                              style: MTextStyles.regular14Grey06,
                              textAlign: TextAlign.center),
                        ],
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Provider.of<LoginProvider>(context, listen: false)
                        .setIsAuth(LoginStatus.Logout);
                  },
                  child: Text(
                    '다른 방법으로 로그인',
                    style: MTextStyles.regular14Grey06_,
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
