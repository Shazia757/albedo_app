import 'package:albedo_app/controller/package_controller.dart';
import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrPackageSessionPage extends StatelessWidget {
  final Package package;

  TrPackageSessionPage({
    super.key,
    required this.package,
  });
  final c = Get.put(PackageController());

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDesktop = Responsive.isDesktop(context);

    if (c.sessions.isEmpty) {
      c.loadPackage(package);
    }
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isDesktop ? null : const DrawerMenu(),
      body: Row(
        children: [
          if (isDesktop) const DrawerMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name ?? "-",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),

                  // ── STATUS TABS ─────────────────────────────────────
                  Obx(
                    () => CustomWidgets().customTabs(
                      context,
                      tabs: c.tabs,
                      selectedIndex: c.selectedTab.value,
                      getCount: (index) {
                        final tab = c.statusMap[index];

                        return c.sessions.where((s) => s.status == tab).length;
                      },
                      onTap: (index) {
                        c.selectedTab.value = index;
                        c.applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── SESSION GRID ────────────────────────────────────
                  Expanded(child: Obx(() {
                    if (c.isMonthView.value) {
                      final sessions = c.monthSessions;

                      return Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => c.closeMonth(),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Month Sessions",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// 📦 Sessions List
                          Expanded(
                            child: ListView.builder(
                              itemCount: sessions.length,
                              itemBuilder: (_, i) {
                                final session = sessions[i];

                                return upcomingSessionCard(session, cs);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    final sessions = c.filteredSessions;
                    final status = c.statusMap[c.selectedTab.value];

                    if (c.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: cs.primary,
                          strokeWidth: 2.5,
                        ),
                      );
                    }

                    if (sessions.isEmpty) {
                      return EmptyState(
                        cs: cs,
                        icon: Icons.event_busy_outlined,
                        title: 'No sessions found',
                        subtitle: 'Try adjusting filters or add one',
                      );
                    }

                    /// ✅ COMPLETED TAB (SPECIAL UI)
                    if (status == 'completed') {
                      final grouped = groupByYearMonth(sessions);

                      if (grouped.isEmpty) {
                        return EmptyState(
                          cs: cs,
                          icon: Icons.event_busy_outlined,
                          title: 'No completed sessions',
                          subtitle: 'No valid session data found',
                        );
                      }

                      return ListView(
                        children: grouped.entries.map((yearEntry) {
                          final year = yearEntry.key;
                          final months = yearEntry.value;

                          int totalMinutes = months.values
                              .expand((e) => e)
                              .fold(0, (sum, s) => sum + (s.duration ?? 0));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "$year • ${(totalMinutes / 60).toStringAsFixed(1)} hrs",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...months.entries.map((monthEntry) {
                                final month = monthEntry.key;
                                final list = monthEntry.value;

                                int monthMinutes = list.fold(
                                    0, (sum, s) => sum + (s.duration ?? 0));

                                return InkWell(
                                  onTap: () {
                                    c.openMonth(list);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: cs.onPrimary,
                                      border: Border.all(
                                          color: cs.outline.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(getMonthName(month)),
                                        Text("${list.length} sessions"),
                                        Text(
                                            "${(monthMinutes / 60).toStringAsFixed(1)} hrs"),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      );
                    }

                    /// ✅ OTHER TABS (GRID)
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 700) {
                          crossAxisCount = 2;
                        }

                        return MasonryGridView.count(
                          padding: const EdgeInsets.only(bottom: 80),
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemCount: sessions.length,
                          itemBuilder: (_, i) {
                            final session = sessions[i];

                            if (status == 'completed') {
                              // handled above already
                              return const SizedBox();
                            } else {
                              return upcomingSessionCard(session, cs);
                            }
                          },
                        );
                      },
                    );
                  }))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getTimeLeft(DateTime date) {
    final sessionDateTime = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final diff = sessionDateTime.difference(DateTime.now());

    if (diff.isNegative) return "Started";

    final hours = diff.inHours;
    final mins = diff.inMinutes % 60;

    return "${hours}h ${mins}m left";
  }

  Widget upcomingSessionCard(Session session, ColorScheme cs) {
    final date = session.date ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW → DATE (left) + STATUS & DURATION (right)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT → Date & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(date),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${formatTime(date)} • ${getTimeLeft(date)}",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              /// RIGHT → Status + Duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (session.status ?? 'Upcoming').toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${session.duration ?? 0} mins",
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 DIVIDER
          Divider(color: cs.outline.withOpacity(0.3)),

          const SizedBox(height: 10),

          /// 🔹 MENTOR ROW
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: cs.primary.withOpacity(0.1),
                backgroundImage: session.mentor?.imageUrl != null
                    ? NetworkImage(session.mentor!.imageUrl!)
                    : null,
                child: session.mentor?.imageUrl == null
                    ? Text(
                        (session.mentor?.name ?? 'M')[0],
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  session.mentor?.name ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<int, Map<int, List<Session>>> groupByYearMonth(List<Session> sessions) {
    final Map<int, Map<int, List<Session>>> data = {};

    for (var s in sessions) {
      final date = s.date ?? DateTime.now();
      final year = date.year;
      final month = date.month;

      data.putIfAbsent(year, () => {});
      data[year]!.putIfAbsent(month, () => []);

      data[year]![month]!.add(s);
    }

    return data;
  }

  String formatTime(DateTime date) {
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return DateFormat('hh:mm a').format(dateTime);
  }
}
