import 'package:albedo_app/controller/settings_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StarOfMonthPage extends StatelessWidget {
  StarOfMonthPage({super.key});

  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: const CustomAppBar(),
      body: FutureBuilder(
        future: controller.fetchRatingValues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── PAGE TITLE ─────────────────────
                    Text(
                      "Star of Month",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary),
                    ),

                    const SizedBox(height: 18),

                    /// ── CARD ───────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.onPrimary,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: cs.outline.withOpacity(.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withOpacity(.04),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ── HEADER ─────────────────────
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rating Values",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: cs.onSurface),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Manage rating values used for monthly star calculations.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: cs.outline),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Divider(
                            height: 1,
                            color: cs.outline.withOpacity(.12),
                          ),

                          const SizedBox(height: 20),

                          /// ── LIST ───────────────────────
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.ratingValues.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item =
                                    controller.ratingValues[index];
                                    final isDefaultField = index < 5;

                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainerHighest
                                        .withOpacity(.18),
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    border: Border.all(
                                      color:
                                          cs.outline.withOpacity(.08),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      /// Label
                                      Container(
                                        width: 52,
                                        height: 52,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: cs.primary
                                              .withOpacity(.08),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Text(
                                          item["label"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: cs.primary,
                                              ),
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      /// Input
                                      Expanded(
                                        child: CustomWidgets()
                                            .dropdownStyledTextField(
                                          context: context,
                                          hint: "Enter value",
                                          controller: controller
                                              .textControllers[index],
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      /// Delete
                                       if (!isDefaultField)
                                      InkWell(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        onTap: () =>
                                            controller.removeField(
                                                index),
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: cs.error
                                                .withOpacity(.08),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    14),
                                          ),
                                          child: Icon(
                                            Icons
                                                .delete_outline_rounded,
                                            color: cs.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 22),

                          Divider(
                            height: 1,
                            color: cs.outline.withOpacity(.12),
                          ),

                          const SizedBox(height: 20),

                          /// ── ACTIONS ────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: 
                                    controller.addField,
                                   
                                  icon:
                                      const Icon(Icons.add_rounded),
                                  label: const Text("Add Field"),
                                  style: FilledButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed:
                                      controller.saveSettings,
                                  icon:
                                      const Icon(Icons.save_rounded),
                                  label: const Text("Save"),
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: BorderSide(
                                      color: cs.outline
                                          .withOpacity(.35),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}