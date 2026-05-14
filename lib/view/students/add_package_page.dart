import 'package:albedo_app/controller/package_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:albedo_app/model/users/teacher_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class AddPackagePage extends StatelessWidget {
  final Package? package;
  AddPackagePage({super.key, this.package});

  final c = Get.put(PackageController());

  bool get isEdit => package != null;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEdit) {
        c.loadPackage(package!);
      } else {
        c.clearForm();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? 'Edit Package' : 'Add Package',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      SizedBox(height: 10),
                      CustomWidgets()
                          .labelWithAsterisk('Package Type', required: true),
                      SizedBox(height: 10),

                      /// TYPE SWITCH
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Package",
                                icon: Icons.class_,
                                value: "package",
                                selectedValue: c.selectedType.value,
                                onTap: () => c.selectedType.value = 'package',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildTypeCard(
                                context: context,
                                title: "Repackage",
                                icon: Icons.video_call,
                                value: "repackage",
                                selectedValue: c.selectedType.value,
                                onTap: () => c.selectedType.value = 'repackage',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidgets().labelWithAsterisk('Package Name',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<Package>(
                            context: context,
                            hint: 'Select Package',
                            items: c.packagesList,
                            value: c.selectedPackage.value,
                            itemLabel: (p) => p.subjectName ?? "",
                            onChanged: (p0) => c.selectedPackage.value = p0,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Course', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<String>(
                            context: context,
                            hint: 'Select Course',
                            items: c.courseList,
                            onChanged: (p0) => c.selectedCourse.value = p0,
                            value: c.selectedCourse.value,
                            itemLabel: (item) => item,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Syllabus', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<String>(
                            context: context,
                            hint: 'Select Syllabus',
                            items: c.syllabusList,
                            onChanged: (p0) => c.selectedSyllabus.value = p0,
                            value: c.selectedSyllabus.value,
                            itemLabel: (item) => item,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Category', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<String>(
                            context: context,
                            hint: 'Select Category',
                            items: c.categoryList,
                            onChanged: (p0) => c.selectedCategory.value = p0,
                            value: c.selectedCategory.value,
                            itemLabel: (item) => item,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Standard', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<String>(
                            context: context,
                            hint: 'Select Standard',
                            items: c.categoryList,
                            onChanged: (p0) => c.selectedStandard.value = p0,
                            value: c.selectedStandard.value,
                            itemLabel: (item) => item,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Number of Classes',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Class count',
                              controller: c.classCountController,
                              isNumber: true),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Class Time', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().timePickerStyledField(
                            context: context,
                            controller: c.timeController,
                            selectedTime: c.selectedTime,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Select Duration',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField(
                            context: context,
                            hint: 'Select Duration',
                            items: c.durationOptions,
                            value: c.selectedDuration.value,
                            onChanged: (p0) => c.selectedDuration.value = p0,
                            itemLabel: (item) => "$item minutes",
                          ),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Duration Days',
                              required: true),
                          SizedBox(height: 10),
                          Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomWidgets().dropdownStyledTextField(
                                    context: context,
                                    hint: 'Duration Days',
                                    controller: c.durationDaysController,
                                  ),
                                  if (c.durationError.value.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, left: 4),
                                      child: Text(
                                        c.durationError.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                      ),
                                    ),
                                ],
                              )),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk(
                              'Student Fee (per hour)',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Student Fee',
                              controller: c.studentFeeController,
                              isNumber: true),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk(
                              'Total Package Fee (view only)',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                              context: context,
                              hint: 'Total Package Fee',
                              controller: c.totalPackageFeeController,
                              readOnly: true),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Tuition mode',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField(
                            context: context,
                            hint: 'Select Tution Mode',
                            items: c.tutionOptions,
                            value: c.selectedTuitionMode.value,
                            onChanged: (p0) => c.selectedTuitionMode.value = p0,
                            itemLabel: (item) => "$item minutes",
                          ),
                          SizedBox(height: 10),
                          CustomWidgets()
                              .labelWithAsterisk('Teacher', required: true),
                          SizedBox(height: 10),
                          CustomWidgets().customDropdownField<Teacher>(
                            context: context,
                            hint: 'Select Teacher',
                            items: c.teacherList,
                            value: c.selectedTeacher.value,
                            onChanged: (p0) => c.selectedTeacher.value = p0,
                            itemLabel: (item) => item.name,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk(
                              'Teacher Salary (per hour)',
                              required: true),
                          SizedBox(height: 10),
                          CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: 'Teacher Salary',
                            controller: c.salaryController,
                            isNumber: true,
                          ),
                          SizedBox(height: 10),
                          CustomWidgets().labelWithAsterisk('Package Days',
                              required: true),
                          SizedBox(height: 10),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: _buildTypeCard(
                                    context: context,
                                    title: "Regular",
                                    icon: Icons.class_,
                                    value: "regular",
                                    selectedValue: c.selectedDateType.value,
                                    onTap: () =>
                                        c.selectedDateType.value = "regular",
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildTypeCard(
                                    context: context,
                                    title: "Custom Schedule",
                                    icon: Icons.video_call,
                                    value: "custom",
                                    selectedValue: c.selectedDateType.value,
                                    onTap: () =>
                                        c.selectedDateType.value = "custom",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),

                          // CONTENT
                          Obx(() {
                            if (c.selectedDateType.value == 'regular') {
                              return _buildDaysSelector(context, c);
                            } else {
                              return _buildCalendar(context, c);
                            }
                          }),

                          SizedBox(height: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title + Switch
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Apply Coupon Code",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                      color: Get.theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Obx(() => Switch(
                                        value: c.applyCoupon.value,
                                        onChanged: (val) {
                                          c.applyCoupon.value = val;
                                        },
                                      )),
                                ],
                              ),

                              /// TextField
                              Obx(() {
                                if (!c.applyCoupon.value) {
                                  return SizedBox();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomWidgets()
                                            .dropdownStyledTextField(
                                          context: context,
                                          hint: 'Enter coupon code',
                                          controller: c.couponController,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          c.verifyCoupon(context);
                                        },
                                        label: Text(
                                          'Verify',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 20),

                      /// SUBMIT BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const SizedBox.shrink(),
                              label: Text(
                                'Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateSession(context)) {
                                  if (isEdit) {
                                    c.updatePackage(package!);
                                  } else {
                                    c.addPackage();
                                  }
                                }
                              },
                              icon: Icon(isEdit ? Icons.edit : Icons.add,
                                  size: 15, color: Colors.white),
                              label: Text(
                                isEdit ? 'Update' : 'Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysSelector(BuildContext context, PackageController c) {
    final days = Days.values;

    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            final isSelected = c.selectedDays.contains(day);

            return ChoiceChip(
              label: Text(_dayLabel(day)),
              selected: isSelected,

              // 👇 selected color
              selectedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.12),

              // 👇 default background
              backgroundColor: Colors.transparent,

              // 👇 border styling
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  width: 0.6, // 👈 reduced border width
                ),
              ),

              // 👇 text color
              labelStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87),

              onSelected: (val) {
                if (day == Days.all) {
                  if (val) {
                    c.selectedDays.assignAll(Days.values);
                  } else {
                    c.selectedDays.clear();
                  }
                } else {
                  c.selectedDays.remove(Days.all);

                  if (val) {
                    c.selectedDays.add(day);
                  } else {
                    c.selectedDays.remove(day);
                  }
                }
              },
            );
          }).toList(),
        ));
  }

  String _dayLabel(Days day) {
    switch (day) {
      case Days.all:
        return "All";
      case Days.monday:
        return "Mon";
      case Days.tuesday:
        return "Tue";
      case Days.wednesday:
        return "Wed";
      case Days.thursday:
        return "Thu";
      case Days.friday:
        return "Fri";
      case Days.saturday:
        return "Sat";
      case Days.sunday:
        return "Sun";
    }
  }

  Widget _buildCalendar(BuildContext context, PackageController c) {
    return Obx(() {
      final classCount = c.classCount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (classCount == 0)
            Text(
              "Please enter class count first",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            ),

          SizedBox(height: 8),

          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(2100),
            focusedDay: DateTime.now(),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            selectedDayPredicate: (day) {
              return c.selectedDates.any((d) => isSameDay(d, day));
            },
            enabledDayPredicate: (day) {
              return !day.isBefore(
                DateTime.now().subtract(const Duration(days: 1)),
              );
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (classCount == 0) {
                c.dateError.value = "Enter class count first";
                return;
              }

              final alreadySelected =
                  c.selectedDates.any((d) => isSameDay(d, selectedDay));

              if (alreadySelected) {
                c.selectedDates.removeWhere((d) => isSameDay(d, selectedDay));
                c.dateError.value = '';
              } else {
                if (c.selectedDates.length >= classCount) {
                  c.dateError.value = "You can only select $classCount dates";
                  return;
                }

                c.selectedDates.add(selectedDay);
                c.dateError.value = '';
              }
            },
          ),

          SizedBox(height: 8),

          /// Selected dates preview
          Wrap(
            spacing: 6,
            children: c.selectedDates.map((date) {
              return Chip(
                label: Text(
                  "${date.day}/${date.month}",
                ),
                onDeleted: () {
                  c.selectedDates.remove(date);
                },
              );
            }).toList(),
          ),

          /// Error message
          if (c.dateError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                c.dateError.value,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.onPrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;

  DropdownItem({
    required this.value,
    required this.label,
  });
}
