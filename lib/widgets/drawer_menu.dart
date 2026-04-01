import 'package:albedo_app/view/home_page.dart';
import 'package:albedo_app/view/session_page.dart';
import 'package:albedo_app/view/students_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController c = Get.put(HomeController());
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final sidebar = Container(
      width: 240, // 👈 reduced width (premium feel)
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: Obx(
              () => ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  _menuItem(
                    Icons.home,
                    "Home",
                    active: c.selectedIndex.value == 0,
                    onPressed: () {
                      c.setIndex(0);
                      Get.back(); // close drawer if open
                      Get.to(() => HomeView());
                    },
                  ),
                  _menuItem(
                    Icons.video_collection,
                    "Sessions",
                    active: c.selectedIndex.value == 1,
                    onPressed: () {
                      c.setIndex(1);
                      Get.back(); // close drawer if open
                      Get.to(() => SessionPage());
                    },
                  ),
                  _usersExpansion(),
                  _menuItem(
                    Icons.group,
                    "Batch",
                    active: c.selectedIndex.value == 2,
                    onPressed: () {
                      c.setIndex(2);
                      Get.back(); // close drawer if open
                      Get.to(() => HomeView());
                    },
                  ),
                  _menuItem(
                    Icons.payment,
                    "Payments",
                    active: c.selectedIndex.value == 3,
                    onPressed: () {
                      c.setIndex(3);
                      Get.back(); // close drawer if open
                      Get.to(() => HomeView());
                    },
                  ),
                  _menuItem(
                    Icons.bar_chart,
                    "Reports",
                    active: c.selectedIndex.value == 4,
                    onPressed: () {
                      c.setIndex(4);
                      Get.back(); // close drawer if open
                      Get.to(() => HomeView());
                    },
                  ),
                  _menuItem(
                    Icons.support_agent,
                    "Supports",
                    badge: 3,
                    active: c.selectedIndex.value == 5,
                    onPressed: () {
                      c.setIndex(5);
                      Get.back();
                      Get.to(() => HomeView());
                    },
                  ),
                  _menuItem(
                    Icons.settings,
                    "Settings",
                    active: c.selectedIndex.value == 6,
                    onPressed: () {
                      c.setIndex(6);
                      Get.back();
                      Get.to(() => HomeView());
                    },
                  ),
                ],
              ),
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

  Widget _menuItem(
    IconData icon,
    String title, {
    bool active = false,
    int? badge,
    required VoidCallback onPressed,
  }) {
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
        onTap: onPressed,
      ),
    );
  }

  // ================= USERS =================

  Widget _usersExpansion() {
    HomeController c = Get.find();

    return Obx(() => ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.only(left: 12),
          leading: Icon(
            Icons.people,
            size: 20,
            color: c.selectedIndex.value == 7
                ? const Color(0xFF7F00FF)
                : Colors.grey,
          ),
          title: Text(
            "Users",
            style: TextStyle(
              fontSize: 13,
              color: c.selectedIndex.value == 7
                  ? const Color(0xFF7F00FF)
                  : Colors.black87,
              fontWeight: c.selectedIndex.value == 7
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
          children: [
            _subItem("Students", 0, () {
              Get.to(() => StudentsPage());
            }),
            _subItem("Teachers", 1, () {
              Get.to(() => StudentsPage());
            }),
            _subItem("Mentors", 2, () {
              Get.to(() => StudentsPage());
            }),
            _subItem("Asst. Admin", 3, () {
              Get.to(() => StudentsPage());
            }),
            _subItem("Advisor", 4, () {
              Get.to(() => StudentsPage());
            }),
            _subItem("Others", 5, () {
              Get.to(() => StudentsPage());
            }),
          ],
        ));
  }

  Widget _subItem(String title, int index, VoidCallback onTap) {
    HomeController c = Get.find();

    return Obx(() {
      final isActive = c.selectedSubIndex.value == index;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive ? const Color(0xFFF3E8FF) : Colors.transparent,
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF7F00FF) : Colors.black87,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          onTap: () {
            c.setIndex(7); // parent "Users"
            c.setSubIndex(index);
            Get.back(); // close drawer
            onTap(); // change page if needed
          },
        ),
      );
    });
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
