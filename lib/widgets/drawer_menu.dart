import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({super.key});

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final sidebar = Container(
      width: 240, // 👈 reduced width (premium feel)
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                _menuItem(Icons.home, "Home"),
                _menuItem(Icons.video_collection, "Sessions"),

                _usersExpansion(),

                _menuItem(Icons.group, "Batch"),
                _menuItem(Icons.payment, "Payments"),
                _menuItem(Icons.bar_chart, "Reports"),

                // 🔥 Supports with badge
                _menuItem(Icons.support_agent, "Supports", badge: 3),

                _menuItem(Icons.settings, "Settings"),
              ],
            ),
          ),
        ],
      ),
    );

    // 🔥 RESPONSIVE
    return isDesktop ? sidebar : Drawer(child: sidebar);
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(size: 32),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Admin",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text("admin@albedo.com",
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  // ================= MENU ITEM =================

  Widget _menuItem(IconData icon, String title,
      {bool active = false, int? badge}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: active ? const Color(0xFFF3E8FF) : Colors.transparent,
      ),
      child: ListTile(
        dense: true, // 👈 tighter spacing
        leading: Stack(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? const Color(0xFF7F00FF) : Colors.grey,
            ),

            // 🔥 BADGE
            if (badge != null)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badge.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: active ? const Color(0xFF7F00FF) : Colors.black87,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  // ================= USERS =================

  Widget _usersExpansion() {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.only(left: 12),
      leading: const Icon(Icons.people, size: 20, color: Colors.purple),
      title: const Text("Users", style: TextStyle(fontSize: 13)),
      iconColor: Colors.purple,
      collapsedIconColor: Colors.purple,
      children: [
        _subItem("Students"),
        _subItem("Teachers"),
        _subItem("Mentors"),
        _subItem("Asst. Admin"),
        _subItem("Advisor"),
        _subItem("Others"),
      ],
    );
  }

  Widget _subItem(String title) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      onTap: () {},
    );
  }

  // ================= AVATAR =================

  Widget _buildAvatar({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.18),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
