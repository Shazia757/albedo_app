import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class RescheduleRequestsDetailedPage extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const RescheduleRequestsDetailedPage({
    super.key,
    required this.studentData,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final requests = (studentData["requests"] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cs.outline.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentData["name"] ?? "",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                studentData["id"] ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: cs.outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Requests",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  const SizedBox(height: 12),

                  /// REQUESTS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.onPrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cs.outline.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Requested on ${req["createdAt"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: cs.outline,
                                        ),
                                  ),
                                ),
                                _statusChip(
                                  context,
                                  req["status"] ?? "Pending",
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// CURRENT SESSION
                            _detailTile(
                              context,
                              "Current Session",
                              "${req["currentDate"]} • ${req["currentTime"]}",
                              Icons.schedule,
                            ),

                            const SizedBox(height: 12),

                            /// SUGGESTED SESSION
                            _detailTile(
                              context,
                              "Suggested Session",
                              "${req["suggestedDate"]} • ${req["suggestedTime"]}",
                              Icons.update,
                            ),

                            const SizedBox(height: 12),

                            /// PACKAGE
                            _detailTile(
                              context,
                              "Package",
                              "${req["subject"]} • ${req["standard"]} • ${req["syllabus"]}",
                              Icons.menu_book_rounded,
                            ),

                            const SizedBox(height: 12),

                            /// REASON
                            _detailTile(
                              context,
                              "Reason",
                              req["reason"] ?? "",
                              Icons.notes_rounded,
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: cs.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: cs.outline,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statusChip(
    BuildContext context,
    String status,
  ) {
    Color color = Colors.orange;

    switch (status) {
      case "Approved":
        color = Colors.green;
        break;

      case "Rejected":
        color = Colors.red;
        break;

      case "Rescheduled":
        color = Colors.blue;
        break;

      case "Pending":
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                ),
          ),
        ],
      ),
    );
  }
}
