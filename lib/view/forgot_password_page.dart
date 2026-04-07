import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/view/login_page.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1B), // Matches your new theme
      body: Stack(
        children: [
          _background(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo
                  Image.asset("assets/images/logo.png", height: 80),
                  const SizedBox(height: 20),

                  Container(
                    width: 400,
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
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please enter your email address to receive a password reset token.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Email Input
                        CustomTextField(
                          prefixIcon: Icons.email_outlined,
                          hint: "Enter your email",
                          controller: c.emailController,
                        ),
                        
                        const SizedBox(height: 25),
                        
                        // Send Request Button (Vibrant Purple)
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
                            onPressed: () => c.forgotPassword(),
                            child: c.isLoading.value 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Send Request", 
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                          ),
                        )),
                        
                        const SizedBox(height: 15),
                        
                        // Back to Login Button (Blueish tint to match screenshot)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D32C1), // Deeper blue
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () => Get.offAll(() => const LoginView()),
                            child: const Text(
                              "Back to Login", 
                              style: TextStyle(fontSize: 16, color: Colors.white)
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
        // Main Glow behind the card
        Positioned(
          top: 150,
          left: -80,
          child: _glow(350, const Color(0xFF6200EA).withOpacity(0.5)),
        ),
        // Secondary subtle glow
        Positioned(
          bottom: 50,
          right: -50,
          child: _glow(250, const Color(0xFF9D50FF).withOpacity(0.3)),
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
            blurRadius: 120,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}