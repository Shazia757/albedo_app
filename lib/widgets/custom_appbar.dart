import 'package:albedo_app/view/login_page.dart';
import 'package:albedo_app/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.black),

      // ✅ TITLE OR LOGO
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(color: Colors.black),
            )
          : Row(
              children: [
                Image.asset("assets/images/logo.png", height: 28),
                const SizedBox(width: 8),
              ],
            ),

      // ✅ KEEP ACTIONS HERE
      actions: [
        const Icon(Icons.dark_mode, color: Colors.black),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none, color: Colors.black),
        const SizedBox(width: 12),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          offset: const Offset(0, 45),
          color: Colors.transparent,
          elevation: 0,
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              padding: EdgeInsets.zero,
              child: _profileMenu(context),
            ),
          ],
          child: _avatar(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _profileMenu(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Albedo Admin",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("admin@albedo.com",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              _menuItem(
                icon: Icons.person_outline,
                text: "Profile",
                onTap: () => Get.offAll(ProfilePage()),
              ),
              _menuItem(
                icon: Icons.logout,
                text: "Logout",
                isDanger: true,
                onTap: () => Get.offAll(LoginView()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String text,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isDanger ? Colors.red : Colors.black),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: isDanger ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: ClipOval(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
