import 'package:get/get.dart';

class RequestController {
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedTab = 0.obs;
  final tabs = ["Students", "Teachers"];
  final statusMap = [
    "pending",
    "approved",
    "rejected",
    "rescheduled",
  ];

  /// MOCK DATA (replace with API)
  final students = List.generate(10, (i) {
    return {
      "name": "Student $i",
      "id": "STU00$i",
      "image": "https://i.pravatar.cc/150?img=${i + 1}",
      "pending": i % 3,
      "approved": i % 2,
      "rejected": i % 2 == 0 ? 1 : 0,
      "rescheduled": i % 4,
    };
  });

  final teachers = List.generate(10, (i) {
    return {
      "name": "Teacher $i",
      "id": "TCH00$i",
      "image": "https://i.pravatar.cc/150?img=${i + 20}",
      "pending": i % 2,
      "approved": i % 3,
      "rejected": i % 2 == 1 ? 1 : 0,
      "rescheduled": i % 5,
    };
  });

  bool hasAnyStatus(Map<String, dynamic> data) {
    return (data["pending"] ?? 0) > 0 ||
        (data["approved"] ?? 0) > 0 ||
        (data["rejected"] ?? 0) > 0 ||
        (data["rescheduled"] ?? 0) > 0;
  }
}
