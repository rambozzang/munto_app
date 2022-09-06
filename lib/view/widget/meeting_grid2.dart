// import 'package:color_thief_flutter/color_thief_flutter.dart';
// import 'package:color_thief_flutter/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:munto_app/model/item_data.dart';
// import 'package:munto_app/model/meeting_data.dart';
// import 'package:munto_app/model/provider/item_provider.dart';
// import 'package:munto_app/view/style/colors.dart';
// import 'package:munto_app/view/style/style_data.dart';
// import 'package:munto_app/view/style/textstyles.dart';
// import 'package:provider/provider.dart';

// const pagerItemRatio = 153 / 360;

// class MeetingGridWidget2 extends StatefulWidget {

//   final MeetingGroup group;
//   MeetingGridWidget2(this.group);
//   @override
//   _MeetingGridWidget2State createState() => _MeetingGridWidget2State();
// }

// class _MeetingGridWidget2State extends State<MeetingGridWidget2> with SingleTickerProviderStateMixin {
//   // MeetingGroup group;
//   TabController tabController;
//   int selectedIndex = 0;
//   List<ItemData> list = [];
//   List<String> categoryList = ['전체', '커리어', '문화예술', '글쓰기', '라이프', ];
//   @override
//   void initState() {
//     super.initState();
//     // group = widget.group;
//     tabController = TabController(vsync: this, length: 2);
//     Future.delayed(Duration.zero, () async {
//       final itemProvider = Provider.of<ItemProvider>(context, listen: false);
//       list = await itemProvider.getItems();
//       setState(() {

//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final itemWidth = pagerItemRatio * screenSize.width;
//     final itemHeight = itemWidth * 220 / 153;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[

//         Padding(
//           padding: const EdgeInsets.only(left: 20, bottom: 30),
//           child: Text('모임목록', style: MTextStyles.bold18Black,),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20),
//           child: SizedBox(
//             height: 40,
//             child: ListView.builder(
//                 itemCount: categoryList.length,
//                 scrollDirection: Axis.horizontal,

//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(right:8.0),
//                     child: InkWell(
//                       onTap: (){
//                         setState(() {
//                           selectedIndex = index;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
//                           height: 34,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(Radius.circular(17)),
//                               border: Border.all(color: MColors.white_two, width: 1),
//                               color: selectedIndex == index
//                                   ? MColors.tomato
//                                   : MColors.white_two),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   categoryList[index],
//                                   style: selectedIndex == index
//                                       ? MTextStyles.bold14White
//                                       : MTextStyles.regular14Warmgrey,
//                                 )
//                               ])),
//                     ),
//                   );
//                 }),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.all(20),
//           height: (list.length ~/ 2 * (itemHeight + 30)).toDouble(),
//           child: GridView(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 153/220,
//               crossAxisSpacing: 14.0,
//               mainAxisSpacing: 24.0
//             ),
//             physics: NeverScrollableScrollPhysics(),
//             children: List.generate(list.length, (index){
//               final item = list[index];
//               final isLiked = false;
//               return GestureDetector(
//                 onTap: (){
// //                  Navigator.of(context).push(CupertinoPageRoute(builder:(_)=>GalleryDetail(item)));
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                           Radius.circular(16)
//                       ),
//                       border: Border.all(
//                           color: MColors.very_light_pink,
//                           width: 1
//                       ),
//                       color: Colors.white
//                   )
// ,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                     SizedBox(
//                       width: double.infinity, height: itemHeight * 80 / 220 ,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
//                         child: Stack(children: <Widget>[
//                           Positioned.fill(child: Image.network(item.cover ?? '' ,fit: BoxFit.cover,)),
//                           Positioned(
//                             right:6,
//                             top:6,
//                             width:24,
//                             height:24,
//                             child: FlatButton(
//                               padding: EdgeInsets.zero,
//                               child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
//                                 color: isLiked ? Color.fromRGBO(255, 82, 82, 1.0) : MColors.white ,),
//                               onPressed: (){
//                                 setState(() {
//                                   // item.isFavorite = !item.isFavorite;
//                                 });
//                               },
//                             ),
//                           ),
//                           index == 0 ?
//                           Positioned(
//                             left: 10, top: 10,
//                             child: Container(
//                               width: 66,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(15)
//                                   ),
//                                   color: Color.fromRGBO(255, 82, 82, 0.8)
//                               ),
//                               child: Center(child: Text('시작1일전', style: MTextStyles.bold10White,)),
//                             ),
//                           ) : SizedBox.shrink(),
//                         ],),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 10),
//                       child: Row(
//                         children: <Widget>[
//                           if(item.itemSubject1 != null && item.itemSubject1.isNotEmpty)
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10.0),
//                               margin: EdgeInsets.only(right: 5),
//                               height: 22,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                     Radius.circular(12)
//                                 ),
//                                 color: MColors.white_two,
//                               ),
//                               child: Text(item.itemSubject1, style: MTextStyles.regular10WarmGrey,),
//                             ),
//                           if(item.itemSubject2 != null && item.itemSubject2.isNotEmpty)
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10.0),
//                               margin: EdgeInsets.only(right: 5),
//                               height: 22,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                     Radius.circular(12)
//                                 ),
//                                 color: MColors.white_two,
//                               ),
//                               child: Text(item.itemSubject2, style: MTextStyles.regular10WarmGrey,),
//                             ),

//                         ],
//                       ),
//                     ),
//                   Padding(
//                     padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 10),
//                     child: Text(item.name ?? '', style: MTextStyles.bold14Grey06, maxLines: 1,),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left:12.0, right: 12.0, top: 4),
//                     child: Text(item.itemDetail1 ?? '', style: MTextStyles.regular12Grey06, maxLines: 2, overflow: TextOverflow.ellipsis,),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.only( left: 12.0, top: 16),
//                     child:Row(children: <Widget>[
//                       CircleAvatar(backgroundImage: NetworkImage(item.ItemLeader), radius: 8,),
//                       Padding(padding: EdgeInsets.only(right: 8),),
//                       Text(item.ItemRound[0].round, style: MTextStyles.regular12WarmGrey,  overflow: TextOverflow.ellipsis,)
//                     ],),
//                   ),
//                   ],),
//                 ),
//               );
//             }),
//           ),
//         )
//       ],
//     );
//   }
// }

// class MCirclePainter extends CustomPainter {
//   Paint mPaint;
//   final Color color;
//   MCirclePainter(this.color){
//     mPaint = Paint();
//     mPaint.color = this.color;
//     mPaint.style = PaintingStyle.fill; // Change this to fill

//   }
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawCircle(Offset(size.width *0.5,size.height * 0.75), (size.width + size.height) * 0.39, mPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }

// }
