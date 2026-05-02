import 'package:albedo_app/model/session_model.dart';
import 'package:albedo_app/model/settings/recommendations_model.dart';
import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/controller/home_controller.dart';
import 'package:albedo_app/model/settings/hiring_ad_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

final c = HomeController();

Widget donutChart(BuildContext context) {
  return SizedBox(
    height: 200,
    child: Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            centerSpaceRadius: 65,
            sectionsSpace: 3,
            sections: c.packageData.map((item) {
              return PieChartSectionData(
                value: item['value'],
                color: item['color'],
                showTitle: false,
                radius: 18,
              );
            }).toList(),
          ),
        ),

        // CENTER TEXT
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total Package",
              style: context.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatCurrency(c.totalPackage.value),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget packageList(BuildContext context) {
  return Column(
    children: c.packageData.map((item) {
      final percent = item['value'] / c.totalPackage.value;
      final isSmall = MediaQuery.of(context).size.width < 380;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // ICON CIRCLE
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'],
                color: item['color'],
                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT + PROGRESS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE + VALUE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name'],
                        style: context.textTheme.bodyMedium,
                      ),
                      Text(formatCurrency(item['value']),
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),

                  SizedBox(height: isSmall ? 6 : 12),

                  // PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          height: 12,
                          color: Colors.grey.shade300,
                        ),

                        // Gradient Progress
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              height: 12,
                              width: constraints.maxWidth * percent,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    item['color']
                                        .withOpacity(0.3), // light shade
                                    item['color'], // full color
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }).toList(),
  );
}

String formatCurrency(double value) {
  if (value >= 1000000) {
    return "₹${(value / 1000000).toStringAsFixed(1)}M";
  } else if (value >= 1000) {
    return "₹${(value / 1000).toStringAsFixed(1)}K";
  }
  return "₹${value.toStringAsFixed(0)}";
}

Widget expenseChartCard(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final screenHeight = MediaQuery.of(context).size.height;

  return Obx(() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER (same style as other charts)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${c.expenseRatio.value.toStringAsFixed(2)}%",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Expense Ratio",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),

              // RIGHT SIDE (FILTER)
              Obx(() => PopupMenuButton(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 45),
                    color: context.theme.cardColor,
                    elevation: 0,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: rangeMenu(
                          context,
                          selectedValue: c.expenseRange.value,
                          onSelected: (value) {
                            c.expenseRange.value = value;
                            c.updateExpenseData(value);
                          },
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(c.expenseRange.value,
                              style: context.textTheme.labelLarge),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 2),

          Text(
            "${c.totalExpense.value.toStringAsFixed(0)} / ${c.totalIncome.value.toStringAsFixed(0)}",
            style: context.textTheme.labelSmall?.copyWith(
              color: context.theme.colorScheme.outline,
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 LEGEND (compact like chart style)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                legendDot(context, cs.primary, "Total Hours"),
                const SizedBox(width: 12),
                legendDot(context, cs.secondary, "Class Taken Amount"),
                const SizedBox(width: 12),
                legendDot(context, cs.tertiary, "Total Salary"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 CHART (same style)
          SizedBox(
            height: screenHeight * 0.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: LineChart(
                LineChartData(
                  clipData: FlClipData.all(),
                  minX: 0,
                  maxX: (c.expenseLabels.length - 1).toDouble(),
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5000000,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: (context.theme.colorScheme.outline ?? Colors.grey)
                          .withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= c.expenseLabels.length) {
                            return const SizedBox();
                          }

                          return Text(
                            c.expenseLabels[index],
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.theme.colorScheme.outline,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            formatCompact(value),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.theme.colorScheme.outline,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                              formatCompact(spot.y),
                              TextStyle(
                                color: context.theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ));
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    line(c.totalHours, cs.primary),
                    line(c.classAmount, cs.secondary),
                    line(c.totalSalary, cs.tertiary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget studentsAnalyticsCard(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final auth = Get.find<AuthController>();
  final role = auth.activeUser?.role;
  final isAdvisor = role == "advisor";
  final isSales = role == 'sales';

  return Obx(() {
    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${c.studentCount.value}",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Students",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),

              /// RIGHT (FILTER)
              Obx(() => PopupMenuButton(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 45),
                    color: context.theme.cardColor,
                    elevation: 0,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: rangeMenu(
                          context,
                          selectedValue: c.studentRange.value,
                          onSelected: (value) {
                            c.studentRange.value = value;
                            c.loadDummyStudentAnalytics();
                          },
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(c.studentRange.value,
                              style: context.textTheme.labelLarge),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20),
                        ],
                      ),
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 4),

          /// 🔹 LEGEND
          Row(
            children: [
              legendDot(
                context,
                cs.primary,
                (isAdvisor || isSales)
                    ? "Total Package Amount"
                    : "Total Salary",
              ),
              const SizedBox(width: 10),
              legendDot(context, cs.secondary,
                  (isAdvisor || isSales) ? "Total Spot Amount" : "Pending"),
              const SizedBox(width: 10),
              if (!isAdvisor || !isSales) ...[
                legendDot(context, cs.tertiary, "Received"),
                const SizedBox(width: 10),
                legendDot(context, Colors.green, "Hours"),
              ],
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 CHART
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (c.years.length - 1).toDouble(),
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.theme.colorScheme.outline.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          c.years[value.toInt()],
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.theme.colorScheme.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          formatCompact(value),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.theme.colorScheme.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: isAdvisor
                    ? [
                        line(c.totalPackageData, cs.primary),
                        line(c.totalSpotData, cs.secondary),
                      ]
                    : [
                        line(c.totalSalary, cs.primary),
                        line(c.pendingSalaryData, cs.secondary),
                        line(c.receivedSalaryData, cs.tertiary),
                        line(c.totalHoursData, Colors.green),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget packagesAnalyticsCard(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  return Obx(() {
    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${c.totalPackages.value}",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Packages",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: cs.outline,
                    ),
                  ),
                ],
              ),

              /// RIGHT (FILTER)
              Obx(() => PopupMenuButton(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 45),
                    color: context.theme.cardColor,
                    elevation: 0,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: rangeMenu(
                          context,
                          selectedValue: c.packageRange.value,
                          onSelected: (value) {
                            c.packageRange.value = value;

                            /// 🔹 Load data based on range
                            c.loadDummyPackageAnalytics();
                          },
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            c.packageRange.value,
                            style: context.textTheme.labelLarge,
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),

          const SizedBox(height: 8),

          /// 🔹 LEGEND
          Row(
            children: [
              legendDot(context, cs.primary, "Total Fee"),
              const SizedBox(width: 10),
              legendDot(context, cs.secondary, "Pending Fee"),
              const SizedBox(width: 10),
              legendDot(context, cs.tertiary, "Total Classes"),
              const SizedBox(width: 10),
              legendDot(context, Colors.green, "Hours"),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 CHART
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (c.years.length - 1).toDouble(),
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: cs.outline.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          c.years[value.toInt()],
                          style: context.textTheme.labelSmall?.copyWith(
                            color: cs.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          formatCompact(value),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: cs.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  line(c.totalFeeData, cs.primary),
                  line(c.pendingFeeData, cs.secondary),
                  line(c.totalClassesData, cs.tertiary),
                  line(c.totalHoursData, Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget hiringSection(BuildContext context) {
  return Obx(() {
    if (c.hiringAds.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE (NOW INSIDE)
          Text(
            "Hiring Opportunities",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 CAROUSEL
          hiringCarousel(context, c.hiringAds),
        ],
      ),
    );
  });
}

Widget hiringCarousel(BuildContext context, List<HiringView> data) {
  return SizedBox(
    height: 320,
    child: PageView.builder(
      controller: PageController(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return hiringCard(context, data[index]);
      },
    ),
  );
}

Widget hiringCard(BuildContext context, HiringView item) {
  final cs = Theme.of(context).colorScheme;
  final ad = item.ad;
  final teacher = item.teacher;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    decoration: cardDecoration(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 IMAGE
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: ad.image != null
              ? Image.network(
                  ad.image!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 120,
                  color: cs.primary.withOpacity(0.1),
                  child: Center(
                    child: Icon(Icons.image, color: cs.primary),
                  ),
                ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 SUBJECT / PACKAGE
              Text(
                ad.package,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              /// 🔹 TEACHER
              Text(
                "By ${teacher.name}",
                style: context.textTheme.labelMedium?.copyWith(
                  color: cs.outline,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔹 DATE + TIME
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: cs.outline),
                  const SizedBox(width: 4),
                  Text(
                    "${ad.startDate ?? "-"} → ${ad.endDate ?? "-"}",
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: cs.outline),
                  const SizedBox(width: 4),
                  Text(
                    ad.time ?? "-",
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// 🔹 DAYS
              if (ad.days != null && ad.days!.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children:
                      ad.days!.map((d) => dayChip(context, d.name)).toList(),
                ),

              const SizedBox(height: 10),

              /// 🔹 ACTIONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                      ),
                      onPressed: () {
                        // TODO: Interested
                      },
                      child: const Text(
                        "Interested",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Not Interested
                      },
                      child: const Text("Not Interested"),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget recommendationSection(BuildContext context) {
  final auth = Get.find<AuthController>();

  return Obx(() {
    final isStudent = auth.activeUser?.role == "student";
    if (!isStudent) return const SizedBox();

    if (c.recommendations.isEmpty) {
      final cs = Theme.of(context).colorScheme;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration(context),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.recommend_outlined,
                  size: 32,
                  color: cs.outline,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "No Recommendations",
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Check back soon for new opportunities!",
                style: context.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE
          Text(
            "Recommended for You",
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 CAROUSEL
          recommendationCarousel(context, c.recommendations),
        ],
      ),
    );
  });
}

Widget recommendationCarousel(
    BuildContext context, List<RecommendationView> data) {
  return SizedBox(
    height: 280,
    child: PageView.builder(
      controller: PageController(viewportFraction: 0.85),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return recommendationCard(context, data[index]);
      },
    ),
  );
}

Widget recommendationCard(BuildContext context, RecommendationView item) {
  final cs = Theme.of(context).colorScheme;
  final ad = item.recommendation;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    decoration: cardDecoration(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 IMAGE (same style)
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: ad.image != null
              ? Image.network(
                  ad.image!,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 140,
                  color: cs.primary.withOpacity(0.1),
                  child: Center(
                    child: Icon(Icons.image, color: cs.primary),
                  ),
                ),
        ),

        /// 🔹 CONTENT
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PACKAGE NAME ONLY
              Text(
                ad.package ?? '',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 ACTIONS ONLY
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                      ),
                      onPressed: () {
                        // Interested
                      },
                      child: const Text(
                        "Interested",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Not Interested
                      },
                      child: const Text("Not Interested"),
                    ),
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

Widget dayChip(BuildContext context, String day) {
  final cs = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: cs.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      day,
      style: context.textTheme.labelSmall?.copyWith(
        color: cs.primary,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget nextSessionCard(BuildContext context) {
  final auth = Get.find<AuthController>();
  final role = auth.activeUser?.role;
  final isTeacher = role == "teacher";

  return Obx(() {
    final session = c.nextSession;
    print("Sessions count: ${c.session.length}");
    print("Next session: ${c.nextSession}");
    if (session == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Next Session",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.event_busy,
                    color: context.theme.colorScheme.outline),
                const SizedBox(width: 10),
                Text(
                  "No upcoming sessions",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    final isStarted = session.status == "started";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Next Session"),

          const SizedBox(height: 12),
          sessionMainCard(context, session, isTeacher),

          const SizedBox(height: 12),

          /// 🔹 DETAILS
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              infoCard(context, "Subject", session.package.subjectName ?? "-"),
              infoCard(context, "Syllabus", session.syllabus ?? "-"),
              infoCard(context, "Standard", session.className ?? "-"),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 ACTIONS
          if (isStarted)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_rounded,
                        size: 16, color: Colors.white),
                    label: const Text(
                      "Join",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                    icon:
                        const Icon(Icons.share, size: 16, color: Colors.white),
                    label: const Text(
                      "Share",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  });
}

Widget sessionMainCard(
  BuildContext context,
  Session session,
  bool isTeacher,
) {
  final cs = Theme.of(context).colorScheme;
  final isStarted = session.status == "started";

  /// Role text
  final roleText = isTeacher ? "Student" : "Teacher";

  return Container(
    padding: const EdgeInsets.all(14),
    decoration: cardDecoration(context),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 LEFT SIDE → Avatar + Info
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: cs.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: cs.primary),
              ),

              const SizedBox(width: 12),

              /// Text Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 ROLE (NEW)
                  Text(
                    roleText,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  /// Name
                  Text(
                    isTeacher
                        ? session.student?.name ?? "-"
                        : session.teacher?.name ?? "-",
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// ID
                  Text(
                    isTeacher
                        ? "ID: ${session.student?.studentId ?? "-"}"
                        : "ID: ${session.teacher?.id ?? "-"}",
                    style: context.textTheme.labelSmall?.copyWith(
                      color: cs.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// 🔹 RIGHT SIDE → Status + Date + Time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(0.5), // 🔥 subtle inner card feel
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isStarted
                      ? Colors.green.withOpacity(0.12)
                      : cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isStarted ? "Started" : startsInText(session),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isStarted ? Colors.green : cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// Date
              Text(
                formatDate(session.date),
                style: context.textTheme.labelSmall?.copyWith(
                  color: cs.outline,
                ),
              ),

              const SizedBox(height: 2),

              /// Time
              Text(
                formatTime(session.time),
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String startsInText(Session session) {
  if (session.date == null) return "";

  final diff = session.date!.difference(DateTime.now());

  if (diff.inMinutes < 60) {
    return "Starts in ${diff.inMinutes} min";
  } else if (diff.inHours < 24) {
    return "Starts in ${diff.inHours} hrs";
  } else {
    return "Starts in ${diff.inDays} days";
  }
}

String formatDate(DateTime? date) {
  if (date == null) return "-";
  return "${date.day}/${date.month}/${date.year}";
}

String formatTime(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('hh:mm a').format(dt);
}

Widget infoCard(
  BuildContext context,
  String label,
  String value,
) {
  final cs = Theme.of(context).colorScheme;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: cardDecoration(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: cs.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

LineChartBarData line(List<double> data, Color color) {
  return LineChartBarData(
    isCurved: true,
    preventCurveOverShooting: true,
    curveSmoothness: 0.4,
    spots: data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList(),
    barWidth: 2.4,
    color: color,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [
          color.withOpacity(0.25),
          color.withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}

Widget legendDot(BuildContext context, Color color, String text) {
  return Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.theme.colorScheme.outline,
        ),
      ),
    ],
  );
}

String formatCompact(double value) {
  if (value >= 1000000) {
    return "${(value / 1000000).toStringAsFixed(0)}M";
  }
  if (value >= 1000) {
    return "${(value / 1000).toStringAsFixed(0)}K";
  }
  return value.toStringAsFixed(0);
}

Widget rangeMenu(
  BuildContext context, {
  required String selectedValue,
  required Function(String) onSelected,
}) {
  final ranges = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
    "All",
  ];

  return Container(
    width: 220,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: ranges
          .map((e) => rangeItem(
                context,
                e,
                selectedValue: selectedValue,
                onSelected: onSelected,
              ))
          .toList(),
    ),
  );
}

Widget rangeItem(
  BuildContext context,
  String text, {
  required String selectedValue,
  required Function(String) onSelected,
}) {
  final isSelected = selectedValue == text;

  return InkWell(
    onTap: () {
      onSelected(text);
      Navigator.pop(context);
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ),
  );
}

// ================= CHART =================

Widget chartCard(
  BuildContext context, {
  required String title,
  required String count,
  IconData? icon,
  required List<double> data,
  required Color color,
  Color? iconColor,
  required TimeFilter selectedFilter,
  required Function(TimeFilter) onFilterChanged,
  required RxString selectedRange,
  required Function(String) onRangeChanged,
}) {
  // ✅ Dynamic X-axis labels
  List<String> getXAxisLabels(String range) {
    switch (range) {
      case "This Year":
        return [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ];
      case "This Month":
        return ["W1", "W2", "W3", "W4"];
      case "This Week":
        return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      default: // "All"
        return c.years; // your existing list
    }
  }

  final labels = getXAxisLabels(selectedRange.value);

  double maxY = data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b);
  double interval = maxY / 5;

  return Container(
    height: 220,
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
    decoration: cardDecoration(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: iconColor),
                  const SizedBox(width: 8),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(() => PopupMenuButton(
                  padding: EdgeInsets.zero,
                  offset: const Offset(0, 45),
                  color: context.theme.cardColor,
                  elevation: 0,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      padding: EdgeInsets.zero,
                      child: rangeMenu(
                        context,
                        selectedValue: selectedRange.value,
                        onSelected: (value) {
                          onRangeChanged(value);
                        },
                      ),
                    ),
                  ],
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(selectedRange.value,
                            style: context.textTheme.labelLarge),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20)
                      ],
                    ),
                  ),
                ))
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (labels.length - 1).toDouble(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: interval == 0 ? 1 : interval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: context.theme.colorScheme.outline.withOpacity(0.4),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval == 0 ? 1 : interval,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.theme.colorScheme.outline,
                        ),
                      );
                    },
                  ),
                ),

                // ✅ FIXED: dynamic bottom labels
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();

                      if (index < 0 || index >= labels.length) {
                        return const SizedBox();
                      }

                      return Text(
                        labels[index],
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.theme.colorScheme.outline,
                        ),
                      );
                    },
                  ),
                ),

                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (spots) {
                    return spots.map((spot) {
                      return LineTooltipItem(
                          "${spot.y}",
                          TextStyle(
                            color: context.theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ));
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  curveSmoothness: 0.4,

                  // ✅ Ensure data matches labels length
                  spots: data
                      .asMap()
                      .entries
                      .where((e) => e.key < labels.length)
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),

                  barWidth: 2.4,
                  color: color,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.25),
                        color.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget youtubeCard(BuildContext context) {
  final videoUrl = "https://www.youtube.com/watch?v=bIu_QEapyJk";
  final thumbnail = "https://img.youtube.com/vi/bIu_QEapyJk/0.jpg";

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: cardDecoration(context),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: GestureDetector(
        onTap: () {
          openVideo(videoUrl);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🔹 Thumbnail / fallback
            Image.network(
              thumbnail,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                );
              },
            ),

            // 🔹 Play button overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(14),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget summaryCard(BuildContext context) {
  return Obx(() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Summary",
                style: context.textTheme.titleMedium,
              ),

              // 🔹 RANGE SELECTOR
              Obx(() => PopupMenuButton(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 45),
                    elevation: 0,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: rangeMenu(
                          context,
                          selectedValue: c.summaryRange.value,
                          onSelected: (value) {
                            c.summaryRange.value = value;
                            c.updateSummaryData(value);
                          },
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Text(c.summaryRange.value,
                              style: context.textTheme.labelLarge),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20)
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 14),
          donutChart(context),
          const SizedBox(height: 14),
          packageList(context),
        ],
      ),
    );
  });
}

// ================= COMMON =================

BoxDecoration cardDecoration(BuildContext context) {
  final cs = context.theme.colorScheme;

  return BoxDecoration(
    color: cs.surface,
    borderRadius: BorderRadius.circular(14), // 🔥 reduced
    border: Border.all(
      color: cs.outline.withOpacity(0.12),
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 16,
        spreadRadius: -6,
        offset: const Offset(0, 6),
        color: Colors.black.withOpacity(Get.isDarkMode ? 0.35 : 0.06),
      ),
    ],
  );
}

Future<void> openVideo(String url) async {
  if (kIsWeb) {
    html.window.open(url, "blank");
    return;
  }

  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch $url");
  }
}
