import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AccountController());
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 Background Image + Overlay
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

          /// 🧾 Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    /// 🧠 Logo
                    Image.asset("assets/images/logo.png", height: 80),

                    SizedBox(height: 24),

                    /// 🧊 Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔤 Title
                          Text(
                            "Login",
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 8),

                          /// ✏️ Subtitle
                          Text(
                            "Glad you're back!",
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),

                          SizedBox(height: 24),

                          /// 📧 Email
                          CustomTextField(
                            hint: "Enter your email address",
                            prefixIcon: Icons.email_outlined,
                            controller: c.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            // optional:
                            // errorText: c.emailError.value,
                            // helperText: "We'll never share your email",
                          ),

                          SizedBox(height: 16),

                          /// 🔒 Password
                          CustomTextField(
                            hint: "Enter your password",
                            prefixIcon: Icons.lock_outline,
                            controller: c.passwordController,
                            isPassword: true,
                            obscure: c.obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            // optional:
                            // errorText: c.passwordError.value,
                            // helperText: "Minimum 8 characters",
                          ),

                          SizedBox(height: 24),

                          /// 🔘 Login Button
                          Obx(() {
                            final isLoading = c.isLoading.value;

                            return AnimatedScale(
                              scale: isLoading ? 0.98 : 1,
                              duration: const Duration(milliseconds: 150),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (!isLoading) {
                                      c.login();
                                    }
                                  },
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text("Logging in..."),
                                          ],
                                        )
                                      : Text("Login",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.white)),
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 24),

                          /// ➖ Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "OR",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white54),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24),

                          /// 🔵 Google Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                side: BorderSide(
                                  color: cs.outline.withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                await c.googleLogin();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google.png",
                                    height: 22,
                                  ),
                                  SizedBox(width: 12),
                                  Text("Sign in with Google",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          /// 🔗 Forgot Password
                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => Get.to(() => ForgotPasswordPage()),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Forgot Password?",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}
