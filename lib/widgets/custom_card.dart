import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String id;
  final String status;
  final Color statusColor;

  final List<Widget>? infoRows;
  final List<Map<String, String>>? infoColumns;

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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 TOP ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: $id",
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
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

              /// 🔥 INFO COLUMNS
              if (infoColumns != null && infoColumns!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: infoColumns!
                        .map((item) => ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 120),
                              child: _miniInfo(
                                  context, item['label']!, item['value']!),
                            ))
                        .toList(),
                  ),
                ),

              /// 🔥 CUSTOM INFO ROWS
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
      }),
    );
  }

  /// 🔥 MINI INFO
  Widget _miniInfo(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: cs.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
