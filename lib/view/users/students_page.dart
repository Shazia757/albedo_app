import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/permissions_controller.dart';
import 'package:albedo_app/controller/student_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/view/students/refund_request_page.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/header_with_search.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class StudentsPage extends StatelessWidget {
  StudentsPage({super.key});

  final c = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    final tabs = ["All", "Active", "Batch", "TBA", "Inactive"];
    final isDesktop = Responsive.isDesktop(context);
    final auth = Get.find<AuthController>();
    final role = auth.activeUser?.role;

    final isCustom = ![
      "admin",
      "mentor",
      "advisor",
      "teacher",
      "student",
      "coordinator",
      "finance",
      "sales",
      "hr"
    ].contains(role);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      floatingActionButton: (!isCustom || PermissionService.can("add_students"))
          ? addStudent(context)
          : null,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Column(
              children: [
                HeaderWithSearch(
                  title: "Students",
                  hint: "Search students by name, ID or email...",
                  isSearching: c.isSearching,
                  searchQuery: c.searchQuery,
                  onSearchChanged: () => c.applyFilters(),
                  onSortTap: () => CustomWidgets().showSortSheet<SortType>(
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
                          value: SortType.name,
                          icon: Icons.sort_by_alpha),
                    ],
                    selectedValue: c.sortType.value,
                    onSelected: (val) {
                      c.sortType.value = val;
                      c.applyFilters();
                    },
                  ),
                  onRequestTap: (!isCustom || PermissionService.can("refunds"))
                      ? () => Get.to(() => RefundRequestsPage())
                      : null,
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
                          itemCount: c.filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = c.filteredStudents[index];
                            final isActive = student?.status == "Active";
                            final cs = Theme.of(context).colorScheme;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: InkWell(
                                onTap: (!isCustom ||
                                        PermissionService.can("view_students"))
                                    ? () => openStudentProfile(context, student)
                                    : null,
                                child: PremiumInfoCard(
                                  extraInfo: '',
                                  id: student.studentId ?? "NULL",
                                  title: student.name ?? "NULL",
                                  subtitle: student.email ?? "NULL",
                                  status: student.status,
                                  statusColor: isActive ? cs.primary : cs.error,
                                  footerText:
                                      "Joined • ${student.joinedAt.toString().substring(0, 16)}",
                                  actions: [
                                    InfoAction(
                                      icon: Icons.dashboard,
                                      color: cs.primary,
                                      onTap: () {
                                        final auth = Get.find<AuthController>();
                                        final user = studentToUser(student);

                                        auth.startImpersonation(user);
                                        Get.offAll(() => const Root());
                                      },
                                    ),
                                    if ((!isCustom ||
                                            PermissionService.can(
                                                "edit_students")) &&
                                        student?.status != 'Inactive')
                                      InfoAction(
                                        icon: Icons.edit,
                                        color: cs.secondary,
                                        onTap: () {
                                          c.loadStudents(student!);
                                          editStudent(context);
                                        },
                                      ),
                                    if (!isCustom ||
                                        PermissionService.can(
                                            "deactivate_students"))
                                      InfoAction(
                                        icon: Icons.block,
                                        color: cs.error,
                                        onTap: () => c.handleDeactivate(
                                            context, student),
                                      ),
                                    if (!isCustom ||
                                        (PermissionService.can(
                                            "delete_students")))
                                      InfoAction(
                                          icon: Icons.delete,
                                          color: cs.error,
                                          onTap: () =>
                                              c.handleDelete(context, student)),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void editStudent(BuildContext context) {
    CustomWidgets().showCustomDialog(
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
                  CustomWidgets().labelWithAsterisk('Name', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context, hint: '', controller: c.nameController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Email', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.emailController),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Phone Number', required: true),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.phoneController,
                      isNumber: true),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.whatsappController,
                      isNumber: true),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Parent Name'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.parentNameController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Parent Occupation'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.parentOccupationController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Gender'),
                  const SizedBox(height: 10),
                  // CustomWidgets().customDropdownField(
                  //   context: context,
                  //   hint: 'Select Gender',
                  //   items: ['Male', 'Female'],
                  //   onChanged: (p0) {},
                  // ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Place'),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.placeController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Pincode'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.pincodeController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Address'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.addressController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Time Zone'),
                  const SizedBox(height: 10),
                  // CustomWidgets().customDropdownField(
                  //   context: context,
                  //   hint: 'Select Time Zone',
                  //   items: [],
                  //   onChanged: (p0) {},
                  // ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Mentor'),
                  const SizedBox(height: 10),
                  // CustomWidgets().customDropdownField(
                  //   context: context,
                  //   hint: 'Select Mentor',
                  //   items: c.mentorsList,
                  //   onChanged: (p0) {},
                  // ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                          value: c.isAdmissionFeePaid.value,
                          onChanged: (value) => c.isAdmissionFeePaid.value =
                              !c.isAdmissionFeePaid.value,
                        ),
                      ),
                      Text('Admission Fee Paid'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Comment'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Enter any additional comments',
                      controller: c.commentController,
                      isMultiline: true),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Referred By'),
                  Obx(() {
                    final role = c.selectedRole.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Mentor"),
                                value: "mentor",
                                groupValue: role,
                                onChanged: (value) =>
                                    c.selectedRole.value = value!,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Advisor"),
                                value: "advisor",
                                groupValue: role,
                                onChanged: (value) =>
                                    c.selectedRole.value = value!,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Others"),
                                value: "others",
                                groupValue: role,
                                onChanged: (value) =>
                                    c.selectedRole.value = value!,
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (role.isNotEmpty) ...[
                          CustomWidgets().labelWithAsterisk(
                              role[0].toUpperCase() + role.substring(1)),
                          const SizedBox(height: 10),
                          // CustomWidgets().customDropdownField(
                          //   context: context,
                          //   hint: 'Select',
                          //   items: [],
                          //   onChanged: (p0) {},
                          // ),
                        ]
                      ],
                    );
                  }),
                ],
              ),
            ))
      ],
      onSubmit: () {},
    );
  }

  FloatingActionButton addStudent(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text('Add Student'),
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
                    CustomWidgets().labelWithAsterisk('Name', required: true),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter student name',
                        controller: c.nameController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Email', required: true),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email address',
                        controller: c.emailController),
                    const SizedBox(height: 10),
                    CustomWidgets()
                        .labelWithAsterisk('Phone Number', required: true),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.phoneController,
                        isNumber: true),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: '+1234567890',
                        controller: c.whatsappController,
                        isNumber: true),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Parent Name'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter parent name',
                        controller: c.parentNameController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Parent Occupation'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter parent occupation',
                        controller: c.parentOccupationController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Gender'),
                    const SizedBox(height: 10),
                    // CustomWidgets().customDropdownField(
                    //   context: context,
                    //   hint: 'Select Gender',
                    //   items: ['Male', 'Female'],
                    //   onChanged: (p0) {},
                    // ),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Place'),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter place',
                        controller: c.placeController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Pincode'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter pincode/postal code',
                        controller: c.pincodeController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Address'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter address',
                        controller: c.addressController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Time Zone'),
                    const SizedBox(height: 10),
                    // CustomWidgets().customDropdownField(
                    //   context: context,
                    //   hint: 'Select Time Zone',
                    //   items: [],
                    //   onChanged: (p0) {},
                    // ),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Mentor'),
                    const SizedBox(height: 10),
                    // CustomWidgets().customDropdownField(
                    //   context: context,
                    //   hint: 'Select Mentor',
                    //   items: c.mentorsList,
                    //   onChanged: (p0) {},
                    // ),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Advisor'),
                    const SizedBox(height: 10),
                    // CustomWidgets().customDropdownField(
                    //   context: context,
                    //   hint: 'Select Advisor',
                    //   items: c.advisorsList,
                    //   onChanged: (p0) {},
                    // ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: c.isAdmissionFeePaid.value,
                            onChanged: (value) => c.isAdmissionFeePaid.value =
                                !c.isAdmissionFeePaid.value,
                          ),
                        ),
                        Text('Admission Fee Paid'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Comment'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter any additional comments',
                        controller: c.commentController,
                        isMultiline: true),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Referred By'),
                    Obx(() {
                      final role = c.selectedRole.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Mentor"),
                                  value: "mentor",
                                  groupValue: role,
                                  onChanged: (value) =>
                                      c.selectedRole.value = value!,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Advisor"),
                                  value: "advisor",
                                  groupValue: role,
                                  onChanged: (value) =>
                                      c.selectedRole.value = value!,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Others"),
                                  value: "others",
                                  groupValue: role,
                                  onChanged: (value) =>
                                      c.selectedRole.value = value!,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (role.isNotEmpty) ...[
                            CustomWidgets().labelWithAsterisk(
                                role[0].toUpperCase() + role.substring(1)),
                            const SizedBox(height: 10),
                            // CustomWidgets().customDropdownField(
                            //   context: context,
                            //   hint: 'Select',
                            //   items: [],
                            //   onChanged: (p0) {},
                            // ),
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
      mini: true,
      backgroundColor: context.theme.colorScheme.primary,
      child: Icon(
        Icons.add,
        color: context.theme.colorScheme.onPrimary,
      ),
    );
  }
}
