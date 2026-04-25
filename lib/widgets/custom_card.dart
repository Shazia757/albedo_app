import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String id;
  final String? status;
  final Color? statusColor;

  final List<Widget>? infoRows;
  final List<Map<String, String>>? infoColumns;
  final List<Widget>? actions;

  const InfoCard({
    super.key,
    required this.id,
    this.status,
    this.statusColor,
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.outline.withOpacity(0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT ACCENT
              Container(
                width: 4,
                height: 70,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...infoRows!.map((w) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: w,
                              )),
                        ],
                      ),
                    ),

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
              ),
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
    if (status == null || status!.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor?.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor?.withOpacity(0.3) ?? Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status!.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: statusColor,
            ),
          ),
        ],
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
          label.toUpperCase(),
          style: TextStyle(
            fontSize: isMobile ? 10 : 11,
            letterSpacing: 0.8,
            color: cs.onSurface.withOpacity(0.45),
            fontWeight: FontWeight.w500,
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

class PremiumInfoCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String? status;
  final Color statusColor;
  final String footerText;
  final String? extraInfo;
  final bool hideIfEmpty;
  final List<InfoAction> actions;
  final VoidCallback? onTap;

  const PremiumInfoCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    this.hideIfEmpty = true,
    required this.extraInfo,
    required this.status,
    required this.statusColor,
    required this.footerText,
    required this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT ACCENT
            Container(
              width: 4,
              height: 70,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 10),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Text(
                        id,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      _statusBadge(),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// TITLE
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),

                  const SizedBox(height: 2),

                  /// SUBTITLE
                  if (!(hideIfEmpty &&
                      (subtitle.isEmpty || subtitle == "NULL")))
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),

                  if (extraInfo != null && extraInfo!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      extraInfo!,
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  /// FOOTER
                  Text(
                    footerText,
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ACTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions
                        .map(
                          (a) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _actionBtn(a),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? "-",
        style: TextStyle(
          color: statusColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _actionBtn(InfoAction a) {
    return InkWell(
      onTap: a.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(a.icon, size: 18, color: a.color),
      ),
    );
  }
}

class InfoAction {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;

  InfoAction({
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
  });
}

class InfoActionButton extends StatelessWidget {
  final InfoAction action;

  const InfoActionButton({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: action.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          action.icon,
          color: action.color,
          size: 20,
        ),
      ),
    );
  }
}
