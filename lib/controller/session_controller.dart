import 'dart:developer';

import 'package:albedo_app/api.dart';
import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/meet_model.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/syllabus_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/sessions/session_report_dialog.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum SessionSortType { newest, oldest, student, teacher }

enum FilterType { all, classSession, meetSession }

class SessionController extends GetxController {
  final AuthController auth = Get.find();
  final bool useMock = true;
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  final RxInt currentSessionIndex = 0.obs;
  var searchQuery = ''.obs;
  final pageSize = 20.obs;
  final activeCount = 0.obs;
  final actionCount = 0.obs;
  final upcomingCount = 0.obs;
  final pendingCount = 0.obs;
  final completedCount = 0.obs;
  final meetCount = 0.obs;
  int get totalPages => (totalCount.value / pageSize.value).ceil();

  RxBool isSearching = false.obs;
  RxBool isSessionDetailLoading = false.obs;
  var selectAllMentors = false.obs;
  var selectAllTeachers = false.obs;
  var selectAllStudents = false.obs;
  var selectAllCoordinators = false.obs;
  var selectAllAdvisors = false.obs;
  var selectAllOtherUsers = false.obs;
  var sortType = SessionSortType.newest.obs;
  var filterType = FilterType.all.obs;
  var sessions = <Session>[].obs;
  var meets = <Meet>[].obs;
  RxList<SessionReport> reports = <SessionReport>[].obs;
  Rx<Student?> selectedStudent = Rx<Student?>(null);
  Rx<Teacher?> selectedTeacher = Rx<Teacher?>(null);
  final editSelectedTeacher = Rxn<Teacher>();
  final editSelectedDuration = Rxn<int>();
  final editSelectedDate = Rxn<DateTime>();

  Rx<Package?> selectedPackage = Rx<Package?>(null);

  RxList<Package> packagesList = <Package>[].obs;
  final RxList<Session> filteredSessions = <Session>[].obs;
  final RxList<Meet> filteredMeets = <Meet>[].obs;
  RxList<Student> selectedStudents = <Student>[].obs;
  RxList<Teacher> selectedTeachers = <Teacher>[].obs;
  RxList<Mentor> selectedMentors = <Mentor>[].obs;
  RxList<Coordinator> selectedCoordinators = <Coordinator>[].obs;
  RxList<Advisor> selectedAdvisors = <Advisor>[].obs;
  RxList<OtherUsers> selectedOtherUsers = <OtherUsers>[].obs;
  final RxBool showStudentMenu = false.obs;
  var selectedTeacherEdit = RxnString();
  final formKey = GlobalKey<FormState>();
  var selectedDuration = Rxn<int>();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  final currentPage = 0.obs;
  final totalCount = 0.obs;

  RxString selectedType = "session".obs;
  RxList<Student> studentsList = <Student>[].obs;
  String selectedFile = '';
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Syllabus> categoryList = <Syllabus>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;
  RxList<Advisor> advisorsList = <Advisor>[].obs;
  RxList<OtherUsers> otherUsersList = <OtherUsers>[].obs;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController meetTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  RxBool isLoading = true.obs;
  RxBool isDeleteButtonLoading = false.obs;

  Rxn<SessionReport> reportRx = Rxn<SessionReport>();

  bool get hasReport => reportRx.value != null;

  List<String> tabs = [
    "Active",
    "Action",
    "Upcoming",
    "Pending",
    "Completed",
    "Meets"
  ];

  List<String> statusMap = [
    "started",
    "no_balance",
    "upcoming",
    "pending",
    "completed",
    "meet_done"
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAllCounts();
    fetchData();
    _mockUsers("student");
    _mockUsers("teacher");
    _mockUsers("mentor");
    _mockUsers("coordinator");
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      /// Meet sessions uses different API
      if (selectedTab.value == 5) {
        final response = await Api().getMeetSessions();

        meets.assignAll(response);
        meetCount.value = response.length;

        applyFilters();
        return;
      }

      String category = "active";

      switch (selectedTab.value) {
        case 0:
          category = "active";
          break;

        case 1:
          category = "needs_action";
          break;

        case 2:
          category = "upcoming";
          break;

        case 3:
          category = "pending";
          break;

        case 4:
          category = "completed";
          break;
      }

      final response = await Api().getSessionDetails(
        category: category,
        page: currentPage.value + 1,
        pageSize: pageSize.value,
      );

      sessions.assignAll(response.results);

      totalCount.value = response.count;

      applyFilters();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllCounts() async {
    try {
      final active = await Api().getSessionDetails(
        category: "active",
        page: 1,
        pageSize: 1,
      );

      final action = await Api().getSessionDetails(
        category: "needs_action",
        page: 1,
        pageSize: 1,
      );

      final upcoming = await Api().getSessionDetails(
        category: "upcoming",
        page: 1,
        pageSize: 1,
      );

      final pending = await Api().getSessionDetails(
        category: "pending",
        page: 1,
        pageSize: 1,
      );

      final completed = await Api().getSessionDetails(
        category: "completed",
        page: 1,
        pageSize: 1,
      );

      final meets = await Api().getMeetSessions();

      activeCount.value = active.count;
      actionCount.value = action.count;
      upcomingCount.value = upcoming.count;
      pendingCount.value = pending.count;
      completedCount.value = completed.count;
      meetCount.value = meets.length;
    } catch (e) {
      log(e.toString());
    }
  }

  void onStudentSelected(Student student) {
    selectedStudent.value = student;

    // reset previous selection
    selectedPackage.value = null;

    // build packages list from student
    if (student.packages != null) {
      packagesList.value = student.packages ?? [];
    } else {
      packagesList.clear();
    }
  }

  Future<void> fetchUsers(String type) async {
    try {
      isLoading.value = true;

      if (useMock) {
        _mockUsers(type);
      } else {
        await _apiUsers(type);
      }
    } catch (e) {
      print("$type fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<SessionDetail?> fetchSessionDetail(String id) async {
    try {
      isSessionDetailLoading.value = true;

      return await Api().getSessionDetail(id);
    } catch (e) {
      log(e.toString());
    } finally {
      isSessionDetailLoading.value = false;
    }
  }

  Future<void> _mockUsers(String type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    switch (type) {
      case "student":
        studentsList.assignAll([
          Student(
            studentId: "STU001",
            name: "Aisha",
            email: "aisha@mail.com",
            joinedAt: DateTime.now(),
          ),
          Student(
              studentId: "STU002",
              name: "Rahul",
              email: "rahul@mail.com",
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
                    subjectName: 'Maths',
                    standard: '',
                    syllabus: '',
                    status: '',
                    // packageFee: 0,
                    // takenFee: 0,
                    balance: 0,
                    withdrawals: [],
                    time: '',
                    duration: '',
                    note: '')
              ]),
          Student(
            studentId: "STU003",
            name: "Fatima",
            email: "fatima@mail.com",
            joinedAt: DateTime.now(),
          ),
        ]);
        break;
      case "teacher":
        teacherList.assignAll([
          Teacher(
            id: "T001",
            name: "Ameen Rahman",
            email: "ameen@gmail.com",
            status: "Active",
            gender: "Male",
            type: "Batch",
            joinedAt: DateTime(2023, 5, 10),
            totalStudents: 45,
            totalSessions: 120,
            salary: 40000,
          ),
          Teacher(
            id: "T002",
            name: "Fathima Noor",
            email: "fathima@gmail.com",
            status: "Active",
            gender: "Female",
            joinedAt: DateTime(2024, 1, 15),
            salary: 35000,
          ),
        ]);
        break;

      case "mentor":
        mentorsList.assignAll([
          Mentor(
            empId: "MTR001",
            name: "Saeeda KP",
            email: "saeeda@gmail.com",
            status: "Active",
            gender: "Female",
            joinedAt: DateTime(2023, 3, 12),
            salary: 30000,
          ),
          Mentor(
            empId: "MTR002",
            name: "David Mathew",
            email: "david@gmail.com",
            status: "Active",
            gender: "Male",
            joinedAt: DateTime(2022, 11, 5),
            salary: 32000,
          ),
        ]);
        break;

      case "coordinator":
        coordinatorsList.assignAll([
          Coordinator(
            id: "COO001",
            name: "Najeeb Rahman",
            email: "najeeb.rahman@example.com",
            status: "Active",
            joinedAt: DateTime(2025, 1, 15),
            salary: 25000,
          ),
        ]);
        break;

      case "advisor":
        advisorsList.assignAll([
          Advisor(
            id: "ADV001",
            name: "Fathima",
          ),
        ]);
        break;
    }
  }

  Future<void> _apiUsers(String type) async {
    // final res = await ApiService.getUsers(type: type);

    // switch (type) {
    //   case "student":
    //     studentsList.assignAll(res);
    //     break;
    //   case "teacher":
    //     teacherList.assignAll(res);
    //     break;

    //   case "mentor":
    //     mentorsList.assignAll(res);
    //     break;

    //   case "coordinator":
    //     coordinatorsList.assignAll(res);
    //     break;

    //   case "advisor":
    //     advisorsList.assignAll(res);
    //     break;
    // }

    throw UnimplementedError();
  }

  Future<void> fetchStudentDetail() => fetchUsers("student");
  Future<void> fetchTeacherDetail() => fetchUsers("teacher");
  Future<void> fetchMentorDetail() => fetchUsers("mentor");
  Future<void> fetchCoordinatorDetail() => fetchUsers("coordinator");
  Future<void> fetchAdvisorDetail() => fetchUsers("advisor");

  Student? getStudentById(String id) {
    try {
      return studentsList.firstWhere((e) => e.studentId == id);
    } catch (e) {
      return null;
    }
  }

  Teacher? getTeacherById(String id) {
    try {
      return teacherList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Mentor? getMentorById(String id) {
    print("Clicked ID: $id");
    try {
      return mentorsList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Users mentorToUser(Mentor m) {
    return Users(
      empId: m.id,
      name: m.name,
      role: "mentor",
    );
  }

  Coordinator? getCoordinatorById(String id) {
    print("Clicked ID: $id");
    try {
      return coordinatorsList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Advisor? getAdvisorById(String id) {
    print("Clicked ID: $id");
    try {
      return advisorsList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  void applyFilters() {
    List<Session> temp = List<Session>.from(sessions);

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return (s.student?.name ?? '').toLowerCase().contains(query) ||
            (s.teacher?.name ?? '').toLowerCase().contains(query);
      }).toList();
    }

    /// ↕️ Sort
    if (sortType.value == SessionSortType.newest) {
      temp.sort((a, b) {
        final ad = a.sessionDate;
        final bd = b.sessionDate;

        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;

        return bd.compareTo(ad);
      });
    } else if (sortType.value == SessionSortType.oldest) {
      temp.sort((a, b) {
        final ad = a.sessionDate;
        final bd = b.sessionDate;

        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;

        return ad.compareTo(bd);
      });
    } else if (sortType.value == SessionSortType.student) {
      temp.sort(
          (a, b) => (a.student?.name ?? '').compareTo(b.student?.name ?? ''));
    } else if (sortType.value == SessionSortType.teacher) {
      temp.sort(
          (a, b) => (a.teacher?.name ?? '').compareTo(b.teacher?.name ?? ''));
    }

    filteredSessions.assignAll(temp);

    log("Sessions: ${sessions.length}");
    log("Filtered: ${filteredSessions.length}");
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                    dayPeriodColor: Theme.of(context).colorScheme.primary)),
            child: child!);
      },
    );

    if (picked != null) {
      selectedTime.value = picked;
      timeController.text = picked.format(context);
    }
  }

  void initEdit(Session data) {
    // Ensure teacher list is ready
    final uniqueTeachers = sessions.map((e) => e).toSet().toList();

    teacherList.clear();
    // teacherList.addAll(uniqueTeachers);

    // ✅ Set initial values safely
    // selectedDuration.value =
    //     durationOptions.contains(data.duration) ? data.duration : null;

    // selectedTeacher.value =
    //     teacherList.contains(data.teacher?.name) ? data.teacher?.name : null;

    // // Controllers
    // dateController = TextEditingController(
    //   text: "${data.sesdate?.day}/${data.date?.month}/${data.date?.year}",
    // );

    // timeController = TextEditingController(
    //   text: "${data.date?.hour}:${data.date?.minute}",
    // );

    salaryController =
        TextEditingController(text: data.teacherSalary.toString());
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

  // void loadSession(Session session) {
  //   dateController.text = DateFormat('dd/MM/yyyy').format(session.date!);
  //   selectedDate.value = session.date!;
  //   selectedDuration.value = session.duration;
  //   selectedTeacher.value = session.teacher;

  //   salaryController.text = session.teacherSalary?.toString() ?? '';
  // }

  void updateSession(String id) {
    final updatedData = {
      "date": dateController.text,
      "time": timeController.text,
      "duration": selectedDuration.value,
      "teacher": selectedTeacher.value,
      "salary": salaryController.text,
    };

    // API / DB update
    print("Updating session $id with $updatedData");
  }

  void addOrUpdateReport(SessionReport report) {
    final index = reports.indexWhere((r) => r.studentId == report.studentId);

    if (index == -1) {
      reports.add(report);
    } else {
      reports[index] = report;
    }
  }

  void openSessionReportDialog(Session session) {
    final controller = Get.put(SessionReportController());

    controller.initFromSession(session);

    CustomWidgets().showCustomDialog(
      context: Get.context!,
      title: Text("Edit Session Report"),
      icon: Icons.description,
      formKey: GlobalKey<FormState>(),
      isViewOnly: false,
      submitWidget: Text(
        "Save Report",
        style: Theme.of(Get.context!)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.white),
      ),
      onSubmit: controller.saveReport,
      sections: [
        SessionReportDialogBody(controller: controller),
      ],
    );
  }

  bool validateSession(BuildContext context) {
    String error = "";

    // 🧑 Student
    if (selectedType.value == "session") {
      if (selectedStudent.value == null) {
        error = "Please select a student";
      } else if (selectedPackage.value == null) {
        error = "Please select a package";
      } else if (selectedTeacher.value == null) {
        error = "Please select a teacher";
      } else if (salaryController.text.trim().isEmpty) {
        error = "Teacher salary is required";
      } else if (dateController.text.trim().isEmpty) {
        error = "Session date is required";
      } else if (timeController.text.trim().isEmpty) {
        error = "Session time is required";
      } else if (selectedDuration.value == null) {
        error = "Please select duration";
      }
    } else {
      // MEET VALIDATION
      if (meetTitleController.text.trim().isEmpty) {
        error = "Meet title is required";
      } else if (selectedMentors.isEmpty &&
          selectedTeachers.isEmpty &&
          selectedStudent.value == null &&
          selectedCoordinators.isEmpty &&
          selectedAdvisors.isEmpty &&
          selectedOtherUsers.isEmpty) {
        error = "Select at least one participant";
      } else if (dateController.text.trim().isEmpty) {
        error = "Session date is required";
      } else if (timeController.text.trim().isEmpty) {
        error = "Session time is required";
      } else if (selectedDuration.value == null) {
        error = "Please select duration";
      } else if (descriptionController.text.trim().isEmpty) {
        error = "Description is required";
      }
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

  void addSession() {}
}
