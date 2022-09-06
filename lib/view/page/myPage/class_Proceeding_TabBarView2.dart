import 'package:flutter/material.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassProceedingTabBarView2 extends StatefulWidget {
  @override
  _ClassProceedingTabBarView2State createState() => _ClassProceedingTabBarView2State();
}

class _ClassProceedingTabBarView2State extends State<ClassProceedingTabBarView2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TitleBold16BlackView('1. 1회차 모임 전 타임라인', ''),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(20),
              color: MColors.white_two08,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('모임시작 ~ 모임6일 전', style: MTextStyles.regular12Grey06),
                          Text('2020.02.28까지', style: MTextStyles.bold16Tomato),
                        ],
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('각 회차 모임이후', style: MTextStyles.medium13Black_three),
                      ),
                      Container(
                        child: Text('신청 인원 확인', style: MTextStyles.bold16Black),
                      )
                    ],
                  )
                ],
              )),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('2. 문토 파트너 가이드북', ''),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('가이드북을 꼭 확인해주세요.', style: MTextStyles.medium14Grey06),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text('가이드북 보기 >', style: MTextStyles.bold14Tomato),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('3. 모임 진행 기준', ''),
          Container(
            child: Text('문토 모임은 첫 모임일 기준 5일 전까지 최소 진행인원이 충족되어야 진행됩니다.', style: MTextStyles.medium14Grey06),
          ),
          const SizedBox(
            height: 20,
          ),
          TitleBold16BlackView('4. 발제문 가이드', ''),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('문토가 첫 번째 진행과 발제에 대해 확인하고 피드백을 드립니다.', style: MTextStyles.medium14Grey06),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text('PPT 템플릿 다운받기 >', style: MTextStyles.bold14Tomato),
                ),
                Container(
                  child: Text('PPT 폰트 다운받기 >', style: MTextStyles.bold14Tomato),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
