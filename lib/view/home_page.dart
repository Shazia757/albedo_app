import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/home_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/home_controller.dart';
import '../../../../widgets/drawer_menu.dart';
import 'package:flutter/foundation.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) DrawerMenu(),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final auth = Get.find<AuthController>();
              final role = auth.activeUser?.role;

              return RefreshIndicator(
                onRefresh: () async {
                  await c.refreshDashboard(); // we'll define this
                },
                child: SingleChildScrollView(
                   physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _buildDashboard(context, role),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, String? role) {
    switch (role) {
      case "student":
        return _studentDashboard(context);

      case "teacher":
        return _teacherDashboard(context);

      case "mentor":
        return _mentorDashboard(context);

      case "coordinator":
        return _coordinatorDashboard(context);

      case "advisor":
        return _advisorDashboard(context);

      case "admin":
        return _adminDashboard(context);

      case "finance":
        return _financeDashboard(context);

      case "sales":
        return _salesheadDashboard(context);
      case "hr":
        return _hrDashboard(context);

      default:
        return const SizedBox();
    }
  }

  Widget _studentDashboard(BuildContext context) {
    return Column(
      children: [
        packagesAnalyticsCard(context),
        const SizedBox(height: 14),
        nextSessionCard(context),
        const SizedBox(height: 14),
        youtubeCard(context),
        const SizedBox(height: 14),
        recommendationSection(context),
      ],
    );
  }

  Widget _teacherDashboard(BuildContext context) {
    return Column(
      children: [
        studentsAnalyticsCard(context),
        const SizedBox(height: 14),
        youtubeCard(context),
        const SizedBox(height: 14),
        nextSessionCard(context),
        const SizedBox(height: 14),
        hiringSection(context),
      ],
    );
  }

  Widget _mentorDashboard(BuildContext context) {
    return Column(
      children: [
        expenseChartCard(context),
        const SizedBox(height: 14),
        youtubeCard(context),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Teachers Count",
          count: c.teacherCount.value.toString(),
          data: c.teacherData,
          color: Theme.of(context).colorScheme.secondary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updateTeacherData();
          },
          selectedRange: c.teacherRange,
          onRangeChanged: (v) {
            c.teacherRange.value = v;
            c.updateTeacherData(range: v);
          },
        ),
        const SizedBox(height: 14),
        summaryCard(context),
      ],
    );
  }

  Widget _coordinatorDashboard(BuildContext context) {
    return Column(
      children: [
        expenseChartCard(context),
        const SizedBox(height: 14),
        youtubeCard(context),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Teachers Count",
          count: c.teacherCount.value.toString(),
          data: c.teacherData,
          color: Theme.of(context).colorScheme.secondary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updateTeacherData();
          },
          selectedRange: c.teacherRange,
          onRangeChanged: (v) {
            c.teacherRange.value = v;
            c.updateTeacherData(range: v);
          },
        ),
        const SizedBox(height: 14),
        summaryCard(context),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Mentors Count",
          count: c.mentorCount.value.toString(),
          data: c.mentorData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (p0) {
            c.selectedFilter.value = p0;
            c.updateMentorData();
          },
          selectedRange: c.mentorRange,
          onRangeChanged: (p0) {
            c.mentorRange.value = p0;
            c.updateMentorData(range: p0);
          },
        ),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Coordinators Count",
          count: c.coordinatorCount.value.toString(),
          data: c.coordinatorData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updatecoordinatorData();
          },
          selectedRange: c.coordinatorRange,
          onRangeChanged: (v) {
            c.coordinatorRange.value = v;
            c.updatecoordinatorData(range: v);
          },
        ),
        const SizedBox(height: 14),
        hiringSection(context),
        const SizedBox(height: 14),
        recommendationSection(context),
      ],
    );
  }

  Widget _advisorDashboard(BuildContext context) {
    return Column(
      children: [
        studentsAnalyticsCard(context),
        const SizedBox(height: 14),
        youtubeCard(context),
        const SizedBox(height: 14),
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
      ],
    );
  }

  Widget _adminDashboard(BuildContext context) {
    return Column(
      children: [
        /// 🔹 EXPENSE
        expenseChartCard(context),
        const SizedBox(height: 14),

        /// 🔹 VIDEO
        youtubeCard(context),
        const SizedBox(height: 14),

        /// 🔹 STUDENTS COUNT
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 TEACHERS COUNT
        chartCard(
          context,
          title: "Teachers Count",
          count: c.teacherCount.value.toString(),
          data: c.teacherData,
          color: Theme.of(context).colorScheme.secondary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updateTeacherData();
          },
          selectedRange: c.teacherRange,
          onRangeChanged: (v) {
            c.teacherRange.value = v;
            c.updateTeacherData(range: v);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 SUMMARY
        summaryCard(context),
        const SizedBox(height: 14),

        /// 🔹 MENTORS COUNT
        chartCard(
          context,
          title: "Mentors Count",
          count: c.mentorCount.value.toString(),
          data: c.mentorData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (p0) {
            c.selectedFilter.value = p0;
            c.updateMentorData();
          },
          selectedRange: c.mentorRange,
          onRangeChanged: (p0) {
            c.mentorRange.value = p0;
            c.updateMentorData(range: p0);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 COORDINATORS COUNT
        chartCard(
          context,
          title: "Coordinators Count",
          count: c.coordinatorCount.value.toString(),
          data: c.coordinatorData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updatecoordinatorData();
          },
          selectedRange: c.coordinatorRange,
          onRangeChanged: (v) {
            c.coordinatorRange.value = v;
            c.updatecoordinatorData(range: v);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 RECOMMENDATIONS
        recommendationSection(context),
        const SizedBox(height: 14),

        /// 🔹 HIRING
        hiringSection(context),
      ],
    );
  }

  Widget _financeDashboard(BuildContext context) {
    return Column(
      children: [
        /// 🔹 EXPENSE
        expenseChartCard(context),
        const SizedBox(height: 14),

        /// 🔹 VIDEO
        youtubeCard(context),
        const SizedBox(height: 14),

        /// 🔹 STUDENTS COUNT
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 TEACHERS COUNT
        chartCard(
          context,
          title: "Teachers Count",
          count: c.teacherCount.value.toString(),
          data: c.teacherData,
          color: Theme.of(context).colorScheme.secondary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updateTeacherData();
          },
          selectedRange: c.teacherRange,
          onRangeChanged: (v) {
            c.teacherRange.value = v;
            c.updateTeacherData(range: v);
          },
        ),
      ],
    );
  }

  Widget _salesheadDashboard(BuildContext context) {
    return Column(
      children: [
        /// 🔹 EXPENSE
        studentsAnalyticsCard(context),
        const SizedBox(height: 14),

        /// 🔹 VIDEO
        youtubeCard(context),
        const SizedBox(height: 14),

        /// 🔹 STUDENTS COUNT
        chartCard(
          context,
          title: "Students Count",
          count: c.studentCount.value.toString(),
          data: c.studentData,
          color: Theme.of(context).colorScheme.primary,
          selectedFilter: TimeFilter.all,
          onFilterChanged: (_) {},
          selectedRange: c.studentRange,
          onRangeChanged: (v) {
            c.studentRange.value = v;
            c.updateStudentData(range: v);
          },
        ),
        const SizedBox(height: 14),

        /// 🔹 TEACHERS COUNT
        chartCard(
          context,
          title: "Advisors Count",
          count: c.advisorCount.value.toString(),
          data: c.advisorData,
          color: Theme.of(context).colorScheme.secondary,
          selectedFilter: c.selectedFilter.value,
          onFilterChanged: (f) {
            c.selectedFilter.value = f;
            c.updateAdvisorData();
          },
          selectedRange: c.teacherRange,
          onRangeChanged: (v) {
            c.advisorRange.value = v;
            c.updateAdvisorData(range: v);
          },
        ),
      ],
    );
  }

  Widget _hrDashboard(BuildContext context) {
    return Column(
      children: [
        /// 🔹 VIDEO
        youtubeCard(context),
        const SizedBox(height: 14),
      ],
    );
  }
}
