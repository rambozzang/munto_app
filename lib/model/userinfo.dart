
import 'package:munto_app/model/userProfile_Data.dart';
import 'package:munto_app/model/user_data.dart';

import 'const_data.dart';

class UserInfo{
  static String pushToken;
  static bool isLeader = false;
  static UserProfileData myProfile;
  static get gradeName{
    if(myProfile != null){
      switch (myProfile.grade){
        case 'GENERAL':
          return '일반';
        case 'LEADER':
          return '리더';
        case 'PARTNER':
          return '파트너';
        case 'MEMBER':
          return '멤버';
        case 'WITHDRAWAL':
          return '탈퇴';
        case 'BLACK':
          return '중단';
        case 'ADMIN':
          return '관리자';
        default:
          return '일반';
      }

    }
    return '';
  }

  static bool get needsProfileEdit {
    if(UserInfo.myProfile != null)
      if(UserInfo.myProfile.introduce == null || UserInfo.myProfile.introduce.isEmpty)
        return true;
    if(UserInfo.myProfile.image == null || UserInfo.myProfile.image.isEmpty)
      return true;
    if(UserInfo.myProfile.cover == null || UserInfo.myProfile.cover.isEmpty)
      return true;
    if(UserInfo.myProfile.interestList == null || UserInfo.myProfile.interestList.length == 0)
      return true;
    return false;
  }


  static bool get needsUserInfoEdit {
    if(UserInfo.myProfile != null)
      if(UserInfo.myProfile.phoneNumber == null || UserInfo.myProfile.phoneNumber.isEmpty || UserInfo.myProfile.phoneNumber == '010-0000-0000')
        return true;
    if(UserInfo.myProfile.name == null || UserInfo.myProfile.name.isEmpty || UserInfo.myProfile.name == '이름없음')
      return true;
    return false;
  }
}