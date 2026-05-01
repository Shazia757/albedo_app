import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/view/notifications_page.dart';
import 'package:albedo_app/view/students/student_wallet_page.dart';
import 'package:albedo_app/view/teacher/teachers_wallet_page.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:ui'; // ✅ for blur

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Get.isDarkMode;
    final isDesktop = Responsive.isDesktop(context);

    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;
    final isTeacher = role == 'teacher';
    final isStudent = role == 'student';

    // ✅ Responsive height
    final height = isDesktop ? 72.0 : 60.0;

    return PreferredSize(
      preferredSize: Size.fromHeight(height),

      // ✨ GLASS EFFECT WRAPPER
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            toolbarHeight: height,

            // 🎨 UPDATED BACKGROUND
            backgroundColor: cs.onPrimary,
            elevation: 0,
            scrolledUnderElevation: 4,
            surfaceTintColor: Colors.transparent,

            automaticallyImplyLeading: !isDesktop,
            centerTitle: false,

            iconTheme: IconThemeData(
              color: cs.onSurface,
              size: isDesktop ? 22 : 20,
            ),

            title: title != null
                ? Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: cs.onSurface,
                          letterSpacing: 0.2,
                        ),
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: isDesktop ? 32 : 28, // responsive
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
            // ✅ ACTIONS (responsive spacing)
            actions: [
              _actionButton(
                icon: Icons.notifications_none,
                color: cs,
                onTap: () => Get.offAll(NotificationsPage()),
              ),
              SizedBox(width: isDesktop ? 10 : 6),
              if (isTeacher || isStudent) ...[
                _actionButton(
                  icon: Icons.account_balance_wallet_outlined,
                  color: cs,
                  onTap: () {
                    if (isStudent) {
                      Get.to(() => StudentWalletPage());
                    } else {
                      Get.to(() => TeacherWalletPage());
                    }
                  },
                ),
                SizedBox(width: isDesktop ? 10 : 6),
              ],
              _actionButton(
                icon: isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                color: cs,
                onTap: () {
                  Get.changeThemeMode(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  );
                },
              ),
              SizedBox(width: isDesktop ? 10 : 6),
            ],

            // subtle divider (slightly softer now)
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                color: cs.outline.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required ColorScheme color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          // 🎨 slightly improved contrast for glass bg
          color: color.onSurface.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color.onSurface, size: 20),
        ),
      ),
    );
  }
}
