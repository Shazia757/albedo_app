import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StudentPackagesPage extends StatelessWidget {
  const StudentPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final packages = [
      {
        "teacherName": "John Doe",
        "teacherId": "TCH-1021",
        "status": "Active",
        "subjectId": "SUB-01",
        "subjectName": "Mathematics",
        "standard": "10th Grade",
        "syllabus": "CBSE",
        "totalFee": 5000.0,
        "takenFee": 3000.0,
        "time": "6:00 PM",
        "duration": "1.5 hrs",
      },
      {
        "teacherName": "Sarah Khan",
        "teacherId": "TCH-2045",
        "teacherImage": "https://i.pravatar.cc/150?img=32",
        "status": "Paused",
        "subjectId": "SUB-02",
        "subjectName": "Physics",
        "standard": "12th Grade",
        "syllabus": "State Board",
        "totalFee": 8000.0,
        "takenFee": 2000.0,
        "time": "4:30 PM",
        "duration": "2 hrs",
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(),
      drawer: const DrawerMenu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (packages.isEmpty) {
            return EmptyState(
              cs: cs,
              icon: Icons.person_off,
              title: 'Package not found',
              subtitle: '',
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Page title ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "My Packages",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: cs.primary),
                  ),
                ),

                SizedBox(height: 14),

                // ── Grid ────────────────────────────────────────────
                Expanded(
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    crossAxisCount: constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 600
                            ? 2
                            : 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: packages.length,
                    itemBuilder: (context, index) =>
                        _PackageCard(data: packages[index], cs: cs),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// PACKAGE CARD
// ═══════════════════════════════════════════════════════════════════════
class _PackageCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final ColorScheme cs;

  const _PackageCard({required this.data, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isActive = data["status"] == "Active";
    final statusColor =
        isActive ? const Color(0xFF1D9E75) : const Color(0xFFBA7517);

    final total = (data["totalFee"] as double);
    final paid = (data["takenFee"] as double);
    final balance = total - paid;
    final progress = paid / total;

    return Container(
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ── header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        data["teacherImage"] ?? "https://i.pravatar.cc/150",
                      ),
                      backgroundColor: cs.surfaceContainerHighest,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["teacherName"],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: cs.onSurface),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "${data["teacherId"]} • ${data["subjectId"]}",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: cs.onSurface.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(
                      label: data["status"],
                      color: statusColor,
                    ),
                  ],
                ),

                SizedBox(height: 12),

                /// subject
                Text(
                  data["subjectName"],
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(letterSpacing: -0.2, color: cs.onSurface),
                ),

                SizedBox(height: 8),

                /// tags (same style as your system chips)
                Row(
                  children: [
                    _Tag(label: data["standard"], cs: cs),
                    SizedBox(width: 6),
                    _Tag(label: data["syllabus"], cs: cs),
                  ],
                ),

                SizedBox(height: 14),

                /// fee row (cleaner layout)
                Row(
                  children: [
                    Expanded(
                      child: _FeeStat(
                        label: "Total",
                        value: "₹${total.toStringAsFixed(0)}",
                        cs: cs,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _FeeStat(
                        label: "Paid",
                        value: "₹${paid.toStringAsFixed(0)}",
                        valueColor: const Color(0xFF0F6E56),
                        cs: cs,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _FeeStat(
                        label: "Balance",
                        value: "₹${balance.toStringAsFixed(0)}",
                        valueColor: balance > 0
                            ? const Color(0xFFB26A00)
                            : cs.onSurface,
                        cs: cs,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                /// progress (soft style like modern dashboards)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor:
                        cs.surfaceContainerHighest.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation(statusColor),
                  ),
                ),

                SizedBox(height: 14),

                /// schedule row
                Row(
                  children: [
                    _ScheduleChip(
                      icon: Icons.access_time_outlined,
                      label: data["time"],
                      cs: cs,
                    ),
                    SizedBox(width: 12),
                    _ScheduleChip(
                      icon: Icons.timer_outlined,
                      label: data["duration"],
                      cs: cs,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 5),
          Text(
            label,
            style:
                Theme.of(context).textTheme.labelSmall!.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

// ── Subject tag ───────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label;
  final ColorScheme cs;

  const _Tag({required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: cs.onSurface.withOpacity(0.55)),
      ),
    );
  }
}

// ── Fee stat cell ─────────────────────────────────────────────────────
class _FeeStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final ColorScheme cs;

  const _FeeStat({
    required this.label,
    required this.value,
    this.valueColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: cs.outlineVariant.withOpacity(0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: cs.onSurface.withOpacity(0.45)),
          ),
          SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: valueColor ?? cs.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Schedule chip ─────────────────────────────────────────────────────
class _ScheduleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;

  const _ScheduleChip({
    required this.icon,
    required this.label,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: cs.onSurface.withOpacity(0.4)),
        SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: cs.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }
}
