import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/feed_detail_provider.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/model/provider/order_Provider.dart';
import 'package:munto_app/view/page/communityPage/community_detail.dart';
import 'package:munto_app/view/page/communityPage/community_list_page.dart';
import 'package:munto_app/main.dart';
import 'package:munto_app/view/page/feedPage/feed_detail_page.dart';
import 'package:munto_app/view/page/feedPage/feed_page.dart';
import 'package:munto_app/view/page/feedPage/feed_photo_select_page.dart';
import 'package:munto_app/view/page/feedPage/feed_write_page.dart';
import 'package:munto_app/view/page/galleryPage/guest_profile_page.dart';
import 'package:munto_app/view/page/etcPage/guide_page.dart';
import 'package:munto_app/view/page/etcPage/liker_page.dart';
import 'package:munto_app/view/page/loginPage/login_page2.dart';
import 'package:munto_app/view/page/lounge_page.dart';
import 'package:munto_app/view/page/meetingPage/meetingDetailPage.dart';
import 'package:munto_app/view/page/meetingPage/mettingMpassListPage.dart';
import 'package:munto_app/view/page/messagePage/message_List_page.dart';
import 'package:munto_app/view/page/messagePage/message_detail_page.dart';
import 'package:munto_app/view/page/messagePage/message_new_page.dart';
import 'package:munto_app/view/page/myPage/budget_Manage_Page.dart';
import 'package:munto_app/view/page/myPage/coupon_Page.dart';
import 'package:munto_app/view/page/myPage/class_%20Proceeding_Page.dart';
import 'package:munto_app/view/page/myPage/class_%20Recruiting_Page.dart';
import 'package:munto_app/view/page/myPage/class_Manage_Page.dart';
import 'package:munto_app/view/page/myPage/reader_Reg_Page.dart';
import 'package:munto_app/view/page/myPage/reviews_write_page.dart';
import 'package:munto_app/view/page/myPage/survey_Result_Page.dart';
import 'package:munto_app/view/page/myPage/token_info_page.dart';
import 'package:munto_app/view/page/myPage/user_Modify_Page.dart';
import 'package:munto_app/view/page/myPage/reserve_money_page.dart';
import 'package:munto_app/view/page/myPage/invite_Page.dart';
import 'package:munto_app/view/page/myPage/class_List_Page.dart';
import 'package:munto_app/view/page/myPage/myMain_Page.dart';
import 'package:munto_app/view/page/myPage/zzim_List_Page.dart';
import 'package:munto_app/view/page/orderPage/order_List_Page.dart';
import 'package:munto_app/view/page/orderPage/order_Page.dart';
import 'package:munto_app/view/page/orderPage/order_Completed_Page.dart';
import 'package:munto_app/view/page/orderPage/payment_List_Detail_Page.dart';
import 'package:munto_app/view/page/orderPage/payment_List_page.dart';
import 'package:munto_app/view/page/userPage/my_profile_page.dart';
import 'package:munto_app/view/page/myPage/survey_Detail_Page.dart';
import 'package:munto_app/view/page/myPage/survey_Page.dart';
import 'package:munto_app/view/page/myPage/reviews_Page.dart';
import 'package:munto_app/view/page/userPage/email_find_Page.dart';
import 'package:munto_app/view/page/userPage/email_find_success_Page.dart';
import 'package:munto_app/view/page/userPage/password_find_Page.dart';
import 'package:munto_app/view/page/userPage/password_notfind_Page.dart';
import 'package:munto_app/view/page/userPage/password_reset_Page.dart';
import 'package:munto_app/view/page/loginPage/signup_page.dart';
import 'package:munto_app/view/page/socialingPage/Socialing_detail_Page.dart';
import 'package:munto_app/view/page/socialingPage/open_socialing_page.dart';
import 'package:munto_app/view/page/userPage/user_find_main_Page.dart';
import 'package:munto_app/view/page/userPage/user_profile_page.dart';
import 'package:munto_app/view/page/etcPage/write_tag_page.dart';
import 'package:munto_app/view/page/userPage/notification_page.dart';
import 'package:provider/provider.dart';

import 'model/provider/feed_write_provider.dart';
import 'model/provider/other_user_profile_provider.dart';
import 'model/userinfo.dart';
import 'view/page/loginPage/login_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic arguments = settings.arguments;

    // print('Router.settings.name = >  ${settings.name}');
    // print('Router.settings.arguments = >  ${settings.arguments}');

    switch (settings.name) {
      case 'LoungePage':
        return CupertinoPageRoute(builder: (_) => LoungePage());
      case 'LoginPage':
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case 'MyPage':
        return CupertinoPageRoute(builder: (_) => MyMainPage());
      case 'ClassListPage':
        return CupertinoPageRoute(builder: (_) => ClassListPage());
      case 'ReviewsPage':
        return CupertinoPageRoute(builder: (_) => ReviewsPage());
      case 'SurveyPage':
        return CupertinoPageRoute(builder: (_) => SurveyPage());
      case 'InvitePage':
        return CupertinoPageRoute(builder: (_) => InvitePage());
      case 'SurveyDetailPage':
        return CupertinoPageRoute(builder: (_) => SurveyDetailPage());

      case 'FeedWritePage':
        return CupertinoPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<FeedWriteProvider>(
                create: (_) => FeedWriteProvider(),
                child: FeedWritePage(
                  tags: arguments != null ? arguments['tags'] : [],
                )));

      case 'WriteTagPage':
        return CupertinoPageRoute(builder: (_) => WriteTagPage([]));

      case 'ReviewsWritePage':
        return CupertinoPageRoute(
            builder: (_) => ReviewsWritePage(
                  writableReviewsData: arguments[0],
                  reviewData: arguments[1],
                  isEdit: arguments[2],
                ));

      case 'CustomerModifyPage':
        return CupertinoPageRoute(builder: (_) => CustomerModifyPage());
      case 'CouponPage':
        return CupertinoPageRoute(builder: (_) => CouponPage());

      case 'PaymentListPage':
        return CupertinoPageRoute(builder: (_) => PaymentListPage());
      case 'ReserveMoneyPage':
        return CupertinoPageRoute(builder: (_) => ReserveMoneyPage());
      case 'ClassManagePage':
        return CupertinoPageRoute(builder: (_) => ClassManagePage());
      case 'ReaderRegPage':
        return CupertinoPageRoute(builder: (_) => ReaderRegPage());

      case 'BudgetManagePage':
        return CupertinoPageRoute(builder: (_) => BudgetManagePage());
      case 'ClassRecruitingPage':
        return CupertinoPageRoute(
            builder: (_) => ClassRecruitingPage(arguments));
      case 'ClassProceedingPage':
        return CupertinoPageRoute(
            builder: (_) => ClassProceedingPage(map: arguments));

      case 'SurveyResultPage':
        return CupertinoPageRoute(builder: (_) => SurveyResultPage());

      case 'OpenSocialingPage':
        return CupertinoPageRoute(builder: (_) => OpenSocialingPage());

      case 'MessageListPage':
        return CupertinoPageRoute(builder: (_) => MessageListPage());

      case 'MessageDetailPage':
        return CupertinoPageRoute(
            builder: (_) => MessageDetailPage(
                  userProfileData: arguments,
                ));
      case 'MessageNewPage':
        return CupertinoPageRoute(builder: (_) => MessageNewPage());

      case 'MyProfilePage':
        return CupertinoPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) =>
                      OtherUserProfileProvider('${UserInfo.myProfile.id}'),
                  child: MyProfilePage(),
                ));
      case 'FeedPage':
        return CupertinoPageRoute(builder: (_) => FeedPage());
      case 'LikerPage':
        return CupertinoPageRoute(
            settings: settings, builder: (_) => LikerPage());
      case 'NotificationPage':
        return CupertinoPageRoute(builder: (_) => NotificationPage());
      case 'CommunityListPage':
        return CupertinoPageRoute(builder: (_) => CommunityListPage());
      // case 'CommunityDetailPage':
      //   return CupertinoPageRoute(builder: (_) => CommunityDetailPage(arguments[0], arguments[1], arguments[2]));
      case 'TokenInfoPage':
        return CupertinoPageRoute(builder: (_) => TokenInfoPage());
      case 'LoginPage2':
        return CupertinoPageRoute(builder: (_) => LoginPage2());
      case 'SignUpPage':
        return CupertinoPageRoute(builder: (_) => SignUpPage());
      case 'Main':
        return CupertinoPageRoute(builder: (_) => Main());
      case 'SocialingDetailPage':
        return CupertinoPageRoute(
            builder: (_) => SocialingDetailPage(socialingData: arguments));
      case 'GuidePage':
        return CupertinoPageRoute(builder: (_) => GuidePage());
      case 'GuestProfilePage':
        return CupertinoPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) =>
                      OtherUserProfileProvider('${UserInfo.myProfile.id}'),
                  child: GuestProfilePage(),
                ));
      case 'PasswordFindPage':
        return CupertinoPageRoute(builder: (_) => PasswordFindPage());
      case 'PasswordNofindPage':
        return CupertinoPageRoute(builder: (_) => PasswordNofindPage());
      case 'PasswordResetPage':
        return CupertinoPageRoute(
            builder: (_) => PasswordResetPage(map: arguments));
      case 'UserFindMainPage':
        return CupertinoPageRoute(builder: (_) => UserFindMainPage());
      case 'EmailFindPage':
        return CupertinoPageRoute(builder: (_) => EmailFindPage());
      case 'EmailFindSuccessPage':
        return CupertinoPageRoute(
            builder: (_) => EmailFindSuccessPage(
                  joineMail: arguments,
                ));
      case 'FeedDetailPage':
        return CupertinoPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) =>
                      FeedDetailProvider(arguments['feed'] as FeedData),
                  child: FeedDetailPage(arguments['feed'] as FeedData,
                      scrollOffset: arguments['scrollOffset'] as double),
                ));
      case 'UserProfilePage':
        return CupertinoPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => OtherUserProfileProvider(arguments.toString()),
                  child: UserProfilePage(),
                ));
      case 'MeetingDetailPage':
        return CupertinoPageRoute(
            builder: (_) => MeetingDetailPage(
                  id: arguments[0],
                  title: arguments[1],
                  isMPASS: arguments[2],
                ));

      case 'MeetingMpassListPage':
        return CupertinoPageRoute(builder: (_) => MeetingMpassListPage());

      case 'OrderListpage':
        return CupertinoPageRoute(builder: (_) => OrderListpage());

      case 'ZzimListPage':
        return CupertinoPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<OrderProver>(
                create: (_) => OrderProver(), child: ZzimListPage()));
      //return CupertinoPageRoute(builder: (_) => ZzimListPage());

      case 'OrderPage':
        return CupertinoPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<OrderProver>(
                create: (_) => OrderProver(), child: OrderPage(arguments)));
      //return CupertinoPageRoute(builder: (_) => OrderPage(arguments));
      case 'OrderCampletedPage':
        return CupertinoPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider<OrderProver>(
                create: (_) => OrderProver(),
                child: OrderCampletedPage(arguments)));
      //return CupertinoPageRoute(builder: (_) => OrderCampletedPage(arguments));
      case 'PaymentListDetailPage':
        return CupertinoPageRoute(builder: (_) => PaymentListDetailPage());

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('lib/route.dart에 정의되지 않은 페이지입니다.'),
                  ),
                ));
    }
  }
}
