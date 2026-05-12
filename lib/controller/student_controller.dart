import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/feedback_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/stu_wallet_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/wallet_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StudentSortType { newest, oldest, name }

class StudentController extends GetxController {
  final AuthController auth = Get.find();

  var students = <Student>[].obs;
  var filteredStudents = <Student>[].obs;
  RxList<Feedbacks> teacherFeedbacks = <Feedbacks>[].obs;
  RxList<Feedbacks> mentorFeedbacks = <Feedbacks>[].obs;

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
  var sortType = StudentSortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  RxBool isActive = false.obs;
  RxString status = "Demo Pending".obs;
  var selectedIndex = 0.obs;
  RxString selectedFilter = "All".obs;
  Rx<Package?> selectedPackage = Rx<Package?>(null);
  final RxString selectedTimezone = ''.obs;
  final RxString selectedMentor = ''.obs;
  final RxString selectedAdvisor = ''.obs;
  final RxString selectedReferralSource = ''.obs;

  RxInt feedbackTabIndex = 0.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------
  int get allCount => students.length;

  int get activeCount => students.where((e) => e.status == "Active").length;

  int get batchCount => students.where((e) => e.type == "Batch").length;

  int get tbaCount => students.where((e) => e.type == "TBA").length;

  int get inactiveCount => students.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount},
        {"label": "Active", "count": activeCount},
        {"label": "Batch", "count": batchCount},
        {"label": "TBA", "count": tbaCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  // 🎯 Student-specific fields
  RxBool isAdmissionFeePaid = false.obs;
  var selectedRole = ''.obs;

  var step = 1.obs;
  RxList<String> packageList = <String>[].obs;
  RxList<String> mentorsList = <String>[].obs;
  RxList<String> advisorsList = <String>[].obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController couponcodeController = TextEditingController();
  TextEditingController refundAmountController = TextEditingController();
  TextEditingController refundMessageController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentOccupationController = TextEditingController();
  TextEditingController mentorController = TextEditingController();
  TextEditingController advisorController = TextEditingController();
  TextEditingController referredByController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  List<String> tabs = [
    "Profile",
    "Packages",
    "Batches",
    "Wallet",
    "Batch Payments",
    "Assessments",
    "Sessions",
    "Feedbacks",
    "Certificates"
  ];

  void nextStep() {
    step.value = 2;
  }

  void reset() {
    step.value = 1;
  }

  var transactions = <TransactionModel>[].obs;

  List<String> feedbackTabs = ['Teacher', 'Mentor'];

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allStudents = _getDummyStudents();

      List<Student> result;

      if (user?.role == "admin") {
        result = allStudents; // full access
      } else if (user?.role == "coordinator") {
        result =
            allStudents.where((s) => s.coordinator?.id == user!.id).toList();
      } else if (user?.role == "teacher") {
        result = allStudents.where((s) => s.teacherId == user!.id).toList();
      } else if (user?.role == "mentor") {
        result = allStudents.where((s) => s.mentor?.id == user!.id).toList();
      } else {
        result = [];
      }

      students.assignAll(result);
      filteredStudents.assignAll(result);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Student> _getDummyStudents() {
    return [
      Student(
        studentId: "STU1001",
        name: "Riya Shah",
        email: "riya.shah@email.com",
        phone: "9876543210",
        whatsapp: "9876543210",
        imageUrl: "https://randomuser.me/api/portraits/women/45.jpg",

        status: "Active",
        type: "Batch",
        category: "Regular",
        batch: [
          Batch(
              batchID: 'BAT101',
              batchName: '10th CBSE',
              status: 'Active',
              amountPaid: '12000',
              paidDate: DateTime.now())
        ],

        joinedAt: DateTime.now(),
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),

        gender: "Female",
        timezone: "Asia/Kolkata",
        address: "12, MG Road",
        place: "Mumbai",

        parentName: "Rajesh Shah",
        parentOccupation: "Businessman",

        createdBy: "Admin",
        referredBy: "Google",
        referralName: "Anita",
        referralRole: "Parent",

        isFeePaid: true,

        /// 🔷 Academic Info
        course: "CBSE",
        subjects: "Maths, Science, English",
        syllabus: "CBSE 2023",
        syllabusId: "SYL001",
        standard: 8,

        /// 🔷 Class Tracking
        classHours: 40,
        classesTaken: 32,
        totalHour: 100,
        totalSession: 50,

        /// 🔷 Fees
        amount: 20000,
        amountPerHour: 500,
        totalAmount: 25000,
        regFee: 2000,
        totalPaid: 18000,
        balance: 7000,

        /// 🔷 Wallet
        wallet: StudentWallet(
          balance: 1500,
          totalDeposited: 5000,
        ),

        /// 🔷 Teacher / Staff
        teacherId: "T001",
        advisorName: "Mr. Joseph",
        advisorId: "A101",

        mentor: Mentor(
          name: "Sarah Williams",
          empId: "MNT-441",
          joinedAt: DateTime.now(),
        ),

        coordinator: Coordinator(
          name: "John Mathew",
          id: "CRD-782",
          joinedAt: DateTime.now(),
        ),

        advisor: Advisor(
          name: "Joseph Sir",
          id: "ADV-12",
          joinedAt: DateTime.now(),
        ),

        /// 🔷 Packages
        packages: [
          Package(
              status: 'active',
              subjectId: "PKG001",
              name: "Maths Advanced",
              standard: '10',
              duration: '50',
              packageFee: 15000,
              sessions: [
                Session(
                    id: '1',
                    status: 'completed',
                    date: DateTime.now().subtract(Duration(hours: 100))),
                Session(id: '2', status: 'upcoming'),
              ]),
          Package(
            status: 'Inactive',
            subjectId: "PKG002",
            name: "Science Foundation",
            duration: '40',
            packageFee: 12000,
          ),
        ],

        /// 🔷 Assessments
        assessment: [
          Assessment(
            id: "ASM001",
            type: "Mid Term Assessment",
            date: "2025-02-10",
            testType: ["Online"],
            attentionQuestions: ["Focus", "Listening"],
          ),
          Assessment(
            id: "ASM002",
            type: "Final Evaluation",
            date: "2025-03-20",
            testType: ["Offline"],
            attentionQuestions: ["Participation"],
          ),
        ],
      ),
      Student(
        studentId: "STU1002",
        name: "Ameen",
        email: "ameen@email.com",
        status: "Inactive",
        type: "TBA",
        joinedAt: DateTime.now(),
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        teacherId: "T002",
        mentor: Mentor(name: '', empId: '', joinedAt: DateTime.now()),
        coordinator: Coordinator(name: '', id: '', joinedAt: DateTime.now()),
      ),
      Student(
          studentId: "ST07",
          name: "Sneha",
          joinedAt: DateTime.now(),
          packages: [
            Package(
                name: 'Maths',
                teacher: Teacher(
                    id: '',
                    name: '',
                    status: '',
                    joinedAt: DateTime.now(),
                    gender: ''),
                subjectId: 'subjectId',
                subjectName: 'subjectName',
                standard: 'standard',
                syllabus: 'syllabus',
                status: 'status',
                packageFee: 0,
                takenFee: 0,
                balance: 0,
                withdrawals: [],
                time: 'time',
                duration: 'duration',
                note: 'no')
          ]),
    ];
  }

  /// --------------------------
  /// Filters
  /// --------------------------
  void applyFilters() {
    List<Student> temp = students;

    // Tabs
    switch (selectedTab.value) {
      case 1:
        temp = temp.where((s) => s.status == "Active").toList();
        break;
      case 2:
        temp = temp.where((s) => s.type == "Batch").toList();
        break;
      case 3:
        temp = temp.where((s) => s.type == "TBA").toList();
        break;
      case 4:
        temp = temp.where((s) => s.status == "Inactive").toList();
        break;
    }

    // Search
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((s) =>
              s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              s.email!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              s.studentId!
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == StudentSortType.newest) {
      temp.sort(
        (a, b) => (b.joinedAt ?? DateTime(1900))
            .compareTo(a.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == StudentSortType.oldest) {
      temp.sort(
        (a, b) => (a.joinedAt ?? DateTime(1900))
            .compareTo(b.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == StudentSortType.name) {
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
    }

    filteredStudents.assignAll(temp);
  }

  void loadStudents(Student student) {
    nameController.text = student.name.toString();
    emailController.text = student.email.toString();
    phoneController.text = student.phone.toString();
    whatsappController.text = student.whatsapp.toString();
    parentNameController.text = student.parentName.toString();
    parentOccupationController.text = student.parentOccupation.toString();
    whatsappController.text = student.whatsapp.toString();
    genderController.text = student.gender.toString();
    placeController.text = student.place.toString();
    pincodeController.text = student.pincode.toString();
    addressController.text = student.address.toString();
    timezoneController.text = student.timezone.toString();
    mentorController.text = student.mentor.toString();
    advisorController.text = student.advisorName.toString();
    referredByController.text = student.referredBy.toString();
  }

  delete(String id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
  }

  void handleDelete(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',
        context: context,
        text: "Do you want to request deletion of this student?",
        onConfirm: () => requestDelete(student.studentId!),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',
        context: context,
        text: "Are you sure you want to delete this student permanently?",
        onConfirm: () => delete(student.studentId!),
      );
    }
  }

  void handleDeactivate(BuildContext context, Student student) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this student?",
        onConfirm: () => requestDeactivate(student.studentId!),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this student permanently?",
        onConfirm: () => deactivate(student.studentId!),
      );
    }
  }

  deactivate(String id) {
    isDeleteButtonLoading.value = true;
    // Api().deleteProgram(id).then(
    //   (value) {
    //     if (value?.status == true) {
    //       isDeleteButtonLoading.value = false;
    //       Get.back();
    //       Get.back();
    //       Get.snackbar(
    //           "Success", value?.message ?? "Program deleted successfully.");
    //     } else {
    //       // CustomWidgets.showSnackBar(
    //       //     "Error", value?.message ?? 'Failed to delete program.');
    //     }
    //   },
    // );
  }

  void requestDeactivate(String studentId) {
    print("Request sent to deactivate student: $studentId");

    // TODO:
    // Call API → create approval request
    // Show snackbar
  }

  void requestDelete(String studentId) {
    print("Request sent to delete student: $studentId");

    // TODO:
    // Call API → create approval request
  }

  bool validate(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Parent Opinion is required";
    } else if (selectedPackage.value == null) {
      error = "Please select a package";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  bool validateStudent(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Student name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (whatsappController.text.trim().isNotEmpty &&
        whatsappController.text.trim().length < 10) {
      error = "Enter a valid WhatsApp number";
    } else if (placeController.text.trim().isEmpty) {
      error = "Place is required";
    } else if (pincodeController.text.trim().isEmpty) {
      error = "Pincode is required";
    } else if (pincodeController.text.trim().length < 5) {
      error = "Enter a valid pincode";
    } else if (addressController.text.trim().isEmpty) {
      error = "Address is required";
    } else if (selectedTimezone.value.trim().isEmpty) {
      error = "Please select a time zone";
    } else if (selectedMentor.value.trim().isEmpty) {
      error = "Please select a mentor";
    } else if (selectedAdvisor.value.trim().isEmpty) {
      error = "Please select an advisor";
    } else if (selectedRole.value.isEmpty) {
      error = "Please select referred by type";
    } else if (selectedReferralSource.value.trim().isEmpty) {
      error = "Please select referral source";
    }

    if (error.isNotEmpty) {
      Get.snackbar(
        "Error",
        error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
      );

      return false;
    }

    return true;
  }

  void addStudent() {}

  void updateStudent() {}
}
