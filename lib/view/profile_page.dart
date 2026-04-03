import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AccountController c = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      backgroundColor: cs.surface,
      body: Obx(() {
        final user = c.user.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              /// 🔥 TOP BANNER
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary, cs.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              /// 🔥 PROFILE SECTION (OVERLAP)
              Transform.translate(
                offset: const Offset(0, -60),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: cs.surface,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: cs.primary,
                        child: ClipOval(
                          child: user.profileImage != null &&
                                  user.profileImage!.isNotEmpty
                              ? Image.network(
                                  user.profileImage!,
                                  width: 92,
                                  height: 92,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _initial(user, context),
                                )
                              : _initial(user, context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      user.role,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔥 INFO SECTIONS (NOT FORM STYLE)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _infoTile(
                      context,
                      title: "Employee ID",
                      value: user.employeeId,
                      icon: Icons.badge_outlined,
                    ),
                    _editableTile(
                      context,
                      title: "Email",
                      controller: c.emailController,
                      editable: c.isEditing.value,
                      icon: Icons.email_outlined,
                    ),
                    _editableTile(
                      context,
                      title: "Contact",
                      controller: c.contactController,
                      editable: c.isEditing.value,
                      icon: Icons.phone_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 ACTION BUTTON (FLOATING STYLE)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          c.isEditing.value ? "Save Changes" : "Edit Profile",
                        ),
                        onPressed: () {
                          if (c.isEditing.value) {
                            c.updateUser(
                              name: user.name,
                              email: c.emailController.text,
                              contact: c.contactController.text,
                            );
                          } else {
                            c.toggleEdit();
                          }
                        },
                      ),
                    )),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: cs.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          c.isEditing.value ? "Cancel" : "Reset Password",
                          style: TextStyle(color: cs.onSurface),
                        ),
                        onPressed: () {
                          if (c.isEditing.value) {
                            c.cancelEdit();
                          } else {
                            c.resetPassword();
                          }
                        },
                      ),
                    )),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 NON-EDITABLE TILE
  Widget _infoTile(BuildContext context,
      {required String title, required String value, required IconData icon}) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelMedium),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 EDITABLE TILE
  Widget _editableTile(BuildContext context,
      {required String title,
      required TextEditingController controller,
      required bool editable,
      required IconData icon}) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: AbsorbPointer(
              // 🔥 THIS FIXES EDIT ISSUE
              absorbing: !editable,
              child: TextField(
                controller: controller,
                readOnly: !editable,
                style: TextStyle(
                  color:
                      editable ? cs.onSurface : cs.onSurface.withOpacity(0.7),
                ),
                decoration: InputDecoration(
                  labelText: title,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔤 INITIAL
  Widget _initial(user, BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Text(
      user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: cs.onPrimary,
      ),
    );
  }
}
