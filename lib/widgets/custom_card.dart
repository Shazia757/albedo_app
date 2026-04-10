import 'package:albedo_app/widgets/responsive.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;
        final isTablet = constraints.maxWidth < 700;

        final horizontalPadding = isMobile ? 12.0 : 20.0;
        final verticalPadding = isMobile ? 12.0 : 20.0;

        return Container(
          padding: EdgeInsets.fromLTRB(
              horizontalPadding, verticalPadding, horizontalPadding, 10),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 16,
            vertical: isMobile ? 6 : 10,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 HEADER (Responsive)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 260;

                  return isTight
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildIdChip(context),
                            _buildStatus(context),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildIdChip(context),
                            _buildStatus(context),
                          ],
                        );
                },
              ),
              const SizedBox(height: 10),

              /// 🔥 INFO COLUMNS
              if (infoColumns != null && infoColumns!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 12),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: infoColumns!.map((item) {
                      return SizedBox(
                        width: isMobile
                            ? constraints.maxWidth // full width on mobile
                            : isTablet
                                ? (constraints.maxWidth / 2) - 16
                                : (constraints.maxWidth / 3) - 16,
                        child: _miniInfo(
                          context,
                          item['label']!,
                          item['value']!,
                          isMobile,
                        ),
                      );
                    }).toList(),
                  ),
                ),

              /// 🔥 CUSTOM ROWS
              if (infoRows != null)
                ...infoRows!.map((w) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: w,
                    )),

              const SizedBox(height: 8),

              /// 🔥 ACTIONS
              if (actions != null && actions!.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 6,
                    runSpacing: 6,
                    children: actions!,
                  ),
                ),

              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIdChip(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "ID: $id",
        style: TextStyle(
          fontSize: Responsive.isMobile(context) ? 11 : 13,
          fontWeight: FontWeight.w600,
          color: cs.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Text(
      status.toUpperCase(),
      style: TextStyle(
        fontSize: Responsive.isMobile(context) ? 11 : 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: statusColor,
      ),
    );
  }

  /// 🔥 MINI INFO
  Widget _miniInfo(
      BuildContext context, String label, String value, bool isMobile) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 10 : 11,
            color: cs.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
