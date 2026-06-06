import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:get/get.dart';

class TrStudentsController extends GetxController {
  /// 🔹 Loading
  var isLoading = true.obs;

  /// 🔹 Data
  var students = <Student>[].obs;
  var packages = <Package>[].obs;

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

  void fetchStudents() async {
    await Future.delayed(const Duration(milliseconds: 800));

    /// 🔸 Dummy Students
    students.value = [
      Student(
        name: "Aisha Rahman",
        joinedAt: DateTime.now(),
        studentId: "STU-1001",
        email: "aisha@gmail.com",
        mentor: Mentor(name: '', empId: '', joinedAt: DateTime.now()),
        teacherId: "T1",
      ),
      Student(
        name: "Rahul Kumar",
        joinedAt: DateTime.now(),
        studentId: "STU-1002",
        email: "rahul@gmail.com",
        mentor: Mentor(name: '', empId: '', joinedAt: DateTime.now()),
        teacherId: "T1",
      ),
    ];

    /// 🔸 Dummy Packages
    packages.value = [
      Package(
        teacher: Teacher(
            id: '', name: '', status: '', joinedAt: DateTime.now(), gender: ''),
        subjectId: "SUB1",
        subjectName: "Mathematics",
        standard: "10",
        syllabus: "CBSE",
        status: "Active",
        packageFee: 5000,
        // takenFee: 2000,
        balance: 3000,
        withdrawals: [],
        time: "10:00 AM",
        duration: "1 hr",
        note: "",
      ),
    ];

    isLoading.value = false;
  }

  /// 🔹 Get packages for a student
  List<Package> getPackagesByStudent(String? teacherId) {
    return packages.where((p) => p.teacher?.id == teacherId).toList();
  }

  var searchQuery = ''.obs;
  var isSearching = false.obs;
}
