import 'package:albedo_app/controller/assessment_controller.dart';
import 'package:albedo_app/model/settings/assessment_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAssessmentPage extends StatelessWidget {
  final Assessment? assessment;
  AddAssessmentPage({super.key, this.assessment});

  final c = Get.put(AssessmentController(), permanent: true);

  bool get isEdit => assessment != null;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    bool _initialized = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        c.initForEdit(assessment);
        _initialized = true;
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
                        isEdit ? 'Edit Assessment' : 'Add Assessment',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 10),
                      _assessmentSelector(c),
                      SizedBox(height: 12),

                      _attentionCard(c, context),
                      SizedBox(height: 12),

                      _testReportSection(context, c),

                      SizedBox(height: 12),
                      _voiceNotesCard(context),
                      SizedBox(height: 12),

                      CustomWidgets()
                          .labelWithAsterisk("Parent Opinion", required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Type your opinion',
                          controller: c.parentOpinionController,
                          isMultiline: true),
                      SizedBox(height: 10),

                      CustomWidgets().labelWithAsterisk("Assessment Summary",
                          required: true),
                      SizedBox(height: 10),
                      CustomWidgets().dropdownStyledTextField(
                          context: context,
                          hint: 'Type here',
                          controller: c.assessmentSummaryController,
                          isMultiline: true),
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
                                if (c.validate(context)) {
                                  isEdit
                                      ? c.updateAssessment()
                                      : c.addAssessment();
                                }
                              },
                              icon: const Icon(Icons.add,
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

  Widget _assessmentSelector(AssessmentController c) {
    final assessmentList = [
      "Academic",
      "basics",
      "maths",
      "online schooling",
      "pencil foundation",
      "song"
    ];

    final cs = Get.theme.colorScheme;

    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: assessmentList.map((item) {
              final isSelected = c.selectedAssessment.value == item;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  backgroundColor: cs.onPrimary,
                  checkmarkColor: cs.primary,
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (_) {
                    c.selectedAssessment.value = item;
                  },
                  selectedColor: cs.primary.withOpacity(0.15),
                  labelStyle: Get.textTheme.bodyMedium!.copyWith(
                      color: isSelected ? cs.primary : cs.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          isSelected ? cs.primary : cs.outline.withOpacity(0.5),
                      width: 0.8,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  Widget _attentionCard(AssessmentController c, BuildContext context) {
    final questions = [
      "Focus",
      "Listening",
      "Participation",
    ];

    // ensure controllers exist
    c.initAttentionQuestions(questions);

    return _card(
      title: "Attention in Online Classes",
      child: Column(
        children: questions.map((q) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(q)),
                  _starRating(
                    // initial: c.attentionRatings[q] ?? 0,
                    onChanged: (val) => c.attentionRatings[q] = val,
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 125,
                    child: CustomWidgets().dropdownStyledTextField(
                      context: context,
                      hint: 'Mark',
                      controller: c.attentionMarkControllers[q],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _testReportSection(BuildContext context, AssessmentController c) {
    return Obx(() {
      final type = c.selectedAssessment.value;

      return Column(
        children: [
          Text('TEST REPORTS'),
          SizedBox(height: 5),
          if (type.toLowerCase().contains("academic"))
            _academicCard(context, c),
          if (type.toLowerCase().contains("basics")) _languageCard(context, c),
          if (type.toLowerCase().contains("maths")) _mathCard(context, c),
          if (type.trim().toLowerCase().contains("online schooling")) ...[
            _languageCard(context, c),
            SizedBox(height: 10),
            _mathCard(context, c),
            SizedBox(height: 10),
            _subjectsCard(context, c),
            SizedBox(height: 10),
            _keyPointsCard(context),
            SizedBox(height: 10),
            _academicCard(context, c),
          ],
          if (type.toLowerCase().contains("pencil foundation")) ...[
            _languageCard(context, c),
            SizedBox(height: 10),
            _mathCard(context, c),
          ],
          if (type.toLowerCase().contains("song")) _subjectsCard(context, c),
        ],
      );
    });
  }

  Widget _academicCard(BuildContext context, AssessmentController c) {
    return _card(
      title: "Academics",
      child: Obx(() => Column(
            children: [
              ...c.academicSubjects.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔷 Header row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subject ${index + 1}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),

                          /// ❌ Remove (from 2nd)
                          if (index >= 1)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () =>
                                  c.academicSubjects.removeAt(index),
                            )
                        ],
                      ),

                      SizedBox(height: 8),

                      /// 🔷 Subject field
                      CustomWidgets().labelWithAsterisk('Subject'),
                      SizedBox(height: 6),
                      CustomWidgets().dropdownStyledTextField(
                        context: context,
                        hint: 'Enter subject...',
                        onTap: () {},
                      ),

                      SizedBox(height: 10),

                      /// ⭐ Ratings
                      Column(
                        children: [
                          Text(
                            'Current Grade',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          _ratingRow((v) {
                            item.current = v;
                          }),
                          SizedBox(height: 5)
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Expected Grade",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          _ratingRow((v) {
                            item.expected = v;
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              /// ➕ Add button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    c.academicSubjects.add(
                      AcademicData(
                        name: "",
                        current: 0,
                        expected: 0,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: Text(
                    "Add Academic Subject",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _languageCard(BuildContext context, AssessmentController c) {
    return _card(
      title: "Language",
      child: Obx(() {
        return Column(
          children: [
            /// 🔷 Subtitle only when empty
            if (!c.isAddingLanguage.value && c.languages.isEmpty)
              Text(
                "Add languages to assess student's language skills",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
              ),

            /// 🔷 Input Mode
            if (c.isAddingLanguage.value) ...[
              CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Enter language name',
                controller: c.languageController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        c.isAddingLanguage.value = false;
                        c.languageController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (c.languageController.text.trim().isEmpty) return;

                        c.languages.add(
                          LanguageData(
                            name: c.languageController.text.trim(),
                          ),
                        );

                        c.languageController.clear();
                        c.isAddingLanguage.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Add",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 12),

            /// 🔷 Language Cards
            ...c.languages.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => c.languages.removeAt(index),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    /// Checkboxes
                    Wrap(
                      spacing: 10,
                      children: [
                        _checkBox(
                          label: "Reading",
                          value: item.reading ?? false,
                          onChanged: (v) {
                            item.reading = v;
                            c.languages.refresh();
                          },
                        ),
                        _checkBox(
                          label: "Writing",
                          value: item.writing ?? false,
                          onChanged: (v) {
                            item.writing = v;
                            c.languages.refresh();
                          },
                        ),
                        _checkBox(
                          label: "Creativity",
                          value: item.creativity ?? false,
                          onChanged: (v) {
                            item.creativity = v;
                            c.languages.refresh();
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    /// Mark
                    Row(
                      children: [
                        Text("Mark:"),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: CustomWidgets().dropdownStyledTextField(
                            context: context,
                            hint: '0',
                            controller: c.languageMarkController,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    /// Rating
                    _starRating(
                      initial: item.rating ?? 0,
                      onChanged: (v) {
                        item.rating = v;
                        c.languages.refresh();
                      },
                    ),
                  ],
                ),
              );
            }),

            /// 🔷 Divider + Add Button AT LAST
            SizedBox(height: 10),
            if (!c.isAddingLanguage.value)
              Column(
                children: [
                  Divider(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        c.isAddingLanguage.value = true;
                      },
                      icon:
                          const Icon(Icons.add, size: 15, color: Colors.white),
                      label: Text(
                        'Add Language',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }

  /// helper checkbox widget
  Widget _checkBox({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
        ),
        Text(label),
      ],
    );
  }

  Widget _mathCard(BuildContext context, AssessmentController c) {
    final topics = [
      "Numbers",
      "Addition",
      "Subtraction",
      "Multiplication",
      "Division",
      "Combined Calculation"
    ];

    return _card(
      title: "Maths",
      child: Obx(() => Column(
            children: [
              /// 🔷 DEFAULT TOPICS (static)
              ...topics.map((t) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        t,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 8),
                      _starRating(onChanged: (v) {}),
                    ],
                  ),
                );
              }),

              /// 🔷 ADDED TOPICS (dynamic)
              ...c.mathTopics.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Stack(
                    children: [
                      /// Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              item.name ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(height: 8),
                          _starRating(onChanged: (v) {
                            item.rating = v;
                          }),
                        ],
                      ),

                      /// ❌ Delete button (top-right)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            c.mathTopics.removeAt(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 10),

              /// 🔷 ADD MODE
              if (c.isAddingMath.value) ...[
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter math topic ',
                  controller: c.mathController,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          c.isAddingMath.value = false;
                          c.mathController.clear();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (c.mathController.text.trim().isEmpty) return;

                          c.mathTopics.add(Item(
                            name: c.mathController.text.trim(),
                            rating: 0,
                          ));

                          c.mathController.clear();
                          c.isAddingMath.value = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Add",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ]

              /// 🔷 DEFAULT BUTTON
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      c.isAddingMath.value = true;
                    },
                    icon: const Icon(Icons.add, size: 15, color: Colors.white),
                    label: Text(
                      'Add Math Topic',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          )),
    );
  }

  Widget _subjectsCard(BuildContext context, AssessmentController c) {
    final defaultSubjects = [
      "Science",
      "Social Studies",
      "Computer Science",
      "General Knowledge",
      "Environmental Studies",
      "Art & Craft"
    ];

    return _card(
      title: "Subjects",
      child: Obx(() {
        return Column(
          children: [
            /// 🔷 DEFAULT SUBJECTS
            ...defaultSubjects.map((t) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      t,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 8),
                    _starRating(onChanged: (v) {}),
                  ],
                ),
              );
            }),

            /// 🔷 CUSTOM ADDED SUBJECTS
            ...c.subjects.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            item.name ?? "",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(height: 8),
                        _starRating(onChanged: (v) {
                          item.rating = v;
                          c.subjects.refresh();
                        }),
                      ],
                    ),

                    /// ❌ Delete
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          c.subjects.removeAt(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 10),

            /// 🔷 ADD MODE
            if (c.isAddingSubject.value) ...[
              CustomWidgets().dropdownStyledTextField(
                context: context,
                hint: 'Enter subject',
                controller: c.subjectController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        c.isAddingSubject.value = false;
                        c.subjectController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (c.subjectController.text.trim().isEmpty) return;

                        c.subjects.add(Item(
                            name: c.subjectController.text.trim(), rating: 0));

                        c.subjectController.clear();
                        c.isAddingSubject.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Add",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ]

            /// 🔷 ADD BUTTON
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    c.isAddingSubject.value = true;
                  },
                  icon: const Icon(Icons.add, size: 15, color: Colors.white),
                  label: Text(
                    'Add Subject',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _keyPointsCard(BuildContext context) {
    final points = [
      "Problem Solving",
      "Critical Thinking",
      "Creativity",
      "Communication",
      "Teamwork",
      "Time Management"
    ];

    return _card(
        title: "Key Points",
        child: Obx(() => Column(children: [
              ...points.map((t) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        t,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 8),
                      _starRating(
                        onChanged: (p0) {},
                      )
                    ],
                  ),
                );
              }),
              ...c.keypoints.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Stack(
                    children: [
                      /// Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              item.name ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(height: 8),
                          _starRating(onChanged: (v) {
                            item.rating = v;
                          }),
                        ],
                      ),

                      /// ❌ Delete button (top-right)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            c.keypoints.removeAt(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 10),

              /// 🔷 ADD MODE
              if (c.isAddingKeypoints.value) ...[
                CustomWidgets().dropdownStyledTextField(
                  context: context,
                  hint: 'Enter key point ',
                  controller: c.keypointController,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          c.isAddingKeypoints.value = false;
                          c.keypointController.clear();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (c.keypointController.text.trim().isEmpty) return;

                          c.keypoints.add(Item(
                            name: c.keypointController.text.trim(),
                            rating: 0,
                          ));

                          c.keypointController.clear();
                          c.isAddingKeypoints.value = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Add",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      c.isAddingKeypoints.value = true;
                    },
                    icon: const Icon(Icons.add, size: 15, color: Colors.white),
                    label: Text(
                      'Add Key Point',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ])));
  }

  Widget _voiceNotesCard(BuildContext context) {
    return _card(
      title: "Voice Notes",
      subtitle: 'Click "Start Recording" to add voice notes to your assessment',
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 18, color: Colors.white),
        label: Text(
          "Start Recording",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _card(
      {required String title, String? subtitle, required Widget child}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(title.toUpperCase(), style: Get.textTheme.titleSmall),
            SizedBox(height: 10),
            if (subtitle != null) ...[
              Text(subtitle, style: Get.textTheme.bodySmall),
              SizedBox(height: 20),
            ],
            child
          ],
        ),
      ),
    );
  }

  Widget _starRating({int initial = 0, required Function(int) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < initial ? Icons.star : Icons.star_border,
            size: 18,
            color: Colors.orange,
          ),
          onPressed: () => onChanged(i + 1),
        );
      }),
    );
  }

  Widget _ratingRow(Function(int) onChanged) {
    return _starRating(onChanged: onChanged);
  }
}
