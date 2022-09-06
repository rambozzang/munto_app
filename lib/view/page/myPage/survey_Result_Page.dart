import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/survey_Data.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/model/meeting_data.dart';

List<String> ans1 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];
List<String> ans2 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];
List<String> ans3 = ['네, 피드백을 주세요.', '아니오, 괜찮습니다.'];
List<String> ans4 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];

class SurveyResultPage extends StatefulWidget {
  @override
  _SurveyhResultPageState createState() => _SurveyhResultPageState();
}

class _SurveyhResultPageState extends State<SurveyResultPage> {
  ClassProvider classService = ClassProvider();

  final StreamController<SurveyData> _stateDataCtrl = StreamController();

  SurveyData surveyData;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    //만족도 결과
    Map<String, dynamic> map = Map();
    map['itemId'] = '1';
    map['itemRoundId'] = '1';
    surveyData = await classService.getClassSurveyResult(map);
  }

  @override
  void dispose() {
    _stateDataCtrl.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              _researchDesc(),
              const SizedBox(
                height: 25,
              ),
              _multipleChoiceQuestion('1. 오늘 모임의 만족도를 평가해주세요.', 1, ans1, '3'),
              _multipleChoiceQuestion('2. 모임을 진행한 리더분에 대한 만족도를 평가해주세요.', 2, ans2, '2'),
              _multipleChoiceQuestion('3. 모임을 진행한 파트너분에 대한 만족도를 평가해주세요. ', 3, ans3, '1'),
              _shortAnswerQuestion('4. 오늘 모임이 만족스러웠다면, 어떤 부분에서 만족스러웠나요?', '아하하하'),
              _shortAnswerQuestion('5. 오늘 모임이 만족스럽지 못했다면, 더 만족스러운 모임을 위한 의견을 들려주세요.', '아하하하'),
              _shortAnswerQuestion('6. 리더 또는 파트너 분에게 건의하고 싶은 사항이 있으신가요?', '아하하하'),
              _shortAnswerQuestion('7. 그 외, 여러분의 의견을 자유로이 남겨주세요.', '아하하하'),
              _multipleChoiceQuestion('(선택) 문지기의 피드백을 원하시나요?', 4, ans4, '3'),
            ],
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "만족도 조사 결과보기",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
    );
  }

  Widget _researchDesc() {
    return Container(
        child: Column(children: [
      Container(
          padding: EdgeInsets.all(18),
          //  color: MColors.white_two08,
          child: Column(
            children: [
              Container(
                  height: 40,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Text('번호', style: MTextStyles.regular12Grey06),
                      SizedBox(
                        width: 10,
                      ),
                      Text('0', style: MTextStyles.bold14Black),
                      SizedBox(
                        width: 30,
                      ),
                      Text('이름', style: MTextStyles.regular12Grey06),
                      SizedBox(
                        width: 10,
                      ),
                      Text('익명1', style: MTextStyles.bold14Black),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: MColors.pinkish_grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text('[1회차] 2020.03.12(수) 오후 8시 합정', style: MTextStyles.bold14Black)),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: 72, child: Text('모임 만족도', style: MTextStyles.regular14Grey06_)),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('4 점', style: MTextStyles.bold16Tomato),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: MColors.greyish,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: 72, child: Text('리더 만족도', style: MTextStyles.regular14Grey06_)),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('4 점', style: MTextStyles.bold16Tomato),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: MColors.greyish,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(width: 82, child: Text('파트너 만족도', style: MTextStyles.regular14Grey06_)),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('3 점', style: MTextStyles.bold16Tomato),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    ]));
  }

  // 객관식 문제
  Widget _multipleChoiceQuestion(String question, int qid, List<String> answerList, String answer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            question,
            style: MTextStyles.medium16Grey06,
          ),
        ),
        Column(
          children: [
            ListView.builder(
                itemCount: answerList.length,
                primary: false,
                shrinkWrap: true,
                //   scrollDirection: Axis.horizontal,
                //itemExtent: 1.0,
                //  physics: const NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 5, right: 10),
                itemBuilder: (context, position) {
                  return RadioListTile(
                    title: Text(answerList[position],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0,
                        )),
                    value: position,
                    dense: true,
                    toggleable: true,
                    activeColor: Colors.red,
                    groupValue: qid,
                    onChanged: (value) {
                      setState(() {});
                    },
                  );
                })
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  //주관식 문제
  Widget _shortAnswerQuestion(String question, String answer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            question,
            style: MTextStyles.medium16Grey06,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 5, //Normal textInputField will be displayed
            maxLines: 5, // when user presses enter it will adapt to it
            decoration: InputDecoration(
                // prefixIcon: Padding(
                //   padding: EdgeInsets.all(10.0),
                //   child: Icon(Icons.person, size: 40.0, color: Colors.grey),
                // ),
                hintText: "내용을 입력해주세요.",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(new Radius.circular(10.0))),
                labelStyle: TextStyle(color: Colors.grey)),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
            ),
            // controller: host,
            validator: (value) {
              if (value.isEmpty) {
                return "Empty value";
              }
            },
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
