import 'package:albedo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderWithSearch extends StatelessWidget {
  final String title;
  final String hint;
  final RxBool isSearching;
  final RxString searchQuery;
  final VoidCallback onSearchChanged;
  final VoidCallback? onSortTap;
  final int? requestCount;
  final VoidCallback? onRequestTap;
  final List<Widget>? actions;

  const HeaderWithSearch({
    super.key,
    required this.title,
    this.onRequestTap,
    this.requestCount,
    required this.hint,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchChanged,
    this.onSortTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Obx(() {
        final searching = isSearching.value;
        final cs = Theme.of(context).colorScheme;

        return Row(
          children: [
            /// 🔹 TITLE / SEARCH
            if (!searching)
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: cs.primary),
                ),
              )
            else
              Expanded(
                child: CustomWidgets().premiumSearch(
                  context,
                  hint: hint,
                  onChanged: (value) {
                    searchQuery.value = value;
                    onSearchChanged();
                  },
                ),
              ),

            /// 🔍 TOGGLE
            IconButton(
              icon: Icon(
                searching ? Icons.close : Icons.search,
                color: cs.primary,
              ),
              onPressed: () {
                isSearching.value = !searching;

                if (searching) {
                  searchQuery.value = "";
                  onSearchChanged();
                }
              },
            ),

            /// 🔽 SORT
            if (onSortTap != null)
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: onSortTap,
                color: cs.primary,
              ),

            if (onRequestTap != null)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.inbox_outlined,
                      color: cs.primary,
                    ),
                    tooltip: "Requests",
                    onPressed: onRequestTap,
                  ),
                  if ((requestCount ?? 0) > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        height: 18,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: cs.surface,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          requestCount! > 99 ? '99+' : requestCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (actions != null) ...actions!,
          ],
        );
      }),
    );
  }
}
