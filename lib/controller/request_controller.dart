import 'package:albedo_app/model/request_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
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

  final students = List.generate(
    10,
    (i) => StudentRequest(
      student: Student(
        name: "Student $i",
        studentId: "STU00$i",
        imageUrl: "https://i.pravatar.cc/150?img=${i + 1}",
      ),
      pending: i % 3,
      approved: i % 2,
      rejected: i % 2 == 0 ? 1 : 0,
      rescheduled: i % 4,
      requests: List.generate(
        4,
        (j) {
          final statuses = [
            "Pending",
            "Approved",
            "Rejected",
            "Rescheduled",
          ];

          return Requests(
            requestId: "REQ-${i + 1}${j + 1}",
            status: statuses[j % statuses.length],
            currentDate: "12 May 2026",
            currentTime: "${10 + j}:00 AM",
            suggestedDate: "14 May 2026",
            suggestedTime: "${2 + j}:30 PM",
            subject: j % 2 == 0 ? "Mathematics" : "Physics",
            standard: "${8 + j}",
            syllabus: j % 2 == 0 ? "CBSE" : "State",
            reason: j % 2 == 0 ? "School examination" : "Medical appointment",
            createdAt: "${10 + j} May 2026",
          );
        },
      ),
    ),
  );

  List<StudentRequest> get filteredStudents {
  final query = searchQuery.value.toLowerCase().trim();

  if (query.isEmpty) return students;

  return students.where((item) {
    final studentName = item.student.name.toLowerCase();
    final studentId = item.student.studentId?.toLowerCase()??'';

    // Optional mentor fields
    final mentorName =
        item.student.mentor?.name.toLowerCase() ?? "";

    final mentorId =
        item.student.mentor?.id?.toLowerCase() ?? "";

    return studentName.contains(query) ||
        studentId.contains(query) ||
        mentorName.contains(query) ||
        mentorId.contains(query);
  }).toList();
}

  int getCount(int index) {
    if (tabs.isEmpty || index >= tabs.length) return 0;

    final tab = tabs[index];
    final filteredTrsList =
        teachers.where((item) => hasAnyStatus(item)).toList();

    if (tab == "Students") return students.length;
    if (tab == "Teachers") return filteredTrsList.length;

    return students.length;
  }

  List<StudentRequest> get filteredRequests {
    final q = searchQuery.value.toLowerCase();

    if (q.isEmpty) return students;

    return students.where((e) {
      return (e.student.name ?? '').toLowerCase().contains(q) ||
          (e.student.mentor?.name ?? '').toLowerCase().contains(q);
    }).toList();
  }

  final teachers = List.generate(
    10,
    (i) => TeacherRequest(
      teacher: Teacher(
        name: "Teacher $i",
        id: "TCH00$i",
        imageUrl: "https://i.pravatar.cc/150?img=${i + 20}",
      ),
      pending: i % 2,
      approved: i % 3,
      rejected: i % 2 == 1 ? 1 : 0,
      rescheduled: i % 5,
      requests: List.generate(
        4,
        (j) {
          final statuses = [
            "Pending",
            "Approved",
            "Rejected",
            "Rescheduled",
          ];

          return Requests(
            requestId: "TREQ-${i + 1}${j + 1}",
            status: statuses[j % statuses.length],
            currentDate: "15 May 2026",
            currentTime: "${9 + j}:00 AM",
            suggestedDate: "18 May 2026",
            suggestedTime: "${1 + j}:30 PM",
            subject: j % 2 == 0 ? "Chemistry" : "Biology",
            standard: "${9 + j}",
            syllabus: j % 2 == 0 ? "CBSE" : "ICSE",
            reason: j % 2 == 0 ? "Personal emergency" : "Medical leave",
            createdAt: "${11 + j} May 2026",
          );
        },
      ),
    ),
  );

  bool hasAnyStatus(BaseRequestUser item) {
    return item.pending > 0 ||
        item.approved > 0 ||
        item.rejected > 0 ||
        item.rescheduled > 0;
  }
}

class RefundController extends GetxController {}
