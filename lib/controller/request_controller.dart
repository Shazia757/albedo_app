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

      /// REQUESTS
      "requests": List.generate(4, (j) {
        final statuses = [
          "Pending",
          "Approved",
          "Rejected",
          "Rescheduled",
        ];

        return {
          "requestId": "REQ-${i + 1}${j + 1}",
          "status": statuses[j % statuses.length],
          "currentDate": "12 May 2026",
          "currentTime": "${10 + j}:00 AM",
          "suggestedDate": "14 May 2026",
          "suggestedTime": "${2 + j}:30 PM",
          "subject": j % 2 == 0 ? "Mathematics" : "Physics",
          "standard": "${8 + j}",
          "syllabus": j % 2 == 0 ? "CBSE" : "State",
          "reason": j % 2 == 0 ? "School examination" : "Medical appointment",
          "createdAt": "${10 + j} May 2026",
        };
      }),
    };
  });
  int getCount(int index) {
    if (tabs.isEmpty || index >= tabs.length) return 0;

    final tab = tabs[index];
    final filteredTrsList =
        teachers.where((item) => hasAnyStatus(item)).toList();

    if (tab == "Students") return students.length;
    if (tab == "Teachers") return filteredTrsList.length;

    return students.length;
  }

  final teachers = List.generate(10, (i) {
    return {
      "name": "Teacher $i",
      "id": "TCH00$i",
      "image": "https://i.pravatar.cc/150?img=${i + 20}",

      "pending": i % 2,
      "approved": i % 3,
      "rejected": i % 2 == 1 ? 1 : 0,
      "rescheduled": i % 5,

      /// REQUESTS
      "requests": List.generate(4, (j) {
        final statuses = [
          "Pending",
          "Approved",
          "Rejected",
          "Rescheduled",
        ];

        return {
          "requestId": "TREQ-${i + 1}${j + 1}",
          "status": statuses[j % statuses.length],
          "currentDate": "15 May 2026",
          "currentTime": "${9 + j}:00 AM",
          "suggestedDate": "18 May 2026",
          "suggestedTime": "${1 + j}:30 PM",
          "subject": j % 2 == 0 ? "Chemistry" : "Biology",
          "standard": "${9 + j}",
          "syllabus": j % 2 == 0 ? "CBSE" : "ICSE",
          "reason": j % 2 == 0 ? "Personal emergency" : "Medical leave",
          "createdAt": "${11 + j} May 2026",
        };
      }),
    };
  });
  
  bool hasAnyStatus(Map<String, dynamic> data) {
    return (data["pending"] ?? 0) > 0 ||
        (data["approved"] ?? 0) > 0 ||
        (data["rejected"] ?? 0) > 0 ||
        (data["rescheduled"] ?? 0) > 0;
  }
}
