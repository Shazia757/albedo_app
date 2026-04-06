import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/view/login_page.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());

    return Scaffold(
      body: Row(
        children: [
          // 🌟 LEFT SIDE (Only Tablet/Desktop)
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 120, // adjust as needed
                  ),
                ),
              ),
            ),

          // 🔐 RIGHT SIDE (Login Form)
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                _background(),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset("assets/images/logo.png", height: 80),
                        Container(
                          width: Responsive.isDesktop(context)
                              ? 400
                              : double.infinity,
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withOpacity(0.6),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Forgot Password?",
                                    style: TextStyle(
                                      color: Color(0xFF374151),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )),
                                const SizedBox(height: 8),
                                const Text(
                                    "Enter your email to receive reset token",
                                    style: TextStyle(color: Color(0xFF6B7280))),
                                const SizedBox(height: 28),
                                CustomTextField(
                                  prefixIcon: Icons.email_outlined,
                                  hint: "Email address",
                                  controller: c.emailController,
                                ),
                                const SizedBox(height: 18),
                                Obx(
                                  () => CustomWidgets().buildActionButton(
                                    context: context,
                                    text: 'Send Request',
                                    loadingText: 'Sending Request...',
                                    isLoading: c.isLoading.value,
                                    onPressed: () => c.forgotPassword(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomWidgets().buildActionButton(
                                  context: context,
                                  text: 'Back to Login',
                                  onPressed: () => Get.offAll(LoginView()),
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .shadow
                                      .withOpacity(0.8),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8F9FF),
                Color(0xFFEDEBFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Glow effect
        Positioned(
          top: 100,
          left: -50,
          child: _glow(),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: _glow(),
        ),
      ],
    );
  }

  Widget _glow() {
    return Container(
      width: 300,
      height: 300,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0x337F00FF), // 👈 very light purple (20% opacity)
            Colors.transparent,
          ],
          stops: [0.2, 1.0], // 👈 smooth spread
        ),
      ),
    );
  }
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}
