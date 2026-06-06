import 'package:albedo_app/widgets/responsive.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PremiumInfoCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String? status;
  final Color statusColor;
  final String footerText;
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

    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP ROW
          Row(
            children: [
              Expanded(
                child: Text(
                  id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                ),
              ),
              if (status != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: StatusBadge(
                    status: status!,
                    color: statusColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// 🔹 CONTENT ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// AVATAR
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

              const SizedBox(width: 10),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TITLE
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: cs.onSurface,
                          ),
                    ),

                    const SizedBox(height: 5),

                    /// SUBTITLE
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                    ),

                    const SizedBox(height: 6),

                    /// FOOTER
                    Text(
                      footerText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                    ),

                    if (extraWidget != null) ...[
                      const SizedBox(height: 10),
                      extraWidget!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: () async {
          final overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          final box = context.findRenderObject() as RenderBox;

          final topLeft = box.localToGlobal(
            Offset.zero,
            ancestor: overlay,
          );

          final bottomRight = box.localToGlobal(
            box.size.bottomRight(Offset.zero),
            ancestor: overlay,
          );

          final position = RelativeRect.fromLTRB(
            bottomRight.dx - 220, // align menu to right
            bottomRight.dy - 10, // slightly below top
            overlay.size.width - bottomRight.dx,
            overlay.size.height - bottomRight.dy,
          );

          final selected = await showMenu<int>(
            context: context,
            position: position,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            items: List.generate(actions.length, (i) {
              final a = actions[i];

              return PopupMenuItem<int>(
                value: i,
                height: 48,
                child: Row(
                  children: [
                    Icon(
                      a.icon,
                      color: a.color,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      a.label ?? '',
                      style: TextStyle(
                        color: a.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );

          if (selected != null) {
            actions[selected].onTap();
          }
        },
        child: card,
      ),
    );
  }
}

class InfoAction {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? label;

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
