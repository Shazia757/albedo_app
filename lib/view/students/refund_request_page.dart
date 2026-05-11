import 'package:albedo_app/controller/request_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                    style: Theme.of(context).textTheme.titleLarge,
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200 ? 3 : 1;

                      return MasonryGridView.count(
                        padding: const EdgeInsets.all(12),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final r = requests[index];
                          return RefundRequestCard(data: r);
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
  final Map<String, dynamic> data;

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
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${data["refundCount"] ?? 0} refunds",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),

              /// 🔵 STUDENT (MAIN CARD)
              _MainUserCard(
                name: data["studentName"] ?? "-",
                id: data["studentId"] ?? "-",
                cs: cs,
              ),

              const SizedBox(height: 12),

              /// 🟣 MENTOR (SECONDARY CARD)
              _SubUserCard(
                name: data["mentorName"] ?? "-",
                id: data["mentorId"] ?? "-",
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  id,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  id,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
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
