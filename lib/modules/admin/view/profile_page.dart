import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AccountController c = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: isWide ? null : const DrawerMenu(),
      backgroundColor: cs.surfaceContainerLowest,
      body: Obx(() {
        final user = c.user.value;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              children: [
                /// ── PROFILE HERO CARD ──────────────────────────────────
                _ProfileHeroCard(user: user, cs: cs, c: c),

                const SizedBox(height: 20),

                /// ── ACCOUNT INFO ───────────────────────────────────────
                _SectionCard(
                  title: "Account Info",
                  icon: Icons.badge_outlined,
                  cs: cs,
                  child: Column(
                    children: [
                      _InfoRow(
                        label: "Employee ID",
                        value: user.id ?? "—",
                        icon: Icons.fingerprint,
                        cs: cs,
                      ),
                      _Divider(cs: cs),
                      _InfoRow(
                        label: "Email",
                        value: user.email ?? "—",
                        icon: Icons.mail_outline_rounded,
                        cs: cs,
                      ),
                      _Divider(cs: cs),
                      _InfoRow(
                        label: "Phone",
                        value: user.contact ?? "—",
                        icon: Icons.phone_outlined,
                        cs: cs,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ── QUICK ACCESS ───────────────────────────────────────
                _SectionCard(
                  title: "Quick Access",
                  icon: Icons.grid_view_rounded,
                  cs: cs,
                  child: Column(
                    children: [
                      _QuickAccessTile(
                        label: "Android App",
                        icon: Icons.android_rounded,
                        iconColor: const Color(0xFF3DDC84),
                        cs: cs,
                        onTap: () {},
                      ),
                      _Divider(cs: cs),
                      _QuickAccessTile(
                        label: "iOS App",
                        icon: Icons.phone_iphone_rounded,
                        iconColor: const Color(0xFF007AFF),
                        cs: cs,
                        onTap: () {},
                      ),
                      _Divider(cs: cs),
                      _QuickAccessTile(
                        label: "Documentation",
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFFFF9500),
                        cs: cs,
                        onTap: () {},
                      ),
                      _Divider(cs: cs),
                      _QuickAccessTile(
                        label: "Calculator",
                        icon: Icons.calculate_rounded,
                        iconColor: const Color(0xFF5856D6),
                        cs: cs,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// ── DANGER ZONE ────────────────────────────────────────
                _DangerZoneCard(cs: cs, c: c),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _openResetDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    CustomWidgets().showCustomDialog(
      context: context,
      icon: Icons.lock_reset,
      title: const Text("Reset Password"),
      formKey: formKey,
      submitText: "Reset",
      sections: [
        CustomWidgets().labelWithAsterisk('Email', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter email',
            controller: c.emailController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Old Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter old password',
            controller: c.oldPasswordController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('New Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter new password',
            controller: c.newPasswordController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Confirm Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Confirm new password',
            controller: c.confirmPassController),
        const SizedBox(height: 10),
      ],
      onSubmit: () {
        c.resetPassword(
          email: c.emailController.text,
          oldPassword: c.oldPasswordController.text,
          newPassword: c.newPasswordController.text,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFILE HERO CARD
// ─────────────────────────────────────────────────────────────
class _ProfileHeroCard extends StatelessWidget {
  final dynamic user;
  final ColorScheme cs;
  final AccountController c;

  const _ProfileHeroCard({
    required this.user,
    required this.cs,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary,
            cs.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          // Subtle circle decoration
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: cs.primaryContainer,
                    child: ClipOval(
                      child: user.profileImage != null &&
                              user.profileImage!.isNotEmpty
                          ? Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain, width: 88, height: 88)
                          : Text(
                              user.name != null && user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Name
                Text(
                  user.name ?? "N/A",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 4),

                // Role pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role ?? "Member",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _HeroButton(
                        label: "Reset Password",
                        icon: Icons.lock_reset_rounded,
                        outlined: true,
                        onTap: () => _openResetDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HeroButton(
                        label: "Logout",
                        icon: Icons.logout_rounded,
                        outlined: false,
                        onTap: () => c.logout(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openResetDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    CustomWidgets().showCustomDialog(
      context: context,
      icon: Icons.lock_reset,
      title: const Text("Reset Password"),
      formKey: formKey,
      submitText: "Reset",
      sections: [
        CustomWidgets().labelWithAsterisk('Email', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter email',
            controller: c.emailController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Old Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter old password',
            controller: c.oldPasswordController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('New Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Enter new password',
            controller: c.newPasswordController),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Confirm Password', required: true),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Confirm new password',
            controller: c.confirmPassController),
      ],
      onSubmit: () {
        c.resetPassword(
          email: c.emailController.text,
          oldPassword: c.oldPasswordController.text,
          newPassword: c.newPasswordController.text,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HERO BUTTON
// ─────────────────────────────────────────────────────────────
class _HeroButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool outlined;
  final VoidCallback onTap;

  const _HeroButton({
    required this.label,
    required this.icon,
    required this.outlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: outlined ? Colors.white.withOpacity(0.15) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.white24,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: outlined
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(14),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: outlined
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: outlined
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SECTION CARD
// ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final ColorScheme cs;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.cs,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: cs.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ColorScheme cs;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withOpacity(0.55),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK ACCESS TILE
// ─────────────────────────────────────────────────────────────
class _QuickAccessTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: cs.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DANGER ZONE CARD
// ─────────────────────────────────────────────────────────────
class _DangerZoneCard extends StatelessWidget {
  final ColorScheme cs;
  final AccountController c;

  const _DangerZoneCard({required this.cs, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.logout_rounded, size: 20, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign out",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: cs.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "You will need to log in again to access your account.",
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () => c.logout(),
            style: TextButton.styleFrom(
              foregroundColor: cs.error,
              backgroundColor: cs.error.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// THIN DIVIDER
// ─────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  final ColorScheme cs;
  const _Divider({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.8,
      color: cs.outlineVariant.withOpacity(0.35),
    );
  }
}
