import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/users/add_teacher_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, name }

class TeacherController extends GetxController {
  final AuthController auth = Get.find();

  var teachers = <Teacher>[].obs;
  var filteredTeachers = <Teacher>[].obs;
  final tabs = ["All", "Active", "Batch", "Inactive"];
  var selectedTab = 0.obs;
  var selectedDate = Rxn<DateTime>();
  final RxString selectedBank = ''.obs;
  var selectedFromDate = Rxn<DateTime>();
  var selectedUntilDate = Rxn<DateTime>();
  final RxString selectedTimezone = ''.obs;
  final RxString selectedBranch = ''.obs;

  final RxList<ExperienceFormData> experiences = <ExperienceFormData>[].obs;

  var searchQuery = ''.obs;
  var sortType = SortType.newest.obs;
  var isSearching = false.obs;
  var isLoading = true.obs;
  var isDeleteButtonLoading = true.obs;
  var isDeactivateButtonLoading = true.obs;
  RxBool isActive = false.obs;
  RxString status = "Demo Pending".obs;
  var selectedIndex = 0.obs;
  RxString selectedFilter = "All".obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool showUnlockForm = false.obs;
  final RxBool selectAllStudents = false.obs;

  final RxString unlockFrom = ''.obs;
  final RxString unlockTo = ''.obs;
  final RxString reLockAfter = ''.obs;

  final RxString targetType = 'All Students'.obs;

  RxInt feedbackTabIndex = 0.obs;

  // --------------------------
  // Counts for tabs
  // --------------------------
  int get allCount => teachers.length;

  int get activeCount => teachers.where((e) => e.status == "Active").length;

  int get batchCount => teachers.where((e) => e.type == "Batch").length;

  int get inactiveCount => teachers.where((e) => e.status == "Inactive").length;

  List<Map<String, dynamic>> get tabData => [
        {"label": "All", "count": allCount},
        {"label": "Active", "count": activeCount},
        {"label": "Batch", "count": batchCount},
        {"label": "Inactive", "count": inactiveCount},
      ];

  List<String> detailedTabs = [
    "Profile",
    "Professional",
    "Students",
    "Batches",
    "Wallet",
    "Feedback",
    "Access"
  ];

  List<String> feedbackTabs = ['Student', 'Mentor'];

  final Map<String, List<String>> bankBranches = {
    'State Bank of India': [
      'Kayamkulam',
      'Mavelikkara',
      'Haripad',
    ],
    'HDFC Bank': [
      'Kayamkulam',
      'Alappuzha',
      'Kollam',
    ],
    'ICICI Bank': [
      'Kayamkulam',
      'Karunagappally',
    ],
    'Federal Bank': [
      'Kayamkulam',
      'Cherthala',
    ],
  };

  // 🎯 Teacher-specific fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController teacherIdController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController prefLangController = TextEditingController();
  TextEditingController tutionModeController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController relockController = TextEditingController();
  final ifscController = TextEditingController();
  final resumeController = TextEditingController();
  final demoController = TextEditingController();

  final RxList<Map<String, dynamic>> students = [
    {"id": "STU001", "name": "Amina"},
    {"id": "STU002", "name": "Rayan"},
    {"id": "STU003", "name": "Sara"},
  ].obs;

  final RxList<Map<String, dynamic>> selectedStudents =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
    selectedStudents.add({
      "id": "all",
      "name": "All Students",
    });
    addExperience();
  }

  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allTeachers = _getDummyTeachers();

      List<Teacher> result;

      if (user?.role == "admin") {
        result = allTeachers;
      } else if (user?.role == "coordinator") {
        result =
            allTeachers.where((t) => t.coordinator?.id == user!.id).toList();
      } else if (user?.role == "mentor") {
        result = allTeachers.where((t) => t.mentor?.id == user!.id).toList();
      } else {
        result = []; // teachers shouldn't see other teachers usually
      }

      teachers.assignAll(result);
      applyFilters();
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Teacher> _getDummyTeachers() {
    return [
      Teacher(
          id: "TEA1001",
          name: "John Doe",
          email: "john@email.com",
          imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
          status: "Active",
          gender: "Male",
          type: "Batch",
          joinedAt: DateTime.now(),
          phone: "9876543210",
          whatsapp: "9876543210",
          dob: "1995-08-15",
          qualification: "MSc Mathematics",
          place: "Kozhikode",
          pincode: "673001",
          address: "Green Villa, Kozhikode, Kerala",
          timezone: "Asia/Kolkata",
          prefLanguage: "English",
          tuitionMode: "Online",
          accountNumber: "123456789012",
          accountHolder: "John Doe",
          upiId: "john@upi",
          ifscCode: "SBIN0001234",
          accountType: "Savings",
          bankName: "State Bank of India",
          bankBranch: "Kozhikode Main",
          totalStudents: 45,
          totalPackages: 18,
          salary: 85000,
          paid: 60000,
          balance: 25000,
          totalSessions: 120,
          totalHours: 240,
          student: [
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
            ),
          ],
          coordinator: Coordinator(
            id: "CRD1001",
            name: "Sarah Williams",
            imageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
            joinedAt: DateTime.now(),
          ),
          mentor: Mentor(
            id: "MNT1001",
            empId: "EMP4521",
            name: "Michael Chen",
            imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
            joinedAt: DateTime.now(),
          ),
          batch: [
            Batch(
              id: "BAT1001",
              batchName: "NEET Crash Batch",
              status: "Active",
            ),
            Batch(
              id: "BAT1002",
              batchName: "JEE Advanced Batch",
              status: "Completed",
            ),
          ],
          experience: [
            Experience(companyName: 'Albedo', months: 2, years: 1),
            Experience(companyName: 'Star', months: 7)
          ]),
      Teacher(
        id: "TEA1002",
        name: "Ms. Smith",
        email: "smith@email.com",
        status: "Inactive",
        type: "Batch",
        phone: "+9876543210",
        joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        gender: 'Female',
        coordinator: Coordinator(name: '', id: '', joinedAt: DateTime.now()),
        mentor: Mentor(
          name: '',
          empId: '',
          joinedAt: DateTime.now(),
        ),
      )
    ];
  }

  Users teacherToUser(Teacher t) {
    return Users(
      empId: t.id,
      name: t.name,
      role: "teacher",
    );
  }

  void applyFilters() {
    List<Teacher> temp = teachers;

    switch (selectedTab.value) {
      case 1:
        temp = temp.where((t) => t.status == "Active").toList();
        break;
      case 2:
        temp = temp.where((t) => t.type == "Batch").toList();
        break;
      case 3:
        temp = temp.where((t) => t.status == "Inactive").toList();
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where((t) =>
              t.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    if (sortType.value == SortType.newest) {
      temp.sort(
        (a, b) => (b.joinedAt ?? DateTime(1900))
            .compareTo(a.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == SortType.oldest) {
      temp.sort(
        (a, b) => (a.joinedAt ?? DateTime(1900))
            .compareTo(b.joinedAt ?? DateTime(1900)),
      );
    } else if (sortType.value == SortType.name) {
      temp.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
    }

    filteredTeachers.assignAll(temp);
  }

  final RxMap<String, List<Map<String, dynamic>>> studentFeedbacks =
      <String, List<Map<String, dynamic>>>{
    'T001': [
      {
        "id": "FDB001",
        "student_name": "Amina",
        "rating": 4.8,
        "message":
            "Very supportive teacher. The sessions were easy to understand.",
        "date": "2026-05-01",
      },
    ],
    'TEA002': [
      {
        "id": "FDB010",
        "student_name": "Hiba",
        "rating": 5.0,
        "message": "Very interactive classes.",
        "date": "2026-05-04",
      },
    ],
  }.obs;
  final RxMap<String, List<Map<String, dynamic>>> mentorFeedbacks =
      <String, List<Map<String, dynamic>>>{
    'TEA001': [
      {
        "id": "MFB001",
        "mentor_name": "Shahid",
        "rating": 4.5,
        "message": "Teacher manages students well and maintains consistency.",
        "date": "2026-05-02",
      },
    ],
  }.obs;
  final RxList<Map<String, dynamic>> accessOverrides =
      <Map<String, dynamic>>[].obs;

  void loadTeachers(Teacher teacher) {
    nameController.text = teacher.name.toString();
    emailController.text = teacher.email.toString();
    phoneController.text = teacher.phone.toString();
    whatsappController.text = teacher.whatsapp.toString();
    genderController.text = teacher.gender.toString();
    placeController.text = teacher.place.toString();
    pincodeController.text = teacher.pincode.toString();
    addressController.text = teacher.address.toString();
    timezoneController.text = teacher.timezone.toString();
    tutionModeController.text = teacher.tuitionMode.toString();
    accountNumberController.text = teacher.accountNumber.toString();
    accountHolderNameController.text = teacher.accountHolder.toString();
    upiIdController.text = teacher.upiId.toString();
    accountTypeController.text = teacher.accountType.toString();
    bankNameController.text = teacher.bankName.toString();
    bankBranchController.text = teacher.bankBranch.toString();
  }

  void handleDelete(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',
        context: context,
        text: "Do you want to request deletion of this teacher?",
        onConfirm: () => requestDelete(teacher.id),
      );
    } else {
      CustomWidgets().showDeleteDialog(
        title: 'Are you sure?',
        context: context,
        text: "Are you sure you want to delete this teacher permanently?",
        onConfirm: () => delete(teacher.id),
      );
    }
  }

  void handleDeactivate(BuildContext context, Teacher teacher) {
    final user = auth.activeUser;

    if (user?.role == "coordinator") {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Do you want to request inactivation for this teacher?",
        onConfirm: () => requestDeactivate(teacher.id),
      );
    } else {
      CustomWidgets().showDeactivateDialog(
        context: context,
        text: "Are you sure you want to deactivate this teacher permanently?",
        onConfirm: () => deactivate(teacher.id),
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

  void addExperience() {
    experiences.add(ExperienceFormData());
  }

  void removeExperience(int index) {
    experiences[index].dispose();
    experiences.removeAt(index);
  }

  void addTeacher() {}

  bool validateTeacher(BuildContext context) {
    String error = "";

    if (nameController.text.trim().isEmpty) {
      error = "Teacher name is required";
    } else if (emailController.text.trim().isEmpty) {
      error = "Email is required";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      error = "Enter a valid email address";
    } else if (phoneController.text.trim().isEmpty) {
      error = "Phone number is required";
    } else if (phoneController.text.trim().length < 10) {
      error = "Enter a valid phone number";
    } else if (genderController.text.trim().isEmpty) {
      error = "Gender is required";
    } else if (dobController.text.trim().isEmpty) {
      error = "Date of birth is required";
    } else if (qualificationController.text.trim().isEmpty) {
      error = "Qualification is required";
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
    } else if (prefLangController.text.trim().isEmpty) {
      error = "Preferred language is required";
    } else if (tutionModeController.text.trim().isEmpty) {
      error = "Tuition mode is required";
    }

    /// Experience Validation
    else if (experiences.isEmpty) {
      error = "At least one experience is required";
    } else {
      for (int i = 0; i < experiences.length; i++) {
        final exp = experiences[i];

        if (exp.companyController.text.trim().isEmpty) {
          error = "Company name is required in Experience ${i + 1}";
          break;
        } else if (exp.yearController.text.trim().isEmpty) {
          error = "Years is required in Experience ${i + 1}";
          break;
        } else if (exp.monthController.text.trim().isEmpty) {
          error = "Months is required in Experience ${i + 1}";
          break;
        }
      }
    }

    /// Bank Details
    if (error.isEmpty && accountNumberController.text.trim().isEmpty) {
      error = "Account number is required";
    } else if (error.isEmpty &&
        accountHolderNameController.text.trim().isEmpty) {
      error = "Account holder name is required";
    } else if (error.isEmpty && selectedBank.value.trim().isEmpty) {
      error = "Please select a bank";
    } else if (error.isEmpty && selectedBranch.value.trim().isEmpty) {
      error = "Please select a branch";
    } else if (error.isEmpty && ifscController.text.trim().isEmpty) {
      error = "IFSC code is required";
    } else if (error.isEmpty && resumeController.text.trim().isEmpty) {
      error = "Resume URL is required";
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

  updateTeacher() {}
}
