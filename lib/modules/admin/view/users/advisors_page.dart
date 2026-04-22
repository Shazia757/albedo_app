import 'package:albedo_app/controller/advisor_controller.dart';
import 'package:albedo_app/model/users/advisor_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvisorsPage extends StatelessWidget {
  AdvisorsPage({super.key});

  final c = Get.put(AdvisorController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addAdvisor(context),
      body: Row(
        children: [
          if (isDesktop) DrawerMenu(),
          Expanded(
            child: Column(
              children: [
                /// 🔍 Search + Sort
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomWidgets().premiumSearch(context,
                            hint: "Search Advisors...",
                            onChanged: (value) => c.searchQuery.value = value),
                      ),

                      const SizedBox(width: 10),

                      /// Sort
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => CustomWidgets().showSortSheet<SortType>(
                          title: "Sort Coordinators",
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
                    tabs: c.tabs,
                    selectedIndex: c.selectedTab.value,
                    onTap: (index) {
                      c.selectedTab.value = index;
                      c.applyFilters();
                    },
                    getCount: (index) {
                      switch (index) {
                        case 0:
                          return c.activeCount;
                        case 1:
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
                    if (c.filteredAdvisors.isEmpty) {
                      return const Center(child: Text("No advisors found"));
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: c.filteredAdvisors.length,
                        itemBuilder: (context, index) {
                          final teacher = c.filteredAdvisors[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 700),
                                child: _card(context, teacher),
                              ),
                            ),
                          );
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

  Widget _card(BuildContext context, Advisor adr) {
    final cs = Theme.of(context).colorScheme;

    final isActive = adr.status == "Active";

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
                      adr.id ?? 'NULL',
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
                        adr.status ?? 'NULL',
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
                  adr.name ?? 'NULL',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                /// Email
                Text(
                  adr.email ?? 'NULL',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.6),
                  ),
                ),

                const SizedBox(height: 6),

                /// Extra Info
                Text(
                  "Contact • ${adr.phone ?? "N/A"}",
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
                    if (adr.status == 'Active')
                      CustomWidgets().iconBtn(
                        icon: Icons.edit,
                        color: cs.secondary,
                        onTap: () {
                          c.loadAdvisors(adr);
                          editAdvisor(context);
                        },
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
                      onTap: () => CustomWidgets().showDeleteDialog(
                        text:
                            'Are you sure you want to delete this coordinator permanently?',
                        context: context,
                        onConfirm: () => c.delete(adr.id),
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

  FloatingActionButton addAdvisor(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: Text('Add Advisor'),
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
                        hint: 'Enter advisor name',
                        controller: c.nameController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Email', required: true),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter email',
                        controller: c.emailController),
                    const SizedBox(height: 10),
                    CustomWidgets()
                        .labelWithAsterisk('Phone Number', required: true),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter phone number',
                        controller: c.phoneController),
                    // const SizedBox(height: 10),
                    // CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                    // const SizedBox(height: 10),
                    // CustomWidgets().dropdownStyledTextField(
                    //     context: context,
                    //     hint: 'Enter WhatsApp Number',
                    //     controller: c.whatsappController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Joining Date'),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Select Date',
                        controller: c.dobController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Qualification'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Qualification',
                        controller: c.qualificationController),
                    const SizedBox(height: 10),
                    CustomWidgets().labelWithAsterisk('Address'),
                    const SizedBox(height: 10),
                    CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Address',
                        controller: c.addressController),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Experience',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => Column(
                          children: [
                            Column(
                              children: List.generate(
                                c.experiences.length,
                                (index) {
                                  final exp = c.experiences[index];

                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Title
                                          Text(
                                            "Experience ${index + 1}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Company
                                          CustomWidgets().labelWithAsterisk(
                                              'Company Name'),
                                          const SizedBox(height: 8),
                                          CustomWidgets()
                                              .dropdownStyledTextField(
                                            context: context,
                                            hint: 'Enter company name',
                                            controller: exp.companyController,
                                          ),

                                          const SizedBox(height: 10),

                                          // Years
                                          CustomWidgets()
                                              .labelWithAsterisk('Years'),
                                          const SizedBox(height: 8),
                                          CustomWidgets()
                                              .dropdownStyledTextField(
                                            context: context,
                                            hint: 'Years',
                                            controller: exp.yearController,
                                          ),

                                          const SizedBox(height: 10),

                                          // Months
                                          CustomWidgets()
                                              .labelWithAsterisk('Months'),
                                          const SizedBox(height: 8),
                                          CustomWidgets()
                                              .dropdownStyledTextField(
                                            context: context,
                                            hint: 'Months',
                                            controller: exp.monthController,
                                          ),

                                          const SizedBox(height: 10),
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
                          ],
                        )),
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

  void editAdvisor(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: Text('Edit Advisor'),
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
                      context: context,
                      hint: 'Enter advisor name',
                      controller: c.nameController),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Employee ID', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: '',
                      controller: c.empIdController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Email', required: true),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Enter email',
                      controller: c.emailController),
                  const SizedBox(height: 10),
                  CustomWidgets()
                      .labelWithAsterisk('Phone Number', required: true),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Enter phone number',
                      controller: c.phoneController),
                  // const SizedBox(height: 10),
                  // CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                  // const SizedBox(height: 10),
                  // CustomWidgets().dropdownStyledTextField(
                  //     context: context,
                  //     hint: 'Enter WhatsApp Number',
                  //     controller: c.whatsappController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Joining Date'),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Select Date',
                      controller: c.dobController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Qualification'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Qualification',
                      controller: c.qualificationController),
                  const SizedBox(height: 10),
                  CustomWidgets().labelWithAsterisk('Address'),
                  const SizedBox(height: 10),
                  CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Address',
                      controller: c.addressController),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Experience',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Column(
                        children: [
                          Column(
                            children: List.generate(
                              c.experiences.length,
                              (index) {
                                final exp = c.experiences[index];

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          "Experience ${index + 1}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        // Company
                                        CustomWidgets()
                                            .labelWithAsterisk('Company Name'),
                                        const SizedBox(height: 8),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Enter company name',
                                          controller: exp.companyController,
                                        ),

                                        const SizedBox(height: 10),

                                        // Years
                                        CustomWidgets()
                                            .labelWithAsterisk('Years'),
                                        const SizedBox(height: 8),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Years',
                                          controller: exp.yearController,
                                        ),

                                        const SizedBox(height: 10),

                                        // Months
                                        CustomWidgets()
                                            .labelWithAsterisk('Months'),
                                        const SizedBox(height: 8),
                                        CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Months',
                                          controller: exp.monthController,
                                        ),

                                        const SizedBox(height: 10),
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
                        ],
                      )),
                ],
              ),
            ))
      ],
      onSubmit: () {},
    );
  }
}
