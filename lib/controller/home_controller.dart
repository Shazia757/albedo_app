import 'package:get/get.dart';

class HomeController extends GetxController {
  var isUsersExpanded = false.obs;

  void toggleUsers() {
    isUsersExpanded.value = !isUsersExpanded.value;
  }

  // Sample chart data
  List<double> studentData = [10, 20, 15, 30, 25, 40];
  List<double> womenData = [5, 15, 10, 25, 20, 30];
  List<double> assistantData = [2, 8, 5, 15, 10, 18];
}