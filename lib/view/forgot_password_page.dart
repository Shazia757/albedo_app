import 'package:albedo_app/controller/account_controller.dart';
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Albedo LMS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
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
                                const Text("Forgot Password",
                                    style: TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text(
                                    "Enter your email to receive reset token",
                                    style: TextStyle(color: Color(0xFF6B7280))),
                                const SizedBox(height: 28),
                                CustomTextField(
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      color: Color(0xFF9CA3AF)),
                                  hint: "Email address",
                                  controller: c.emailController,
                                ),
                                const SizedBox(height: 18),
                                Obx(() => GestureDetector(
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF7F00FF),
                                              Color(0xFFE100FF),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF7F00FF)
                                                  .withOpacity(0.2),
                                              blurRadius: 15,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: c.isLoading.value
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Text("Send Request",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  )),
                                        ),
                                      ),
                                    )),
                                const SizedBox(height: 12),
                                InkWell(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFFE5E7EB)),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Back to Login",
                                          style: TextStyle(
                                            color: Color(0xFF374151),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ))
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
