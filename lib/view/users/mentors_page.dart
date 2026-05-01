import 'package:albedo_app/config/root.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/mentor_controller.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class MentorsPage extends StatelessWidget {
  final c = Get.put(MentorController());

  MentorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      drawer: isDesktop ? null : const DrawerMenu(),
      floatingActionButton: addMentor(context),
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
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                      getCount: (index) => c.getCount(index),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final data = c.filteredMentors;
                      final cs = Theme.of(context).colorScheme;
                      int crossAxisCount = 1;

                      if (c.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return Center(
                            child: Text(
                          "No mentors found",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ));
                      }

                      if (Responsive.isTablet(context)) {
                        crossAxisCount = 2;
                      } else if (Responsive.isDesktop(context)) {
                        crossAxisCount = 3;
                      }

                      return LayoutBuilder(builder: (context, constraints) {
                        int crossAxisCount = 1;

                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 700) {
                          crossAxisCount = 2;
                        }

                        return MasonryGridView.count(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            crossAxisCount: crossAxisCount,
                            itemCount: c.filteredMentors.length,
                            itemBuilder: (context, index) {
                              final mentor = c.filteredMentors[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: InkWell(
                                  onTap: () => openMentorProfile(
                                    context,
                                    mentor,
                                    (p0) => mentorToUser(mentor),
                                  ),
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 700),
                                    child: PremiumInfoCard(
                                      id: mentor.id ?? "",
                                      title: mentor?.name ?? "",
                                      subtitle: mentor?.email ?? "",
                                      status: mentor?.status,
                                      statusColor:
                                          getStatusColor(mentor?.status),
                                      footerText:
                                          "Joined • ${mentor?.joinedAt.toString().substring(0, 16)}",
                                      extraInfo: mentor?.phone != null
                                          ? "Contact • ${mentor!.phone}"
                                          : null,
                                      onTap: () {
                                        if (mentor != null) {
                                          {
                                            openMentorProfile(
                                              context,
                                              mentor,
                                              (p0) => mentorToUser(mentor),
                                            );
                                          }
                                        }
                                      },
                                      actions: [
                                        InfoAction(
                                          icon: Icons.dashboard,
                                          color: cs.primary,
                                          onTap: () {
                                            final auth =
                                                Get.find<AuthController>();
                                            final user = mentorToUser(mentor);

                                            auth.startImpersonation(user);
                                            Get.offAll(() => const Root());
                                          },
                                        ),
                                        InfoAction(
                                          icon: Icons.edit,
                                          color: cs.secondary,
                                          onTap: () {
                                            if (mentor != null) {
                                              c.loadMentors(mentor);
                                              editMentor(context);
                                            }
                                          },
                                        ),
                                        InfoAction(
                                            icon: Icons.block,
                                            color: cs.error,
                                            onTap: () => c.handleDeactivate(
                                                context, mentor)),
                                        InfoAction(
                                            icon: Icons.delete,
                                            color: cs.error,
                                            onTap: () => c.handleDelete(
                                                context, mentor)),
                                      ],
                                    ),
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
            /// 🔹 TITLE + SEARCH TOGGLE (same row)
            Row(
              children: [
                if (!searching)
                  Expanded(
                    child: Text(
                      "Mentors",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                else
                  Expanded(
                    child: CustomWidgets().premiumSearch(
                      context,
                      hint: "Search mentors...",
                      onChanged: (val) {
                        c.searchQuery.value = val;
                        c.applyFilters();
                      },
                    ),
                  ),

                /// 🔍 SEARCH ICON
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    c.isSearching.value = !searching;

                    if (searching) {
                      c.searchQuery.value = "";
                      c.applyFilters();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      searching ? Icons.close : Icons.search,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// ✅ KEEP THIS ROW UNCHANGED
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

    /// DESKTOP (unchanged)
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: CustomWidgets().premiumSearch(
              context,
              hint: "Search Mentors...",
              onChanged: (val) => c.searchQuery.value = val,
            )),
        const SizedBox(width: 12),
        _filterButton(context),
        const SizedBox(width: 8),
        _sortButton(context, c),
      ],
    );
  }

  Widget _sortButton(BuildContext context, MentorController c) {
    return GestureDetector(
      onTap: () => CustomWidgets().showSortSheet<SortType>(
        title: "Sort Mentors",
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
        onTap: () => CustomWidgets().showFilterSheet(
          title: "Filter Sessions",
          options: c.ratingFilters,
          selectedValue: c.selectedRating.value,
          onSelected: (val) {
            c.selectedRating.value = val;
            c.applyFilters(); // 👈 re-filter
          },
        ),
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

  Widget addMentor(BuildContext context) {
    return AppFAB(
      label: "Add Mentor",
      icon: Icons.add_rounded,
      onPressed: () => CustomWidgets().showCustomDialog(
        context: context,
        title: const Text('Add Mentor'),
        formKey: GlobalKey<FormState>(),
        sections: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                /// 🔹 Profile
                const Center(child: Text('Profile Photo (Max: 50 MB)')),
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
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter mentor name',
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
                  hint: '+1234567890',
                  controller: c.phoneController,
                  isNumber: true,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('WhatsApp Number'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: '+1234567890',
                  controller: c.whatsappController,
                  isNumber: true,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Place'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter place',
                  controller: c.placeController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Pincode'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter pincode',
                  controller: c.pincodeController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Address'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter address',
                  controller: c.addressController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Qualification'),
                CustomWidgets().dropdownStyledTextField(
                  hint: '',
                  context: context,
                  controller: c.qualificationController,
                ),

                const SizedBox(height: 16),

                /// 🔹 Experience
                const Text(
                  'Experience',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.experiences.length,
                    itemBuilder: (context, index) {
                      final exp = c.experiences[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Experience ${index + 1}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Company Name'),
                              CustomWidgets().dropdownStyledTextField(
                                context: context,
                                hint: 'Enter company',
                                controller: exp.companyController,
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Years'),
                              CustomWidgets().dropdownStyledTextField(
                                context: context,
                                hint: 'Years',
                                controller: exp.yearController,
                              ),
                              const SizedBox(height: 10),
                              CustomWidgets().labelWithAsterisk('Months'),
                              CustomWidgets().dropdownStyledTextField(
                                context: context,
                                hint: 'Months',
                                controller: exp.monthController,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// ➕ Add Experience
                ElevatedButton.icon(
                  onPressed: c.addExperience,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Experience"),
                ),

                const SizedBox(height: 20),

                /// 🔹 Bank Details
                CustomWidgets().labelWithAsterisk('Account Number'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter Account Number',
                  controller: c.accountNumberController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Account Holder Name'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter Account Holder Name',
                  controller: c.accountHolderNameController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('UPI ID'),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter UPI ID',
                  controller: c.upiIdController,
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

  void editMentor(BuildContext context) {
    CustomWidgets().showCustomDialog(
      context: context,
      title: const Text('Edit Mentor'),
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
                  hint: 'Enter mentor name',
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
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter phone number',
                  controller: c.phoneController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Joining Date'),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Select date',
                  controller: c.dobController,
                ),

                const SizedBox(height: 10),

                CustomWidgets().labelWithAsterisk('Qualification'),
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Qualification',
                  controller: c.qualificationController,
                ),

                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Place'),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Place',
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
                const SizedBox(height: 8),
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Address',
                  controller: c.addressController,
                ),

                const SizedBox(height: 16),
                CustomWidgets()
                    .labelWithAsterisk('Preferred Language', required: true),
                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Select languages',
                    controller: c.prefLangController),
                const SizedBox(height: 10),

                /// 🔹 EXPERIENCE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Experience',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 10),

                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.experiences.length,
                      itemBuilder: (context, index) {
                        final exp = c.experiences[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Experience ${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomWidgets()
                                    .labelWithAsterisk('Company Name'),
                                const SizedBox(height: 6),
                                CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Enter company',
                                  controller: exp.companyController,
                                ),
                                const SizedBox(height: 10),
                                CustomWidgets().labelWithAsterisk('Years'),
                                const SizedBox(height: 6),
                                CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Years',
                                  controller: exp.yearController,
                                ),
                                const SizedBox(height: 10),
                                CustomWidgets().labelWithAsterisk('Months'),
                                const SizedBox(height: 6),
                                CustomWidgets().dropdownStyledTextField(
                                  context: context,
                                  hint: 'Months',
                                  controller: exp.monthController,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),

                const SizedBox(height: 10),

                /// ➕ Add Experience
                ElevatedButton.icon(
                  onPressed: c.addExperience,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Experience"),
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Account Number'),
                const SizedBox(height: 10),

                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter account number',
                    controller: c.accountNumberController),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Account Holder Name'),
                const SizedBox(height: 10),

                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter account holder name',
                    controller: c.accountHolderNameController),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('UPI ID'),
                const SizedBox(height: 10),

                CustomWidgets().dropdownStyledTextField(
                    context: context,
                    hint: 'Enter UPI ID',
                    controller: c.upiIdController),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Account Type'),
                const SizedBox(height: 10),

                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select Account Type',
                  items: ['Savings', 'Current'],
                  onChanged: (p0) {},
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Bank Name'),
                const SizedBox(height: 10),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select bank',
                  items: [],
                  onChanged: (p0) {},
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Branch Name'),
                const SizedBox(height: 10),
                CustomWidgets().customDropdownField(
                  context: context,
                  hint: 'Select branch',
                  items: [],
                  onChanged: (p0) {},
                ),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('IFSC Code'),
                const SizedBox(height: 10),
                CustomWidgets().dropdownStyledTextField(
                    context: context, hint: 'Auto-filled'),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Coordinator'),
                const SizedBox(height: 10),
                CustomWidgets()
                    .dropdownStyledTextField(context: context, hint: ''),
                const SizedBox(height: 10),
                CustomWidgets().labelWithAsterisk('Resume'),
                const SizedBox(height: 10),
                CustomWidgets()
                    .dropdownStyledTextField(context: context, hint: ''),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
      onSubmit: () {
        // TODO: update mentor
      },
    );
  }
}
