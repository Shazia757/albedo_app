import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:albedo_app/widgets/crud_page.dart';
import 'package:albedo_app/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeadlinePage extends StatelessWidget {
  final c = Get.put(SettingsController());

  DeadlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage<DeadlineConfig>(
      title: 'Completion Deadline',
      items: c.restrictedUsers,
      enableAdd: false, // ❗ disable add button

      itemBuilder: (item, i) {
        return DeadlineTile(
          config: item,
          onUpdate: (updated) {
            c.restrictedUsers[i] = updated;
            c.restrictedUsers.refresh();
          },
        );
      },

      onAdd: (_) async {}, // not used
      onUpdate: (i, val) async {},
      onDelete: (i) async {},
    );
  }
}

class DeadlineTile extends StatefulWidget {
  final DeadlineConfig config;
  final ValueChanged<DeadlineConfig> onUpdate;

  const DeadlineTile({
    super.key,
    required this.config,
    required this.onUpdate,
  });

  @override
  State<DeadlineTile> createState() => _DeadlineTileState();
}

class _DeadlineTileState extends State<DeadlineTile> {
  late DeadlineConfig temp;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    temp = DeadlineConfig(
      role: widget.config.role,
      type: widget.config.type,
      value: widget.config.value,
      enabled: widget.config.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            children: [
              Text(
                widget.config.role,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const Spacer(),
              if (!editing)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => editing = true),
                )
            ],
          ),

          if (!editing) ...[
            /// 🔹 VIEW MODE
            Text(
              temp.enabled
                  ? temp.type == "hours"
                      ? "${temp.value} hours after session"
                      : "${temp.value} day of next month"
                  : "No time limit",
              style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
            ),
          ] else ...[
            const SizedBox(height: 10),

            /// 🔘 TYPE
            Column(
              children: [
                RadioListTile(
                  value: "hours",
                  groupValue: temp.type,
                  onChanged: (val) =>
                      setState(() => temp.type = val.toString()),
                  title: const Text("Hours after session"),
                  subtitle: const Text("e.g. 48 = 2 days after session"),
                ),
                RadioListTile(
                  value: "dayOfMonth",
                  groupValue: temp.type,
                  onChanged: (val) =>
                      setState(() => temp.type = val.toString()),
                  title: const Text("Day of next month"),
                  subtitle: const Text("e.g. 3 = 3rd of next month"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔢 INPUT + SWITCH
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller:
                        TextEditingController(text: temp.value.toString()),
                    onChanged: (v) =>
                        temp.value = int.tryParse(v) ?? temp.value,
                    decoration: InputDecoration(
                      labelText: temp.type == "hours"
                          ? "Number of hours"
                          : "Day of month",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Switch(
                      value: temp.enabled,
                      onChanged: (v) => setState(() => temp.enabled = v),
                    ),
                    Text(
                      temp.enabled ? "Enforced" : "Disabled",
                      style: const TextStyle(fontSize: 11),
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),

            /// 🔘 ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      temp = DeadlineConfig(
                        role: widget.config.role,
                        type: widget.config.type,
                        value: widget.config.value,
                        enabled: widget.config.enabled,
                      );
                      editing = false;
                    });
                  },
                  child: Text(
                    "Cancel",
                    style:
                        TextStyle(color: context.theme.colorScheme.onSurface),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.colorScheme.secondary),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
