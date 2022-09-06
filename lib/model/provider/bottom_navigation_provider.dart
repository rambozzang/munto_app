import 'package:flutter/cupertino.dart';
import 'package:munto_app/model/message_Push_data.dart';
import 'package:munto_app/model/provider/api_Service.dart';

class BottomNavigationProvider with ChangeNotifier {
  int currentIndex = 0;
  void setIndex(int index) {
    print('bottomProvider setIndex : $index');

    if([0,1,3,4].contains(index)){
      currentIndex = index;
      notifyListeners();
    }
  }

  void clearIndex(){
    currentIndex = 0;
  }

  bool communityRefresh = false;
  void refreshCommunity() {
    communityRefresh = true;
    notifyListeners();
  }
  void communityFinished() {
    communityRefresh = false;
  }


  bool loungeFeedRefresh = false;
  void refreshLoungeFeed() {
    loungeFeedRefresh = true;
    notifyListeners();
  }
  void loungeFeedFinished() {
    loungeFeedRefresh = false;
  }


  
  
}
