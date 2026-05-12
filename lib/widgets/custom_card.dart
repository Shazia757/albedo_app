import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
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

              SizedBox(width: 10),

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
                    SizedBox(height: 10),

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

                    SizedBox(height: 8),

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

                    SizedBox(height: 6),
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
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: Responsive.isMobile(context) ? 11 : 13,
            color: cs.onSurface.withOpacity(0.8)),
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    if (status == null || status!.isEmpty) return SizedBox();

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
          SizedBox(width: 6),
          Text(
            status!.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(letterSpacing: 0.6, color: statusColor),
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
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: isMobile ? 10 : 11,
              letterSpacing: 0.8,
              color: cs.onSurface.withOpacity(0.45)),
        ),
        SizedBox(height: 2),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontSize: isMobile ? 12 : 13, color: cs.onSurface),
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
  final Widget? extraWidget;
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
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.outline.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.06),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TOP ROW: AVATAR + NAME + ID
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// PROFILE AVATAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44,
                    height: 44,
                    color: cs.primaryContainer.withOpacity(0.4),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(width: 10),

                /// NAME + ID COLUMN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: cs.onSurface),
                      ),

                      SizedBox(height: 2),

                      /// ID
                      Text(
                        id,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: cs.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),

                /// STATUS BADGE (optional keep)
                if (status != null)
                  StatusBadge(
                    status: status!,
                    color: statusColor,
                  ),
              ],
            ),

            SizedBox(height: 12),

            /// 📧 EMAIL ROW
            Row(
              children: [
                Icon(Icons.email_outlined,
                    size: 14, color: cs.onSurface.withOpacity(0.6)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: cs.onSurface.withOpacity(0.7)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),

            /// 📅 DATE ROW
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: cs.onSurface.withOpacity(0.6)),
                SizedBox(width: 6),
                Text(
                  footerText,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: cs.onSurface.withOpacity(0.6)),
                ),
              ],
            ),

            SizedBox(height: 10),

            /// 🔻 DIVIDER
            Divider(
              height: 16,
              thickness: 0.8,
              color: cs.outline.withOpacity(0.12),
            ),

            /// ⚡ ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions.map((a) {
                return _actionBtn(a);
              }).toList(),
            ),
          ],
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

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? accentColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dividerColor = cs.outlineVariant.withOpacity(0.35);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: cs.onSurface.withOpacity(0.03),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: dividerColor, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (accentColor != null)
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
