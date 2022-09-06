// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:munto_app/model/board_data.dart';
// import 'package:munto_app/view/style/size_config.dart';
//
// import '../../style/textstyles.dart';
//
// class FeedPhotoSelectPage extends StatefulWidget {
//   @override
//   _FeedPhotoSelectPageState createState() => _FeedPhotoSelectPageState();
// }
//
// class _FeedPhotoSelectPageState extends State<FeedPhotoSelectPage> {
//   static const int maxImageCnt = 10;
//
//   int selectedCount = 0;
//   String _selectedValue = '1'; //TODO test용 (삭제해야함)
//   final _valueList = ['1', '2', '3']; //TODO
//
//   List<FeedPhotoDetails> _imageList = new List<FeedPhotoDetails>();
//   List<String> _selectedImageList = new List<String>();
//
//   @override
//   void initState() {
//     super.initState();
//     getImages();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         titleSpacing: 0.0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Positioned(
//               child: FlatButton(
//                   onPressed: () => {
//                         Navigator.pop(context, _selectedImageList),
//                       },
//                   child: Icon(Icons.close)),
//             ),
//             Positioned(
//                 left: 200,
//                 child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                         value: _selectedValue,
//                         items: _valueList.map((value) {
//                           return DropdownMenuItem(
//                             child: Text(value),
//                             value: value,
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedValue = value;
//                           });
//                         }))),
//             Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context, _selectedImageList);
//                 },
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                           style: MTextStyles.bold14Tomato,
//                           text: _selectedImageList.length.toString()),
//                       TextSpan(style: MTextStyles.bold14Tomato, text: "개 추가")
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 95,
//             width: SizeConfig.screenWidth,
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 13),
//             child: ListView.builder(
//               itemCount: _selectedImageList.length,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return RawMaterialButton(
//                   onPressed: () {
//                     // 클릭했을때 list 에 추가하고, 순서하고
//                     _selectPhotoInListView(index);
//                   },
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: 70,
//                         width: 70,
//                         child: Image.network(
//                           _selectedImageList[index],
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         right: 4,
//                         top: 4,
//                         child: _getSelectedPhotoEraseCircle(),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Divider(
//             height: 1,
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
//               itemCount: galleryItemList.length,
//               itemBuilder: (context, index) {
//                 return RawMaterialButton(
//                   onPressed: () {
//                     // 클릭했을때 list 에 추가하고, 순서하고
//                     _selectPhotoInGridView(index);
//                   },
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(0),
//                           image: DecorationImage(
//                               image: NetworkImage(_imageList[index].imagePath),
//                               fit: BoxFit.cover), //TODO 여기에 폰에서 가져온 이미지들을 추가
//                         ),
//                       ),
//                       Positioned(
//                         right: 6,
//                         top: 6,
//                         child: Container(
//                           height: 24,
//                           width: 24,
//                           decoration: ShapeDecoration(
//                             shape: CircleBorder(
//                               side: BorderSide(width: 1, color: Colors.white),
//                             ),
//                           ),
//                           child: Center(
//                             child: _getPhotoCircle(index),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _selectPhotoInGridView(int index) {
//     setState(() {
//       if (_imageList[index].isChecked) {
//         _imageList[index].isChecked = false;
//         _selectedImageList.remove(_imageList[index].imagePath);
//       } else {
//         _imageList[index].isChecked = true;
//         _selectedImageList.add(_imageList[index].imagePath);
//       }
//     });
//   }
//
//   void _selectPhotoInListView(int index) {
//     setState(() {
//       for (int i = 0; i < _imageList.length; i++) {
//         if (_imageList[i].imagePath == _selectedImageList[index]) {
//           _imageList[i].isChecked = false;
//         }
//       }
//       _selectedImageList.remove(_selectedImageList[index]);
//     });
//   }
//
//   getImages() async {
//     // TODO 폰에서 폴더경로와 이미지를 가져와야 하는데.. 어떻게 하지?
//     // 우선 저장된 샘플 이미지로 테스트 하자
//     for (int i = 0; i < galleryItemList.length; i++) {
//       BoardItem item = galleryItemList[i];
//       _imageList.add(
//         FeedPhotoDetails(
//           item.imageUrl(i),
//           '',
//           false,
//         ),
//       );
//     }
//   }
//
//   _getChild(BoardItem item, index) {
//     if (item.imageUrl(index).isNotEmpty)
//       return Image.network(
//         item.imageUrl(index),
//         fit: BoxFit.cover,
//       );
//     else if (item.file != null)
//       return Image.file(
//         item.file,
//         fit: BoxFit.cover,
//       );
//     else
//       return Container();
//   }
//
//   Widget _getPhotoCircle(index) {
//     int imgIndex;
//
//     if (_imageList[index].isChecked == true) {
//       for (int i = 0; i < _selectedImageList.length; i++) {
//         if (_selectedImageList[i] == _imageList[index].imagePath) {
//           imgIndex = i + 1;
//         }
//       }
//       return CircleAvatar(
//         child: Text(imgIndex.toString()),
//         backgroundColor: Colors.red,
//       );
//     } else
//       return Container();
//   }
//
//   Widget _getSelectedPhotoEraseCircle() {
//     return Container(
//       height: 24,
//       width: 24,
//       child: CircleAvatar(
//         child: Icon(
//           Icons.close,
//           size: 16,
//           color: Colors.white.withOpacity(0.8),
//         ),
//         backgroundColor: Colors.black.withOpacity(0.8),
//       ),
//     );
//   }
// }
//
// class FeedPhotoDetails {
//   final String imagePath;
//   final String imageFolder;
//   bool isChecked;
//
//   FeedPhotoDetails(this.imagePath, this.imageFolder, this.isChecked);
// }
