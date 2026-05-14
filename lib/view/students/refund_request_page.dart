import 'package:albedo_app/controller/request_controller.dart';
import 'package:albedo_app/model/request_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class RefundRequestsPage extends StatelessWidget {
  RefundRequestsPage({super.key});

  final c = RequestController();

  /// 🔹 MOCK DATA (replace with API)
  final List<Map<String, dynamic>> requests = List.generate(10, (i) {
    return {
      "studentName": "Student $i",
      "studentId": "STU00$i",
      "studentImage": "https://i.pravatar.cc/150?img=${i + 1}",
      "mentorName": "Mentor $i",
      "mentorId": "MEN00$i",
      "mentorImage": "https://i.pravatar.cc/150?img=${i + 20}",
      "refundCount": (i % 3) + 1,
    };
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12),
                  child: Text(
                    'Refund Requests',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: CustomWidgets().premiumSearch(
                    context,
                    hint: "Search requests...",
                    onChanged: (v) => c.searchQuery.value = v,
                  ),
                ),

                /// 🔹 LIST
                Expanded(
                  child: Obx(
                    () {
                      final data = c.filteredStudents;
                      if (data.isEmpty) {
                        return EmptyState(
                          cs: Theme.of(context).colorScheme,
                          title: 'No requests found',
                          subtitle:
                              "Try searching with student or mentor details",
                          icon: Icons.search_off_rounded,
                        );
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              constraints.maxWidth > 1200 ? 3 : 1;

                          return MasonryGridView.count(
                            padding: const EdgeInsets.all(12),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final r = data[index];
                              return RefundRequestCard(data: r);
                            },
                          );
                        },
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

class RefundRequestCard extends StatelessWidget {
  final StudentRequest data;

  const RefundRequestCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        /// 🔹 MAIN WRAPPER
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              /// 🔵 STUDENT (MAIN CARD + STATUS)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _MainUserCard(
                      name: data.student.name ?? "-",
                      id: data.student.studentId ?? "-",
                      cs: cs,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${data.requests.length ?? 0} refunds",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: cs.primary),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              /// 🟣 MENTOR (SECONDARY CARD)
              _SubUserCard(
                name: data.student.mentor?.name ?? "-",
                id: data.student.mentor?.id ?? "-",
                cs: cs,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 🔵 MAIN (STUDENT CARD)
class _MainUserCard extends StatelessWidget {
  final String name;
  final String id;
  final ColorScheme cs;

  const _MainUserCard({
    required this.name,
    required this.id,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 2),
                Text(
                  id,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🟣 SECONDARY (MENTOR CARD)
class _SubUserCard extends StatelessWidget {
  final String name;
  final String id;
  final ColorScheme cs;

  const _SubUserCard({
    required this.name,
    required this.id,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cs.secondaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  id,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
