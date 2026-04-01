import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../widgets/drawer_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width > 800 ? null : DrawerMenu(),
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Image.asset("assets/images/logo.png",
                height: 28), // replace with your logo
            const SizedBox(width: 8),
            // const Text("albedo", style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          Icon(Icons.dark_mode, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 12),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            offset: const Offset(0, 45),
            color: Colors.transparent,
            elevation: 0,
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                padding: EdgeInsets.zero,
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔥 PROFILE HEADER
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Albedo Admin",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                Text("admin@albedo.com",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                      ),

                      Divider(height: 1),

                      // 🔥 PROFILE BUTTON
                      Row(
                        children: [
                          _menuItem(
                            icon: Icons.person_outline,
                            text: "Profile",
                            onTap: () {
                              Navigator.pop(context);
                              // Navigate to profile
                            },
                          ),
                          _menuItem(
                            icon: Icons.logout,
                            text: "Logout",
                            isDanger: true,
                            onTap: () {
                              Navigator.pop(context);
                              // Logout logic
                            },
                          ),
                        ],
                      ),

                      // 🔥 LOGOUT BUTTON
                    ],
                  ),
                ),
              ),
            ],
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) DrawerMenu(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _chartCard(
                    title: "Students Count",
                    count: "1034",
                    data: controller.studentData,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _summaryCard(),
                  const SizedBox(height: 16),
                  _chartCard(
                    title: "Women Count",
                    count: "10",
                    data: controller.womenData,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 16),
                  _chartCard(
                    title: "Assistants Count",
                    count: "4",
                    data: controller.assistantData,
                    color: Colors.blueAccent,
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

  Widget _chartCard({
    required String title,
    required String count,
    required List<double> data,
    required Color color,
  }) {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      decoration: _cardDecoration(),
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
              style: const TextStyle(
                color: Colors.grey,
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
                    color: Colors.grey.withOpacity(0.15),
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
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
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
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
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
                          const TextStyle(color: Colors.white),
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

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
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
                    color: Colors.purple,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: Colors.orange,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: Colors.blue,
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
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

  Widget _menuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                size: 18, color: isDanger ? Colors.red : Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: isDanger ? Colors.red : null,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
