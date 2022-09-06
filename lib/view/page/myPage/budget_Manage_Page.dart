import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/fund_Data.dart';
import 'package:munto_app/model/provider/api_Response.dart';
import 'package:munto_app/model/provider/class_prodiver.dart';
import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/textstyles.dart';

class BudgetManagePage extends StatefulWidget {
  @override
  _BudgetManagePageState createState() => _BudgetManagePageState();
}

class _BudgetManagePageState extends State<BudgetManagePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  int yearValue;
  String monthValue;
  String dayValue;

  List<String> _banks = ["신한은행", "KB은행", "기업은행", "우리은행", "농협", "수협"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  final StreamController<Response<FundData>> _budgetCtrl = StreamController();
  ClassProvider classService = ClassProvider();

  //계좌번호
  final FocusNode _accountNumberTxtNode = FocusNode();
  final TextEditingController _accountNumberTxtCtrl = TextEditingController();

  // 예금주
  final FocusNode _accountHolderTxtNode = FocusNode();
  final TextEditingController _accountHolderTxtCtrl = TextEditingController();
  // 주민등록번호1
  final FocusNode _idNumberFrontTxtNode = FocusNode();
  final TextEditingController _idNumberFrontTxtCtrl = TextEditingController();
  // 주민등록번호2
  final FocusNode _idNumberBackTxtNode = FocusNode();
  final TextEditingController _idNumberBackTxtCtrl = TextEditingController();

  bool _autoValidate = false;

  FundData fundData;
  String bankValue;
  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();

    _budgetCtrl.stream.listen((event) {
       if(event.status == Status.COMPLETED ) {
        _accountNumberTxtCtrl.value = _accountNumberTxtCtrl.value.copyWith(text: '7777');
        _accountHolderTxtCtrl.value = _accountHolderTxtCtrl.value.copyWith(text: '7777');
        _idNumberFrontTxtCtrl.value = _idNumberFrontTxtCtrl.value.copyWith(text: '7777');
        _idNumberBackTxtCtrl.value = _idNumberBackTxtCtrl.value.copyWith(text: '7777');
       }
    });
    _getBudgetData();
  }

  _getBudgetData() async {
    _budgetCtrl.sink.add(Response.loading());

    try {
    // fundData = await classService.getFundData();
    _budgetCtrl.sink.add(Response.completed(fundData));

    } catch(e){
       _budgetCtrl.sink.add(Response.error(e.toString()));
    }
    // _accountNumberTxtCtrl.value = _accountNumberTxtCtrl.value.copyWith(text: '7777');
    // _accountHolderTxtCtrl.value = _accountHolderTxtCtrl.value.copyWith(text: '7777');
    // _idNumberFrontTxtCtrl.value = _idNumberFrontTxtCtrl.value.copyWith(text: '7777');
    // _idNumberBackTxtCtrl.value = _idNumberBackTxtCtrl.value.copyWith(text: '7777');
    // _idNumberBackTxtCtrl.value.copyWith(text: '77117');
  }
void checkValue() {
    if (_accountNumberTxtCtrl.text.length > 1 &&
        _accountHolderTxtCtrl.text.length > 5 &&
        _idNumberFrontTxtCtrl.text.length > 2 &&
        _idNumberBackTxtCtrl.text.length == 15) {
      print("체크완료...");
     
    } else {
      print("체크완료...");
    }
  
  }


  saveBudgetData() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      // 저장 api 호출
      var result;
      if (result) {
        print("입력 성공!!!!!");
        Navigator.pop(context);
      } else {
        print("입력 실패!!!!!");
      }
    } else {
      print('form validate 에러.');
      setState(() => _autoValidate = true);
    }
  }

  // 포커스 이동 함수
  fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _banks) {
      items.add(new DropdownMenuItem(
          value: city,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: new Text(
              city,
              style: TextStyle(fontSize: 14),
            ),
          )));
    }
    return items;
  }

  @override
  void dispose() {
    _budgetCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '은행',
                        style: MTextStyles.medium13Black_three,
                      ),
                    ),
                    Container(
                      height: 62,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                        //   color: Colors.yellow,
                          border: Border.all(color: MColors.greyish, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Center(
                          child: new DropdownButtonFormField(
                            value: bankValue,
                          //  isDense: true,
                            isExpanded: true,
                            //elevation: 16,
                            iconSize: 30.0,
                            hint: Text(
                              '은행을 선택해주세요',
                              style: MTextStyles.regular14WarmGrey,
                            ),
                            items: _dropDownMenuItems,
                            decoration: InputDecoration.collapsed(hintText: ''),
                            onChanged: (val) {
                              setState(() {
                                bankValue = val;
                              });
                              print('$val');
                            },
                            validator:  (String arg) {
                              if (arg  == null) {
                                // alert("받는분 이름을 정확히 입력하세요!");
                                return '은행을 선택해 주세요!';
                              } else {
                                return null;
                              }
                            },
                      //       decoration: InputDecoration(
                      // enabledBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.white))),
                             

                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 22,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '계좌번호',
                            style: MTextStyles.medium13Black_three,
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 70,
                     // color : Colors.yellow,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        //    autofocus: true,
                        //   obscureText: true,
                        controller: _accountNumberTxtCtrl,
                        validator: (String arg) {
                          if (arg.length <= 1) {
                            // alert("받는분 이름을 정확히 입력하세요!");
                            return '계좌 번호를 정확히 입력하세요!';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (txt) {
                           checkValue();
                        },
                        //textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                        },
                        style: MTextStyles.regular14BlackColor,
                        maxLength: 20,
                        focusNode: _accountNumberTxtNode,
                        decoration: InputDecoration(
                        
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.all(
                            7.0,
                          ),
                          hintText: '- 는 제외하고 입력해주세요',
                          hintStyle: MTextStyles.regular14WarmGrey,
                          counterText: "",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MColors.greyish,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      height: 22,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '예금주',
                        style: MTextStyles.medium13Black_three,
                      ),
                    ),
                    Container(
                      height: 70,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        // autofocus: true,
                        controller: _accountHolderTxtCtrl,
                        validator: (String arg) {
                          if (arg.length <= 1) {
                            // alert("받는분 이름을 정확히 입력하세요!");
                            return '예금주명을 정확히 입력하세요!';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (txt) {
                         checkValue();
                        },
                        //obscureText: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term) {
                          // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                        },
                        style: MTextStyles.regular14BlackColor,
                        maxLength: 50,
                        focusNode: _accountHolderTxtNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: new EdgeInsets.all(
                            7.0,
                          ),
                          hintText: '예금주를 입력해주새요',
                          hintStyle: MTextStyles.regular14WarmGrey,
                          counterText: "",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MColors.greyish,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Container(
                      height: 22,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '주민등록번호',
                        style: MTextStyles.medium13Black_three,
                      ),
                    ),
                    Container(
                      height: 70,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(right: 20.0 , left: 20.0, top: 1),
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              //  autofocus: true,
                              controller: _idNumberFrontTxtCtrl,
                              validator: (String arg) {
                                if (arg.length < 6) {
                                  // alert("받는분 이름을 정확히 입력하세요!");
                                  return '6자리를 정확히 입력하세요!';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (txt) {
                                if (txt.length == 7) {
                                  fieldFocusChange(context, _idNumberFrontTxtNode, _idNumberBackTxtNode);
                                  return null;
                                }
                              },
                              // textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                fieldFocusChange(context, _idNumberFrontTxtNode, _idNumberBackTxtNode);
                              },
                              style: MTextStyles.regular14BlackColor,
                              maxLength: 7,
                              focusNode: _idNumberFrontTxtNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.all(
                                  7.0,
                                ),
                                hintText: '앞자리',
                                hintStyle: MTextStyles.regular14WarmGrey,
                                counterText: "",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: MColors.greyish,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              //  autofocus: true,
                              controller: _idNumberBackTxtCtrl,
                              validator: (String arg) {
                                if (arg.length < 7) {
                                  // alert("받는분 이름을 정확히 입력하세요!");
                                  return '7자리를 정확히 입력하세요!';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (txt) {
                                 checkValue();
                              },
                              //  textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                // fieldFocusChange(context, _destNameFocus, _destTelFocus);
                              },
                              obscureText: true,
                              style: MTextStyles.regular14BlackColor,
                              maxLength: 7,
                              focusNode: _idNumberBackTxtNode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.all(
                                  7.0,
                                ),
                                hintText: '뒷자리',
                                hintStyle: MTextStyles.regular14WarmGrey,
                                counterText: "",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: MColors.greyish,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: FlatButton(
                                    child: new Text("취소하기", style: MTextStyles.regular14BlackColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29.0),
                                    ),
                                    color: MColors.white_three,
                                    onPressed: () {}),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 46,
                                child: FlatButton(
                                    child: new Text("저장하기", style: MTextStyles.bold14White),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(29.0),
                                    ),
                                    color: MColors.tomato,
                                    onPressed: ()=> saveBudgetData()),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ))

                //  _cardListBox(),
              ],
            ),
          ),
        ));
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "정산 정보 관리",
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
}
