import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/common_views/forgot_password_page.dart';
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
              child: LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/logo.png", height: 80),
                          const SizedBox(height: 16),
                          Flexible(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Login",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Glad you're back.!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),

                                    const SizedBox(height: 24),

                                    CustomTextField(
                                      prefixIcon: Icons.email_outlined,
                                      hint: "Email address",
                                      controller: c.emailController,
                                    ),
                                    const SizedBox(height: 16),

                                    CustomTextField(
                                      prefixIcon: Icons.lock_outline,
                                      hint: "Password",
                                      controller: c.passwordController,
                                      isPassword: true,
                                      obscure: c.obscurePassword,
                                    ),

                                    const SizedBox(height: 16),

                                    // Login Button
                                    Obx(() => SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF9D50FF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () => c.login(),
                                            child: c.isLoading.value
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white)
                                                : const Text("Login",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white)),
                                          ),
                                        )),

                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                                color: Colors.white
                                                    .withOpacity(0.1))),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Text("OR",
                                              style: TextStyle(
                                                  color: Colors.white38)),
                                        ),
                                        Expanded(
                                            child: Divider(
                                                color: Colors.white
                                                    .withOpacity(0.1))),
                                      ],
                                    ),

                                    const SizedBox(height: 20),

                                    // Google Sign In Button
                                    InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () {
                                        // TODO: Google login
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                "assets/images/google.png",
                                                height: 22),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Sign in with Google",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: Colors.black87,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    Center(
                                      child: InkWell(
                                        onTap: () =>
                                            Get.to(() => ForgotPasswordPage()),
                                        child: Text(
                                          "Forgot Password?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: Colors.white70,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
          ],
        ));
  }

  Widget _background() {
    return SizedBox.expand(
      child: Image.asset(
        "assets/images/bg.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
