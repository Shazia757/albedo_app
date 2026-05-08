import 'package:albedo_app/controller/batch_list_controller.dart';
import 'package:albedo_app/model/batch_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBatchSessionPage extends StatelessWidget {
  const AddBatchSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<BatchListController>();
    final isDesktop = Responsive.isDesktop(context);

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
                        'Add Batch Session',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                    

                   
        CustomWidgets().labelWithAsterisk('Select Batch', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField<Batch>(
          context: context,
          hint: 'Select Batch',
          items: c.batchList,
          value: c.selectedBatch.value,
          itemLabel: (s) => s.batchName??'',
          onChanged: (batch) => c.onBatchSelected(batch),
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Package', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Package',
          items: c.packagesList,
          value: c.selectedPackage.value,
          itemLabel: (p) => p.subjectName??'',
          onChanged: (p0) => c.selectedPackage.value = p0,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Teacher', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Teacher',
          items: c.teacherList,
          onChanged: (p0) => c.selectedTeacher.value = p0,
          value: c.selectedTeacher.value,
          itemLabel: (item) => item.name,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Teacher Salary'),
        const SizedBox(height: 10),
        CustomWidgets().dropdownStyledTextField(
            context: context,
            hint: 'Teacher Salary',
            controller: c.salaryController,
            isNumber: true),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Date', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDatePickerField(
          context: context,
          controller: c.dateController,
          selectedDate: c.selectedDate,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Session Time', required: true),
        const SizedBox(height: 10),
        CustomWidgets().timePickerStyledField(
          context: context,
          controller: c.timeController,
          selectedTime: c.selectedTime,
        ),
        const SizedBox(height: 10),
        CustomWidgets().labelWithAsterisk('Select Duration', required: true),
        const SizedBox(height: 10),
        CustomWidgets().customDropdownField(
          context: context,
          hint: 'Select Duration',
          items: c.durationOptions,
          value: c.selectedDuration.value,
          onChanged: (p0) => c.selectedDuration.value = p0,
          itemLabel: (item) => "$item minutes",
        ),
      
    

                      const SizedBox(height: 20),

                      /// SUBMIT BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.back(),
                              icon: const SizedBox.shrink(),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13),
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (c.validateSession(context)) {
                                  c.addSession();
                                }
                              },
                              icon: const Icon(Icons.add,
                                  size: 15, color: Colors.white),
                              label: const Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
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
}

class DropdownItem<T> {
  final T value;
  final String label;

  DropdownItem({
    required this.value,
    required this.label,
  });
}
