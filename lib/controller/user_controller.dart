import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var isLoading = true.obs;

  var teachers = <Teacher>[].obs;
  var mentors = <Mentor>[].obs;
  var coordinators = <Coordinator>[].obs;
  var advisors = <Advisor>[].obs;
  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;
  RxList<Advisor> advisorsList = <Advisor>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    await Future.wait([
      fetchTeacherDetail(),
      fetchMentorDetail(),
      fetchCoordinatorDetail(),
      fetchAdvisorDetail(),
    ]);
  }

  Future<void> fetchTeacherDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      teachers.assignAll([
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

  Future<void> fetchMentorDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      mentorsList.assignAll([
        Mentor(
          id: "MTR001",
          name: "Saeeda KP",
          email: "saeeda@gmail.com",
          status: "Active",
          gender: "Female",
          joinedAt: DateTime(2023, 3, 12),
          phone: "9876543211",
          whatsapp: "9876543211",
          qualification: "MA English",
          place: "Malappuram",
          pincode: "676505",
          address: "Kottakkal, Malappuram",
          timezone: "IST",
          prefLanguage: "English",
          salary: 30000,
          bankName: "SBI",
          accountNumber: "111122223333",
          accountHolder: "Saeeda KP",
          accountType: "Savings",
          upiId: "saeeda@upi",
        ),
        Mentor(
          id: "MTR002",
          name: "David Mathew",
          email: "david@gmail.com",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime(2022, 11, 5),
          phone: "9123456789",
          qualification: "MSc Physics",
          place: "Kozhikode",
          address: "Koyilandy, Kozhikode",
          prefLanguage: "English",
          salary: 32000,
          bankName: "HDFC",
          accountNumber: "444455556666",
          accountHolder: "David Mathew",
          accountType: "Savings",
          upiId: "david@upi",
        ),
      ]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCoordinatorDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      coordinatorsList.assignAll([
        Coordinator(
          id: "COO001",
          name: "Najeeb Rahman",
          joinedAt: DateTime(2025, 1, 15),
          email: "najeeb.rahman@example.com",
          imageUrl: "https://example.com/profile/najeeb.jpg",
          status: "Active",
          gender: "Male",
          phone: "+919876543210",
          whatsapp: "+919876543210",
          dob: "1995-06-12",
          qualification: "MBA",
          place: "Malappuram",
          pincode: "679322",
          address: "Green Villa, Perintalmanna, Kerala",
          prefLanguage: "English",
          accountNumber: "123456789012",
          accountHolder: "Najeeb Rahman",
          upiId: "najeeb@upi",
          accountType: "Savings",
          bankName: "State Bank of India",
          bankBranch: "Perintalmanna Branch",
          salary: 25000,
        ),
      ]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAdvisorDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      advisorsList.assignAll([
        Advisor(
          id: "ADV001",
          name: "Fathima Noor",
          joinedAt: DateTime(2025, 3, 10),
          email: "fathima.noor@example.com",
          status: "Active",
          gender: "Female",
          phone: "+919812345678",
          whatsapp: "+919812345678",
          convertedStudents: 45,
          imageUrl: "https://example.com/profile/fathima.jpg",
          dob: "1998-09-21",
          qualification: "BBA",
          place: "Kozhikode",
          pincode: "673001",
          address: "Noor Manzil, Kozhikode, Kerala",
        ),
      ]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Teacher? getTeacherById(String id) {
    return teachers.firstWhereOrNull((e) => e.id == id);
  }
}
