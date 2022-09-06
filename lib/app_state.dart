import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:munto_app/model/userinfo.dart';

import 'model/urls.dart';
import 'util.dart';

//event
const OPEN_APP = 'open app';
const CLOSE_APP = 'close app';
const SIGN_UP = 'sign up';
const LOG_IN = 'log in';
const LOG_OUT = 'log out';
const EDIT_PROFILE = 'edit profile';
const PAGEVIEW_PROFILE = 'pageview_profile';
const PAGEVIEW_MY_PROFILE = 'pageview_myprofile';

const PAGEVIEW_LOUNGE = 'pageview_lounge';
const TOTAL_SWIPES_LOUNGE = 'total swipes_lounge';
const COMMENT = 'comment';
const FOLLOW_MEMBER = 'follow member';
const CLICK_LIKE_BUTTON = 'click like button';
const UPLOAD_FEED = 'upload feed';
const UPLOAD_SOCIALING = 'upload socialing';
const PAGEVIEW_SOSIALING = 'pageview socialing';
const JOIN_SOCIALING = 'join socialing';
// const UPLOAD_FEED  = 'upload feed';
const CLICK_PLUS_BUTTON = 'click plus button';
const CLICK_WRITE_BUTTON  = 'click write button';
const PAGEVIEW_QUESTION_DETAIL = 'pageview_questiondetail';
//userProperties

Amplitude analytics;

AppStateLog(context,event,{properties}){
  try{
    if(event == PAGEVIEW_MY_PROFILE){
      Util.addSharedCount(KEY_WRITE_BUTTON_COUNT);
    }
    initAnalytics();
    analytics.logEvent(event, eventProperties: properties);
  } catch (e){}
}

AppStateSetUserId(userId){
  try{
    initAnalytics();
    analytics.setUserId(userId);
  } catch (e){}
}

AppStateSetUserProperties(properties){
  try{
    initAnalytics();
    analytics.setUserProperties(properties);
  } catch (e){}
}
initAnalytics(){
  if(analytics == null){
    analytics = Amplitude.getInstance(instanceName: kReleaseMode ? 'munto' : 'munto(test)');
    analytics.setUseDynamicConfig(true);
    analytics.setServerUrl("https://api2.amplitude.com");
    analytics.init(amplitudeKey);
    analytics.enableCoppaControl();
    analytics.trackingSessionEvents(true);
    analytics.logEvent(OPEN_APP);
  }

  if(UserInfo.myProfile != null){
    analytics.setUserId("${UserInfo.myProfile?.id ?? ''}");
    analytics.setUserProperties({
      'Total Number of Followers': '${UserInfo.myProfile?.following?.length ?? 0})',
      'Gender': '${UserInfo.myProfile?.sex ?? ''})',
      'AGE': '${UserInfo.myProfile?.age ?? ''})',
      'member_ID': '${UserInfo.myProfile?.id ?? ''})',
      'member_Email': '${UserInfo.myProfile?.email ?? ''})',
    });
  } else {
    analytics.setUserId("notLoggedInUser");
  }
}

// class AppState extends InheritedWidget {
//
//   const AppState({
//     Key key,
//     @required this.analytics,
//     @required this.setMessage,
//     @required Widget child,
//   }) : super(key: key, child: child);
//
//   final Amplitude analytics;
//   final ValueSetter<String> setMessage;
//
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     return false;
//   }
//
//   static AppState of(BuildContext context) {
//     return context.inheritFromWidgetOfExactType(AppState);
//   }
// }