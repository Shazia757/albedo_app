import 'dart:ui';

import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                              const Text("Login",
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: Color(0xFF111827),
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              const Text("Glad you're back.!",
                                  style: TextStyle(color: Color(0xFF6B7280))),
                              const SizedBox(height: 28),
                              CustomTextField(
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: Color(0xFF9CA3AF)),
                                hint: "Email address",
                                controller: c.emailController,
                              ),
                              const SizedBox(height: 18),
                              Obx(() => CustomTextField(
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Color(0xFF9CA3AF)),
                                    hint: "Password",
                                    controller: c.passwordController,
                                    isPassword: true,
                                    obscure: c.obscurePassword.value,
                                    toggle: c.togglePassword,
                                  )),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Row(
                                      children: [
                                        Checkbox(
                                          value: c.rememberMe.value,
                                          activeColor: Color(0xFF7F00FF),
                                          onChanged: c.toggleRemember,
                                        ),
                                        const Text("Remember me",
                                            style: TextStyle(
                                                color: Color(0xFF374151))),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        Get.to(() => ForgotPasswordPage()),
                                    child: Text("Forgot Password?",
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Obx(() => GestureDetector(
                                    onTap: c.login,
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
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
                                            : const Text("Login",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                )),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 18),
                              Row(
                                children: const [
                                  Expanded(
                                      child: Divider(color: Color(0xFFE5E7EB))),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text("OR",
                                        style: TextStyle(
                                            color: Color(0xFF9CA3AF))),
                                  ),
                                  Expanded(
                                      child: Divider(color: Color(0xFFE5E7EB))),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Color(0xFFE5E7EB)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/google.png",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Sign in with Google",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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


