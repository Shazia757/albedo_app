import 'package:albedo_app/model/feedback_model.dart';
import 'package:flutter/material.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // simulate API

    feedbacks.value = []; // replace with API data

    isLoading.value = false;
  }

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
    List<Feedbacks> filtered = feedbacks;

    final query = searchQuery.value.toLowerCase();

    if (query.isNotEmpty) {
      filtered = filtered.where((s) {
        return s.student!.name.toLowerCase().contains(query) ||
            s.teacher!.name.toLowerCase().contains(query) ||
            s.id.toLowerCase().contains(query);
      }).toList();
    }

    // Example filter logic
    if (selectedFilter.value != 'All') {
      filtered = filtered.where((s) {
        return s.rating >= int.parse(selectedFilter.value[0]);
      }).toList();
    }

    // sorting
    switch (selectedSort.value) {
      case 'Newest':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Oldest':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Highest Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest Rating':
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    return filtered;
  }

  Widget applyFilters() {
    return SizedBox(); //TODO
  }
}
