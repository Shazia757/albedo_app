import 'package:albedo_app/common_views/login_page.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:albedo_app/modules/advisor/dashboard.dart';
import 'package:albedo_app/modules/coordinator/dashboard.dart';
import 'package:albedo_app/modules/mentor/dashboard.dart';
import 'package:albedo_app/modules/student/home_page.dart';
import 'package:albedo_app/modules/teacher/dashboard.dart';
import 'package:albedo_app/widgets/impersonation_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.activeUser;
      print("ROOT sees user: $user");

      if (user == null) {
        return LoginView();
      }

      Widget page;

      switch (user.role) {
        case "admin":
          page = HomeView();
          break;

        case "student":
          page = HomePage();
          break;
        case "teacher":
          page = TeacherDashboard();
          break;
        case "mentor":
          page = MentorDashboard();
          break;
        case "coordinator":
          page = CoordinatorDashboard();
          break;
        case "advisor":
          page = AdvisorDashboard();
          break;
        default:
          page = LoginView();
      }

      return Scaffold(
        body: Column(
          children: [
            const ImpersonationBanner(),
            Expanded(child: page),
          ],
        ),
      );
    });
  }
}
