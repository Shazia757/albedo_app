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
    final cs = Theme.of(context).colorScheme;
    final isDark = Get.isDarkMode;

    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      scrolledUnderElevation: 2,
      iconTheme: IconThemeData(color: cs.onSurface),
      // ✅ TITLE OR LOGO
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            )
          : Row(
              children: [
                Image.asset("assets/images/logo.png", height: 28),
                const SizedBox(width: 8),
              ],
            ),

      // ✅ KEEP ACTIONS HERE
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.changeThemeMode(
              isDark ? ThemeMode.light : ThemeMode.dark,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.notifications_none, color: cs.onSurface),
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
          child: _avatar(context),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _profileMenu(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
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
                  children: [
                    Text("Albedo Admin",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      "admin@albedo.com",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          Row(
            children: [
              _menuItem(
                context: context,
                icon: Icons.person_outline,
                text: "Profile",
                onTap: () => Get.offAll(ProfilePage()),
              ),
              _menuItem(
                context: context,
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
    required BuildContext context,
    required IconData icon,
    required String text,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;

    final color = isDanger ? cs.error : cs.onSurface;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
        ),
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
