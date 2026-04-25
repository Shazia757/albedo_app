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
  final VoidCallback? onAdd;
  final List<Widget>? actions;

  const HeaderWithSearch({
    super.key,
    required this.title,
    required this.hint,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchChanged,
    this.onSortTap,
    this.onAdd,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Obx(() {
        final searching = isSearching.value;

        return Row(
          children: [
            /// 🔹 TITLE / SEARCH
            if (!searching)
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
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
              icon: Icon(searching ? Icons.close : Icons.search),
              onPressed: () {
                isSearching.value = !searching;

                if (searching) {
                  searchQuery.value = "";
                  onSearchChanged();
                }
              },
            ),

            if (actions != null) ...actions!,

            /// 🔽 SORT
            if (onSortTap != null)
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: onSortTap,
              ),

            /// ➕ ADD (optional)
            if (onAdd != null)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onAdd,
              ),
          ],
        );
      }),
    );
  }
}
