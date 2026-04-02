import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String id;
  final String status;
  final Color statusColor;

  final List<Widget>? infoRows; // custom layouts
  final List<Map<String, String>>? infoColumns; // simple key-value pairs

  final List<Widget>? actions;

  const InfoCard({
    super.key,
    required this.id,
    required this.status,
    required this.statusColor,
    this.infoRows,
    this.infoColumns,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: $id",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.replaceAll("_", " "),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 INFO COLUMNS (AUTO GRID)
          if (infoColumns != null && infoColumns!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: infoColumns!
                    .map((item) => ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 120),
                          child: _miniInfo(item['label']!, item['value']!),
                        ))
                    .toList(),
              ),
            ),

          /// 🔥 CUSTOM INFO ROWS (if provided)
          if (infoRows != null)
            ...infoRows!.map((w) => Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: w,
                )),

          const SizedBox(height: 6),

          /// 🔥 ACTIONS
          if (actions != null && actions!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...actions!.map((a) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: a,
                    )),
              ],
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// 🔥 MINI INFO WIDGET
  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
