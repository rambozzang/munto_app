//IDE에서 클래스명으로 네비게이션 하는경우 이동편의를 위해
//만들어놓은 빈클래스
class ConstData{}

// const dummyProfileImage = 'https://munto-images.s3.ap-northeast-2.amazonaws.com/user/default-profile-image.png';

const TEMP_APPLE_MAIL = 'temp_apple@munto.kr';
const TEMP_KAKAO_MAIL = 'temp_kakao@munto.kr';

const QUESTION_TAG_LIST = [
  <String>[],
  ['일주일중', '가장좋아하는시간', ],
  ['오늘발길이이끈곳', ],
  ['오랜시간내곁에머문문장', ],
  ['힘들고지칠때찾는것'],
  ['우연히발견한' ,'탐나는물건',],
  ['내취향이담긴집'],
  ['나만알고싶은아티스트'],
  ['오늘다가온영감', '아카이브'],
  ['새로알게된음악취향'],
  ['또가고싶은그곳'],
  ['오랜시간내곁에있는물건',],
  ['오늘눈길이머문곳',  ],
  ['오늘의기록', '일상'],
  ['2021', '시작하고싶은것'],
  ['잊지못하는영화속장면'],
  ['남들에겐없는', '나만의아이템'],
  ['함께하고싶은', '홈파티음식'],
  ['요즘푹빠진음악', ],
  ['요즘즐겨보는', '유튜브채널'],
  ['내방안의포스터', ],
  ['매일을', '함께하는가방'],
  ['추억이담긴물건', ],
  ['이번주', '나의작은시도'],
  ['겨울을함께할책', ],
  ['좋아하는향', ],
  ['좋아하는단어', ],
  ['매일루틴', ],
  ['겨울엔꼭', '먹어야해요'],
  ['최애맥주', ],
  ['여행중', '그냥지나칠수없었던것'],
















// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '잊지못하는영화속장면', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '남들에겐없는', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '매일을', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오늘발길이이끈곳', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오랜시간내곁에머문문장', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '나만알고싶은아티스트', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '우연히발견한', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '일주일중', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '새로알게된음악취향', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오랜시간내곁에있는물건', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '오늘눈길이머문곳', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);
// INSERT INTO public."Tag"("createdAt", "updatedAt", "deletedAt", "name", image) VALUES(now(),now(), NULL, '', NULL);




];

const QUESTION_FILE_LIST = [
  'assets/questions/q0.png',
  'assets/questions/q1.png',
  'assets/questions/q2.png',
  'assets/questions/q3.png',
  'assets/questions/q4.png',
  'assets/questions/q5.png',
  'assets/questions/q6.png',
  'assets/questions/q7.png',
  'assets/questions/q8.png',
  'assets/questions/q9.png',
  'assets/questions/q10.png',
  'assets/questions/q11.png',
  'assets/questions/q12.png',
  'assets/questions/q13.png',
  'assets/questions/q14.png',
  'assets/questions/q16.png',
  'assets/questions/q17.png',
  'assets/questions/q18.png',
  'assets/questions/q19.png',
  'assets/questions/q20.png',
  'assets/questions/q21.png',
  'assets/questions/q22.png',
  'assets/questions/q23.png',
  'assets/questions/q24.png',
  'assets/questions/q25.png',
  'assets/questions/q26.png',
  'assets/questions/q27.png',
  'assets/questions/q28.png',
  'assets/questions/q29.png',
  'assets/questions/q30.png',
  'assets/questions/q31.png',
];

bool isSNSTempMail(email){
  if(email == TEMP_APPLE_MAIL || email == TEMP_KAKAO_MAIL)
    return true;
  return false;
}