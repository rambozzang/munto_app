import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/login_provider.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:provider/provider.dart';

class SocialingOpenWidget extends StatefulWidget {
  const SocialingOpenWidget({
    @required this.context,
  });

  final BuildContext context;

  @override
  _SocialingOpenWidgetState createState() => _SocialingOpenWidgetState();
}

class _SocialingOpenWidgetState extends State<SocialingOpenWidget>
    with AutomaticKeepAliveClientMixin<SocialingOpenWidget> {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
      child: Opacity(
        opacity: 0.800000011920929,
        child: Container(
          height: 100,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: MColors.white_three, width: 1),
              color: MColors.white_two),
          child: ListTile(
            onTap: () {
              final loginPro =
                  Provider.of<LoginProvider>(context, listen: false);
              if (loginPro.isSnsTempUser || loginPro.isGeneralUser) {
                return;
              }
              Navigator.of(context).pushNamed('OpenSocialingPage');
            },
            title: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('소셜링 열기', style: MTextStyles.bold20Grey06)),
            subtitle: Text(
              "나와 꼭 맞는 취향을 가진 사람들을\n만날 기회 직접 만들어볼까요?",
              style: MTextStyles.regular14Grey06,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: MColors.tomato,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
