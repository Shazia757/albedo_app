import 'package:get/get.dart';

class HomeController extends GetxController {
  var isUsersExpanded = false.obs;
  var selectedIndex = 0.obs;
  var selectedSubIndex = 0.obs;


  void toggleUsers() {
    isUsersExpanded.value = !isUsersExpanded.value;
  }

    void setIndex(int index) {
    selectedIndex.value = index;
  }

  void setSubIndex(int index) {
    selectedSubIndex.value = index;
  }


  // Sample chart data
  List<double> studentData = [10, 20, 15, 30, 25, 40];
  List<double> womenData = [5, 15, 10, 25, 20, 30];
  List<double> assistantData = [2, 8, 5, 15, 10, 18];
}