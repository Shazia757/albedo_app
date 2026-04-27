import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/report_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  final AuthController auth = Get.find();

  var selectedTab = 'Students'.obs;
  var searchQuery = ''.obs;
  var selectedRange = 'This Month'.obs;
  RxBool isSearching = false.obs;
  var isLoading = true.obs;

  var students = <Student>[].obs;
  var teachers = <Teacher>[].obs;
  var advisors = <Advisor>[].obs;
  var mentors = <Mentor>[].obs;
  var recommendationViews = <RecommendationView>[].obs;
  var hiringViews = <HiringView>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  Future<void> loadDummyData() async {
    try {
      isLoading.value = true;

      final user = auth.activeUser;

      await Future.delayed(const Duration(seconds: 2));

      final allStudents = _getDummyStudents();
      final allTeachers = _getDummyTeachers();
      final allAdvisors = _getDummyAdvisors();

      List<Student> studentResult;
      List<Teacher> teacherResult;
      List<Advisor> advisorResult;
      List<RecommendationView> recommendationViews = [];

      if (user?.role == "admin") {
        studentResult = allStudents; // full access
        teacherResult = allTeachers;
        advisorResult = allAdvisors;
      } else if (user?.role == "coordinator") {
        studentResult =
            allStudents.where((s) => s.coordinatorId == user!.id).toList();
        teacherResult =
            allTeachers.where((s) => s.coordinatorId == user!.id).toList();
        advisorResult =
            allAdvisors.where((a) => a.coordinatorId == user!.id).toList();
      } else if (user?.role == "teacher") {
        studentResult =
            allStudents.where((s) => s.teacherId == user!.id).toList();
        teacherResult = allTeachers.where((s) => s.id == user!.id).toList();
        advisorResult = [];
      } else if (user?.role == "mentor") {
        studentResult =
            allStudents.where((s) => s.mentorId == user!.id).toList();
        teacherResult =
            allTeachers.where((s) => s.mentorId == user!.id).toList();
        advisorResult =
            allAdvisors.where((a) => a.mentorId == user!.id).toList();
      } else {
        studentResult = [];
        teacherResult = [];
        advisorResult = [];
      }

      students.assignAll(studentResult);
      teachers.assignAll(teacherResult);
      advisors.assignAll(advisorResult);
      filteredStudents.assignAll(studentResult);
      filteredTeachers.assignAll(teacherResult);
      filteredAdvisors.assignAll(advisorResult);

      final responses = _getDummyRecommendationResponses();

      final allRecs = _getDummyRecommendations();
      for (var res in responses) {
        final student = allStudents.firstWhere(
          (s) => s.studentId == res.studentId,
        );

        final rec = allRecs.firstWhere(
          (r) => r.id == res.adId,
        );

        recommendationViews.add(
          RecommendationView(
            student: student,
            recommendation: rec,
            response: res,
          ),
        );
      }
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
        email: "riya@email.com",
        status: "Active",
        type: "Batch",
        joinedAt: DateTime.now(),
        admissionDate: DateTime.parse('2023-01-15 12:00:00'),
        teacherId: "T001",
        mentorId: "MTR001",
        coordinatorId: "COO1001",
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
        mentorId: "MTR002",
        coordinatorId: "COO1002",
      ),
    ];
  }

  List<Teacher> _getDummyTeachers() {
    return [
      Teacher(
        id: "TEA1001",
        name: "John",
        email: "john@email.com",
        status: "Active",
        type: "Batch",
        phone: "123456",
        joinedAt: DateTime.now(),
        gender: 'Male',
        coordinatorId: "COO1001",
        mentorId: "MTR001",
      ),
      Teacher(
        id: "TEA1002",
        name: "Ms. Smith",
        email: "smith@email.com",
        status: "Inactive",
        type: "Batch",
        phone: "+9876543210",
        joinedAt: DateTime.parse('2024-12-01 09:00:00'),
        gender: 'Female',
        coordinatorId: "COO1002",
        mentorId: "MTR002",
      ),
    ];
  }

  List<Advisor> _getDummyAdvisors() {
    return [
      Advisor(
        id: "ADV1001",
        name: "Aisha Rahman",
        email: "aisha@email.com",
        status: "Active",
        gender: "Female",
        joinedAt: DateTime.now(),
        phone: "+919876543210",
        whatsapp: "+919876543210",
        convertedStudents: 25,
        qualification: "MBA",
        place: "Malappuram",
        pincode: "676505",
        address: "Green Valley, Malappuram",
        dob: "1995-06-12",
        imageUrl: "",
      ),
      Advisor(
        id: "ADV1002",
        name: "Rahul Nair",
        email: "rahul@email.com",
        status: "Inactive",
        gender: "Male",
        joinedAt: DateTime.parse('2024-11-15 10:30:00'),
        phone: "+919123456789",
        whatsapp: "+919123456789",
        convertedStudents: 12,
        qualification: "B.Tech",
        place: "Kozhikode",
        pincode: "673001",
        address: "City Center, Kozhikode",
        dob: "1993-02-20",
        imageUrl: "",
      ),
      Advisor(
        id: "ADV1003",
        name: "Fatima Noor",
        email: "fatima@email.com",
        status: "Active",
        gender: "Female",
        joinedAt: DateTime.parse('2025-01-10 08:00:00'),
        phone: "+918765432198",
        whatsapp: "+918765432198",
        convertedStudents: 40,
        qualification: "M.Com",
        place: "Perintalmanna",
        pincode: "679322",
        address: "Near Town Hall, Perintalmanna",
        dob: "1996-09-05",
        imageUrl: "",
      ),
    ];
  }

  List<Recommendations> _getDummyRecommendations() {
    return [
      Recommendations(
        id: "REC001",
        package: "Flutter Training",
        batch: "Batch A",
        startDate: "2025-05-01",
        endDate: "2025-08-01",
        visibleTo: ["SYL001"],
      ),
    ];
  }

  List<RecommendationResponse> _getDummyRecommendationResponses() {
    return [
      RecommendationResponse(
        adId: "REC001",
        studentId: "STU1001",
        status: "Interested",
        respondedAt: DateTime.now(),
      ),
      RecommendationResponse(
        adId: "REC001",
        studentId: "STU1002",
        status: "Not Interested",
        respondedAt: DateTime.now(),
      ),
    ];
  }

  List<HiringResponse> _getDummyHiringResponses() {
    return [
      HiringResponse(
        adId: "AD001",
        teacherId: "TEA1001",
        status: "interested",
        respondedAt: DateTime.now(),
      ),
      HiringResponse(
        adId: "AD001",
        teacherId: "TEA1002",
        status: "not_interested",
        respondedAt: DateTime.now(),
      ),
    ];
  }

  List<Student> get filteredStudents {
    return students.where((e) {
      return e.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<Teacher> get filteredTeachers {
    return teachers.where((e) {
      return e.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<Advisor> get filteredAdvisors {
    return advisors.where((e) {
      return e.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }
  List<Mentor> get filteredMentors {
    return mentors.where((e) {
      return e.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<RecommendationView> get filteredRecommendations {
    final q = searchQuery.value.toLowerCase();

    return recommendationViews.where((r) {
      return r.student.name.toLowerCase().contains(q) ||
          (r.recommendation.package ?? '').toLowerCase().contains(q) ||
          r.response.status.toLowerCase().contains(q);
    }).toList();
  }

  List<HiringView> get filteredHiring {
    final q = searchQuery.value.toLowerCase();

    return hiringViews.where((h) {
      return h.teacher.name.toLowerCase().contains(q) ||
          h.ad.package.toLowerCase().contains(q) ||
          h.response.status.toLowerCase().contains(q);
    }).toList();
  }
}
