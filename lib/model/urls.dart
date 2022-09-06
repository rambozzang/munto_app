//IDE에서 클래스명으로 네비게이션 하는경우 이동편의를 위해
//만들어놓은 빈클래스
import 'package:flutter/foundation.dart';

class Urls {}

const releaseHost = 'https://api.munto.co.kr';
//const debugHost = 'https://devapi.munto.co.kr';
const debugHost = 'https://api.munto.co.kr';

bool adminTestMode = false;
String get hostUrl {
  if (adminTestMode) return debugHost;
  if (kReleaseMode) return releaseHost;
  return debugHost;
}

String get amplitudeId {
  if (adminTestMode) return '304706';
  if (kReleaseMode) return '304704';
  return '304706';
}

String get amplitudeKey {
  if (adminTestMode) return 'bdc1fd7ea737b2e6b830c756fc0ea5ad';
  if (kReleaseMode) return 'f79b31e1d5d1b4115774290aea1ecdd1';
  return 'bdc1fd7ea737b2e6b830c756fc0ea5ad';
}
