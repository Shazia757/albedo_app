import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, student, teacher }

enum FilterType { all, classSession, meetSession }

class SessionController extends GetxController {
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  var searchQuery = ''.obs;
  RxBool isSearching = false.obs;
  var selectAllMentors = false.obs;
  var selectAllTeachers = false.obs;
  var selectAllStudents = false.obs;
  var selectAllCoordinators = false.obs;
  var selectAllAdvisors = false.obs;
  var selectAllOtherUsers = false.obs;
  var sortType = SortType.newest.obs;
  var filterType = SortType.newest.obs;
  var sessions = <Session>[].obs;
  var selectedTeacher = RxnString();
  RxList<Student> selectedStudents = <Student>[].obs;
  RxList<Teacher> selectedTeachers = <Teacher>[].obs;
  RxList<Mentor> selectedMentors = <Mentor>[].obs;
  RxList<Coordinator> selectedCoordinators = <Coordinator>[].obs;
  RxList<Advisor> selectedAdvisors = <Advisor>[].obs;
  RxList<String> selectedOtherUsers = <String>[].obs;
  final RxBool showStudentMenu = false.obs;
  var selectedTeacherEdit = RxnString();
  final formKey = GlobalKey<FormState>();
  var selectedDuration = Rxn<int>();
  var selectedPackage = RxnString();
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  RxString selectedType = "session".obs;
  RxList<Student> studentsList = <Student>[].obs;
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Coordinator> coordinatorsList = <Coordinator>[].obs;
  RxList<Advisor> advisorsList = <Advisor>[].obs;
  RxList<String> otherUsersList = <String>[].obs;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController meetTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  final packageOptions = ['Package A', 'Package B', 'Package C'];

  RxBool isLoading = true.obs;
  RxBool isDeleteButtonLoading = false.obs;

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

  List<Session> get filteredSessions {
    final status = statusMap[selectedTab.value];

    // ✅ Step 1: Filter first
    List<Session> filtered = sessions.where((s) {
      final matchesStatus = s.status == status;

      final matchesSearch = s.studentName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.studentId.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.teacherId.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.teacherName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.id.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.package.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.className.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.date.toString().contains(searchQuery.value.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
    if (selectedTeacher.value != null && selectedTeacher.value!.isNotEmpty) {
      filtered = filtered
          .where((s) => s.teacherName == selectedTeacher.value)
          .toList();
    }

    // 🔥 Step 2: ADD SORTING HERE (THIS IS WHAT YOU ASKED)
    switch (sortType.value) {
      case SortType.newest:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortType.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortType.student:
        filtered.sort((a, b) => a.studentName.compareTo(b.studentName));
        break;
      case SortType.teacher:
        filtered.sort((a, b) => a.teacherName.compareTo(b.teacherName));
        break;
    }

    // ✅ Step 3: Return final list
    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchStudentDetail();
    fetchTeacherDetail();
    fetchMentorDetail();
    fetchCoordinatorDetail();
    fetchAdvisorDetail();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      sessions.assignAll([
        Session(
          id: "S001",
          studentName: "Aisha",
          studentId: "STU001",
          package: "Premium Package",
          syllabus: "CBSE Mathematics",
          className: "Class 10",
          teacherName: "Ameen Rahman",
          teacherId: "T001",
          mentorName: "Saeeda",
          mentorId: "MTR001",

          // Optional fields
          coordinatorName: "Najeeb",
          coordinatorId: "COO001",
          advisorName: "Fathima",
          advisorId: "ADV001",

          date: DateTime(2026, 4, 23),
          time: DateTime(2026, 4, 23, 10, 30), // 10:30 AM
          status: "started",

          duration: 60, // in minutes
          teacherSalary: 500.0,
        ),
        Session(
          id: "S002",
          studentName: "Rahul",
          studentId: "ST02",
          syllabus: 'SCERT',
          mentorId: 'MTR002',
          mentorName: 'David',
          package: "Science",
          className: "9B",
          teacherName: "David",
          teacherId: "T002",
          date: DateTime.now().add(const Duration(days: 1)),
          time: DateTime.now(),
          status: "upcoming",
        ),
        Session(
          id: "S003",
          studentName: "Fatima",
          studentId: "ST03",
          package: "English",
          syllabus: 'CBSE',
          className: "8C",
          mentorId: 'MTR001',
          mentorName: 'Saeeda',
          teacherName: "John",
          teacherId: "T001",
          date: DateTime.now(),
          time: DateTime.now(),
          status: "pending",
        ),
        Session(
          id: "S004",
          studentName: "Arjun",
          studentId: "ST04",
          package: "Physics",
          syllabus: 'SCERT',
          mentorId: 'MTR002',
          mentorName: 'David',
          className: "11A",
          teacherName: "Meera",
          teacherId: "T03",
          date: DateTime.now().subtract(const Duration(days: 3)),
          time: DateTime.now(),
          status: "completed",
        ),
        Session(
          id: "S005",
          studentName: "Nisha",
          studentId: "ST05",
          package: "Chemistry",
          syllabus: "CBSE",
          className: "12B",
          mentorId: 'MTR001',
          mentorName: 'Saeeda',
          teacherName: "David",
          teacherId: "T002",
          date: DateTime.now(),
          time: DateTime.now(),
          status: "no_balance",
        ),
        Session(
          id: "S006",
          studentName: "Ali",
          studentId: "ST06",
          package: "Biology",
          syllabus: 'SCERT',
          mentorId: 'MTR002',
          mentorName: 'David',
          className: "10A",
          teacherName: "Meera",
          teacherId: "T03",
          time: DateTime.now(),
          date: DateTime.now().subtract(const Duration(hours: 5)),
          status: "meet_done",
        ),
        Session(
          id: "S007",
          studentName: "Sneha",
          studentId: "ST07",
          package: "Math",
          syllabus: 'CBSE',
          mentorId: 'MTR001',
          mentorName: 'Saeeda',
          className: "9A",
          time: DateTime.now(),
          teacherName: "John",
          teacherId: "T001",
          date: DateTime.now().add(const Duration(hours: 3)),
          status: "started",
        ),
      ]);
      filteredSessions.assignAll(sessions);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStudentDetail() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      studentsList.assignAll([
        Student(
            studentId: "STU001",
            name: "Aisha",
            email: "aisha@mail.com",
            joinedAt: DateTime.now()),
        Student(
            studentId: "STU002",
            name: "Rahul",
            email: "rahul@mail.com",
            joinedAt: DateTime.now())
      ]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
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

  // void setStudents(List<Student> list) {
  //   studentsList.assignAll(list);

  //   _studentMap.clear();
  //   for (var s in list) {
  //     _studentMap[s.studentId!] = s;
  //   }
  // }

  Student? getStudentById(String id) {
    try {
      return studentsList.firstWhere((e) => e.studentId == id);
    } catch (e) {
      return null;
    }
  }

  Users studentToUser(Student s) {
    return Users(
      id: s.studentId!,
      name: s.name,
      role: "student",
    );
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
      id: m.id,
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

  Users coordinatorToUser(Coordinator c) {
    return Users(
      id: c.id,
      name: c.name,
      role: "coordinator",
    );
  }

  Advisor? getAdvisorById(String id) {
    print("Clicked ID: $id");
    try {
      return advisorsList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Users advisorToUser(Advisor a) {
    return Users(
      id: a.id,
      name: a.name,
      role: "advisor",
    );
  }

  void applyFilters() {
    List<Session> temp = sessions;

    /// 🎯 Tab-based status filter
    final status = statusMap[selectedTab.value];
    temp = temp.where((s) => s.status == status).toList();

    /// 🔍 Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      temp = temp.where((s) {
        return s.studentName.toLowerCase().contains(query) ||
            s.teacherName.toLowerCase().contains(query);
      }).toList();
    }

    /// ↕️ Sort (keep if needed)
    if (sortType.value == "new") {
      temp.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortType.value == "old") {
      temp.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortType.value == "name") {
      temp.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    /// ✅ Final update
    filteredSessions.assignAll(temp);
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
    selectedDuration.value =
        durationOptions.contains(data.duration) ? data.duration : null;

    selectedTeacher.value =
        teacherList.contains(data.teacherName) ? data.teacherName : null;

    // Controllers
    dateController = TextEditingController(
      text: "${data.date.day}/${data.date.month}/${data.date.year}",
    );

    timeController = TextEditingController(
      text: "${data.date.hour}:${data.date.minute}",
    );

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

  void loadSession(Session session) {
    dateController.text = session.date.toString();
    timeController.text = session.time.toString();

    selectedDuration.value = session.duration;
    selectedTeacher.value = session.teacherName;

    salaryController.text = session.teacherSalary?.toString() ?? '';
  }

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
}
