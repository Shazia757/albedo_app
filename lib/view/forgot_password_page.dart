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
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/bg.jpg",
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo
                  Image.asset("assets/images/logo.png", height: 80),
                  SizedBox(height: 20),

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
                        Text(
                          "Forgot Password?",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Please enter your email address to receive a password reset token.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white.withOpacity(0.7)),
                        ),
                        SizedBox(height: 30),

                        // Email Input
                        CustomTextField(
                          prefixIcon: Icons.email_outlined,
                          hint: "Enter your email",
                          controller: c.emailController,
                        ),

                        SizedBox(height: 25),

                        // Send Request Button (Vibrant Purple)
                        Obx(() => SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () => c.forgotPassword(),
                                child: c.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text("Send Request",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Colors.white)),
                              ),
                            )),

                        SizedBox(height: 15),

                        // Back to Login Button (Blueish tint to match screenshot)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary, // Deeper blue
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () =>
                                Get.offAll(() => const LoginView()),
                            child: Text("Back to Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white)),
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
}
