import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:get/get.dart';
import '../model/package_model.dart';

class StudentTeachersController extends GetxController {
  var teachers = <Teacher>[].obs;
  var packages = <Package>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    teachers.value = [
      Teacher(
          id: "T1",
          name: "John Doe",
          email: "john@gmail.com",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
          imageUrl: "",
          phone: "9999999999",
          whatsapp: "9999999999",
          totalPackages: 3,
          tuitionMode: "Online",
          coordinator: Coordinator(name: '', id: '', joinedAt: DateTime.now()),
          mentor: Mentor(
            name: '',
            id: '',
            joinedAt: DateTime.now(),
          )),
    ];

    packages.value = [
      Package(
        teacherId: "T1",
        teacherName: "John Doe",
        teacherImage: "",
        subjectId: "S1",
        subjectName: "Maths",
        standard: "10",
        syllabus: "CBSE",
        status: "Active",
        packageFee: 5000,
        takenFee: 3000,
        balance: 2000,
        withdrawals: [],
        time: "10:00 AM",
        duration: "2 hrs",
        note: "Algebra focus",
      ),
    ];
  }

  List<Package> getPackagesByTeacher(String teacherId) {
    return packages.where((p) => p.teacherId == teacherId).toList();
  }
}
