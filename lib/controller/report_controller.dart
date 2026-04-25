import 'package:albedo_app/model/report_model.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var selectedRange = 'This Month'.obs;
  RxBool isSearching=false.obs;

  var packages = <PackageReportModel>[].obs;
  var students = <PackageReportModel>[].obs;
  var teachers = <PackageReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
    loadStudentData();
    loadTeacherData();
  }

  void loadDummyData() {
    packages.value = List.generate(10, (i) {
      return PackageReportModel(
        status: i % 2 == 0 ? "Active" : "Inactive",
        advisor: "Advisor ${i % 3}",
        studentName: "Student $i",
        studentId: "ID00$i",
        contact: "98765432$i",
        whatsapp: "98765432$i",
        classHours: 20 + i,
        classesTaken: 10 + i,
        amount: 500.0,
        totalAmount: 5000.0,
        totalPaid: 3000.0,
        balance: 2000.0,
        course: "Course ${i % 3}",
        standard: 10,
      );
    });
  }

  void loadStudentData() {
    students.value = List.generate(10, (i) {
      return PackageReportModel(
        status: i % 2 == 0 ? "Active" : "Inactive",
        advisor: "Advisor ${i % 3}",
        studentName: "Student $i",
        studentId: "ID00$i",
        contact: "98765432$i",
        whatsapp: "98765432$i",
        classHours: 20 + i,
        classesTaken: 10 + i,
        amount: 500.0,
        totalAmount: 5000.0,
        totalPaid: 3000.0,
        balance: 2000.0,
        course: "Course ${i % 3}",
        standard: 10,
      );
    });
  }

  void loadTeacherData() {
    teachers.value = List.generate(10, (i) {
      return PackageReportModel(
        status: i % 2 == 0 ? "Active" : "Inactive",
        advisor: "Advisor ${i % 3}",
        studentName: "Teacher $i",
        studentId: "ID00$i",
        contact: "98765432$i",
        whatsapp: "98765432$i",
        classHours: 20 + i,
        classesTaken: 10 + i,
        amount: 500.0,
        totalAmount: 5000.0,
        totalPaid: 3000.0,
        balance: 2000.0,
        course: "Course ${i % 3}",
        standard: 10,
      );
    });
  }

  List<PackageReportModel> get filteredPackages {
    return packages.where((e) {
      return e.studentName
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<PackageReportModel> get filteredStudents {
    return students.where((e) {
      return e.studentName
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<PackageReportModel> get filteredTeachers {
    return teachers.where((e) {
      return e.studentName
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
    }).toList();
  }
}
