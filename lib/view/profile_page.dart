import 'dart:io';

import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        final AuthController auth = Get.find<AuthController>();
        final user = auth.activeUser;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              children: [
                /// ── PROFILE HERO CARD ──────────────────────────────────
                _ProfileHeroCard(user: user, cs: cs, c: c),

                SizedBox(height: 20),

                /// ── ACCOUNT INFO ───────────────────────────────────────
                _SectionCard(
                  title: "Account Info",
                  icon: Icons.badge_outlined,
                  child: Column(
                    children: [
                      _InfoRow(
                        label: "Employee ID",
                        value: user?.empId ?? "—",
                        icon: Icons.fingerprint,
                      ),
                      _Divider(cs: cs),
                      _InfoRow(
                        label: "Email",
                        value: user?.email ?? "—",
                        icon: Icons.mail_outline_rounded,
                      ),
                      _Divider(cs: cs),
                      _InfoRow(
                        label: "Phone",
                        value: user?.contact ?? "—",
                        icon: Icons.phone_outlined,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// ── QUICK ACCESS ───────────────────────────────────────
                _SectionCard(
                  title: "Quick Access",
                  icon: Icons.grid_view_rounded,
                  child: Column(
                    children: [
                      _QuickAccessTile(
                        label: "Documentation",
                        icon: Icons.menu_book_rounded,
                        iconColor: const Color(0xFFFF9500),
                        onTap: () {},
                      ),
                      _Divider(cs: cs),
                      _QuickAccessTile(
                        label: "Calc | Albedo",
                        icon: Icons.calculate_rounded,
                        iconColor: const Color(0xFF5856D6),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                /// ── DANGER ZONE ────────────────────────────────────────
                _DangerZoneCard(cs: cs, c: c),

                SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFILE HERO CARD
// ─────────────────────────────────────────────────────────────
class _ProfileHeroCard extends StatelessWidget {
  final Users? user;
  final ColorScheme cs;
  final AccountController c;

  const _ProfileHeroCard({
    required this.user,
    required this.cs,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final profile = user?.profileImage ?? '';
    final name = user?.name ?? "";
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
        borderRadius: BorderRadius.circular(20),
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
                      child: profile.isNotEmpty
                          ? Image.asset('assets/images/logo.png',
                              fit: BoxFit.contain, width: 88, height: 88)
                          : Text(
                              name.isNotEmpty ? name[0].toUpperCase() : "?",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Name
                Text(
                  name ?? "N/A",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white, letterSpacing: -0.3),
                ),

                SizedBox(height: 4),

                // Role pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user?.role ?? "Member",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.3),
                  ),
                ),

                SizedBox(height: 24),

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
                    SizedBox(width: 12),
                    Expanded(
                      child: Obx(() {
                        return _HeroButton(
                          label: c.isEditLoading.value ? "Loading..." : "Edit",
                          icon: Icons.edit_outlined,
                          outlined: false,
                          onTap: () {
                            if (!c.isEditLoading.value) {
                              editUser(context);
                            }
                          },
                        );
                      }),
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

  ///---------------- SEND RESET LINK DIALOG ----------------///

  void _openResetDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    CustomWidgets().showCustomDialog(
      context: context,
      icon: Icons.email_outlined,
      title: Text("Request Password Reset"),
      formKey: formKey,
      submitWidget: Obx(
        () => (c.isLoading.value)
            ? CircularProgressIndicator(
                color: cs.primary,
              )
            : Text(
                "Send Link",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
      ),
      sections: [
        /// EMAIL
        CustomWidgets().labelWithAsterisk(
          'Email',
          required: true,
        ),

        SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter email',
          controller: c.emailController,
        ),
      ],
      onSubmit: () async {
        final success = await c.passwordResetRequest();

        /// OPEN NEXT DIALOG AFTER SUCCESS
        if (success) {
          /// CLEAR OLD VALUES
          c.otpController.clear();
          c.newPasswordController.clear();
          c.confirmPassController.clear();

          Future.delayed(
            const Duration(milliseconds: 300),
            () => _openResetConfirmDialog(context),
          );
        }
      },
    );
  }

  ///---------------- CONFIRM RESET DIALOG ----------------///

  void _openResetConfirmDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    CustomWidgets().showCustomDialog(
      context: context,
      icon: Icons.lock_reset,
      title: Text("Reset Password"),
      formKey: formKey,
      submitWidget: Obx(
        () => (c.isLoading.value)
            ? CircularProgressIndicator(
                color: cs.primary,
              )
            : Text(
                "Reset Password",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
      ),
      sections: [
        /// OTP
        CustomWidgets().labelWithAsterisk(
          'OTP / Token',
          required: true,
        ),

        SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter OTP',
          controller: c.otpController,
        ),

        SizedBox(height: 20),

        /// NEW PASSWORD
        CustomWidgets().labelWithAsterisk(
          'New Password',
          required: true,
        ),

        SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Enter new password',
          controller: c.newPasswordController,
        ),

        SizedBox(height: 20),

        /// CONFIRM PASSWORD
        CustomWidgets().labelWithAsterisk(
          'Confirm Password',
          required: true,
        ),

        SizedBox(height: 10),

        CustomWidgets().dropdownStyledTextField(
          context: context,
          hint: 'Confirm new password',
          controller: c.confirmPassController,
        ),
      ],
      onSubmit: () async {
        await c.resetPasswordConfirmRequest();
      },
    );
  }

  Future<void> editUser(BuildContext context) async {
    c.isEditLoading.value = true;

    try {
      final user = LocalStorage().readUser();

      c.nameController.text = user?.name ?? '';
      c.empIdController.text = user?.empId ?? '';
      c.emailController.text = user?.email ?? '';
      c.phoneController.text = user?.contact ?? '';
      c.positionController.text = user?.role ?? '';

      c.profileImagePath.value = ''; // reset picked image
      c.remoteProfileImage.value = user?.profileImage ?? '';

      final rawPath = c.remoteProfileImage.value;
      final imageUrl = buildImageUrl(rawPath);

      if (imageUrl.isNotEmpty) {
        await precacheImage(
          NetworkImage(imageUrl),
          context,
        );
      }

      if (!context.mounted) return;

      CustomWidgets().showCustomDialog(
        context: context,
        title: Text('Edit User'),
        icon: Icons.edit,
        submitWidget: Obx(
          () => (c.isLoading.value)
              ? CircularProgressIndicator(
                  color: cs.primary,
                )
              : Text(
                  "Update",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
        ),
        formKey: GlobalKey<FormState>(),
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Profile Photo (Max: 50 MB)'),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => c.pickProfileImage(),
                    child: CircleAvatar(
                      radius: 35,
                      child: ClipOval(
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: Obx(() {
                            final local = c.profileImagePath.value;
                            final remote = c.remoteProfileImage.value;

                            if (local.isNotEmpty) {
                              return Image.file(File(local), fit: BoxFit.cover);
                            }

                            if (remote.isNotEmpty) {
                              return Image.network(
                                remote.trim(),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Image.asset('assets/images/logo.png'),
                              );
                            }

                            return Image.asset('assets/images/logo.png');
                          }),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomWidgets().labelWithAsterisk('Name', required: true),
                  CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter name',
                    controller: c.nameController,
                  ),
                  SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Employee ID', required: true),
                  CustomWidgets().dropdownStyledTextField(
                      hint: '',
                      context: context,
                      controller: c.empIdController,
                      readOnly: true),
                  SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Email', required: true),
                  CustomWidgets().dropdownStyledTextField(
                    hint: '',
                    context: context,
                    controller: c.emailController,
                  ),
                  SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Phone Number', required: true),
                  CustomWidgets().dropdownStyledTextField(
                    hint: '',
                    context: context,
                    controller: c.phoneController,
                  ),
                  SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Position'),
                  CustomWidgets().dropdownStyledTextField(
                    hint: '',
                    context: context,
                    controller: c.positionController,
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
        ],
        onSubmit: () {
          c.updateUser(
            id: user?.id ?? '',
            empId: c.empIdController.text,
            name: c.nameController.text,
            email: c.emailController.text,
            contact: c.phoneController.text,
          );
        },
      );
    } finally {
      c.isEditLoading.value = false;
    }
  }

  String buildImageUrl(String? path) {
    if (path == null) return '';

    final clean = path.trim().replaceAll('\n', '').replaceAll('\r', '');

    if (clean.isEmpty) return '';

    if (clean.startsWith('http')) return clean;

    return "https://api.albedoedu.com$clean";
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
              SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: outlined
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary),
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
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: cs.primary),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            child,
          ],
        ),
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

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary.withOpacity(0.7)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// QUICK ACCESS TILE
// ─────────────────────────────────────────────────────────────
class _QuickAccessTile extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_QuickAccessTile> createState() => _QuickAccessTileState();
}

class _QuickAccessTileState extends State<_QuickAccessTile> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: hovering ? cs.primary.withOpacity(0.06) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, size: 18, color: widget.iconColor),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: cs.onSurface.withOpacity(0.4),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign out",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: cs.error),
                ),
                SizedBox(height: 2),
                Text(
                  "You will need to log in again to access your account.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: cs.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
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
            child: Obx(
              () => (c.isLoading.value)
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onSurface,
                      ),
                    )
                  : Text(
                      "Logout",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
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
