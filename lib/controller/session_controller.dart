import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/session_report_controller.dart';
import 'package:albedo_app/model/meet_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/sessions/session_report_dialog.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, oldest, student, teacher }

enum FilterType { all, classSession, meetSession }

class SessionController extends GetxController {
  final AuthController auth = Get.find();
  var selectedTab = 0.obs;
  var selectedStatus = 0.obs;
  final RxInt currentSessionIndex = 0.obs;
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
  var meets = <Meet>[].obs;
  RxList<SessionReport> reports = <SessionReport>[].obs;
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
  String selectedFile = '';
  RxList<Teacher> teacherList = <Teacher>[].obs;
  RxList<Mentor> mentorsList = <Mentor>[].obs;
  RxList<Category> categoryList = <Category>[].obs;
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
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();

  final durationOptions = [30, 45, 60, 75, 90, 105, 120];

  final packageOptions = ['Package A', 'Package B', 'Package C'];

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

  List<Session> get filteredSessions {
    final status = statusMap[selectedTab.value];

    // ✅ Step 1: Filter first
    List<Session> filtered = sessions.where((s) {
      final matchesStatus = s.status == status;

      final matchesSearch = s.student!.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.student!.studentId!
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.teacher!.id
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          s.teacher!.name
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
          .where((s) => s.teacher?.name == selectedTeacher.value)
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
        filtered.sort((a, b) => a.student!.name.compareTo(b.student!.name));
        break;
      case SortType.teacher:
        filtered.sort((a, b) => a.teacher!.name.compareTo(b.teacher!.name));
        break;
    }

    // ✅ Step 3: Return final list
    return filtered;
  }

  List<Meet> get filteredMeets {
    final tab = statusMap[selectedTab.value];

    List<Meet> filtered = meets.where((m) {
      bool matchesStatus = true;

      // 🎯 Map tab → meet status
      if (tab == "meet_done") {
        matchesStatus = m.status == "finished";
      }

      final matchesSearch =
          m.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              m.date.toString().contains(searchQuery.value.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allSessions = _getDummySessions();
      final allMeets = _getDummyMeets();

      List<Session> result = [];
      List<Meet> meetResult = [];

      if (user?.role == "admin") {
        result = allSessions;
        meetResult = allMeets;
      } else if (user?.role == "coordinator") {
        result =
            allSessions.where((s) => s.coordinator?.id == user!.id).toList();

        meetResult = allMeets
            .where((m) => m.members.any((u) => u.id == user?.id))
            .toList();
      } else if (user?.role == "teacher") {
        result = allSessions.where((s) => s.teacher?.id == user!.id).toList();

        meetResult = allMeets
            .where((m) => m.members.any((u) => u.id == user?.id))
            .toList();
      } else if (user?.role == "mentor") {
        result = allSessions.where((s) => s.mentor?.id == user!.id).toList();

        meetResult = allMeets
            .where((m) => m.members.any((u) => u.id == user?.id))
            .toList();
      } else {
        result = [];
        meetResult = [];
      }

      // ✅ Assign safely
      sessions.assignAll(result);
      meets.assignAll(meetResult);

      filteredSessions.assignAll(result);
      filteredMeets.assignAll(meetResult);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
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
        package: "Premium Package",
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
          id: "MTR001",
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
        time: const TimeOfDay(hour: 10, minute: 30),
        status: "started",
      ),
      Session(
        id: "S002",
        student: Student(
          studentId: "STU002",
          name: "Rahul",
          joinedAt: DateTime.now(),
        ),
        package: "Science",
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(days: 1)),
        time: const TimeOfDay(hour: 9, minute: 0),
        status: "upcoming",
      ),
      Session(
        id: "S003",
        student: Student(
          studentId: "STU003",
          name: "Fatima",
          joinedAt: DateTime.now(),
        ),
        package: "English",
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
          id: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        time: const TimeOfDay(hour: 11, minute: 15),
        status: "pending",
      ),
      Session(
        id: "S004",
        student: Student(
          studentId: "ST04",
          name: "Arjun",
          joinedAt: DateTime.now(),
        ),
        package: "Physics",
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: const TimeOfDay(hour: 14, minute: 0),
        status: "completed",
      ),
      Session(
        id: "S005",
        student: Student(
          studentId: "ST05",
          name: "Nisha",
          joinedAt: DateTime.now(),
        ),
        package: "Chemistry",
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
          id: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        time: const TimeOfDay(hour: 16, minute: 30),
        status: "no_balance",
      ),
      Session(
        id: "S006",
        student: Student(
          studentId: "ST06",
          name: "Ali",
          joinedAt: DateTime.now(),
        ),
        package: "Biology",
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(hours: 5)),
        time: const TimeOfDay(hour: 8, minute: 45),
        status: "meet_done",
      ),
      Session(
        id: "S007",
        student: Student(
          studentId: "ST07",
          name: "Sneha",
          joinedAt: DateTime.now(),
        ),
        package: "Math",
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
          id: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(hours: 3)),
        time: const TimeOfDay(hour: 13, minute: 0),
        status: "started",
      ),
    ];
  }

  List<Meet> _getDummyMeets() {
    return [
      Meet(
        id: "MT001",
        title: "Math Revision Meet",
        date: DateTime.now().subtract(const Duration(days: 1)),
        startTime: "10:00 AM",
        endTime: "11:00 AM",
        status: "finished",
        members: [
          Users(
            id: "STU001",
            name: "Aisha",
            email: "aisha@mail.com",
            role: "Student",
          ),
          Users(
            id: "T001",
            name: "Ameen Rahman",
            email: "ameen@mail.com",
            role: "Teacher",
          ),
          Users(
            id: "MTR001",
            name: "Saeeda",
            email: "saeeda@mail.com",
            role: "Mentor",
          ),
        ],
      ),
      Meet(
        id: "MT002",
        title: "Science Doubt Clearing",
        date: DateTime.now(),
        startTime: "09:30 AM",
        endTime: "10:30 AM",
        status: "ongoing",
        members: [
          Users(
            id: "STU002",
            name: "Rahul",
            email: "rahul@mail.com",
            role: "Student",
          ),
          Users(
            id: "T002",
            name: "David",
            email: "david@mail.com",
            role: "Teacher",
          ),
        ],
      ),
      Meet(
        id: "MT003",
        title: "English Speaking Practice",
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: "11:00 AM",
        endTime: "12:00 PM",
        status: "upcoming",
        members: [
          Users(
            id: "STU003",
            name: "Fatima",
            email: "fatima@mail.com",
            role: "Student",
          ),
          Users(
            id: "T003",
            name: "John",
            email: "john@mail.com",
            role: "Teacher",
          ),
          Users(
            id: "ADV001",
            name: "Fathima",
            email: "advisor@mail.com",
            role: "Advisor",
          ),
        ],
      ),
      Meet(
        id: "MT004",
        title: "Physics Problem Solving",
        date: DateTime.now().subtract(const Duration(days: 2)),
        startTime: "02:00 PM",
        endTime: "03:00 PM",
        status: "finished",
        members: [
          Users(
            id: "ST04",
            name: "Arjun",
            email: "arjun@mail.com",
            role: "Student",
          ),
          Users(
            id: "T003",
            name: "Meera",
            email: "meera@mail.com",
            role: "Teacher",
          ),
          Users(
            id: "COO1001",
            name: "Maria",
            email: "maria@mail.com",
            role: "Coordinator",
          ),
        ],
      ),
      Meet(
        id: "MT005",
        title: "Chemistry Quick Revision",
        date: DateTime.now().add(const Duration(hours: 5)),
        startTime: "04:00 PM",
        endTime: "05:00 PM",
        status: "upcoming",
        members: [
          Users(
            id: "ST05",
            name: "Nisha",
            email: "nisha@mail.com",
            role: "Student",
          ),
          Users(
            id: "T002",
            name: "David",
            email: "david@mail.com",
            role: "Teacher",
          ),
        ],
      ),
      Meet(
        id: "MT006",
        title: "Biology Live Discussion",
        date: DateTime.now(),
        startTime: "08:30 AM",
        endTime: "09:15 AM",
        status: "finished",
        members: [
          Users(
            id: "ST06",
            name: "Ali",
            email: "ali@mail.com",
            role: "Student",
          ),
          Users(
            id: "T003",
            name: "Meera",
            email: "meera@mail.com",
            role: "Teacher",
          ),
          Users(
            id: "MTR002",
            name: "David",
            email: "mentor@mail.com",
            role: "Mentor",
          ),
        ],
      ),
    ];
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

  Advisor? getAdvisorById(String id) {
    print("Clicked ID: $id");
    try {
      return advisorsList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
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
        return s.student!.name.toLowerCase().contains(query) ||
            s.teacher!.name.toLowerCase().contains(query);
      }).toList();
    }

    /// ↕️ Sort (keep if needed)
    if (sortType.value == "new") {
      temp.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortType.value == "old") {
      temp.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortType.value == "name") {
      temp.sort((a, b) => a.student!.name.compareTo(b.student!.name));
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
        teacherList.contains(data.teacher?.name) ? data.teacher?.name : null;

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
    selectedTeacher.value = session.teacher?.name;

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
      title: const Text("Edit Session Report"),
      icon: Icons.description,
      formKey: GlobalKey<FormState>(),
      isViewOnly: false,
      submitText: "Save Report",
      onSubmit: controller.saveReport,
      sections: [
        SessionReportDialogBody(controller: controller),
      ],
    );
  }
}
