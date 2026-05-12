import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageController extends GetxController {
  RxString selectedType = "package".obs;
  RxString selectedDateType = "regular".obs;
  var sessions = <Session>[].obs;
  var filteredSessions = <Session>[].obs;
  RxList<Package> packagesList = <Package>[].obs;
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<String> courseList = <String>[].obs;
  RxList<String> syllabusList = <String>[].obs;
  RxList<String> categoryList = <String>[].obs;
  RxList<String> standardList = <String>[].obs;
  Rx<Package?> selectedPackage = Rx<Package?>(null);
  Rx<Teacher?> selectedTeacher = Rx<Teacher?>(null);
  Rx<String?> selectedCourse = Rx<String?>(null);
  Rx<String?> selectedSyllabus = Rx<String?>(null);
  Rx<String?> selectedCategory = Rx<String?>(null);
  Rx<String?> selectedStandard = Rx<String?>(null);
  Rx<String?> selectedTuitionMode = Rx<String?>(null);
  RxList<Days> selectedDays = <Days>[].obs;
  RxList<DateTime> selectedDates = <DateTime>[].obs;
  RxList<Session> monthSessions = <Session>[].obs;

  var selectedTime = Rxn<TimeOfDay>();
  var selectedDuration = Rxn<int>();
  var selectedTab = 0.obs;

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];
  final tutionOptions = ['Online Tuition'];

  TextEditingController classCountController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationDaysController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController studentFeeController = TextEditingController();
  TextEditingController totalPackageFeeController = TextEditingController();
  TextEditingController couponController = TextEditingController();

  RxString durationError = ''.obs;
  RxString dateError = ''.obs;
  RxBool applyCoupon = false.obs;
  RxBool isLoading = true.obs;
  final bool useMock = true;
  RxBool isMonthView = false.obs;

  int get classCount => int.tryParse(classCountController.text) ?? 0;

  List<String> tabs = ["Active", "Action", "Upcoming", "Pending", "Completed"];

  List<String> statusMap = [
    "started",
    "no_balance",
    "upcoming",
    "pending",
    "completed"
  ];

  @override
  void onInit() {
    super.onInit();

    classCountController.addListener(validateDuration);
    durationDaysController.addListener(validateDuration);
  }

  void openMonth(List<Session> sessions) {
    monthSessions.value = sessions;
    isMonthView.value = true;
  }

  void closeMonth() {
    isMonthView.value = false;
    monthSessions.clear();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final allSessions =
          useMock ? await _mockSessions() : await _apiSessions();

      List<Session> result = [];

      result = allSessions;

      sessions.assignAll(result);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadPackage(Package package) {
    isLoading.value = true;

    sessions.value = package.sessions ?? [];

    applyFilters();

    isLoading.value = false;
  }

  void applyFilters() {
    final status = statusMap[selectedTab.value];

    filteredSessions.value = sessions.where((s) => s.status == status).toList();
  }

  Future<List<Session>> _mockSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    return _getDummySessions();
  }

  Future<List<Session>> _apiSessions() async {
    throw UnimplementedError();
  }

  List<Session> _getDummySessions() {
    return [
      Session(
        id: "S001",
        student: Student(
          studentId: "STU001",
          name: "Aisha",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            sessions: [Session(id: '1', status: 'active')],
            time: '',
            duration: '',
            note: ''),
        syllabus: "CBSE Mathematics",
        className: "Class 10",
        teacher: Teacher(
          id: "T001",
          name: "Ameen Rahman",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        coordinator: Coordinator(
          id: "COO1001",
          name: "Maria",
          joinedAt: DateTime.now(),
        ),
        advisor: Advisor(
          id: "ADV001",
          name: "Fathima",
          joinedAt: DateTime.now(),
        ),
        date: DateTime(2026, 4, 23),
        status: "started",
      ),
      Session(
        id: "S002",
        student: Student(
          studentId: "STU002",
          name: "Rahul",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "SCERT",
        className: "9B",
        teacher: Teacher(
          id: "T002",
          name: "David",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(days: 1)),
        status: "upcoming",
      ),
      Session(
        id: "S003",
        student: Student(
          studentId: "STU003",
          name: "Fatima",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "CBSE",
        className: "8C",
        teacher: Teacher(
          id: "T001",
          name: "John",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        status: "pending",
      ),
      Session(
        id: "S004",
        student: Student(
          studentId: "ST04",
          name: "Arjun",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "SCERT",
        className: "11A",
        teacher: Teacher(
          id: "T003",
          name: "Meera",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: "completed",
      ),
      Session(
        id: "S005",
        student: Student(
          studentId: "ST05",
          name: "Nisha",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "CBSE",
        className: "12B",
        teacher: Teacher(
          id: "T002",
          name: "David",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        status: "no_balance",
      ),
      Session(
        id: "S006",
        student: Student(
          studentId: "ST06",
          name: "Ali",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "SCERT",
        className: "10A",
        teacher: Teacher(
          id: "T003",
          name: "Meera",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(hours: 5)),
        status: "meet_done",
      ),
      Session(
        id: "S007",
        student: Student(
            studentId: "ST07",
            name: "Sneha",
            assessment: [
              Assessment(
                  id: "A001",
                  type: "Monthly Academic Assessment",
                  testType: ["academic", "maths", "basics"],
                  date: "06 May 2026",
                  attentionQuestions: ["Focus", "Listening", "Participation"],
                  attentionData: [
                    AttentionItem(mark: '10', question: 'Focus', rating: 2)
                  ]),
            ],
            joinedAt: DateTime.now(),
            packages: [
              Package(
                  teacher: Teacher(
                      id: '',
                      name: '',
                      status: '',
                      joinedAt: DateTime.now(),
                      gender: ''),
                  subjectId: '',
                  subjectName: '',
                  standard: '',
                  syllabus: '',
                  status: '',
                  packageFee: 0,
                  takenFee: 0,
                  balance: 0,
                  withdrawals: [],
                  time: '',
                  duration: '',
                  note: ''),
            ]),
        package: Package(
            teacher: Teacher(
                id: '',
                name: '',
                status: '',
                joinedAt: DateTime.now(),
                gender: ''),
            subjectId: '',
            subjectName: '',
            standard: '',
            syllabus: '',
            status: '',
            packageFee: 0,
            takenFee: 0,
            balance: 0,
            withdrawals: [],
            time: '',
            duration: '',
            note: ''),
        syllabus: "CBSE",
        className: "9A",
        teacher: Teacher(
          id: "T001",
          name: "Ameen Rahman",
          status: "Active",
          gender: "Male",
          joinedAt: DateTime.now(),
        ),
        mentor: Mentor(
          empId: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(hours: 3)),
        status: "started",
      ),
    ];
  }

  void validateDuration() {
    final classCount = int.tryParse(classCountController.text) ?? 0;
    final duration = int.tryParse(durationDaysController.text) ?? 0;

    if (duration < classCount) {
      durationError.value =
          "Duration cannot be less than class count ($classCount)";
    } else {
      durationError.value = '';
    }
  }

  bool validateSession(BuildContext context) {
    String error = "";

    if (selectedPackage.value == null) {
      error = "Please select a package";
    } else if (selectedCourse.value == null) {
      error = "Please select a course";
    } else if (selectedSyllabus.value == null) {
      error = "Please select a syllabus";
    } else if (selectedCategory.value == null) {
      error = "Please select a category";
    } else if (selectedStandard.value == null) {
      error = "Please select a standard";
    } else if (classCountController.text.trim().isEmpty) {
      error = "Class count is required";
    } else if (timeController.text.trim().isEmpty) {
      error = "Class time is required";
    } else if (selectedDuration.value == null) {
      error = "Please select duration";
    } else if (durationDaysController.text.trim().isEmpty) {
      error = "Duration days is required";
    } else if (studentFeeController.text.trim().isEmpty) {
      error = "Student Fee is required";
    } else if (selectedTuitionMode.value == null) {
      error = "Please select tution mode";
    } else if (selectedTeacher.value == null) {
      error = "Please select a teacher";
    } else if (salaryController.text.trim().isEmpty) {
      error = "Teacher salary is required";
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

  void addPackage() {}

  bool verifyCoupon(BuildContext context) {
    return true;

    ///TODO
  }
}
