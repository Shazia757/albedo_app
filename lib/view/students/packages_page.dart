import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
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
            return _EmptyState(cs: cs);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Page title ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  "My Packages",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                ),
              ),

              const SizedBox(height: 14),

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
    final balance = (data["totalFee"] as double) - (data["takenFee"] as double);
    final progress =
        (data["takenFee"] as double) / (data["totalFee"] as double);

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: cs.outlineVariant.withOpacity(0.4), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status accent bar ──────────────────────────────────
          Container(height: 3, color: statusColor),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: teacher + status ───────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data["teacherImage"] ?? "",
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (data["teacherName"] as String)[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Teacher name + IDs
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["teacherName"],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${data["teacherId"]} · ${data["subjectId"]}",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: cs.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    _StatusBadge(label: data["status"], color: statusColor),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: cs.outlineVariant.withOpacity(0.4)),
                ),

                // ── Subject + tags ─────────────────────────────
                Text(
                  data["subjectName"],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    _Tag(label: data["standard"], cs: cs),
                    const SizedBox(width: 6),
                    _Tag(label: data["syllabus"], cs: cs),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Fee stats grid ─────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _FeeStat(
                        label: "Total Fee",
                        value: "₹${data["totalFee"].toStringAsFixed(0)}",
                        cs: cs,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _FeeStat(
                        label: "Paid",
                        value: "₹${data["takenFee"].toStringAsFixed(0)}",
                        valueColor: const Color(0xFF0F6E56),
                        cs: cs,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _FeeStat(
                        label: "Balance",
                        value: "₹${balance.toStringAsFixed(0)}",
                        valueColor: balance > 0
                            ? const Color(0xFF854F0B)
                            : cs.onSurface,
                        cs: cs,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Progress bar ───────────────────────────────

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: cs.outlineVariant.withOpacity(0.4)),
                ),

                // ── Schedule row ───────────────────────────────
                Row(
                  children: [
                    _ScheduleChip(
                      icon: Icons.access_time_outlined,
                      label: data["time"],
                      cs: cs,
                    ),
                    const SizedBox(width: 10),
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
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
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
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: cs.onSurface.withOpacity(0.55),
        ),
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
            style: TextStyle(
              fontSize: 10,
              color: cs.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? cs.onSurface,
            ),
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
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: cs.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyState({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_outlined,
                size: 36, color: cs.primary.withOpacity(0.6)),
          ),
          const SizedBox(height: 16),
          Text(
            "No packages found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your enrolled packages will appear here",
            style:
                TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
