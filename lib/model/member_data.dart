import 'dart:math';

class Member {
  String _userId;
  String get userId=>_userId;
  String _name;
  String _memberType;
  String _memo;
  String _userLevel;
  List<String> get tags {
    return ['디자인', '등산', '자전거'];
  }

  String get userLevel {
    if(_userId=='1') return '리더';
    if(_userId=='2') return '파트너';
    if(_userId=='3') return '문지기';
    if(_userId=='4') return '리더';
    if(_userId=='5') return '리더';
    if(_userId=='6') return '파트너';
    if(_userId=='7') return '문지기';
    if(_userId=='8') return '리더';
    if(_userId=='9')  return '리더';
    if(_userId=='10') return '파트너';
    if(_userId=='11') return '문지기';
    if(_userId=='12') return '리더';
    if(_userId=='13') return '리더';
    if(_userId=='14') return '파트너';
    if(_userId=='15') return '문지기';
    return '리더';
  }

  String get profileUrl{
    if(_userId=='1') return 'https://i.pinimg.com/originals/e5/c9/a8/e5c9a8884bc64d8b5c65564eb33b793b.jpg';
    if(_userId=='2') return 'https://cdn.pocket-lint.com/r/s/1200x630/assets/images/142207-phones-feature-what-is-apple-face-id-and-how-does-it-work-image1-5d72kjh6lq.jpg';
    if(_userId=='3') return 'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
    if(_userId=='4') return 'https://is.gd/XDDQVE';
    if(_userId=='5') return 'https://lavinephotography.com.au/wp-content/uploads/2017/01/PROFILE-Photography-112.jpg';
    if(_userId=='6') return 'https://i.pinimg.com/originals/e5/c9/a8/e5c9a8884bc64d8b5c65564eb33b793b.jpg';
    if(_userId=='7') return 'https://cdn.pocket-lint.com/r/s/1200x630/assets/images/142207-phones-feature-what-is-apple-face-id-and-how-does-it-work-image1-5d72kjh6lq.jpg';
    if(_userId=='8') return 'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
    if(_userId=='9') return 'https://is.gd/XDDQVE';
    if(_userId=='10') return 'https://lavinephotography.com.au/wp-content/uploads/2017/01/PROFILE-Photography-112.jpg';
    if(_userId=='11') return 'https://i.pinimg.com/originals/e5/c9/a8/e5c9a8884bc64d8b5c65564eb33b793b.jpg';
    if(_userId=='12') return 'https://cdn.pocket-lint.com/r/s/1200x630/assets/images/142207-phones-feature-what-is-apple-face-id-and-how-does-it-work-image1-5d72kjh6lq.jpg';
    if(_userId=='13') return 'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
    if(_userId=='14') return 'https://is.gd/XDDQVE';
    if(_userId=='15') return 'https://lavinephotography.com.au/wp-content/uploads/2017/01/PROFILE-Photography-112.jpg';
    return 'https://i.pinimg.com/originals/e5/c9/a8/e5c9a8884bc64d8b5c65564eb33b793b.jpg';
  }

  String get profileBackgroundUrl => 'https://www.gettyimages.com/gi-resources/images/500px/983703508.jpg';

  String get name{
    if(_userId=='1') return  '김이서';
    if(_userId=='2') return  '김교동';
    if(_userId=='3') return  '이환주';
    if(_userId=='4') return  '송혜미';
    if(_userId=='5') return  '전혜연';
    if(_userId=='6') return  '주용진';
    if(_userId=='7') return  '김국화';
    if(_userId=='8') return  '배수영';
    if(_userId=='9') return  '박예지';
    if(_userId=='10') return '이병희';
    if(_userId=='11') return '이석준';
    if(_userId=='12') return '서정환';
    if(_userId=='13') return '서영화';
    if(_userId=='14') return '이수민';
    if(_userId=='15') return '이현파';
    return '김문토';
  }

  Member(this._memberType, this._name,this._memo){
    final rand = Random();
    _userId = '${rand.nextInt(15)}';
  }

  Member.dummy(int num){
    _userId = '$num';
  }

}
