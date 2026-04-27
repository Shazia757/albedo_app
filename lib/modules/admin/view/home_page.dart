import 'package:albedo_app/controller/auth_controller.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/home_controller.dart';
import '../../../../widgets/drawer_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) DrawerMenu(),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    _expenseChartCard(context),
                    const SizedBox(height: 14),
                    _chartCard(
                      context,
                      title: "Students Count",
                      count: c.studentCount.value.toString(),
                      data: c.studentData,
                      color: Theme.of(context).colorScheme.primary,
                      selectedFilter: TimeFilter.all,
                      onFilterChanged: (_) {},
                      selectedRange: c.studentRange,
                      onRangeChanged: (value) {
                        c.studentRange.value = value;
                        c.updateStudentData(range: value);
                      },
                    ),
                    const SizedBox(height: 14),
                    _chartCard(
                      context,
                      title: "Teachers Count",
                      count: c.teacherCount.value.toString(),
                      data: c.teacherData,
                      color: Theme.of(context).colorScheme.secondary,
                      selectedFilter: c.selectedFilter.value,
                      onFilterChanged: (filter) {
                        c.selectedFilter.value = filter;
                        c.updateTeacherData();
                      },
                      selectedRange: c.teacherRange,
                      onRangeChanged: (value) {
                        c.teacherRange.value = value;
                        c.updateTeacherData(range: value);
                      },
                    ),
                    const SizedBox(height: 14),
                    _summaryCard(context),
                    const SizedBox(height: 14),
                    _chartCard(
                      context,
                      icon: Icons.people_outline,
                      iconColor: context.theme.colorScheme.secondary,
                      title: "Mentors Count",
                      count: c.mentorCount.value.toString(),
                      data: c.mentorData,
                      color: Theme.of(context).colorScheme.primary,
                      selectedFilter: c.selectedFilter.value,
                      onFilterChanged: (p0) {
                        c.selectedFilter.value = p0;
                        c.updateMentorData();
                      },
                      selectedRange: c.mentorRange,
                      onRangeChanged: (p0) {
                        c.mentorRange.value = p0;
                        c.updateMentorData(range: p0);
                      },
                    ),
                    const SizedBox(height: 14),
                    _chartCard(
                      context,
                      title: "Coordinators Count",
                      count: c.coordinatorCount.value.toString(),
                      data: c.coordinatorData,
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icons.people_outline,
                      iconColor: context.theme.colorScheme.primary,
                      selectedFilter: c.selectedFilter.value,
                      onFilterChanged: (filter) {
                        c.selectedFilter.value = filter;
                        c.updatecoordinatorData();
                      },
                      selectedRange: c.coordinatorRange,
                      onRangeChanged: (value) {
                        c.coordinatorRange.value = value;
                        c.updatecoordinatorData(range: value);
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ================= CHART =================

  Widget _chartCard(
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
      decoration: _cardDecoration(context),
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
                        child: _rangeMenu(
                          context,
                          selectedValue: selectedRange.value,
                          onSelected: (value) {
                            onRangeChanged(value);
                          },
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(selectedRange.value,
                              style: context.textTheme.labelLarge),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20)
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(height: 12),
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
  } // ================= SUMMARY =================

  Widget _summaryCard(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(context),
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
                      color: context.theme.cardColor,
                      elevation: 0,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          padding: EdgeInsets.zero,
                          child: _rangeMenu(
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
                        decoration: BoxDecoration(
                          color: context.theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colorScheme.shadow
                                  .withOpacity(0.08),
                              blurRadius: 10,
                            )
                          ],
                        ),
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
            _donutChart(context),
            const SizedBox(height: 14),
            _packageList(context),
          ],
        ),
      );
    });
  }

  Widget _donutChart(BuildContext context) {
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

  Widget _packageList(BuildContext context) {
    return Column(
      children: c.packageData.map((item) {
        final percent = item['value'] / c.totalPackage.value;

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

                    const SizedBox(height: 6),

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

  Widget _expenseChartCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      return Container(
        height: 260,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        decoration: _cardDecoration(context),
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
                          child: _rangeMenu(
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
            Row(
              children: [
                _legendDot(context, cs.primary, "Hours"),
                const SizedBox(width: 12),
                _legendDot(context, cs.secondary, "Amount"),
                const SizedBox(width: 12),
                _legendDot(context, cs.tertiary, "Salary"),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 CHART (same style)
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
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
                            _formatCompact(value),
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
                              _formatCompact(spot.y),
                              TextStyle(
                                color: context.theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ));
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    _line(c.totalHours, cs.primary),
                    _line(c.classAmount, cs.secondary),
                    _line(c.totalSalary, cs.tertiary),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  LineChartBarData _line(List<double> data, Color color) {
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

  Widget _legendDot(BuildContext context, Color color, String text) {
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

  String _formatCompact(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(0)}M";
    }
    if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(0)}K";
    }
    return value.toStringAsFixed(0);
  }

  Widget _rangeMenu(
    BuildContext context, {
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    final ranges = [
      "All",
      "This Month",
      "This Year",
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
            .map((e) => _rangeItem(
                  context,
                  e,
                  selectedValue: selectedValue,
                  onSelected: onSelected,
                ))
            .toList(),
      ),
    );
  }

  Widget _rangeItem(
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
  // ================= COMMON =================

  BoxDecoration _cardDecoration(BuildContext context) {
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
}
