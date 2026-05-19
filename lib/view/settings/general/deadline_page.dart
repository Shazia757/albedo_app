import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class DeadlinePage extends StatelessWidget {
  final c = Get.put(SettingsController());

  DeadlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: cs.surface,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 900) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ── PAGE TITLE ─────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  child: Text(
                    'Completion Deadline',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700, color: cs.primary),
                  ),
                ),

                /// ── CONTENT ────────────────────────
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 900) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2;
                      }

                      return Obx(
                        () => MasonryGridView.count(
                            crossAxisCount: crossAxisCount,
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              8,
                              16,
                              24,
                            ),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            physics: const BouncingScrollPhysics(),
                            itemCount: c.completionDeadlineSettings.length,
                            itemBuilder: (context, i) {
                              final item = c.completionDeadlineSettings[i];

                              return DeadlineTile(
                                id: item.id ?? "",
                                role: item.role ?? "",
                                value: item.value.toString(),
                                deadlineType: item.deadlineType ?? '',
                                isActive: item.isActive ?? false,
                                onSave: (val) async {
                                  await c.updateDeadline(
                                    id: item.id!,
                                    role: item.role!,
                                    type: item.deadlineType!,
                                    isActive: item.isActive ?? false,
                                    value: int.parse(val),
                                  );
                                },
                              );
                            }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeadlineTile extends StatefulWidget {
  final String id;
  final String role;
  final String value;
  final String deadlineType;
  final bool isActive;

  final ValueChanged<String> onSave;

  const DeadlineTile({
    super.key,
    required this.id,
    required this.role,
    required this.value,
    required this.deadlineType,
    required this.onSave,
    required this.isActive,
  });

  @override
  State<DeadlineTile> createState() => _DeadlineTileState();
}

class _DeadlineTileState extends State<DeadlineTile> {
  late TextEditingController _ctrl;
  late SettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SettingsController>();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final v = _ctrl.text.trim();
    if (v.isEmpty) return;

    widget.onSave(v);
    controller.editingId.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final isEditing = controller.editingId.value == widget.id;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: cs.outline.withOpacity(.5)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(.04),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER ROW
            Row(
              children: [
                Icon(Icons.schedule, color: cs.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.role,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (widget.isActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),

            /// DEADLINE TYPE
            Text(
              "Deadline: ${formatDeadline(widget.deadlineType, int.parse(widget.value))}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 12),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isEditing) ...[
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: _save,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: cs.outline),
                    onPressed: () {
                      _ctrl.text = widget.value;
                      controller.editingId.value = '';
                    },
                  ),
                ] else ...[
                  IconButton(
                      icon: Icon(Icons.edit, color: cs.primary),
                      onPressed: () {
                        final c = Get.find<SettingsController>();
                        c.selectedType.value = widget.deadlineType;
                        c.isActive.value = widget.isActive;
                        if (widget.deadlineType == "HOURS_AFTER_SESSION") {
                          c.hourController.text = widget.value;
                          c.monthController.clear();
                        } else {
                          c.monthController.text = widget.value;
                          c.hourController.clear();
                        }

                        CustomWidgets().showCustomDialog(
                          context: context,
                          submitWidget: Obx(
                            () => (c.isLoading.value)
                                ? CircularProgressIndicator(
                                    color: cs.primary,
                                  )
                                : Text(
                                    "Update",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                          ),
                          title:
                              Text('Edit ${widget.role} Completion Deadline'),
                          formKey: GlobalKey<FormState>(),
                          sections: [
                            Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// TYPE SELECTION
                                    Text("Select Deadline Type"),

                                    RadioListTile(
                                      title: Text("Hours after session"),
                                      value: "HOURS_AFTER_SESSION",
                                      groupValue: c.selectedType.value,
                                      onChanged: (v) =>
                                          c.selectedType.value = v!,
                                    ),

                                    RadioListTile(
                                      title: Text("Day of month"),
                                      value: "DAY_OF_NEXT_MONTH",
                                      groupValue: c.selectedType.value,
                                      onChanged: (v) =>
                                          c.selectedType.value = v!,
                                    ),

                                    const SizedBox(height: 10),

                                    /// CONDITIONAL FIELDS
                                    if (c.selectedType.value ==
                                        "HOURS_AFTER_SESSION") ...[
                                      CustomWidgets()
                                          .labelWithAsterisk('Number of hours'),
                                      const SizedBox(height: 10),
                                      CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Hours',
                                          isNumber: true,
                                          controller: c.hourController)
                                    ],

                                    if (c.selectedType.value ==
                                        "DAY_OF_NEXT_MONTH") ...[
                                      CustomWidgets().labelWithAsterisk(
                                          'Day of month (1–28)'),
                                      const SizedBox(height: 10),
                                      CustomWidgets().dropdownStyledTextField(
                                          context: context,
                                          hint: 'Day',
                                          isNumber: true,
                                          controller: c.monthController),
                                    ],
                                    const SizedBox(height: 10),
                                    Obx(() => SwitchListTile(
                                          title: Text(
                                            c.isActive.value
                                                ? "Deadline is enforced"
                                                : "No time limit (disabled)",
                                          ),
                                          value: c.isActive.value,
                                          onChanged: (v) =>
                                              c.isActive.value = v,
                                        )),
                                  ],
                                )),
                          ],
                          onSubmit: () async {
                            final type = c.selectedType.value;

                            if (type.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please select a deadline type",
                              );
                              return;
                            }

                            String value = '';

                            if (type == "HOURS_AFTER_SESSION") {
                              value = c.hourController.text.trim();

                              if (value.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please enter number of hours",
                                );
                                return;
                              }
                            }

                            if (type == "DAY_OF_NEXT_MONTH") {
                              value = c.monthController.text.trim();

                              if (value.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please enter day of month",
                                );
                                return;
                              }

                              final day = int.tryParse(value);

                              if (day == null || day < 1 || day > 28) {
                                Get.snackbar(
                                  "Error",
                                  "Day must be between 1 and 28",
                                );
                                return;
                              }
                            }

                            await c.updateDeadline(
                              id: widget.id,
                              role: widget.role,
                              type: type,
                              isActive: c.isActive.value,
                              value: int.parse(value),
                            );

                            Get.back();
                          },
                        );
                      }),
                ]
              ],
            )
          ],
        ),
      );
    });
  }

  String formatDeadline(String type, int value) {
    switch (type) {
      case "DAY_OF_NEXT_MONTH":
        return "${ordinal(value)} of next month";

      case "HOURS_AFTER_SESSION":
        return "$value hour${value > 1 ? 's' : ''} after session";

      case "DAYS_AFTER_SESSION":
        return "$value day${value > 1 ? 's' : ''} after session";

      case "IMMEDIATE":
        return "Immediate deadline";

      default:
        return "$value ($type)";
    }
  }

  String ordinal(int number) {
    if (number >= 11 && number <= 13) return "${number}th";

    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }
}
