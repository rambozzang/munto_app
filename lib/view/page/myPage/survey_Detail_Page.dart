import 'package:flutter/material.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/model/meeting_data.dart';

class SurveyDetailPage extends StatefulWidget {
  @override
  _SurveyDetailPageState createState() => _SurveyDetailPageState();
}

List<String> ans1 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];
List<String> ans2 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];
List<String> ans3 = ['네, 피드백을 주세요.', '아니오, 괜찮습니다.'];
List<String> ans4 = ['매우 만족스러웠다.', '비교적 만족스러웠다.', '그저 그랬다.', '비교적 만족스럽지 못했다.', '전혀 만족스럽지 못했다.'];

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              _meetingBox(),
              const SizedBox(
                height: 5,
              ),
              _researchDesc(),
              const SizedBox(
                height: 25,
              ),
              _multipleChoiceQuestion('1. 오늘 모임의 만족도를 평가해주세요.', 1, ans1),
              _multipleChoiceQuestion('2. 모임을 진행한 리더분에 대한 만족도를 평가해주세요.', 2, ans2),
              _multipleChoiceQuestion('3. 모임을 진행한 파트너분에 대한 만족도를 평가해주세요. ', 3, ans3),
              _shortAnswerQuestion('4. 오늘 모임이 만족스러웠다면, 어떤 부분에서 만족스러웠나요?'),
              _shortAnswerQuestion('5. 오늘 모임이 만족스럽지 못했다면, 더 만족스러운 모임을 위한 의견을 들려주세요.'),
              _shortAnswerQuestion('6. 리더 또는 파트너 분에게 건의하고 싶은 사항이 있으신가요?'),
              _shortAnswerQuestion('7. 그 외, 여러분의 의견을 자유로이 남겨주세요.'),
              _multipleChoiceQuestion('(선택) 문지기의 피드백을 원하시나요?', 4, ans4),
              _researchDesc2(),
            ],
          ),
        ));
  }

  Widget _appBar() {
    return new AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: MTextStyles.medium14WarmGrey,
              )),
          Center(
            child: Text(
              '만족도조사',
              style: MTextStyles.bold16Black2,
            ),
          ),
          FlatButton(
            child: Text(
              '완료',
              style: MTextStyles.bold14WarmGrey,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _meetingBox() {
    double sizeWidth = 360 / MediaQuery.of(context).size.width;
    double aa = 20.0 / sizeWidth;
    print(aa);
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // ClassMiddleBox(meetingGroupAll[0]),
        ],
      ),
    );
  }

  Widget _researchDesc() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: new Text(
          "안녕하세요, 소셜 살롱 문토입니다.취향이 통하는 사람들과의 모임, 만남 어떠셨나요?\n\n지금 참여하시는 모임을 보다 더 나은 모임으로 만들기 위해, 그리고 문토의 다음 모임이 보다 더 좋아질 수 있게 여러분의 생각을 들려주세요. \n\n여러분의 의견이, '계속해서 함께 하고 싶은' 문토를 만드는데 큰 힘이 됩니다. 멤버 분들의 많은 의견 기다리겠습니다.",
          style: MTextStyles.medium16Grey06,
        ));
  }

  Widget _researchDesc2() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text('소중한 의견 감사합니다.', style: MTextStyles.bold16Black2),
            new Text(
              "여러분의 의견은 문토에서 충분히 검토한 후, 보다 더 나은 모임을 만들어 나가는데 적극 반영됩니다.\n\n응답 주신 내용 중 일부는 문토 SNS 및 홈페이지를 통해 소개될 수 있습니다.",
              style: MTextStyles.medium16Grey06,
            ),
          ],
        ));
  }

  // 객관식 문제
  Widget _multipleChoiceQuestion(String question, int qid, List<String> answerList) {
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
                itemBuilder: (context, position) {
                  return RadioListTile(
                    title: Text(answerList[position],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: Colors.black87,
                          fontSize: 15,
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
  Widget _shortAnswerQuestion(String question) {
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
                hintText: "내용을 입력해주세요.",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(new Radius.circular(10.0))),
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(new Radius.circular(10.0))),
            ),
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
