
import 'package:flutter/foundation.dart';

var QuestionList = kReleaseMode ? QuestionReleaseList : QuestionDebugList;
// var QuestionList = QuestionReleaseList;
var QuestionDebugList = [
  QuestionData(153 ,	'일주일 중 가장 좋아하는 시간은 언제인가요?','t1.png',  ['일주일중', '가장좋아하는시간', ]),
  QuestionData(149 ,	'오늘 나의 발길을 이끌었던 장소를 소개해주세요!','t2.png',  ['오늘발길이이끈곳', ]),
  QuestionData(150 ,	'오랜시간 내 곁에 머문 문장이 있나요?','t3.png',  ['오랜시간내곁에머문문장', ]),
  QuestionData(134 ,	'당신이 힘들고 지칠 때 찾는 것은 무엇인가요?','t4.png',  ['힘들고지칠때찾는것']),
  QuestionData(152 ,	'우연히 발견한 탐나는 물건을 공유해주세요.','t5.png',  ['우연히발견한' ,'탐나는물건',]),
  QuestionData(136 ,	'내 취향이 담긴 집, 집에서 가장 좋아하는 공간을 소개해주세요.','t6.png',  ['내취향이담긴집']),
  QuestionData(151 ,	'나만 알고 싶었던 아티스트, 살짝 알려주세요.','t7.png',  ['나만알고싶은아티스트']),
  QuestionData(135 ,	'오늘 당신에게 영감으로 다가온 것이 있나요?','t8.png',  ['오늘다가온영감', '아카이브']),
  QuestionData(154 ,	'새로 알게된 당신의 음악 취향이 궁금해요.','t9.png',  ['새로알게된음악취향']),
  QuestionData(138 , 	'또 가고 싶은 그곳은 어디인가요?', 't10.png',['또가고싶은그곳']),
  QuestionData(155 , 	'오랜시간 내 곁을 지켜준 물건이 있나요?', 't11.png',['오랜시간내곁에있는물건',]),
  QuestionData(156 , 	'오늘 나의 눈길을 머물게 했던 것을 남겨보세요.', 't12.png',['오늘눈길이머문곳',  ]),
  QuestionData(141,   '오늘 하루, 어떻게 보내셨나요?', 't13.png',['오늘의기록', '일상']),
  QuestionData(142,  	'2021년 새롭게 시작해보고 싶은 것은 무엇인가요?', 't14.png',['2021', '시작하고싶은것']),
  QuestionData(163,  	'좋아하는 색은 무엇인가요, 좋아하게 된 이유도 궁금해요!', 't15.png',['좋아하는색'],),
  QuestionData(146,  	'아직까지도 잊지 못하는 영화 속 장면이 있나요?', 't16.png',['잊지못하는영화속장면'],),
  QuestionData(113,  	'남들은 안가지고 있을 것 같은, 당신만의 아이템이 궁금해요!', 't17.png',['남들에겐없는', '나만의아이템'],), //체크 필요
  QuestionData(110,  	'홈파티를 연다면, 어떤 음식과 함께하고 싶나요?', 't18.png',['함께하고싶은', '홈파티음식'],),
  QuestionData(169,  	'요즘 푹 빠진 음악이 있다면 알려주세요!', 't19.png',['요즘푹빠진음악', ],),
  QuestionData(115,  	'당신이 요즘 즐겨보는 유튜브 채널이 궁금해요!', 't20.png',['요즘즐겨보는', '유튜브채널'],),
  QuestionData(116,  	'방 안에 붙이고 싶은, 혹은 붙여놓은 포스터가 있나요?', 't21.png',['내방안의포스터', ],),
  QuestionData(164,  	'당신과 매일을 함께하고 있는 가방은 어떤 모습인가요?', 't22.png',['매일을', '함께하는가방'],), //체크 필요
  QuestionData(118,  	'바라보기만 해도 그때가 생각나는 추억이 담긴 물건이 있나요?', 't23.png',['추억이담긴물건', ],),
  QuestionData(119,  	'작은 시도들이 모여 더욱 다채로워지는 취향, 이번주 새롭게 시도해본 것이 있나요?', 't24.png',['이번주', '나의작은시도'],),
  QuestionData(120,  	'이번 겨울, 함께 지낼 책을 알려주세요!', 't25.png',['겨울을함께할책', ],),
  QuestionData(121,  	'쌉쌀한 찻잎의 향, 포근한 우디향 처럼 당신이 좋아하는 향은 무엇인가요?', 't26.png',['좋아하는향', ],),
  QuestionData(122,  	'서로 좋아하는 단어를 말해볼까요? 저는 바스락, 산책, 동무요!', 't27.png',['좋아하는단어', ],),
  QuestionData(123,  	'오롯이 나에게 집중하기 위한 매일의 루틴이 있나요?', 't28.png',['매일루틴', ],),
  QuestionData(124,  	'어쨌든 겨울엔 꼭 먹어야 하는 음식은?', 't29.png',['겨울엔꼭', '먹어야해요'],),
  QuestionData(143,  	'나의 최애 맥주를 알려주세요!', 't30.png',['최애맥주', ],),
  QuestionData(126,  	'그냥 지나치지 못하고 사진으로 담아온 여행의 흔적들을 공유해주세요!', 't31.png',['여행중', '그냥지나칠수없었던것'],),
  QuestionData(127,  	'요즘 푹 빠진 음식이 있다면 알려주세요!', 't32.png',['요즘푹빠진음식'],),



// 146잊지못하는영화속장면
// 147남들에겐없는
// 148매일을
// 149오늘발길이이끈곳
// 150오랜시간내곁에머문문장
// 151나만알고싶은아티스트
// 152우연히발견한
// 153일주일중
// 154새로알게된음악취향
// 155오랜시간내곁에있는물건
// 156오늘눈길이머문곳

// 277	잊지못하는영화속장면
// 278	남들에겐없는
// 279	매일을
// 280	오늘발길이이끈곳
// 276	오랜시간내곁에머문문장
// 282	나만알고싶은아티스트
// 283	우연히발견한
// 284	일주일중
// 285	새로알게된음악취향
// 286	오랜시간내곁에있는물건
// 287	오늘눈길이머문곳
];

var QuestionReleaseList = [
  QuestionData(284,	'일주일 중 가장 좋아하는 시간은 언제인가요?','t1.png',  ['일주일중', '가장좋아하는시간', ]),
  QuestionData(280,	'오늘 나의 발길을 이끌었던 장소를 소개해주세요!','t2.png',  ['오늘발길이이끈곳', ]),
  QuestionData(276,	'오랜시간 내 곁에 머문 문장이 있나요?','t3.png',  ['오랜시간내곁에머문문장', ]),
  QuestionData(262,	'당신이 힘들고 지칠 때 찾는 것은 무엇인가요?','t4.png',  ['힘들고지칠때찾는것']),
  QuestionData(283,	'우연히 발견한 탐나는 물건을 공유해주세요.','t5.png',  ['우연히발견한' ,'탐나는물건',]),
  QuestionData(264,	'내 취향이 담긴 집, 집에서 가장 좋아하는 공간을 소개해주세요.','t6.png',  ['내취향이담긴집']),
  QuestionData(282,	'나만 알고 싶었던 아티스트, 살짝 알려주세요.','t7.png',  ['나만알고싶은아티스트']),
  QuestionData(263,	'오늘 당신에게 영감으로 다가온 것이 있나요?','t8.png',  ['오늘다가온영감', '아카이브']),
  QuestionData(285,	'새로 알게된 당신의 음악 취향이 궁금해요.','t9.png',  ['새로알게된음악취향']),
  QuestionData(266, '또 가고 싶은 그곳은 어디인가요?','t10.png', ['또가고싶은그곳']),
  QuestionData(286, '오랜시간 내 곁을 지켜준 물건이 있나요?','t11.png', ['오랜시간내곁에있는물건',]),
  QuestionData(287, '오늘 나의 눈길을 머물게 했던 것을 남겨보세요.','t12.png', ['오늘눈길이머문곳',  ]),
  QuestionData(269, '오늘 하루, 어떻게 보내셨나요?', 't13.png',['오늘의기록', '일상']),
  QuestionData(182, '2021년 새롭게 시작해보고 싶은 것은 무엇인가요?','t14.png', ['2021', '시작하고싶은것']),
  QuestionData(239, '좋아하는 색은 무엇인가요, 좋아하게 된 이유도 궁금해요!', 't15.png',['좋아하는색'],),
  QuestionData(277, '아직까지도 잊지 못하는 영화 속 장면이 있나요?', 't16.png',['잊지못하는영화속장면'],),
  QuestionData(290, '남들은 안가지고 있을 것 같은, 당신만의 아이템이 궁금해요!', 't17.png',['남들에겐없는', '나만의아이템'],), //체크 필요
  QuestionData(292, '홈파티를 연다면, 어떤 음식과 함께하고 싶나요?', 't18.png',['함께하고싶은', '홈파티음식'],),
  QuestionData(294, '요즘 푹 빠진 음악이 있다면 알려주세요!', 't19.png',['요즘푹빠진음악', ],),
  QuestionData(295, '당신이 요즘 즐겨보는 유튜브 채널이 궁금해요!', 't20.png',['요즘즐겨보는', '유튜브채널'],),

  QuestionData(297, '방 안에 붙이고 싶은, 혹은 붙여놓은 포스터가 있나요?', 't21.png',['내방안의포스터', ],),
  QuestionData(298, '당신과 매일을 함께하고 있는 가방은 어떤 모습인가요?', 't22.png',['매일을', '함께하는가방'],),
  QuestionData(300, '바라보기만 해도 그때가 생각나는 추억이 담긴 물건이 있나요?', 't23.png',['추억이담긴물건', ],),
  QuestionData(301, '작은 시도들이 모여 더욱 다채로워지는 취향, 이번주 새롭게 시도해본 것이 있나요?', 't24.png',['이번주', '나의작은시도'],),
  QuestionData(303, '이번 겨울, 함께 지낼 책을 알려주세요!', 't25.png',['겨울을함께할책', ],),
  QuestionData(304, '쌉쌀한 찻잎의 향, 포근한 우디향 처럼 당신이 좋아하는 향은 무엇인가요?', 't26.png',['좋아하는향', ],),
  QuestionData(305, '서로 좋아하는 단어를 말해볼까요? 저는 바스락, 산책, 동무요!', 't27.png',['좋아하는단어', ],),
  QuestionData(306, '오롯이 나에게 집중하기 위한 매일의 루틴이 있나요?', 't28.png',['매일루틴', ],),
  QuestionData(307, '어쨌든 겨울엔 꼭 먹어야 하는 음식은?', 't29.png',['겨울엔꼭', '먹어야해요'],),
  QuestionData(309, '나의 최애 맥주를 알려주세요!', 't30.png',['최애맥주', ],),
  QuestionData(310, '그냥 지나치지 못하고 사진으로 담아온 여행의 흔적들을 공유해주세요!', 't31.png',['여행중', '그냥지나칠수없었던것'],),
  QuestionData(256, '요즘 푹 빠진 음식이 있다면 알려주세요!', 't32.png',['요즘푹빠진음식'],),

];















































class QuestionData {
  int id;
  String question;
  String image;
  List<String> tagList;
  String get mainTag {
    if(tagList != null && tagList.length > 0)
      return tagList[0];
    return null;
  }
  String get imagePath {
    return 'assets/questions/$image';
  }

  QuestionData(this.id, this.question, this.image, this.tagList);
}


















// 18_#함께하고싶은#홈파티음식.png
// 15_#좋아하는색.png
// 16_#잊지못하는#영화속한장면.png
// 17_#남들에겐없는#나만의아이템.png
// 19_#푹빠진음악.png
// 20_#요즘즐겨보는#유튜브채널.png
// 21_#내방안의포스터.png
// 22_#매일#함께하는가방.png
// 23_#추억이담긴물건.png
// 24_#이번주#나의작은시도.png
// 25_#겨울을함께할책.png
// 26_#좋아하는향.png
// 27_#좋아하는단어.png
// 28_#매일루틴.png
// 29_#겨울엔꼭#먹어야해요.png
// 30_#최애맥주.png
// 31_#여행중#그냥지나칠수없었던것.png
// 32_#요즘푹빠진음식.png

// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '나의발길을이끈장소', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '내곁에머문문장', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '아티스트', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '탐나는물건', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '가장좋아하는시간', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '힘들고지칠때찾는것', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오늘다가온영감', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '내취향이담긴집', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '음악취향', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '또가고싶은그곳', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '내곁에있는물건', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '나의눈길이머문곳', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오늘의기록', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '2021', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);





