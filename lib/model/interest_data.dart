class Interest {
  static final carrierNames = [
    '마케팅', '브랜딩', '기획', '영상', '스타트업', '디자인', '개발', '유튜브',
  ];
  static final carrierValues = [
      'MARKETING', 'BRANDING', 'PLAN', 'VIDEO', 'STARTUP', 'DESIGN', 'PROGRAMMING', 'YOUTUBE',
  ];

  static final cultureNames = [
    '음악', '미술', '영화'
  ];
  static final cultureValues = [
    'MUSIC', 'ART', 'MOVIE',
  ];

  static final writingNames =[
    '시', '에세이', '소설',
  ];
  static final writingValues =[
    'POEM', 'ESSAY', 'NOVEL',
  ];

  static final lifestyle1Names =[
    '힐링','철학'
  ];
  static final lifestyle1Values =[
    'HEALING', 'PHILOSOPHY'
  ];

  static final foodNames = [
    '요리', '와인', '한국술', '사케', '맥주', '독립술집',
  ];
  static final foodValues = [
    'COOK','WINE','KOREAN_ALCHOL','SAKE','BEER','INDEPENDENT_PUB',
  ];

  static final lifeStyle2Names = [
    '아웃도어', '러닝', '등산', '여행',
  ];
  static final lifeStyle2Values = [
    'OUTDOOR','RUNNING','CLIMBING','TRAVELING',
  ];

  static final beautyNames = [
    '메이크업', '요가', '명상',
  ];
  static final beautyValues = [
    'MAKEUP','YOGA','MEDITATION',
  ];
  static final artCraftNames = [
    '뜨개질', '드로잉', '공예', '도예', 'DIY',
  ];
  static final artCraftValues = [
    'KNITTING','DRAWING','CRAFT','CERAMIC','DIY',
  ];

  static List<String> get allNameList {
    return carrierNames + cultureNames + writingNames +
        lifestyle1Names + foodNames + lifeStyle2Names +
        beautyNames + artCraftNames;
  }

  static List<String> get allValueList {
    return carrierValues + cultureValues + writingValues +
        lifestyle1Values + foodValues + lifeStyle2Values +
        beautyValues + artCraftValues;
  }

  static String getNameByValue (String value){
    final index = allValueList.indexOf(value);
    if(0<= index && index < allNameList.length )
      return allNameList[index];
    return value;
  }

  static String getValueByName (String name){

    final index = allNameList.indexOf(name);
    if(0<= index && index < allValueList.length)
      return allValueList[index];
    return '';
  }
}


