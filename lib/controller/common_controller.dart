import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:get/get.dart';

class CommonController extends GetxController {
  RxBool isLoading = true.obs;

  RxList<Teacher> teacherList = <Teacher>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchTeacherDetail();
  }

  Future<void> fetchTeacherDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      teacherList.assignAll([
        Teacher(
          id: "T001",
          name: "Ameen Rahman",
          email: "ameen@gmail.com",
          status: "Active",
          gender: "Male",
          type: "Batch",
          joinedAt: DateTime(2023, 5, 10),
          phone: "9876543210",
          whatsapp: "9876543210",
          qualification: "MSc Mathematics",
          place: "Malappuram",
          pincode: "676505",
          totalStudents: 45,
          totalPackages: 6,
          totalSessions: 120,
          totalHours: 180,
          salary: 40000,
          paid: 30000,
          balance: 10000,
          bankName: "SBI",
          accountNumber: "1234567890",
          accountHolder: "Ameen Rahman",
          accountType: "Savings",
          upiId: "ameen@upi",
        ),
        Teacher(
          id: "T002",
          name: "Fathima Noor",
          email: "fathima@gmail.com",
          status: "Active",
          gender: "Female",
          type: "TBA",
          joinedAt: DateTime(2024, 1, 15),
          phone: "9123456780",
          qualification: "BEd English",
          place: "Kozhikode",
          totalStudents: 30,
          totalPackages: 4,
          totalSessions: 90,
          totalHours: 140,
          salary: 35000,
          paid: 20000,
          balance: 15000,
        ),
      ]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Teacher? getTeacherById(String id) {
    print("Clicked ID: $id");
    try {
      return teacherList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Users teacherToUser(Teacher t) {
    return Users(
      id: t.id,
      name: t.name,
      role: "teacher",
    );
  }
}
