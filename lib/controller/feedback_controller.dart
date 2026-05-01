import 'package:albedo_app/model/feedback_model.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;

  var selectedFilter = 'All'.obs;
  var selectedSort = 'Newest'.obs;

  final filters = ['All', '2 & Up', '3 & Up', '4 & Up'];
  final sorts = ['Newest', 'Oldest', 'Highest Rating', 'Lowest Rating'];

  void setFilter(String value) => selectedFilter.value = value;
  void setSort(String value) => selectedSort.value = value;

  List<String> tabs = [
    "From Student",
    "From Teacher",
    "To Student",
    "To Teacher",
  ];
  List<String> hrTabs = [
    "Student",
    "Teacher",
    "Mentor",
    
  ];

  var feedbacks = <Feedbacks>[].obs;

    List<Feedbacks> get filteredSessions {
      return [];
    // final status = statusMap[selectedTab.value];

    // ✅ Step 1: Filter first
    // List<Feedbacks> filtered = feedbacks.where((s) {
    //   final matchesStatus = s.status == status;

    //   final matchesSearch = s.student!.name
    //           .toLowerCase()
    //           .contains(searchQuery.value.toLowerCase()) ||
    //       s.student!.studentId!
    //           .toLowerCase()
    //           .contains(searchQuery.value.toLowerCase()) ||
    //       s.teacher!.id
    //           .toLowerCase()
    //           .contains(searchQuery.value.toLowerCase()) ||
    //       s.teacher!.name
    //           .toLowerCase()
    //           .contains(searchQuery.value.toLowerCase()) ||
    //       s.id.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
    //       s.package.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
    //       s.className.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
    //       s.date.toString().contains(searchQuery.value.toLowerCase());

    //   return matchesStatus && matchesSearch;
    // }).toList();
    // if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
    //   filtered = filtered
    //       .where((s) => s.teacher?.name == selectedTeacher.value)
    //       .toList();
    // }

    // // 🔥 Step 2: ADD SORTING HERE (THIS IS WHAT YOU ASKED)
    // switch (sortType.value) {
    //   case SortType.newest:
    //     filtered.sort((a, b) => b.date.compareTo(a.date));
    //     break;
    //   case SortType.oldest:
    //     filtered.sort((a, b) => a.date.compareTo(b.date));
    //     break;
    //   case SortType.student:
    //     filtered.sort((a, b) => a.student!.name.compareTo(b.student!.name));
    //     break;
    //   case SortType.teacher:
    //     filtered.sort((a, b) => a.teacher!.name.compareTo(b.teacher!.name));
    //     break;
    // }

    // // ✅ Step 3: Return final list
    // return filtered;
  }


}
