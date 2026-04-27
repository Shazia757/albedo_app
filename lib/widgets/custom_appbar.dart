import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64); // slightly taller

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Get.isDarkMode;
    final isDesktop = Responsive.isDesktop(context);

    return AppBar(
      backgroundColor: cs.surface.withOpacity(0.95), // subtle depth
      elevation: 0,
      scrolledUnderElevation: 6, // smoother scroll effect
      automaticallyImplyLeading: !isDesktop,
      centerTitle: false,
      surfaceTintColor: Colors.transparent, // removes M3 overlay tint

      iconTheme: IconThemeData(
        color: cs.onSurface,
        size: 22,
      ),

      // ✅ TITLE / LOGO
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: cs.onSurface,
                    letterSpacing: 0.2,
                  ),
            )
          : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 30,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

      // ✅ ACTIONS (polished spacing + touch feel)
      actions: [
        _actionButton(
          icon: isDark ? Icons.light_mode : Icons.dark_mode,
          color: cs,
          onTap: () {
            Get.changeThemeMode(
              isDark ? ThemeMode.light : ThemeMode.dark,
            );
          },
        ),
        const SizedBox(width: 8),
        _actionButton(
          icon: Icons.install_mobile,
          color: cs,
          onTap: () {},
        ),
        const SizedBox(width: 8),
        _actionButton(
          icon: Icons.notifications_none,
          color: cs,
          onTap: () {},
        ),
        const SizedBox(width: 12),
      ],

      // ✅ subtle bottom divider (premium feel)
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: cs.outline.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required ColorScheme color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color.onSurface.withOpacity(0.06),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color.onSurface, size: 20),
        ),
      ),
    );
  }
}
