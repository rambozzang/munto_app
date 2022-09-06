import 'package:flutter/material.dart';
import 'package:munto_app/view/style/textstyles.dart';

class ClassProceedingTabBarView4 extends StatefulWidget {
  @override
  _ClassProceedingTabBarView4State createState() => _ClassProceedingTabBarView4State();
}

class _ClassProceedingTabBarView4State extends State<ClassProceedingTabBarView4> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _budgetTitle('모임 정보'),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('모임명', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('[블랙]소셜나잇아웃', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('리더', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('김지영', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('진행일', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('2/1, 2/5, 2/14, 2/19, 3/1, 3/12', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            const SizedBox(
              height: 15
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('BudgetManagePage'),
              child: Container(
                // height: 54,
                // padding: EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: [
                    Divider(
                      color: Colors.black26,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '정산 정보 관리',
                            style: MTextStyles.medium14Grey06,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 13,
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.black26,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        _budgetTitle('지급 정보'),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('상태', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('지급대기', style: MTextStyles.bold16Tomato)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('정산일', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('2020.04.11', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('주민번호등록', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('123456-392811', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('거래은행', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('국민은행', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('계좌번호', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('392201-02-1993872', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('예금주', style: MTextStyles.medium14Grey06)),
                  Expanded(flex: 3, child: Text('김지영', style: MTextStyles.bold14Grey06)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        _budgetTitle('지급 내역'),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('정산 기준액', style: MTextStyles.medium14Grey06)),
                    Expanded(flex: 3, child: Text('50,000원', style: MTextStyles.bold14Grey06)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('해당인원', style: MTextStyles.medium14Grey06)),
                    Expanded(flex: 3, child: Text('12명', style: MTextStyles.bold14Grey06)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('정산액', style: MTextStyles.medium14Grey06)),
                    Expanded(flex: 3, child: Text('600,000원', style: MTextStyles.bold14Grey06)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('소득세', style: MTextStyles.medium14Grey06)),
                    Expanded(flex: 3, child: Text('39,392원 (정산액의 3%)', style: MTextStyles.bold14Grey06)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('지방소득세', style: MTextStyles.medium14Grey06)),
                    Expanded(flex: 3, child: Text('2,219원 (정산액의 0.3%)', style: MTextStyles.bold14Grey06)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text('차인 지급액', style: MTextStyles.bold16Tomato)),
                    Expanded(flex: 3, child: Text('542,192원', style: MTextStyles.bold16Tomato)),
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    ));
  }

   Widget _budgetTitle(text) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, textAlign: TextAlign.start, style: MTextStyles.bold18Black),
          Divider(
            color: Colors.black38,
          )
        ],
      ),
    );
  }

}