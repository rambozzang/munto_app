import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:munto_app/model/provider/bottom_navigation_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class Error extends StatelessWidget {
  const Error({Key key, this.errorMessage, this.onRetryPressed}) : super(key: key);

  final String errorMessage;
  final Function onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 28),
            SvgPicture.asset('assets/mypage/empty_500_error_60_px.svg',
                width: 45, height: 45, fit: BoxFit.scaleDown, color: MColors.warm_grey),
            Text(
              '다시 한번 확인해주세요!',
              textAlign: TextAlign.center,
              style: MTextStyles.bold16Grey06,
            ),
            SizedBox(height: 8),
            Text(
              '지금 서버와 연결이 원활하지 않습니다.\n문제를 해결하기 위해 열심히 노력하고 있습니다.\n잠시 후 다시 확인해주세요.',
              textAlign: TextAlign.center,
              style: MTextStyles.regular14WarmGrey,
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 8),
            RaisedButton(
              color: MColors.tomato,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0),
              ),
              child: Text(
                '라운지로 이동',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){
                Provider.of<BottomNavigationProvider>(context, listen:false).setIndex(0);
              },
            ),
            onRetryPressed != null
                ? FlatButton(
                    color: Colors.transparent,
                    child: Text(
                      '새로고침',
                      style: TextStyle(
                        color: MColors.tomato,
                      ),
                    ),
                    onPressed: onRetryPressed,
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

class ErrorNotFound extends StatelessWidget {
  const ErrorNotFound({Key key, this.errorMessage}) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 28),
          SvgPicture.asset('assets/mypage/empty_400_error_60_px.svg',
              width: 45, height: 45, fit: BoxFit.scaleDown, color: MColors.warm_grey),
          Text(
            '잠시 후 다시 확인해주세요!',
            textAlign: TextAlign.center,
            style: MTextStyles.bold16Grey06,
          ),
          SizedBox(height: 8),
          Text(
            '요청하신 페이지가 사라졌거나,\n다른 페이지로 변경되었습니다.\n인기 있는 모임은 서두르셔야 신청할 수 있답니다!',
            textAlign: TextAlign.center,
            style: MTextStyles.regular14WarmGrey,
          ),
          SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: MColors.tomato,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0),
            ),
            child: Text(
              '라운지로 이동',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamed('LoungePage'),
          ),
        ],
      ),
    );
  }
}
