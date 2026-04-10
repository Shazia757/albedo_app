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
      backgroundColor: const Color(0xFF0D0D1B), // Deep dark background
      body: Stack(
        children: [
          _background(),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  // const SizedBox(height: 50),
                  Image.asset("assets/images/logo.png", height: 80),
                  const SizedBox(height: 20),
                  Container(
                    // width: 400,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // Glassmorphism effect
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Glad you're back.!",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Using your existing CustomTextField - ensure it handles white text internally
                        CustomTextField(
                          prefixIcon: Icons.email_outlined,
                          hint: "Email address",
                          controller: c.emailController,
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          prefixIcon: Icons.lock_outline,
                          hint: "Password",
                          controller: c.passwordController,
                          isPassword: true,
                          obscure: c.obscurePassword,
                        ),

                        const SizedBox(height: 20),

                        // Login Button
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9D50FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () => c.login(),
                                child: c.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text("Login",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                              ),
                            )),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withOpacity(0.1))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("OR",
                                  style: TextStyle(color: Colors.white38)),
                            ),
                            Expanded(
                                child: Divider(
                                    color: Colors.white.withOpacity(0.1))),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // Google Sign In Button
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(30), // Pill shaped
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/google.png",
                                  height: 24),
                              const SizedBox(width: 12),
                              const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: InkWell(
                            onTap: () => Get.to(() => ForgotPasswordPage()),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Stack(
      children: [
        // Large Purple Glow (Top Left)
        Positioned(
          top: -100,
          left: -100,
          child: _glow(400, const Color(0xFF6200EA).withOpacity(0.4)),
        ),
        // Smaller Purple Glow (Middle Left)
        Positioned(
          top: 200,
          left: -50,
          child: _glow(250, const Color(0xFF9D50FF).withOpacity(0.3)),
        ),
        // Bottom Glow
        Positioned(
          bottom: -150,
          right: -50,
          child: _glow(500, const Color(0xFF6200EA).withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
