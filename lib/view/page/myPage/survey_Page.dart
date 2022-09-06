import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/class_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/model/survey_Data.dart';
import 'package:munto_app/view/page/myPage/myPage_Widget.dart';
import 'package:munto_app/view/style/textstyles.dart';

import 'package:munto_app/view/widget/error_page.dart';

import '../../../util.dart';
class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  ClassProvider classService = ClassProvider();

  List<SurveyData> _classSurveyList = [];
  final StreamController<Response<List<SurveyData>>> _classSurveyListCtrl = StreamController();

  @override
  void dispose() {
    _classSurveyListCtrl.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getSurveyList();
  }

  _getSurveyList() async {
    try {
       _classSurveyListCtrl.sink.add(Response.loading());

      _classSurveyList = await classService.getClassSurveyAvailabe();
      debugPrint('_classSurveyList : ${_classSurveyList.toString()}' );
      _classSurveyListCtrl.sink.add(Response.completed(_classSurveyList));

    } catch(e){
      print('e : ${e.toString()}');
      _classSurveyListCtrl.sink.add(Response.error(e.toString()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: StreamBuilder<Response<List<SurveyData>>>(
          stream: _classSurveyListCtrl.stream,
          builder: (BuildContext context, AsyncSnapshot<Response<List<SurveyData>>> snapshot) {
            return _getStreamBuild(snapshot);
          }),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "만족도조사",
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
      actions: [Text(' ')],
      elevation: 0.0,
    );
  }


  Widget _getStreamBuild( snapshot) {
    if (snapshot.hasData) {
      switch (snapshot.data.status) {
          case Status.LOADING:
            return Center(child: Padding(
              padding: const EdgeInsets.all(68.0),
              child: CircularProgressIndicator(),
            ));
            break;
          case Status.COMPLETED:
            return snapshot.data.data.length > 0 ? _getbody(snapshot.data) : _classNoDataWidget();
            break;
          case Status.ERROR:
            return Error(
              errorMessage: snapshot.data.message,
              onRetryPressed: () => null,
            );
            break;
        }
    }
    return Center(child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: CircularProgressIndicator(),
    ));
  }


  Widget _getbody(snapshot) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          _researchListBox(snapshot.data)
        ],
      ),
    );
  }

  Widget _researchListBox(List<SurveyData> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
              children: [
                TitleBold16BlackView('작성 가능한 설문', '${list.length}건'),
                const SizedBox(
                  height: 9,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      // width: double.infinity,
                      // height: 170,
                      child: Column(
                        children: [
                          ClassMiddleBox(ClassData.fromSurveyData(item)),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                              // width: 320,
                              height: 40,
                              child: OutlineButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text("설문에 참여하기", style: MTextStyles.regular14Grey06),
                                      Container(width: 30, child: Image.asset('assets/mypage/rectangle.png')),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(29.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  onPressed: ()  {
                                    // Navigator.of(context).pushNamed('SurveyDetailPage');
                                    Util.showOneButtonDialog(context, '준비중인 기능입니다.', '', '확인', () { });
                                  })),
                          Divider1(),
                        ],
                      ),
                    );
                  },
                )
              ],
            )
    );
  }

  // 전체 데이타 없을 경우
  Widget _classNoDataWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NodataImage(wid: 60.0, hei: 60.0, path: 'assets/mypage/empty_survey_60_px.svg' , colors : Colors.grey),
              const SizedBox(height: 15),
              Text('작성 가능한 설문이 없습니다.', style: MTextStyles.medium16WarmGrey),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

}
