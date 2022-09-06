import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class InteractionTest extends StatefulWidget {
  @override
  _InteractionTestState createState() => _InteractionTestState();
}

class _InteractionTestState extends State<InteractionTest>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;
  final kExpandedHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print('_scrollController.offset = ${_scrollController.offset}');
    print('_scrollOpacity = $_scrollOpacity');

    return Scaffold(
//      body: NestedScrollView(
//        controller: _scrollController,
//        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//          return [
//            SliverAppBar(
//              flexibleSpace: FlexibleSpaceBar(
//                title: Align(
//                  alignment: Alignment.topCenter,
//                  child: Text('테스트 '),
//                ),
//                centerTitle: true,
//                titlePadding: EdgeInsets.symmetric(
//                    vertical: 16.0, horizontal: _horizontalTitlePadding),
//              ),
//              expandedHeight: kExpandedHeight,
//              pinned: true,
//            )
//          ];
//        },
//        body:
//          SingleChildScrollView(
//            child: Column(
//              children: [
//                Container(color: Colors.blue, height: 200,),
//                Container(color: Colors.yellow, height: 200,),
//                Container(color: Colors.greenAccent, height: 200,),
//                Container(color: Colors.redAccent, height: 200,),
//                Container(color: Colors.blue, height: 200,),
//                Container(color: Colors.yellow, height: 200,),
//                Container(color: Colors.greenAccent, height: 200,),
//                Container(color: Colors.redAccent, height: 200,),
//
//              ],
//            ),
//          ),
//      ),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: 100,
                    color: Colors.lightBlue,
                  ),
                );
              },
              childCount: 20,
            ),
          ),
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {},
            ),
            title: Text('123'),
            // flexibleSpace: _buildFlexibleSpace(),
            flexibleSpace: _buildSizedBoxSpace(),
            pinned: true,
            centerTitle: true,
            // expandedHeight: kExpandedHeight + 200,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(44.0),
              child: TabBar(
                labelPadding: EdgeInsets.only(left: 10, right: 10),
                labelStyle: MTextStyles.bold16Tomato,
                unselectedLabelStyle: MTextStyles.bold16PinkishGrey,
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: MColors.tomato),
                  insets: EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                ),
                tabs: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 6.0),
                      height: 30.0,
                      child: Text(
                        '라운지',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 6.0),
                      height: 30.0,
                      child: Text(
                        '소셜링',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 6.0),
                      height: 30.0,
                      child: Text(
                        '모임',
                      )),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 6.0),
                      height: 30.0,
                      child: Text(
                        '마켓',
                      ))
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    height: 100,
                    color: Colors.lightBlue,
                  ),
                );
              },
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }

  double get _scrollOpacity {
    if (_scrollController.hasClients) {
      if (_scrollController.offset < 0) return 1.0;
      if (_scrollController.offset > kExpandedHeight) return 0.0;
      double opacity = 1.0 - (_scrollController.offset / kExpandedHeight);
      if (opacity < 0.5) return opacity * 0.8;
      return opacity;
    }
    return 0.0;
  }

  double get _horizontalTitlePadding {
    const kBasePadding = 30.0;
    const kMultiplier = 0.5;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
//        print('kBasePadding1 = $kBasePadding');
        return kBasePadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
//        print('kBasePadding2 = ${(kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +kBasePadding}');
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }

      // In case 0%-50% of the expanded height is viewed
//      print('kBasePadding3 = ${(_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +kBasePadding}');
      return (_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding;
    }

//    print('kBasePadding4 = $kBasePadding');

    return kBasePadding;
  }

  Widget _buildFlexibleSpace() {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 44.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/icons/notification.svg'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('NotificationPage');
                  },
                ),
                Image.network(
                  'https://www.popsci.com/resizer/QgEMm6gNVXFYEFCmonq-Tp9_D7g=/760x506/cloudfront-us-east-1.images.arcpublishing.com/bonnier/3NIEQB3SFVCMNHH6MHZ42FO6PA.jpg',
                  fit: BoxFit.cover,
                ),
                Text('123122423423423'),
                Text('123122423423423'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      child: SizedBox(
                        width: 30 * 2.0,
                        height: 30 * 2.0,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(''),
                              radius: 30,
                            ),
                            SvgPicture.asset(
                              'assets/icons/profile_edit.svg',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 9),
                    ),
                    Expanded(
                        child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '\n',
                          style: MTextStyles.bold18Black,
                        ),
                        TextSpan(
                          text: '멤버',
                          style: MTextStyles.regular10WarmGrey,
                        )
                      ]),
                    )),
                    Padding(
                      padding: EdgeInsets.only(right: 14, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child: Image.asset('assets/ico_profile_facebook.png'),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 14, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child:
                              Image.asset('assets/ico_profile_instagram.png'),
                          onTap: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0, bottom: 4),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          child: Image.asset('assets/ico_profile_url.png'),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                Text('123122423423423'),
              ],
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: _horizontalTitlePadding),
    );
  }

  Widget _buildSizedBoxSpace() {
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/notification.svg'),
            onPressed: () {
              Navigator.of(context).pushNamed('NotificationPage');
            },
          ),
          Image.network(
            'https://www.popsci.com/resizer/QgEMm6gNVXFYEFCmonq-Tp9_D7g=/760x506/cloudfront-us-east-1.images.arcpublishing.com/bonnier/3NIEQB3SFVCMNHH6MHZ42FO6PA.jpg',
            fit: BoxFit.cover,
          ),
          Text('123122423423423'),
          Text('123122423423423'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: SizedBox(
                  width: 30 * 2.0,
                  height: 30 * 2.0,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(''),
                        radius: 30,
                      ),
                      SvgPicture.asset(
                        'assets/icons/profile_edit.svg',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(right: 9),
              ),
              Expanded(
                  child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '\n',
                    style: MTextStyles.bold18Black,
                  ),
                  TextSpan(
                    text: '멤버',
                    style: MTextStyles.regular10WarmGrey,
                  )
                ]),
              )),
              Padding(
                padding: EdgeInsets.only(right: 14, bottom: 4),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: InkWell(
                    child: Image.asset('assets/ico_profile_facebook.png'),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 14, bottom: 4),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: InkWell(
                    child: Image.asset('assets/ico_profile_instagram.png'),
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0, bottom: 4),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: InkWell(
                    child: Image.asset('assets/ico_profile_url.png'),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
          Text('123122423423423'),
        ],
      ),
    );
  }
}
