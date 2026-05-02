import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TimeFilter { all, week, month, year }

class HomeController extends GetxController {
  var studentCount = 0.obs;
  var teacherCount = 0.obs;
  var coordinatorCount = 0.obs;
  var mentorCount = 0.obs;
  var advisorCount = 0.obs;

  var studentData = <double>[].obs;
  var session = <Session>[].obs;
  var teacherData = <double>[].obs;
  var coordinatorData = <double>[].obs;
  var advisorData = <double>[].obs;
  var mentorData = <double>[].obs;
  var isLoading = true.obs;
  var isUsersExpanded = false.obs;
  var selectedIndex = 0.obs;
  var selectedParentIndex = (-1).obs;
  var selectedSubIndex = (-1).obs;
  var totalPackage = 0.0.obs;

  var packageData = <Map<String, dynamic>>[].obs;

  RxDouble receivedSalary = 0.0.obs;
  RxString packageRange = "All".obs;

  RxList<double> pendingSalaryData = <double>[].obs;
  RxList<double> receivedSalaryData = <double>[].obs;
  RxList<double> totalHoursData = <double>[].obs;

  var totalHours = <double>[].obs;
  var classAmount = <double>[].obs;
  var totalSalary = <double>[].obs;
  var totalPackageData = <double>[].obs;
  var totalSpotData = <double>[].obs;
  final totalPackages = 0.obs;
  RxList<double> totalFeeData = <double>[].obs;
  RxList<double> pendingFeeData = <double>[].obs;
  RxList<double> totalClassesData = <double>[].obs;
  RxList<String> years = <String>[].obs;

  var expenseRatio = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalIncome = 0.0.obs;
  var selectedFilter = TimeFilter.all.obs;
  var studentRange = "This Year".obs;
  var teacherRange = "This Year".obs;
  var advisorRange = "This Year".obs;
  var coordinatorRange = "This Year".obs;
  var mentorRange = "This Year".obs;
  var summaryRange = "This Year".obs;
  var expenseRange = "This Year".obs;

  RxList<String> xLabels = <String>[].obs;
  var studentLabels = <String>[].obs;
  var teacherLabels = <String>[].obs;
  var advisorLabels = <String>[].obs;
  var coordinatorLabels = <String>[].obs;
  var mentorLabels = <String>[].obs;
  var expenseLabels = <String>[].obs;
  var isExpenseLoading = true.obs;
  final hiringAds = <HiringView>[].obs;
  final recommendations = <RecommendationView>[].obs;

  Future<void> refreshDashboard() async {
    isLoading.value = true;

    try {
      updateStudentData();
      updateTeacherData();
      updateMentorData();
      updateAdvisorData();
      updatecoordinatorData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final AuthController auth = Get.find();

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allSessions = _getDummySessions();

      List<Session> result;

      if (user?.role == "teacher") {
        result = allSessions.where((s) => s.teacher?.id == user!.id).toList();
      } else if (user?.role == "student") {
        result =
            allSessions.where((s) => s.student?.studentId == user!.id).toList();
      } else {
        result = [];
      }

      session.assignAll(allSessions);
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
        package: Package(
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
        syllabus: "CBSE Mathematics",
        className: "Class 10",
        teacher: Teacher(
          id: "TEA1001",
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
        date: DateTime(2026, 4, 28),
        time: const TimeOfDay(hour: 13, minute: 0),
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
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().add(const Duration(days: 1)),
        time: const TimeOfDay(hour: 13, minute: 0),
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
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
          id: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        time: const TimeOfDay(hour: 13, minute: 0),
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
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: const TimeOfDay(hour: 13, minute: 0),
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
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
          id: "MTR001",
          name: "Saeeda",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now(),
        time: const TimeOfDay(hour: 13, minute: 0),
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
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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
          id: "MTR002",
          name: "David",
          joinedAt: DateTime.now(),
        ),
        date: DateTime.now().subtract(const Duration(hours: 5)),
        time: const TimeOfDay(hour: 13, minute: 0),
        status: "meet_done",
      ),
      Session(
        id: "S007",
        student: Student(
          studentId: "ST07",
          name: "Sneha",
          joinedAt: DateTime.now(),
        ),
        package: Package(
            teacherId: '',
            teacherName: '',
            teacherImage: '',
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

  Session? get nextSession {
    if (session.isEmpty) return null;

    final now = DateTime.now();

    /// ✅ COPY list (IMPORTANT)
    final sortedSessions = List<Session>.from(session)
      ..sort((a, b) => a.date!.compareTo(b.date!));

    // started
    final started = sortedSessions.where((s) => s.status == "started");
    if (started.isNotEmpty) return started.first;

    // upcoming
    final upcoming = sortedSessions.where((s) => s.date!.isAfter(now)).toList();

    if (upcoming.isNotEmpty) {
      return upcoming.first;
    }

    return sortedSessions.first;
  }

  void loadHiringAds() {
    hiringAds.assignAll(getDummyHiring());
  }

  List<HiringView> getDummyHiring() {
    return [
      HiringView(
          teacher: Teacher(
            id: "T01",
            name: "Ameen",
            status: "Active",
            gender: "Male",
            joinedAt: DateTime.now(),
          ),
          ad: HiringAd(
            package: "Mathematics - Class 10",
            image: "https://picsum.photos/400/200",
            startDate: "May 1",
            endDate: "May 30",
            time: "10:00 AM - 11:00 AM",
            days: [Days.monday, Days.friday],
          ),
          response: HiringResponse(
              adId: '',
              teacherId: '',
              status: '',
              respondedAt: DateTime.now())),
    ];
  }

  void loadRecommendations() {
    recommendations.assignAll(getDummyRecommendations());
  }

  List<RecommendationView> getDummyRecommendations() {
    return [
      RecommendationView(
        student: Student(
          studentId: "STU001",
          name: "Aisha",
          joinedAt: DateTime.now(),
        ),
        recommendation: Recommendations(
          id: "REC001",
          visibleTo: ["student"],
        ),
        response: RecommendationResponse(
          adId: "AD001",
          studentId: "STU001",
          status: "pending",
          respondedAt: DateTime.now(),
        ),
      ),
      RecommendationView(
        student: Student(
          studentId: "STU002",
          name: "Rahul",
          joinedAt: DateTime.now(),
        ),
        recommendation: Recommendations(
          id: "REC002",
          visibleTo: ["student"],
        ),
        response: RecommendationResponse(
          adId: "AD002",
          studentId: "STU002",
          status: "interested",
          respondedAt: DateTime.now(),
        ),
      ),
      RecommendationView(
        student: Student(
          studentId: "STU003",
          name: "Fatima",
          joinedAt: DateTime.now(),
        ),
        recommendation: Recommendations(
          id: "REC003",
          visibleTo: ["student"],
        ),
        response: RecommendationResponse(
          adId: "AD003",
          studentId: "STU003",
          status: "not_interested",
          respondedAt: DateTime.now(),
        ),
      ),
    ];
  }

  void updateStudentData({TimeFilter? filter, String? range}) {
    if (range != null) {
      switch (range) {
        case "All":
          studentData.assignAll([10, 30, 20, 40, 35, 50]);
          studentLabels
              .assignAll(["2021", "2022", "2023", "2024", "2025", "2026"]);
          break;

        case "This Month":
          studentData.assignAll([5, 8, 6, 7, 9, 10]);
          studentLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
          break;

        case "This Year":
          studentData.assignAll([100, 200, 300, 400, 500, 600]);
          studentLabels
              .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
          break;
      }
      return;
    }
  }

  void loadDummyPackageAnalytics() {
    final range = packageRange.value;

    if (range == "This Week") {
      years.assignAll(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]);

      totalFeeData.assignAll([200, 350, 300, 400, 500, 450, 600]);
      pendingFeeData.assignAll([100, 150, 120, 180, 200, 170, 220]);
      totalClassesData.assignAll([2, 3, 2, 4, 5, 4, 6]);
      totalHoursData.assignAll([1, 2, 1.5, 2.5, 3, 2.5, 3.5]);

      totalPackages.value = 12;
    } else if (range == "This Month") {
      years.assignAll(["W1", "W2", "W3", "W4"]);

      totalFeeData.assignAll([1500, 2200, 1800, 2600]);
      pendingFeeData.assignAll([600, 900, 700, 1000]);
      totalClassesData.assignAll([12, 18, 15, 20]);
      totalHoursData.assignAll([20, 28, 24, 32]);

      totalPackages.value = 48;
    } else if (range == "This Year") {
      years.assignAll([
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ]);

      totalFeeData.assignAll([5, 8, 6, 10, 12, 9, 14, 11, 13, 15, 16, 18]);
      pendingFeeData.assignAll([2, 3, 2, 4, 5, 3, 6, 4, 5, 6, 7, 8]);
      totalClassesData
          .assignAll([20, 30, 25, 35, 40, 32, 45, 38, 42, 48, 50, 55]);
      totalHoursData
          .assignAll([30, 45, 38, 50, 60, 48, 70, 58, 65, 75, 80, 90]);

      totalPackages.value = 120;
    }
  }

  void updateTeacherData({String? range}) {
    switch (range) {
      case "All":
        teacherData.assignAll([2, 5, 3, 6, 4, 7]);
        teacherLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        teacherData.assignAll([1, 2, 3, 2, 4, 3]);
        teacherLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        teacherData.assignAll([10, 20, 30, 25, 35, 40]);
        teacherLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updateAdvisorData({String? range}) {
    switch (range) {
      case "All":
        advisorData.assignAll([2, 5, 3, 6, 4, 7]);
        advisorLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        advisorData.assignAll([1, 2, 3, 2, 4, 3]);
        advisorLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        advisorData.assignAll([10, 20, 30, 25, 35, 40]);
        advisorLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updatecoordinatorData({String? range}) {
    switch (range) {
      case "All":
        coordinatorData.assignAll([1, 2, 1, 3, 2, 4]);
        coordinatorLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        coordinatorData.assignAll([1, 1, 2, 1, 2, 2]);
        coordinatorLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        coordinatorData.assignAll([5, 10, 15, 20, 25, 30]);
        coordinatorLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updateMentorData({String? range}) {
    switch (range) {
      case "All":
        mentorData.assignAll([1, 2, 1, 3, 2, 4]);
        mentorLabels.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
        break;

      case "This Month":
        mentorData.assignAll([1, 1, 2, 1, 2, 2]);
        mentorLabels.assignAll(["W1", "W2", "W3", "W4", "W5", "W6"]);
        break;

      case "This Year":
        mentorData.assignAll([5, 10, 15, 20, 25, 30]);
        mentorLabels
            .assignAll(["2019", "2020", "2021", "2022", "2023", "2024"]);
        break;
    }
  }

  void updateSummaryData(String range) {
    switch (range) {
      case "All":
        loadDummyData(); // existing
        break;

      case "This Month":
        packageData.assignAll([
          {
            "name": "Total Package",
            "value": 12000000.0,
            "color": Colors.orange,
            "icon": Icons.inventory_2_outlined,
          },
          {
            "name": "To Collect",
            "value": 6000000.0,
            "color": Colors.purple,
            "icon": Icons.currency_rupee,
          },
        ]);
        break;

      case "This Year":
        packageData.assignAll([
          {
            "name": "Total Package",
            "value": 50000000.0,
            "color": Colors.orange,
            "icon": Icons.inventory_2_outlined,
          },
          {
            "name": "To Collect",
            "value": 20000000.0,
            "color": Colors.purple,
            "icon": Icons.currency_rupee,
          },
        ]);
        break;
    }

    // recalculate total
    totalPackage.value = packageData.fold(
      0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  void updateExpenseData(String range) {
    isExpenseLoading.value = true;

    final now = DateTime.now();

    List<double> hours = [];
    List<double> amount = [];
    List<double> salary = [];
    List<String> labels = [];

    switch (range) {
      case "All":
        final startYear = 2021;
        final currentYear = now.year;

        for (int y = startYear; y <= currentYear; y++) {
          labels.add(y.toString());
          hours.add(_mock(y));
          amount.add(_mock(y) * 100000);
          salary.add(_mock(y) * 50000);
        }
        break;

      case "Today":
        for (int h = 0; h < 24; h++) {
          labels.add("${h}h");
          hours.add(_mock(h));
          amount.add(_mock(h) * 10000);
          salary.add(_mock(h) * 5000);
        }
        break;

      case "This Week":
        final start = now.subtract(Duration(days: now.weekday - 1));

        for (int i = 0; i < now.weekday; i++) {
          final d = start.add(Duration(days: i));
          labels.add("${d.day}/${d.month}");

          hours.add(_mock(i));
          amount.add(_mock(i) * 50000);
          salary.add(_mock(i) * 20000);
        }
        break;

      case "This Month":
        int currentWeek = ((now.day - 1) ~/ 7) + 1;

        for (int w = 1; w <= currentWeek; w++) {
          labels.add("W$w");

          hours.add(_mock(w));
          amount.add(_mock(w) * 200000);
          salary.add(_mock(w) * 100000);
        }
        break;

      case "This Year":
        const months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ];

        for (int i = 0; i < 12; i++) {
          labels.add(months[i]);

          hours.add(_mock(i));
          amount.add(_mock(i) * 300000);
          salary.add(_mock(i) * 150000);
        }
        break;
    }

    totalHours.assignAll(hours);
    classAmount.assignAll(amount);
    totalSalary.assignAll(salary);
    expenseLabels.assignAll(labels);

    totalExpense.value = salary.isEmpty ? 0 : salary.reduce((a, b) => a + b);

    totalIncome.value = amount.isEmpty ? 0 : amount.reduce((a, b) => a + b);

    expenseRatio.value = totalIncome.value == 0
        ? 0
        : (totalExpense.value / totalIncome.value) * 100;

    isExpenseLoading.value = false;
  }

  double _mock(int seed) {
    return (seed * 10 + 20).toDouble();
  }

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    loadDummyData();
    loadChartData();
    loadDummyStudentAnalytics();
    loadDummyPackageAnalytics();
    fetchData();
    loadHiringAds();
    updateExpenseData(expenseRange.value);
    totalFeeData.assignAll([10, 20, 30, 25, 40]);
    pendingFeeData.assignAll([5, 10, 15, 10, 20]);
    totalClassesData.assignAll([2, 4, 6, 5, 7]);
    totalHoursData.assignAll([1, 3, 5, 4, 6]);
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // 🔥 Replace with your API call
      await Future.delayed(const Duration(seconds: 2));

      // Example response mapping
      studentCount.value = 1034;
      teacherCount.value = 10;
      coordinatorCount.value = 4;
      mentorCount.value = 18;
      advisorCount.value = 6;

      studentData.assignAll([10, 30, 20, 40, 35, 50]);
      teacherData.assignAll([2, 5, 3, 6, 4, 7]);
      coordinatorData.assignAll([1, 2, 1, 3, 2, 4]);
      mentorData.assignAll([3, 6, 4, 8, 5, 7]);
      advisorData.assignAll([2, 4, 3, 5, 6, 4]);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadDummyStudentAnalytics() {
    studentCount.value = 120;

    receivedSalary.value = 320000;

    totalPackageData.value = [5, 8, 6, 10];
    totalSpotData.value = [3, 6, 4, 7];

    totalSalary.assignAll([100000, 200000, 300000, 350000, 420000, 500000]);

    pendingSalaryData
        .assignAll([80000, 120000, 150000, 170000, 160000, 180000]);

    receivedSalaryData
        .assignAll([20000, 80000, 150000, 180000, 260000, 320000]);

    totalHoursData.assignAll([50, 80, 120, 140, 160, 200]);

    years.assignAll(["Jan", "Feb", "Mar", "Apr", "May", "Jun"]);
  }

  void toggleUsers() {
    isUsersExpanded.value = !isUsersExpanded.value;
  }

  void setIndex(int index) {
    selectedIndex.value = index;
  }

  void setSubIndex(int index) {
    selectedSubIndex.value = index;
  }

  void loadDummyData() {
    final data = [
      {
        "name": "Total Package",
        "value": 32919144.18,
        "color": Colors.orange,
        "icon": Icons.inventory_2_outlined,
      },
      {
        "name": "To Collect",
        "value": 20624645.51,
        "color": Colors.purple,
        "icon": Icons.currency_rupee,
      },
      {
        "name": "Refund",
        "value": 162388.63,
        "color": Colors.red,
        "icon": Icons.receipt_long,
      },
      {
        "name": "Coupon Code",
        "value": 1297.5,
        "color": Colors.blue,
        "icon": Icons.local_offer,
      },
    ];

    packageData.assignAll(data);

    totalPackage.value = data.fold(
      0,
      (sum, item) => sum + (item['value'] as double),
    );
  }

  void loadChartData() {
    totalHours.assignAll([0, 0, 0, 0, 0, 0]);
    classAmount.assignAll([0, 0, 0, 0, 16000000, 7000000]);
    totalSalary.assignAll([0, 0, 0, 0, 5000000, 2000000]);

    totalExpense.value = 8117251.30;
    totalIncome.value = 25375041.46;

    expenseRatio.value = (totalExpense.value / totalIncome.value) * 100;
  }
}
