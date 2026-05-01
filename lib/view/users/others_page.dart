import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/other_users_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/users/other_users_model.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/view/permissions_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                      final data = c.filteredOtherUsers;
                      int crossAxisCount = 1;

                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      return LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount = 1;

                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 700) {
                          crossAxisCount = 2;
                        }

                        return MasonryGridView.count(
                            crossAxisCount: crossAxisCount,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final otherUsers = data[index];
                              final cs = Theme.of(context).colorScheme;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 700),
                                  child: PremiumInfoCard(
                                    id: otherUsers.id ?? "",
                                    title: otherUsers?.name ?? "",
                                    subtitle: otherUsers?.email ?? "",
                                    status: otherUsers?.status,
                                    statusColor:
                                        getStatusColor(otherUsers?.status),
                                    footerText:
                                        "Joined • ${otherUsers?.joinedAt.toString().substring(0, 16)}",
                                    extraInfo: otherUsers?.phone != null
                                        ? "Contact • ${otherUsers!.phone}"
                                        : null,
                                    onTap: () {
                                      if (otherUsers != null) {
                                        {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                width: 350,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    /// 🔹 Profile Image
                                                    CircleAvatar(
                                                      radius: 40,
                                                      // backgroundImage:
                                                      //     user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
                                                      child: otherUsers
                                                                  .imageUrl ==
                                                              null
                                                          ? Image.asset(
                                                              'assets/images/logo.png')
                                                          : null,
                                                    ),

                                                    const SizedBox(height: 12),

                                                    /// 🔹 Name
                                                    Text(
                                                      otherUsers.name ?? "-",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),

                                                    const SizedBox(height: 4),

                                                    /// 🔹 Role
                                                    Text(
                                                      otherUsers.role ?? "User",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600]),
                                                    ),

                                                    const Divider(height: 24),

                                                    /// 🔹 Details
                                                    infoRow(
                                                        icon: Icons.badge,
                                                        label: "Emp ID",
                                                        value: otherUsers.id),
                                                    infoRow(
                                                        icon: Icons.email,
                                                        label: "Email",
                                                        value:
                                                            otherUsers.email),
                                                    infoRow(
                                                        icon: Icons.phone,
                                                        label: "Phone",
                                                        value:
                                                            otherUsers.phone),

                                                    const SizedBox(height: 20),

                                                    /// 🔹 Actions
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        InfoActionButton(
                                                          action: InfoAction(
                                                            icon:
                                                                Icons.dashboard,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            onTap: () {
                                                              final auth = Get.find<
                                                                  AuthController>();
                                                              final user =
                                                                  otherUserToUser(
                                                                      otherUsers);

                                                              auth.startImpersonation(
                                                                  user);
                                                              Get.offAll(() =>
                                                                  const Root());
                                                            },
                                                          ),
                                                        ),
                                                        if ((otherUsers.role !=
                                                                'finance') &&
                                                            (otherUsers.role !=
                                                                'sales') &&
                                                            (otherUsers.role !=
                                                                'admin') &&
                                                            (otherUsers.role !=
                                                                'hr'))
                                                          InfoActionButton(
                                                            action: InfoAction(
                                                              icon: Icons
                                                                  .accessibility_new,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                              onTap: () =>
                                                                  Get.offAll(
                                                                      PermissionsPage()),
                                                            ),
                                                          ),
                                                        InfoActionButton(
                                                          action: InfoAction(
                                                            icon: Icons.edit,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            onTap: () {
                                                              if (otherUsers !=
                                                                  null) {
                                                                c.loadOtherUsers(
                                                                    otherUsers);
                                                                editUser(
                                                                    context);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        InfoActionButton(
                                                          action: InfoAction(
                                                            icon: Icons.delete,
                                                            color: cs.error,
                                                            onTap: () =>
                                                                CustomWidgets()
                                                                    .showDeleteDialog(
                                                              text:
                                                                  'Are you sure you want to delete this user permanently?',
                                                              context: context,
                                                              onConfirm: () =>
                                                                  c.delete(
                                                                      otherUsers!
                                                                          .id),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    actions: [],
                                  ),
                                ),
                              );
                            });
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
      return Obx(() {
        final searching = c.isSearching.value;

        return Column(
          children: [
            /// 🔹 TITLE / SEARCH ROW
            Row(
              children: [
                const SizedBox(width: 10),

                if (!searching)
                  Expanded(
                    child: Text(
                      "Users",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                else
                  Expanded(
                    child: CustomWidgets().premiumSearch(
                      context,
                      hint: "Search users...",
                      onChanged: (val) {
                        c.searchQuery.value = val;
                        c.applyFilters();
                      },
                    ),
                  ),

                /// 🔍 TOGGLE BUTTON
                IconButton(
                  icon: Icon(searching ? Icons.close : Icons.search),
                  onPressed: () {
                    c.isSearching.value = !searching;

                    if (searching) {
                      c.searchQuery.value = "";
                      c.applyFilters();
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔽 FILTER + SORT (UNCHANGED)
            Row(
              children: [
                Expanded(child: _filterButton(context)),
                const SizedBox(width: 10),
                Expanded(child: _sortButton(context, c)),
              ],
            )
          ],
        );
      });
    }

    /// 💻 DESKTOP (optional: you can keep or add title here too)
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "Users",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomWidgets().premiumSearch(
            context,
            hint: "Search Users...",
            onChanged: (val) => c.searchQuery.value = val,
          ),
        ),
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
          onTap: () => CustomWidgets().showFilterSheet<String>(
            title: "Filter by Role",
            options: c.roleFilters,
            selectedValue: c.selectedRole.value,
            onSelected: (value) => c.updateRole(value),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.filter_list, size: 18),
              SizedBox(width: 6),
              Text("Filter", style: TextStyle(fontSize: 13)),
            ],
          ),
        ));
  }

  Widget addOtherUsers(BuildContext context) {
    return AppFAB(
      label: "Add User",
      icon: Icons.add_rounded,
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
                  child: const CircleAvatar(
                    radius: 35,
                    child: ClipOval(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Basic Info
                CustomWidgets().labelWithAsterisk('Name', required: true),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter name',
                  controller: c.nameController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Email', required: true),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter email',
                  controller: c.emailController,
                ),

                const SizedBox(height: 10),

                CustomWidgets()
                    .labelWithAsterisk('Phone Number', required: true),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter phone number',
                  controller: c.phoneController,
                  isNumber: true,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Position', required: true),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select Position',
                  items: const [
                    'Admin',
                    'HR',
                    'Finance',
                    'Sales Head',
                    'Others'
                  ],
                  value: c.selectedPosition.value.isEmpty
                      ? null
                      : c.selectedPosition.value,
                  onChanged: (p0) => c.selectedPosition.value = p0,
                ),

                /// 🔹 Conditional Custom Position
                Obx(
                  () => c.selectedPosition.value != "Others"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidgets()
                                  .labelWithAsterisk('Custom Position'),
                              const SizedBox(height: 10),
                              CustomWidgets().dropdownStyledTextField(
                                context: context,
                                hint: 'Enter Custom Position',
                                controller: c.customPositionController,
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
        onSubmit: () {
          // TODO: implement submit
        },
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

  Users otherUserToUser(OtherUsers a) {
    return Users(
      id: a.id,
      name: a.name,
      role: a.role,
    );
  }
}
