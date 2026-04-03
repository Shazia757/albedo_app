import 'package:albedo_app/controller/account_controller.dart';
import 'package:albedo_app/widgets/button.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AccountController c = Get.put(AccountController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      body: Obx(() {
        final user = c.user.value;

        nameController.text = user.name;
        emailController.text = user.email;
        contactController.text = user.contact;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // PROFILE IMAGE
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: ClipOval(
                  child: user.profileImage != null
                      ? Image.network(
                          user.profileImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Show initial if image fails
                            return Center(
                              child: Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.role,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // CARD
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField("Name", nameController, c.isEditing.value),
                      _buildField("Employee ID",
                          TextEditingController(text: user.employeeId), false),
                      _buildField("Role",
                          TextEditingController(text: user.role), false),
                      _buildField("Email", emailController, c.isEditing.value),
                      _buildField(
                          "Contact", contactController, c.isEditing.value),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => iconBtn(
                        color: Colors.blue,
                        icon: c.isEditing.value ? Icons.save : Icons.edit,
                        title: c.isEditing.value ? "Save" : "Edit",
                        onTap: () {
                          if (c.isEditing.value) {
                            c.updateUser(
                              name: nameController.text,
                              email: emailController.text,
                              contact: contactController.text,
                            );
                          } else {
                            c.toggleEdit();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => iconBtn(
                          color: Colors.red,
                          icon: c.isEditing.value
                              ? Icons.lock_reset
                              : Icons.cancel,
                          title:
                              c.isEditing.value ? "Cancel" : "Reset Password",
                          onTap: () => c.isEditing.value
                              ? c.cancelEdit()
                              : c.resetPassword()),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: !editable,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
