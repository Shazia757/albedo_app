import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../widgets/drawer_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: CustomAppBar(),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) DrawerMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _chartCard(
                    context,
                    title: "Students Count",
                    count: "1034",
                    data: c.studentData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  _summaryCard(context),
                  const SizedBox(height: 16),
                  _chartCard(
                    context,
                    title: "Women Count",
                    count: "10",
                    data: c.womenData,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  _chartCard(
                    context,
                    title: "Assistants Count",
                    count: "4",
                    data: c.assistantData,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
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
    required List<double> data,
    required Color color,
  }) {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 2),
          Text(title,
              style: TextStyle(
                color: context.theme.colorScheme.outline,
                fontSize: 13,
              )),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 5,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.theme.colorScheme.outline.withOpacity(0.4),
                    strokeWidth: 1,
                  ),
                ),

                // ✅ AXIS LABELS (2022 / 2023)
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: context.theme.colorScheme.outline,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          "Jan",
                          "Feb",
                          "Mar",
                          "Apr",
                          "May",
                          "Jun"
                        ];
                        return Text(
                          labels[value.toInt()],
                          style: TextStyle(
                            fontSize: 10,
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

                // ✅ TOOLTIP (Hover / Tap)
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          "${spot.y}",
                          TextStyle(color: context.theme.colorScheme.onPrimary),
                        );
                      }).toList();
                    },
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.4,
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    barWidth: 3,
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
  // ================= SUMMARY =================

  Widget _summaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Summary", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    value: 40,
                    color: context.theme.colorScheme.primary,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: context.theme.colorScheme.secondary,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: context.theme.colorScheme.tertiary,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          // const Center(
          //   child: Text("₹32.2M",
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          // ),
        ],
      ),
    );
  }

  // ================= COMMON =================

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.theme.cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          blurRadius: 12,
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
