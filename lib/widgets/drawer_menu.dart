import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/modules/admin/view/feedback_page.dart';
import 'package:albedo_app/modules/admin/view/profile_page.dart';
import 'package:albedo_app/modules/admin/view/users/advisors_page.dart';
import 'package:albedo_app/modules/admin/view/batch_page.dart';
import 'package:albedo_app/modules/admin/view/sessions/batch_session_page.dart';
import 'package:albedo_app/modules/admin/view/users/coordinator_page.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:albedo_app/modules/admin/view/users/mentors_page.dart';
import 'package:albedo_app/modules/admin/view/users/others_page.dart';
import 'package:albedo_app/modules/admin/view/payment_page.dart';
import 'package:albedo_app/modules/admin/view/report/report_page.dart';
import 'package:albedo_app/modules/admin/view/sessions/session_page.dart';
import 'package:albedo_app/modules/admin/view/settings/settings_page.dart';
import 'package:albedo_app/modules/admin/view/users/students_page.dart';
import 'package:albedo_app/modules/admin/view/support_page.dart';
import 'package:albedo_app/modules/admin/view/users/teachers_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.put(HomeController());
    final cs = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final sidebar = Container(
      width: 260,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          right: BorderSide(
            color: cs.outline.withOpacity(0.08),
          ),
        ),
      ),
      child: Column(
        children: [
          _header(context),

          /// 🔹 MENU LIST
          Expanded(
            child: Obx(() {
              final auth = Get.find<AuthController>();

              final user = auth.activeUser;
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final role = auth.activeUser?.role;
              final isAdmin = role == "admin";
              final isMentor = role == "mentor";

              final List<Widget> menuItems = [];

              menuItems.add(
                _menuItem(
                  context,
                  Icons.home,
                  "Home",
                  active: c.selectedIndex.value == 0,
                  onPressed: () {
                    c.setIndex(0);
                    c.selectedParentIndex.value = -1;
                    c.selectedSubIndex.value = -1;
                    Get.back();
                    Get.offAll(() => HomeView());
                  },
                ),
              );

              /// ✅ SESSIONS
              menuItems.add(
                DrawerExpansionMenu(
                  title: 'Sessions',
                  icon: Icons.video_collection,
                  parentIndex: 1,
                  selectedParentIndex: c.selectedParentIndex,
                  selectedSubIndex: c.selectedSubIndex,
                  children: [
                    DrawerSubItem(
                      title: 'Sessions',
                      index: 10,
                      onTap: () => Get.offAll(SessionPage()),
                    ),
                    DrawerSubItem(
                      title: 'Batches',
                      index: 11,
                      onTap: () => Get.offAll(BatchesListPage()),
                    ),
                  ],
                ),
              );

              /// ✅ USERS (filtered)
              if (!isMentor) {
                menuItems.add(
                  DrawerExpansionMenu(
                    title: 'Users',
                    icon: Icons.people,
                    parentIndex: 7,
                    selectedParentIndex: c.selectedParentIndex,
                    selectedSubIndex: c.selectedSubIndex,
                    children: [
                      DrawerSubItem(
                          title: "Students",
                          index: 20,
                          onTap: () => Get.offAll(StudentsPage())),
                      DrawerSubItem(
                          title: "Teachers",
                          index: 21,
                          onTap: () => Get.offAll(TeachersPage())),
                      DrawerSubItem(
                          title: "Mentors",
                          index: 22,
                          onTap: () => Get.offAll(MentorsPage())),
                      if (isAdmin) ...[
                        DrawerSubItem(
                            title: "Coordinators",
                            index: 23,
                            onTap: () => Get.offAll(CoordinatorPage())),
                        DrawerSubItem(
                            title: "Advisors",
                            index: 24,
                            onTap: () => Get.offAll(AdvisorsPage())),
                        DrawerSubItem(
                            title: "Others",
                            index: 25,
                            onTap: () => Get.offAll(OthersPage())),
                      ],
                    ],
                  ),
                );
              }
              if (isMentor) {
                menuItems.add(
                  _menuItem(
                    context,
                    Icons.school,
                    "Students",
                    active: c.selectedIndex.value == 20,
                    onPressed: () {
                      c.setIndex(20);
                      Get.back();
                      Get.offAll(() => StudentsPage());
                    },
                  ),
                );

                menuItems.add(
                  _menuItem(
                    context,
                    Icons.person,
                    "Teachers",
                    active: c.selectedIndex.value == 21,
                    onPressed: () {
                      c.setIndex(21);
                      Get.back();
                      Get.offAll(() => TeachersPage());
                    },
                  ),
                );
                menuItems.add(
                  _menuItem(
                    context,
                    Icons.feedback_outlined,
                    "Feedback",
                    active: c.selectedIndex.value == 40,
                    onPressed: () {
                      c.setIndex(40);
                      c.selectedParentIndex.value = -1;
                      c.selectedSubIndex.value = -1;
                      Get.back();
                      Get.offAll(() => FeedbackPage());
                    },
                  ),
                );
              }

              /// ✅ BATCH
              menuItems.add(
                _menuItem(
                  context,
                  Icons.group,
                  "Batch",
                  active: c.selectedIndex.value == 2,
                  onPressed: () {
                    c.setIndex(2);
                    c.selectedParentIndex.value = -1;
                    c.selectedSubIndex.value = -1;
                    Get.back();
                    Get.offAll(() => BatchesPage());
                  },
                ),
              );

              /// 🔥 INSERT PAYMENTS ONLY FOR ADMIN (after batch)
              if (isAdmin) {
                menuItems.add(
                  DrawerExpansionMenu(
                    title: 'Payments',
                    icon: Icons.payment,
                    parentIndex: 8,
                    selectedParentIndex: c.selectedParentIndex,
                    selectedSubIndex: c.selectedSubIndex,
                    children: [
                      DrawerSubItem(
                          title: "Student",
                          index: 30,
                          onTap: () => Get.offAll(() =>
                              PaymentPage(type: PaymentUserType.student))),
                      DrawerSubItem(
                          title: "Teacher",
                          index: 31,
                          onTap: () => Get.offAll(() =>
                              PaymentPage(type: PaymentUserType.teacher))),
                    ],
                  ),
                );
              }

              /// ✅ REPORTS
              menuItems.add(
                _menuItem(
                  context,
                  Icons.bar_chart,
                  "Reports",
                  active: c.selectedIndex.value == 4,
                  onPressed: () {
                    c.setIndex(4);
                    c.selectedParentIndex.value = -1;
                    c.selectedSubIndex.value = -1;
                    Get.back();
                    Get.offAll(() => ReportsPage());
                  },
                ),
              );

              /// ✅ SUPPORT
              menuItems.add(
                _menuItem(
                  context,
                  Icons.support_agent,
                  "Supports",
                  active: c.selectedIndex.value == 5,
                  onPressed: () {
                    c.setIndex(5);
                    c.selectedParentIndex.value = -1;
                    c.selectedSubIndex.value = -1;
                    Get.back();
                    Get.offAll(() => SupportsPage());
                  },
                ),
              );

              /// 🔥 SETTINGS ONLY FOR ADMIN (always last)
              if (isAdmin) {
                menuItems.add(
                  _menuItem(
                    context,
                    Icons.settings,
                    "Settings",
                    active: c.selectedIndex.value == 6,
                    onPressed: () {
                      c.setIndex(6);
                      c.selectedParentIndex.value = -1;
                      c.selectedSubIndex.value = -1;
                      Get.back();
                      Get.offAll(() => SettingsPage());
                    },
                  ),
                );
              }

              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: menuItems,
              );
            }),
          ),

          /// 🔻 PROFILE SECTION (NEW)
          _profileSection(context),
        ],
      ),
    );

    return isDesktop ? sidebar : Drawer(child: sidebar);
  }

  // ================= HEADER =================

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final auth = Get.find<AuthController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: cs.outline.withOpacity(0.08)),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(context, size: 36),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.activeUser?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                auth.activeUser?.email ?? '',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= MENU ITEM =================

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool active = false,
    required VoidCallback onPressed,
  }) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            active ? cs.primaryContainer.withOpacity(0.5) : Colors.transparent,
      ),
      child: Stack(
        children: [
          /// 🔥 LEFT INDICATOR
          if (active)
            Positioned(
              left: 0,
              top: 8,
              bottom: 8,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

          ListTile(
            dense: true,
            leading: Icon(
              icon,
              size: active ? 22 : 20,
              color: active ? cs.primary : cs.onSurface.withOpacity(0.5),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? cs.primary : cs.onSurface,
              ),
            ),
            onTap: onPressed,
          ),
        ],
      ),
    );
  }

  // ================= PROFILE =================

  Widget _profileSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: cs.outline.withOpacity(0.08)),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.to(() => ProfilePage()); // 🔥 your profile screen
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildAvatar(context, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "View Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.2),
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
// ================= SUB MENU =================

class DrawerExpansionMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final int parentIndex;
  final RxInt selectedParentIndex;
  final RxInt selectedSubIndex;
  final List<DrawerSubItem> children;

  const DrawerExpansionMenu({
    super.key,
    required this.title,
    required this.icon,
    required this.parentIndex,
    required this.selectedParentIndex,
    required this.selectedSubIndex,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      /// 🔹 UI state (only for expand/collapse)
      final isOpen = selectedParentIndex.value == parentIndex;

      /// 🔹 Navigation state (only for highlight)
      final isActive = selectedParentIndex.value == parentIndex &&
          selectedSubIndex.value != -1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Parent Tile
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              /// 🔥 ONLY toggle open/close
              selectedParentIndex.value = isOpen ? -1 : parentIndex;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isActive
                    ? cs.primaryContainer.withOpacity(0.4)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color:
                        isActive ? cs.primary : cs.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? cs.primary : cs.onSurface,
                      ),
                    ),
                  ),

                  /// 🔥 Arrow animation
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isOpen ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 Children (Animated)
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Column(
              children: children.map((item) {
                return _ProSubItem(
                  item: item,
                  parentIndex: parentIndex,
                  selectedParentIndex: selectedParentIndex,
                  selectedSubIndex: selectedSubIndex,
                );
              }).toList(),
            ),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      );
    });
  }
}

class _ProSubItem extends StatefulWidget {
  final DrawerSubItem item;
  final int parentIndex;
  final RxInt selectedParentIndex;
  final RxInt selectedSubIndex;

  const _ProSubItem({
    required this.item,
    required this.parentIndex,
    required this.selectedParentIndex,
    required this.selectedSubIndex,
  });

  @override
  State<_ProSubItem> createState() => _ProSubItemState();
}

class _ProSubItemState extends State<_ProSubItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final isActive = widget.selectedParentIndex.value == widget.parentIndex &&
          widget.selectedSubIndex.value == widget.item.index;

      return MouseRegion(
        onEnter: (_) => setState(() => isHover = true),
        onExit: (_) => setState(() => isHover = false),
        child: InkWell(
          onTap: () {
            final c = Get.find<HomeController>(); // 🔥 get controller

            c.selectedIndex.value = -1;
            widget.selectedParentIndex.value = widget.parentIndex;
            widget.selectedSubIndex.value = widget.item.index;

            Get.back();
            widget.item.onTap();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isActive
                  ? cs.primaryContainer.withOpacity(0.5)
                  : isHover
                      ? cs.primaryContainer.withOpacity(0.2)
                      : Colors.transparent,
            ),
            child: Row(
              children: [
                /// 🔥 Left indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: 16,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isActive ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Text(
                  widget.item.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? cs.primary : cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class DrawerSubItem {
  final String title;
  final int index;
  final VoidCallback onTap;

  DrawerSubItem({
    required this.title,
    required this.index,
    required this.onTap,
  });
}

class DrawerSubItemWidget extends StatelessWidget {
  final DrawerSubItem item;
  final int parentIndex;
  final RxInt selectedParentIndex;
  final RxInt selectedSubIndex;

  const DrawerSubItemWidget({
    super.key,
    required this.item,
    required this.parentIndex,
    required this.selectedParentIndex,
    required this.selectedSubIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = selectedSubIndex.value == item.index;
      final cs = Theme.of(context).colorScheme;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive
              ? cs.primaryContainer.withOpacity(0.5)
              : Colors.transparent,
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? cs.primary : cs.onSurface,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          onTap: () {
            selectedParentIndex.value = parentIndex;
            selectedSubIndex.value = item.index;
            Get.back(); // close drawer
            item.onTap(); // navigate/change page
          },
        ),
      );
    });
  }
}
