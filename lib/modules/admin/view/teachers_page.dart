import 'package:albedo_app/controller/session_controller.dart';
import 'package:albedo_app/controller/teacher_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeachersPage extends StatelessWidget {
  TeachersPage({super.key});

  final c = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final tabs = ["All", "Active", "Batch", "Inactive"];

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
                      hint: "Search teachers...",
                      onChanged: (value) => c.searchQuery.value = value),
                ),

                const SizedBox(width: 10),

                /// Sort
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => CustomWidgets().showSortSheet(
                    title: "Sort Teachers",
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
                          value: SortType.teacher,
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
              if (c.filteredTeachers.isEmpty) {
                return const Center(child: Text("No teachers found"));
              }

              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: c.filteredTeachers.length,
                  itemBuilder: (context, index) {
                    final teacher = c.filteredTeachers[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: _card(context, teacher),
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

  /// 💎 Premium Card
  Widget _card(BuildContext context, Teacher? t) {
    final cs = Theme.of(context).colorScheme;

    final isActive = t?.status == "Active";

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
                      t?.id ?? 'NULL',
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
                        t?.status ?? 'NULL',
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
                  t?.name ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  t?.email ?? 'NULL',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 6),

                /// Extra Info
                Text(
                  "Contact • ${t?.phone ?? "N/A"}",
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
                        title:Text( 'Edit Teacher'),
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
                                        'Teacher ID',
                                        required: true),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.teacherIdController),
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
                                        .labelWithAsterisk('Date of Birth'),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.dobController),
                                    const SizedBox(height: 10),
                                    CustomWidgets()
                                        .labelWithAsterisk('Qualification'),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.qualificationController),
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
                                    CustomWidgets().labelWithAsterisk(
                                        'Preferred Language',
                                        required: true),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.prefLangController),
                                    const SizedBox(height: 10),
                                    CustomWidgets().labelWithAsterisk(
                                        'Tuition Mode',
                                        required: true),
                                    CustomWidgets().dropdownStyledTextField(
                                        context: context,
                                        hint: '',
                                        controller: c.tutionModeController),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Experience',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Obx(() => Column(
                                          children: [
                                            Column(
                                              children: List.generate(
                                                c.experiences.length,
                                                (index) {
                                                  final exp =
                                                      c.experiences[index];

                                                  return Card(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    elevation: 2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Title
                                                          Text(
                                                            "Experience ${index + 1}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                              height: 10),

                                                          // Company
                                                          CustomWidgets()
                                                              .labelWithAsterisk(
                                                                  'Company Name'),
                                                          const SizedBox(
                                                              height: 8),
                                                          CustomWidgets()
                                                              .dropdownStyledTextField(
                                                            context: context,
                                                            hint:
                                                                'Enter company name',
                                                            controller: exp
                                                                .companyController,
                                                          ),

                                                          const SizedBox(
                                                              height: 10),

                                                          // Years
                                                          CustomWidgets()
                                                              .labelWithAsterisk(
                                                                  'Years'),
                                                          const SizedBox(
                                                              height: 8),
                                                          CustomWidgets()
                                                              .dropdownStyledTextField(
                                                            context: context,
                                                            hint: 'Years',
                                                            controller: exp
                                                                .yearController,
                                                          ),

                                                          const SizedBox(
                                                              height: 10),

                                                          // Months
                                                          CustomWidgets()
                                                              .labelWithAsterisk(
                                                                  'Months'),
                                                          const SizedBox(
                                                              height: 8),
                                                          CustomWidgets()
                                                              .dropdownStyledTextField(
                                                            context: context,
                                                            hint: 'Months',
                                                            controller: exp
                                                                .monthController,
                                                          ),

                                                          const SizedBox(
                                                              height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            // ➕ Add Button at Bottom
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: c.addExperience,
                                                // c.addExperience,
                                                icon: Icon(Icons.add),
                                                label: Text("Add Experience"),
                                              ),
                                            ),

                                            const SizedBox(height: 10),
                                            CustomWidgets().labelWithAsterisk(
                                                'Account Number'),
                                            const SizedBox(height: 10),

                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                                    context: context,
                                                    hint: '',
                                                    controller: c
                                                        .accountNumberController),
                                            const SizedBox(height: 10),
                                            CustomWidgets().labelWithAsterisk(
                                                'Account Holder Name'),
                                            const SizedBox(height: 10),

                                            CustomWidgets().dropdownStyledTextField(
                                                context: context,
                                                hint: '',
                                                controller: c
                                                    .accountHolderNameController),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .labelWithAsterisk('UPI ID'),
                                            const SizedBox(height: 10),

                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                                    context: context,
                                                    hint: '',
                                                    controller:
                                                        c.upiIdController),
                                            const SizedBox(height: 10),
                                            CustomWidgets().labelWithAsterisk(
                                                'Account Type'),
                                            const SizedBox(height: 10),

                                            CustomWidgets().customDropdownField(
                                              context: context,
                                              hint: '',
                                              items: ['Savings', 'Current'],
                                              onChanged: (p0) {},
                                            ),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .labelWithAsterisk('Bank Name'),
                                            const SizedBox(height: 10),
                                            CustomWidgets().customDropdownField(
                                              context: context,
                                              hint: 'Select bank',
                                              items: [],
                                              onChanged: (p0) {},
                                            ),
                                            const SizedBox(height: 10),
                                            CustomWidgets().labelWithAsterisk(
                                                'Branch Name'),
                                            const SizedBox(height: 10),
                                            CustomWidgets().customDropdownField(
                                              context: context,
                                              hint: 'Select branch',
                                              items: [],
                                              onChanged: (p0) {},
                                            ),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .labelWithAsterisk('IFSC Code'),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                                    context: context,
                                                    hint: 'Auto-filled'),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .labelWithAsterisk('Resume'),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                                    context: context,
                                                    hint: 'Enter Resume URL'),
                                            const SizedBox(height: 10),
                                            CustomWidgets().labelWithAsterisk(
                                                'Demo Video (Optional)'),
                                            const SizedBox(height: 10),
                                            CustomWidgets()
                                                .dropdownStyledTextField(
                                                    context: context,
                                                    hint: 'Enter Demo URL'),
                                            const SizedBox(height: 20),
                                          ],
                                        )),
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
