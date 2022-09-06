import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munto_app/model/provider/tag_search_provider.dart';

import 'package:munto_app/view/style/colors.dart';
import 'package:munto_app/view/style/size_config.dart';
import 'package:munto_app/view/style/textstyles.dart';
import 'package:munto_app/view/widget/feed_list_item.dart';

class WriteTagPage extends StatefulWidget {
  final List<String> prevList;

  WriteTagPage(this.prevList);
  @override
  _WriteTagPageState createState() => _WriteTagPageState();
}

class _WriteTagPageState extends State<WriteTagPage> {
  FocusNode _textFocusNode = FocusNode();
  final _tagTextController = TextEditingController();

  static const int Max_SELECTED_TAG = 6;
  List<String> _selectedTagList;
  StreamController<List<TagSearchData>> _tagSearchDataListStream =
      StreamController();
  List<TagSearchData> _emptyTagList = new List<TagSearchData>();
  TagSearchProvider _tagSearchProvider;

  @override
  void initState() {
    super.initState();
    _tagSearchProvider = new TagSearchProvider();
    _tagTextController.addListener(textListener);

    print('widget.prevList ${widget.prevList?.length ?? 0}');

    _selectedTagList = [];
    if(widget.prevList != null)
      _selectedTagList.addAll(widget.prevList);

  }

  @override
  void dispose() {
    _tagTextController.dispose();
    super.dispose();
  }

  textListener() async {
    //입력할때 마다 서버에서 받아옴
    if (_tagTextController.text != '') {
      _tagSearchProvider
          .searchTag(_tagTextController.text, '0', '10')
          .then((value) {
        _tagSearchDataListStream.add(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build _selectedTagList ${_selectedTagList.length}');
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appbar(),
      body: _body(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Center(
          child: Text(
        "태그 추가",
        style: MTextStyles.bold16Black,
      )),
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context, []);
        },
      ),
      actions: [
        FlatButton(
          child: Text('완료', style: MTextStyles.bold14WarmGrey,),
          onPressed: () {
            setState(() {
              Navigator.pop(context, _selectedTagList);
            });
          },
        )
      ],
      elevation: 0.0,
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextField(
              textInputAction: TextInputAction.newline,
              onSubmitted: (newValue) => _addTag(newValue),
              focusNode: _textFocusNode,
              onChanged: (value) {},

              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: MColors.white_two)),
                hintText: '태그 검색',
                hintStyle: TextStyle(
                  color: Color.fromRGBO(200, 200, 200, 1.0),
                  fontSize: 14,
                ),
              ),
              controller: _tagTextController,
              // style: MTextStyles.regular14Grey05,
            ),
          ),
          SizedBox(
            height: 31,
          ),
          SingleChildScrollView(
            child: Container(
              height: 500,
              child: StreamBuilder(
                stream: _tagSearchDataListStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.length != 0) {
                    print('hasData');

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data[index];
                        return Container(
                          height: 38,
                          child: ListTile(
                            onTap: () {
                              _addTag(item?.name);
                            },
                            leading: Text(
                              item?.name,
                              style: MTextStyles.regular14Grey06,
                            ),
                            trailing: Text(
                              item?.count.toString(),
                              style: MTextStyles.regular14WarmGrey,
                            ),
                          ),
                        );
                      },
                    );

                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _selectedTagList.length == 0
                            ? Container()
                            : Row(
                          children: [
                            Text(
                              '선택한 태그',
                              style: MTextStyles.bold16Black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              _selectedTagList.length.toString() + '/6',
                              style: MTextStyles.bold12PinkishGrey,
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children:
                          _selectedTagList.asMap().entries.map((entry) {
                            int index = entry.key;
                            return buildChip(index);
                          }).toList(),
                        ),
                      ],
                    );

                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChip(int index) {
    return Chip(
      label: Text(
        '#${_selectedTagList[index]}',
        style: MTextStyles.regular12Tomato,
      ),
      deleteIcon: Icon(
        Icons.close,
        color: MColors.tomato,
        size: 14,
      ),
      onDeleted: () {
        setState(() {
          _selectedTagList.removeAt(index);
        });
      },
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: MColors.tomato, width: 1)),
    );
  }

  void _addTag(String name) {
    if (_selectedTagList.contains(name)) {
      showAlertDialog(context, '같은 Tag를 입력하셨습니다.');
    } else if (_selectedTagList.length >= Max_SELECTED_TAG) {
      showAlertDialog(context, '최대 입력 갯수 6개를 초과하였습니다.');
    } else {
      name.replaceAll('#', '');
      setState(() {
        _selectedTagList.add(name);
      });
    }

    _tagTextController.clear();
    _tagSearchDataListStream.sink.add(_emptyTagList);
  }

  void showAlertDialog(BuildContext context, String alertText) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('최대 입력 갯수 초과'),
          content: Text(alertText),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
