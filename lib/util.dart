import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:munto_app/model/fcm_message_main_data.dart';
import 'package:munto_app/model/provider/feed_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//const _key = 'Z%k3PdDx<X[FWaV!';

const KEY_EMAIL = 'email';
const KEY_PASSWORD = 'password';
const KEY_TOKEN = 'token';
const KEY_ACCESS_TOKEN = 'accessToken';
const KEY_LOGIN_PROVIDER = 'loginProvider';
const KEY_PERMISSION_INFO_SHOWN = 'hasPermissionInfoShown';
const KEY_AGREEMENT_CONFIRMED = 'hasConfirmedAgreement';
const KEY_ADMIN_TEST = 'adminTestMode';
const GUEST_YN = 'guestYn';
const KEY_PUSH_ALLOWED = 'pushAllowed';
const KEY_WRITE_BUTTON_COUNT = 'writeButtonCount';

const int MAXIMUN_SEC = 60;
const int MAXIMUN_MIN = 60;
const int MAXIMUN_HOUR = 24;
const int MAXIMUN_DAY = 31;
const int MAXIMUN_DAY_MONTH = 365;

class Util {
  /*AES 인코딩 함수
  20.09.21. 이경준
  * */
  static String encodeAES(String source) {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(source, iv: iv);

    return encrypted.base64;
  }

  /*AES 디코딩 함수
  20.09.21. 이경준
  * */
  static String decodeAES(String encoded) {
    final encrypted = encrypt.Encrypted.from64(encoded);
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt(encrypted, iv: iv);
  }

  static Future<void> setSharedString(String key, value) async {
    if (key != null && value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  static Future<String> getSharedString(String key) async {
    if (key != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    return null;
  }

  static Future<void> setSharedInt(String key, value) async {
    if (key != null && value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    }
  }

  static Future<int> getSharedInt(String key) async {
    if (key != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    }
    return null;
  }

  static Future<void> addSharedCount(String key) async {
    if (key != null) {
      int a = await Util.getSharedInt(key) ?? 0;
      setSharedInt(key, ++a);
    }
  }

  static void delSharedString(String key) async {
    try {
      if (key != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
      }
    } on Exception {
      print('delExceptioni');
    }
  }

  static void allDeleteSharedString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String dateString(DateTime dateTime) {
    final now = DateTime.now();
    //미래는 표시하지 않음
    if (dateTime.isAfter(now)) return '';

    final difference = now.difference(dateTime);
    if (difference.inSeconds < MAXIMUN_SEC) return '${difference.inSeconds}초 전';
    if (difference.inMinutes < MAXIMUN_MIN) return '${difference.inMinutes}분 전';
    if (difference.inHours < MAXIMUN_HOUR) return '${difference.inHours}시간 전';
    if (difference.inDays < MAXIMUN_DAY) return '${difference.inDays}일 전';
    if (difference.inDays < MAXIMUN_DAY_MONTH)
      return '${(difference.inDays / 30).round()}달 전';

    return '${(difference.inDays / 365).round()}년 전';
  }

  // class 의 classType의 이름 가져오기
  static String getClassTypeName(String nm) {
    String val = nm.toUpperCase();

    switch (val) {
      case 'ITEM':
        return '정기모임';
      case 'SOCIALING':
        return '소셜링';
      default:
        return '정기모임';
    }
  }

  // class 의 classType의 이름 가져오기
  // LEADER, PARTNER, MEMBER, WITHDRAWAL, BLACK
  static String getGradeName(String nm) {
    switch (nm) {
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

  // TextFormfield validator 사용
  static String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return '정확한 Email 주소를 입력해주세요!';
    else
      return null;
  }

  static String validatePassword(String value) {
    Pattern pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,15}$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return '영문/숫자/6~15자리로 입력해주세요!';
    else
      return null;
  }

  // rest api 데이트 타입을 2020.01.01 포멧으로 변환
  static String getDateYmd(value) {
    try {
      return DateFormat('yyyy.MM.dd').format(DateTime.parse(value));
    } catch (e) {}
    return '';
  }

  static String getDateYmdE(value) {
    try {
      final date = DateTime.parse(value);
      return '${DateFormat('yyyy.MM.dd').format(date)}(${getWeekDayInt(date.weekday)})';
    } catch (e) {}
    return '';
  }

  static String getLocalizedHour(value) {
    try {
      final date = DateTime.parse(value);
      return '${getTypeOfTime(date)}${date.hour % 12}시';
    } catch (e) {}
    return '';
  }

  static void showCenterFlash({
    BuildContext context,
    FlashPosition position,
    FlashStyle style,
    Alignment alignment,
    String text,
  }) {
    showFlash(
      context: context,
      duration: Duration(milliseconds: 3200),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: MColors.black_three,
          borderRadius: BorderRadius.circular(13.0),
          borderColor: MColors.black_three,
          position: position,
          style: style,
          alignment: alignment,
          margin: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                text,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        print('showCenterFlash : ${_.toString()}');
      }
    });
  }

  static void showToast(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('$text'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  //1.2 (월) 오전1시
  static String getFormattedday1(String startDate) {
    try {
      DateTime startDateTime = DateTime.parse(startDate).toLocal();

      return '${startDateTime.month}.${startDateTime.day} (${Util.getWeekDayInt(startDateTime.weekday)})' +
          '${getTypeOfTime(startDateTime)} ${getHour(startDateTime)}시';
    } catch (e) {}

    return '';

    // return startDate.substring(5, 7) +
    //     '.' +
    //     startDate.substring(8, 10) +
    //     '(' +
    //     getWeekDay(DateFormat('EEEE').format(DateTime.parse(startDate))) +
    //     ')' +
    //     getTypeOfTime(DateTime.parse(startDate)) +
    //     getHour(DateTime.parse(startDate)) +
    //     '시';
  }

  //  날짜 : 2020.04.05(화)오전 7시
  static String getFormattedday2(String startDate) {
    try {
      DateTime startDateTime = DateTime.parse(startDate).toLocal();

      return '${startDateTime.year}.${startDateTime.month}.${startDateTime.day} (${Util.getWeekDayInt(startDateTime.weekday)})' +
          '${getTypeOfTime(startDateTime)} ${getHour(startDateTime)}시';
    } catch (e) {}

    return '';
  }

  //  날짜 : 2020.04.05(화)오전 7시
  static String getFormattedday3(String startDate) {
    try {
      DateTime startDateTime = DateTime.parse(startDate).toLocal();

      return '${startDateTime.year}.${startDateTime.month}.${startDateTime.day}(${Util.getWeekDayInt(startDateTime.weekday)})' +
          '${getTypeOfTime(startDateTime)}${getHour(startDateTime)}:${getMinite(startDateTime)}:${getSecond(startDateTime)}';
    } catch (e) {}

    return '';
  }

  static getMoneyformat(price) {
    if (price == '') {
      return '0';
    }
    if (price.toString() == '0') {
      return '0';
    }
    return NumberFormat('###,###,###,###')
        .format(price ?? '0')
        .replaceAll(' ', '');
  }

  static String getFormattedTime(DateTime selectedTime) {
    if (selectedTime != null) {
      return '${Util.getTypeOfTime(selectedTime)}${selectedTime.hour % 12}시 ${selectedTime.minute}분';
    }
    return '';
  }

  static String getWeekDay(String format) {
    switch (format) {
      case 'Monday':
        return '월';
      case 'Tuesday':
        return '화';
      case 'Wednesday':
        return '수';
      case 'Thursday':
        return '목';
      case 'Friday':
        return '금';
      case 'Saturday':
        return '토';
      case 'Sunday':
        return '일';
      default:
        return '-';
    }
  }

  static String getWeekDayInt(int weekDay) {
    switch (weekDay) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }

  static String getTypeOfTime(DateTime parse) {
    String typeOfTime = parse.hour < 12 ? '오전 ' : '오후 ';
    return typeOfTime;
  }

  static String getHour(DateTime parse) {
    int hour = parse.hour < 12 ? parse.hour : parse.hour - 12;
    return hour.toString();
  }

  static String getMinite(DateTime parse) {
    int minute = parse.minute < 60 ? parse.minute : parse.minute - 60;
    return minute.toString();
  }

  static String getSecond(DateTime parse) {
    int second = parse.second < 60 ? parse.second : parse.second - 60;
    return second.toString();
  }

  static Future<bool> showSimpleDialog(context, String content,
      String confirmText, VoidCallback onConfirm) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  content,
                  style: MTextStyles.regular16Black_04,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 17),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onConfirm();
                          },
                          child: Text(
                            confirmText,
                            style: MTextStyles.bold14Tomato,
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
    return result;
  }

  static Future<bool> showOneButtonDialog(context, String title, String content,
      String confirmText, VoidCallback onConfirm) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  title,
                  style: MTextStyles.bold16Black,
                ),
                SizedBox(height: 6),
                Text(
                  content,
                  style: MTextStyles.regular13Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 17),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onConfirm();
                          },
                          child: Text(
                            confirmText,
                            style: MTextStyles.bold14Tomato,
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
    return result;
  }

  static Future<bool> showNegativeDialog(context, String title,
      String negativeText, VoidCallback onNegative) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  title,
                  style: MTextStyles.medium16Black,
                ),
                SizedBox(height: 17),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Text(
                            '취소',
                            style: MTextStyles.bold14Grey06,
                          ),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onNegative();
                          },
                          child: Text(
                            negativeText,
                            style: MTextStyles.bold14Tomato,
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
    return result;
  }

  // firebase alram  kind 네비
  static String getNavibyFirebaseKind(String nm) {
    switch (nm) {
      case 'GO_TO_FEED':
        return 'FeedDetailPage';
        break;
      case 'GO_TO_FEED_COMMENT':
        return 'FeedDetailPage';
        break;
      case 'GO_TO_MESSAGE_ROOM':
        return 'MessageListPage';
        break;
      case 'GO_TO_PROFILE':
        return 'UserProfilePage';
        break;
      case 'GO_TO_COMMUNITY':
        return 'CommunityListPage';
        break;
      //TODO : 아래 링크 설정해야함
      // case 'GO_TO_DETAIL_CLASS':
      // return 'CommunityDetailPage';
      // break;
      case 'GO_TO_ORDER_LIST':
        return '';
        break;
      case 'GO_TO_BASKET':
        return '';
        break;
      case 'GO_TO_MYPAGE':
        return 'MyPage';

      default:
        return '';
    }
  }

  static Future<bool> showNegativeDialog2(context, String title, String content,
      String negativeText, VoidCallback onNegative) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  title,
                  style: MTextStyles.medium16Black,
                ),
                SizedBox(height: 6),
                Text(
                  content,
                  style: MTextStyles.medium14Grey06,
                ),
                SizedBox(height: 17),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Text(
                            '취소',
                            style: MTextStyles.bold14Grey06,
                          ),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onNegative();
                          },
                          child: Text(
                            negativeText,
                            style: MTextStyles.bold14Tomato,
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
    return result;
  }

  static Future<bool> showNegativeDialog3(context, String title, String content,
      String negativeText, VoidCallback onNegative) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  title,
                  style: MTextStyles.appleMedium19Black,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 6.0, bottom: 17.0),
                  child: Text(
                    content,
                    style: MTextStyles.cjk13Black_008,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Text(
                            '다음에',
                            style: MTextStyles.cjkRegular16Grey06,
                          ),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onNegative();
                          },
                          child: Text(
                            negativeText,
                            style: MTextStyles.cjkBold16Tomato,
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
    return result;
  }

  static Future<bool> showNegativeDialog4(
      context,
      String title,
      String content,
      String positiveText,
      String negativeText,
      VoidCallback onPositive,
      VoidCallback onNegative) async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 23),
                Text(
                  title,
                  style: MTextStyles.appleMedium19Black,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 6.0, bottom: 17.0),
                  child: Text(
                    content,
                    style: MTextStyles.cjk13Black_008,
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(height: 0),
                Container(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onPositive();
                          },
                          child: Text(
                            positiveText,
                            style: MTextStyles.cjkRegular14Grey06,
                          ),
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            onNegative();
                          },
                          child: Text(
                            negativeText,
                            style: MTextStyles.cjkBold14Tomato,
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
    return result;
  }

  static String getCategoryName1(String itemSubject) {
    if (categoryDic1[itemSubject] != null) return categoryDic1[itemSubject];
    return '';
  }

  static String getCategoryName2(String itemSubject) {
    if (categoryDic2[itemSubject] != null) return categoryDic2[itemSubject];
    return '';
  }

  static const categoryDic1 = {
    'WRITE': '글쓰기',
    'CAREER': '커리어',
    'INVESTMENT': '재테크',
    'CULTUREART': '문화/예술',
    'MUSIC': '음악',
    'FOOD': '푸드',
    'MOVIE': '영화',
    'DRINK': '드링크',
    'SOCIAL': '소셜',
    'PASS': '패스'
  };
  static const categoryDic2 = {
    'ESSAY': '에세이',
    'COPYWRITING': '카피라이팅',
    'POEM': '시',
    'NOVEL': '소설',
    'WEBNOVEL': '웹소설',
    'MARKETING': '마케팅',
    'MANAGEMENT': '경영',
    'BRANDING': '브렌딩',
    'SELF_IMPROVEMENT': '자기계발',
    'OPERATION': '운영',
    'INVESTMENT_TECH': '재테크',
    'REALESTATE': '부동산',
    'INVESTMENT': '투자',
    'ASSET_MANAGEMENT': '자산운용',
    'ART': '미술',
    'READING': '독서',
    'PUBLISHING': '독립출판',
    'ARCHITECTURE': '건축',
    'CITY': '도시',
    'PSYCHOLOGY': '심리',
    'ACTING': '연기',
    'BEAUTY': '뷰티',
    'HEALTH': '헬스',
    'PHOTO': '사진',
    'JAZZ': '재즈',
    'CLASSIC': '클래식',
    'WRITING': '작사',
    'MUSIC_DISCUSSION': '토론',
    'COOK': '요리',
    'PAIRING': '페어링',
    'DAINTY_FOOD': '미식',
    'MOVIE_DISCUSSION': '영화토론',
    'SOUNDTRACK': '영화음악',
    'DOCU': '다큐',
    'WINE': '와인',
    'BEER': '맥주',
    'LIQUOR': '양주',
    'COCKTAIL': '칵테일',
    'TRADITIONAL_LIQUOR': '전통주',
    'SAKE': '사케',
    'COFFEE': '커피',
    'PREFERENCE': '취향',
    'TALKING': '토킹',
    'HANGOUT': '행아웃',
    'ONLINE': '온라인',
    'MEMBERSHIP': '멤버십',
    'SNO_MPASS': 'SNO M패스',
    'MPASS': 'M패스'
  };

  static void showGeneralUserDialog(context) {
    Util.showOneButtonDialog(
        context,
        '문토는 멤버십 전용 서비스 입니다',
        '문토 멤버십에 가입하면 모든 서비스를 정상적으로 이용할 수 있습니다. 나에게 꼭 맞는 모임을 찾아 신청해 보세요!',
        '확인',
        () {});
  }
}

// Textformfield 숫자 자동 셋팅
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("#,###");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
