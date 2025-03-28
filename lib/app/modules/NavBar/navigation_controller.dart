import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs; // Observable variable for selected index

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}