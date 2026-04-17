import 'package:albedo_app/controller/other_users_controller.dart';
import 'package:albedo_app/model/other_users_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OthersPage extends StatelessWidget {
  final c = Get.put(OtherUsersController());

  OthersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addOtherUsers(context),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _topBar(context),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final data = c.otherUsers;
                      int crossAxisCount = 1;

                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final otherUsers = data[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 700),
                                  child: _card(context, otherUsers),
                                ),
                              ),
                            );
                          });
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          CustomWidgets().premiumSearch(
            context,
            hint: "Search users...",
            onChanged: (val) => c.searchQuery.value = val,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _filterButton(context)),
              const SizedBox(width: 10),
              Expanded(child: _sortButton(context, c)),
            ],
          )
        ],
      );
    }

    return Row(
      children: [
        Expanded(
            flex: 3,
            child: CustomWidgets().premiumSearch(
              context,
              hint: "Search Users...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _sortButton(BuildContext context, OtherUsersController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showSortSheet<SortType>(
        title: "Sort Users",
        options: [
          SortOption(
              label: "Newest", value: SortType.newest, icon: Icons.schedule),
          SortOption(
              label: "Oldest", value: SortType.oldest, icon: Icons.history),
          SortOption(
              label: "Name A-Z",
              value: SortType.name,
              icon: Icons.sort_by_alpha),
        ],
        selectedValue: c.sortType.value,
        onSelected: (val) {
          c.sortType.value = val;
          c.applyFilters();
        },
      ),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, size: 18),
            SizedBox(width: 6),
            Text("Sort"),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: open filter bottom sheet
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.filter_list, size: 18),
            SizedBox(width: 6),
            Text("Filter", style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, OtherUsers user) {
    final cs = Theme.of(context).colorScheme;

    final isActive = user.status == "Active";

    final statusColor = isActive ? cs.primary : cs.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Left Accent Bar
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Row
                Row(
                  children: [
                    Text(
                      user.id ?? 'NULL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),

                    /// Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.status ?? '',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Name
                Text(
                  user.name ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  user.email ?? 'NULL',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 6),

                /// Extra Info
                Text(
                  "Contact • ${user.phone ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔘 Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomWidgets().iconBtn(
                      title: "Dashboard",
                      icon: Icons.dashboard,
                      color: cs.primary,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.edit,
                      color: cs.secondary,
                      onTap: () {
                        c.loadOtherUsers(user);
                        editUser(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.delete,
                      color: cs.error,
                      onTap: () => CustomWidgets().showDeleteDialog(
                        text:
                            'Are you sure you want to delete this coordinator permanently?',
                        context: context,
                        onConfirm: () => c.delete(user.id),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton addOtherUsers(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: const Text('Add New User'),
        formKey: GlobalKey<FormState>(),
        sections: [
          SingleChildScrollView(
            child: Column(
              children: [
                /// 🔹 Profile
                const Text('Profile Photo (Max: 50 MB)'),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Basic Info
                CustomWidgets().labelWithAsterisk('Name', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter name',
                  controller: c.nameController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Email', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter email',
                  controller: c.emailController,
                ),

                const SizedBox(height: 10),

                CustomWidgets()
                    .labelWithAsterisk('Phone Number', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter phone number',
                  controller: c.phoneController,
                  isNumber: true,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Position', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Select Position',
                  controller: c.positionController,
                  isNumber: true,
                ),
              ],
            ),
          ),
        ],
        onSubmit: () {
          // TODO: implement submit
        },
      ),
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }

  void editUser(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Edit User'),
      icon: Icons.edit,
      formKey: GlobalKey<FormState>(),
      sections: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 🔹 Profile
                const Text('Profile Photo (Max: 50 MB)'),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Basic Info
                CustomWidgets().labelWithAsterisk('Name', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter name',
                  controller: c.nameController,
                ),

                const SizedBox(height: 10),

                CustomWidgets()
                    .labelWithAsterisk('Employee ID', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: '',
                  controller: c.empIdController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Email', required: true),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter email',
                  controller: c.emailController,
                ),

                const SizedBox(height: 10),

                CustomWidgets()
                    .labelWithAsterisk('Phone Number', required: true),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter phone number',
                  controller: c.phoneController,
                ),
                const SizedBox(height: 8),

                CustomWidgets().labelWithAsterisk('Position'),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Select Position',
                  controller: c.positionController,
                  isNumber: true,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
      onSubmit: () {
        // TODO: update user
      },
    );
  }
}
