import 'package:albedo_app/login_page.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/view/home_page.dart';
import 'package:albedo_app/widgets/impersonation_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.activeUser;

      if (user == null) {
        return LoginView();
      }

      return Scaffold(
        body: Column(
          children: [
            const ImpersonationBanner(),
            Expanded(child: HomeView()),
          ],
        ),
      );
    });
  }
}
