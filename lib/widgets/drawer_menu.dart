import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/modules/admin/view/advisors_page.dart';
import 'package:albedo_app/modules/admin/view/batch_page.dart';
import 'package:albedo_app/modules/admin/view/batches_list_page.dart';
import 'package:albedo_app/modules/admin/view/coordinator_page.dart';
import 'package:albedo_app/modules/admin/view/home_page.dart';
import 'package:albedo_app/modules/admin/view/payment_page.dart';
import 'package:albedo_app/modules/admin/view/report_page.dart';
import 'package:albedo_app/modules/admin/view/session_page.dart';
import 'package:albedo_app/modules/admin/view/students_page.dart';
import 'package:albedo_app/modules/admin/view/support_page.dart';
import 'package:albedo_app/modules/admin/view/teachers_page.dart';
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
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _header(context),
          Expanded(
            child: Obx(
              () => ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                children: [
                  _menuItem(
                    context,
                    Icons.home,
                    "Home",
                    active: c.selectedIndex.value == 0,
                    onPressed: () {
                      c.setIndex(0);
                      Get.back(); // close drawer if open
                      Get.to(() => HomeView());
                    },
                  ),
                  DrawerExpansionMenu(
                      title: 'Sessions',
                      leadingIcon: Icons.video_collection,
                      parentIndex: 1,
                      selectedParentIndex: c.selectedIndex,
                      selectedSubIndex: c.selectedSubIndex,
                      children: [
                        DrawerSubItem(
                          title: 'Sessions',
                          index: 0,
                          onTap: () => Get.offAll(SessionPage()),
                        ),
                        DrawerSubItem(
                          title: 'Batches',
                          index: 1,
                          onTap: () => Get.offAll(BatchesListPage()),
                        ),
                      ]),
                  // _menuItem(
                  //   context,
                  //   Icons.video_collection,
                  //   "Sessions",
                  //   active: c.selectedIndex.value == 1,
                  //   onPressed: () {
                  //     c.setIndex(1);
                  //     Get.back(); // close drawer if open
                  //     Get.to(() => SessionPage());
                  //   },
                  // ),
                  DrawerExpansionMenu(
                      title: 'Users',
                      leadingIcon: Icons.people,
                      parentIndex: 7,
                      selectedParentIndex: c.selectedIndex,
                      selectedSubIndex: c.selectedSubIndex,
                      children: [
                        DrawerSubItem(
                          title: "Students",
                          index: 0,
                          onTap: () => Get.offAll(StudentsPage()),
                        ),
                        DrawerSubItem(
                          title: "Teachers",
                          index: 1,
                          onTap: () => Get.offAll(TeachersPage()),
                        ),
                        DrawerSubItem(title: "Mentors", index: 2, onTap: () {}),
                        DrawerSubItem(
                            title: "Coordinators",
                            index: 3,
                            onTap: () => Get.offAll(CoordinatorPage())),
                        DrawerSubItem(
                            title: "Advisors",
                            index: 4,
                            onTap: () => Get.offAll(AdvisorsPage())),
                        DrawerSubItem(title: "Others", index: 5, onTap: () {}),
                      ]),
                  _menuItem(
                    context,
                    Icons.group,
                    "Batch",
                    active: c.selectedIndex.value == 2,
                    onPressed: () {
                      c.setIndex(2);
                      Get.back(); // close drawer if open
                      Get.to(() => BatchesPage());
                    },
                  ),
                  DrawerExpansionMenu(
                      title: 'Payments',
                      leadingIcon: Icons.payment,
                      parentIndex: 8,
                      selectedParentIndex: c.selectedIndex,
                      selectedSubIndex: c.selectedSubIndex,
                      children: [
                        DrawerSubItem(
                            title: "Student",
                            index: 0,
                            onTap: () => Get.offAll(() =>
                                PaymentPage(type: PaymentUserType.student))),
                        DrawerSubItem(
                            title: "Teacher",
                            index: 1,
                            onTap: () => Get.offAll(() =>
                                PaymentPage(type: PaymentUserType.teacher))),
                      ]),
                  _menuItem(
                    context,
                    Icons.bar_chart,
                    "Reports",
                    active: c.selectedIndex.value == 4,
                    onPressed: () {
                      c.setIndex(4);
                      Get.back(); // close drawer if open
                      Get.to(() => ReportsPage());
                    },
                  ),
                  _menuItem(
                    context,
                    Icons.support_agent,
                    "Supports",
                    active: c.selectedIndex.value == 5,
                    onPressed: () {
                      c.setIndex(5);
                      Get.back();
                      Get.to(() => SupportsPage());
                    },
                  ),
                  _menuItem(
                    context,
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

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(
            color: cs.outline.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(context, size: 32),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Admin",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(
                "admin@albedo.com",
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
    int? badge,
    required VoidCallback onPressed,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            active ? cs.primaryContainer.withOpacity(0.5) : Colors.transparent,
      ),
      child: ListTile(
        dense: true, // 👈 tighter spacing
        leading: Stack(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? cs.primary : cs.onSurface.withOpacity(0.6),
            ),

            // 🔥 BADGE
            if (badge != null)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    badge.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
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
            color: active ? cs.primary : cs.onSurface,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
  // ================= AVATAR =================

  Widget _buildAvatar(BuildContext context, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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

// ================= SUB MENU =================

class DrawerExpansionMenu extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final int parentIndex;
  final RxInt selectedParentIndex;
  final RxInt selectedSubIndex;
  final List<DrawerSubItem> children;

  const DrawerExpansionMenu({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.parentIndex,
    required this.selectedParentIndex,
    required this.selectedSubIndex,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.only(left: 12),
            leading: Icon(
              leadingIcon,
              size: 20,
              color: selectedParentIndex.value == parentIndex
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: selectedParentIndex.value == parentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: selectedParentIndex.value == parentIndex
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
            children: children
                .map((item) => DrawerSubItemWidget(
                      item: item,
                      parentIndex: parentIndex,
                      selectedParentIndex: selectedParentIndex,
                      selectedSubIndex: selectedSubIndex,
                    ))
                .toList(),
          ),
        ));
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
