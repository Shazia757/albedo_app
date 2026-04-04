import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/view/forgot_password_page.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // 🌟 LEFT SIDE (Only Tablet/Desktop)
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
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
                        if (Responsive.isMobile(context))
                          Image.asset("assets/images/logo.png", height: 80),
                        Container(
                          width: Responsive.isDesktop(context)
                              ? 400
                              : double.infinity,
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: cs.surface.withOpacity(0.7),
                            border: Border.all(
                              color: cs.outline.withOpacity(0.2),
                            ),
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
                              Text("Login",
                                  style: TextStyle(
                                      fontSize: 28,
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Glad you're back.!",
                                  style: TextStyle(
                                      color: cs.onSurface.withOpacity(0.6))),
                              const SizedBox(height: 28),
                              CustomTextField(
                                prefixIcon: Icons.email_outlined,
                                hint: "Email address",
                                controller: c.emailController,
                              ),
                              const SizedBox(height: 18),
                              CustomTextField(
                                prefixIcon: Icons.lock_outline,
                                hint: "Password",
                                controller: c.passwordController,
                                isPassword: true,
                                obscure:
                                    c.obscurePassword, // ✅ pass RxBool directly
                              ),
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
                                          activeColor: cs.secondary,
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
                              Obx(
                                () => buildActionButton(
                                  context: context,
                                  text: 'Login',
                                  color: cs.secondary,
                                  isLoading: c.isLoading.value,
                                  onPressed: () => c.login(),
                                ),
                              ),
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
