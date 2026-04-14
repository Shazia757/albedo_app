import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/student_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsPage extends StatelessWidget {
  StudentsPage({super.key});

  final c = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    final tabs = ["All", "Active", "Batch", "TBA", "Inactive"];
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: Responsive.isMobile(context) ? const CustomAppBar() : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Column(
        children: [
          /// 🔍 Search + Sort
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: CustomWidgets().premiumSearch(context,
                        hint: "Search students...", onChanged: (value) {
                  c.searchQuery.value = value;
                  c.applyFilters();
                })),

                const SizedBox(width: 10),

                /// Sort
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => CustomWidgets().showSortSheet(
                    title: "Sort Students",
                    options: [
                      SortOption(
                          label: "Newest",
                          value: SortType.newest,
                          icon: Icons.schedule),
                      SortOption(
                          label: "Oldest",
                          value: SortType.oldest,
                          icon: Icons.history),
                      SortOption(
                          label: "Name A-Z",
                          value: SortType.student,
                          icon: Icons.sort_by_alpha),
                    ],
                    selectedValue: c.sortType.value,
                    onSelected: (val) {
                      c.sortType.value = val;
                      c.applyFilters();
                    },
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.sort, size: 20),
                  ),
                )
              ],
            ),
          ),

          /// 🧭 Tabs
          Obx(
            () => CustomWidgets().customTabs(
              context,
              tabs: tabs,
              selectedIndex: c.selectedTab.value,
              onTap: (index) {
                c.selectedTab.value = index;
                c.applyFilters();
              },
              getCount: (index) {
                switch (index) {
                  case 0:
                    return c.allCount;
                  case 1:
                    return c.activeCount;
                  case 2:
                    return c.batchCount;
                  case 3:
                    return c.tbaCount;
                  case 4:
                    return c.inactiveCount;
                  default:
                    return 0;
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 List
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.filteredStudents.isEmpty) {
                return const Center(child: Text("No students found"));
              }

              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: c.filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = c.filteredStudents[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: _card(context, student),
                        ),
                      ),
                    );
                  });
            }),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, Student? s) {
    final cs = Theme.of(context).colorScheme;

    final isActive = s?.status == "Active";

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
                      s?.studentId ?? 'NULL',
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
                        s?.status ?? 'NULL',
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
                  s?.name ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  s?.email ?? 'NULL',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 6),

                /// Extra Info
                Text(
                  "Joined • ${s?.joinedAt.toString().substring(0, 16) ?? 'NULL'}",
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
                      onTap: () => CustomWidgets().showCustomDialog(
                        context: context,
                        title: Text('Edit Student'),
                        icon: Icons.edit,
                        formKey: GlobalKey<FormState>(),
                        sections: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text('Profile Photo (Max: 50 MB)'),
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
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk('Name',
                                        required: true),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.nameController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk('Email',
                                        required: true),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.emailController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk(
                                        'Phone Number',
                                        required: true),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.phoneController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('WhatsApp Number'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.whatsappController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Parent Name'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.parentNameController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Parent Occupation'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller:
                                            c.parentOccupationController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk('Gender'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.genderController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk('Place'),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.placeController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Pincode'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.pincodeController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Address'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.addressController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Time Zone'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.timezoneController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk('Mentor'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.mentorController),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            value: c.isAdmissionFeePaid.value,
                                            onChanged: (value) =>
                                                c.isAdmissionFeePaid.value =
                                                    !c.isAdmissionFeePaid.value,
                                          ),
                                        ),
                                        Text('Admission Fee Paid'),
                                      ],
                                    ),
                                    CustomWidgets()
                                        .labelWithAsterisk('Comment'),
                                    const SizedBox(height: 10),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: 'Enter any additional comments',
                                        controller: c.commentController,
                                        isMultiline: true),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Referred By'),
                                    Obx(() {
                                      final role = c.selectedRole.value;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RadioListTile<String>(
                                                  title: const Text("Mentor"),
                                                  value: "mentor",
                                                  groupValue: role,
                                                  onChanged: (value) => c
                                                      .selectedRole
                                                      .value = value!,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                              ),
                                              Expanded(
                                                child: RadioListTile<String>(
                                                  title: const Text("Advisor"),
                                                  value: "advisor",
                                                  groupValue: role,
                                                  onChanged: (value) => c
                                                      .selectedRole
                                                      .value = value!,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                              ),
                                              Expanded(
                                                child: RadioListTile<String>(
                                                  title: const Text("Others"),
                                                  value: "others",
                                                  groupValue: role,
                                                  onChanged: (value) => c
                                                      .selectedRole
                                                      .value = value!,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          if (role.isNotEmpty) ...[
                                            CustomWidgets().labelWithAsterisk(
                                                role[0].toUpperCase() +
                                                    role.substring(1)),
                                            const SizedBox(height: 10),
                                            CustomWidgets().customDropdownField(
                                              context: context,
                                              hint: '',
                                              items: [],
                                              onChanged: (p0) {},
                                            ),
                                          ]
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ))
                        ],
                        onSubmit: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.block,
                      color: cs.error,
                    ),
                    const SizedBox(width: 8),
                    CustomWidgets().iconBtn(
                      icon: Icons.delete,
                      color: cs.error,
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
}
