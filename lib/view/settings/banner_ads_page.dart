// import 'package:albedo_app/controller/settings_controller.dart';
// import 'package:albedo_app/model/settings/banners_model.dart';
// import 'package:albedo_app/widgets/responsive.dart';
// import 'package:albedo_app/widgets/widgets.dart';
// import 'package:albedo_app/widgets/custom_appbar.dart';
// import 'package:albedo_app/widgets/drawer_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';

// class BannerAdsPage extends StatelessWidget {
//   final c = Get.put(SettingsController());

//   BannerAdsPage({super.key}) ;

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = Responsive.isDesktop(context);

//     return Scaffold(
//       appBar: const CustomAppBar(),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       floatingActionButton: addBannerBtn(context),
//       body: Row(
//         children: [
//           if (isDesktop) const DrawerMenu(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// ── PAGE TITLE ─────────────────────
//                   Text(
//                     "Banner Advertisements",
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.w700,
//                         ),
//                   ),

//                   SizedBox(height: 24),

//                   /// ── CONTENT ────────────────────────
//                   Expanded(
//                     child: Obx(() {
//                       final data = c.banners;

//                       if (c.isLoading.value) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }

//                       if (data.isEmpty) {
//                         return Center(
//                           child: Text("No banners found"),
//                         );
//                       }

//                       return LayoutBuilder(
//                         builder: (context, constraints) {
//                           int crossAxisCount = 1;

//                           if (constraints.maxWidth > 1200) {
//                             crossAxisCount = 3;
//                           } else if (constraints.maxWidth > 700) {
//                             crossAxisCount = 2;
//                           }

//                           return MasonryGridView.count(
//                             padding: EdgeInsets.zero,
//                             crossAxisCount: crossAxisCount,
//                             mainAxisSpacing: 12,
//                             crossAxisSpacing: 12,
//                             itemCount: data.length,
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (_, i) {
//                               final item = data[i];

//                               return CustomCard(
//                                 title: item.url,
//                                 c: c,
//                                 visibleTo: item.dashboardTarget
//                                     ?.map((e) => c.visibleToFromString(e))
//                                     .toList(),
//                                 actions: [
//                                   CustomWidgets().iconBtn(
//                                     icon: Icons.edit,
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     onTap: () {
//                                       editBanner(context);
//                                     },
//                                   ),
//                                   SizedBox(width: 10),
//                                   CustomWidgets().iconBtn(
//                                     icon: Icons.delete,
//                                     color: Theme.of(context).colorScheme.error,
//                                     onTap: () {
//                                       CustomWidgets().showDeleteDialog(
//                                         dltText: Obx(
//   () => c.isLoading.value
//       ? const SizedBox(
//           width: 18,
//           height: 18,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             color: Colors.white,
//           ),
//         )
//       : Text(
//           "Yes",
//           style: Theme.of(context)
//               .textTheme
//               .titleSmall!
//               .copyWith(color: Colors.white),
//         ),
// ),
//                                         title: 'Are you sure?',
//                                         context: context,
//                                         text:
//                                             'Are you sure you want to delete this action?',
//                                         onConfirm: () => c.delete(item.id),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void editBanner(BuildContext context) {
//     CustomWidgets().showCustomDialog(
//       context: context,
//       title: Text('Edit Banner'),
//       icon: Icons.edit,
//       formKey: GlobalKey<FormState>(),
//       sections: [
//         Container(),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Redirect URL'),
//         SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context, hint: '', controller: c.urlController),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('From Date'),
//         SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context, hint: '', controller: c.startDateController),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('To Date'),
//         SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context, hint: '', controller: c.endDateController),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Visible To:'),
//         SizedBox(height: 10),
//         MultiSelector<VisibleTo>(
//           items: VisibleTo.values.where((e) => e != VisibleTo.all).toList(),
//           labelBuilder: (v) => c.getLabel(v),
//           initial: List<VisibleTo>.from(c.selected),
//           onChanged: (val) {
//             c.selected.assignAll(val);
//           },
//         ),
//       ],
//       onSubmit: () {},
//     );
//   }

//   FloatingActionButton addBannerBtn(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => CustomWidgets().showCustomDialog(
//         context: context,
//         title: Text("Add Banner"),
//         formKey: GlobalKey<FormState>(),
//         onSubmit: () {},
//         sections: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.75,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Obx(
//                     () => Row(
//                       children: [
//                         Expanded(
//                           child: RadioListTile(
//                             dense: true,
//                             title: Text('Regular Banner'),
//                             value: BannerType.regularBanner,
//                             groupValue: c.selectedType.value,
//                             onChanged: (value) {
//                               if (value != null) {
//                                 c.selectedType.value = value;
//                               }
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: RadioListTile(
//                             dense: true,
//                             title: Text('Default Banner'),
//                             value: BannerType.defaultBanner,
//                             groupValue: c.selectedType.value,
//                             onChanged: (value) {
//                               if (value != null) {
//                                 c.selectedType.value = value;
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Obx(() {
//                     if (c.selectedType.value == BannerType.regularBanner) {
//                       return Column(
//                         children: [
//                           Container(),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('Redirect URL'),
//                           SizedBox(height: 10),
//                           CustomWidgets().dropdownStyledTextField(
//                               context: context,
//                               hint: '',
//                               controller: c.urlController),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('From Date'),
//                           SizedBox(height: 10),
//                           CustomWidgets().dropdownStyledTextField(
//                               context: context,
//                               hint: '',
//                               controller: c.startDateController),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('To Date'),
//                           SizedBox(height: 10),
//                           CustomWidgets().dropdownStyledTextField(
//                               context: context,
//                               hint: '',
//                               controller: c.endDateController),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('Visible To:'),
//                           SizedBox(height: 10),
//                           MultiSelector<VisibleTo>(
//                             items: VisibleTo.values
//                                 .where((e) => e != VisibleTo.all)
//                                 .toList(),
//                             allValue: VisibleTo.all,
//                             labelBuilder: (v) => c.getLabel(v),
//                             initial: List<VisibleTo>.from(c.selected),
//                             onChanged: (val) {
//                               c.selected.assignAll(val);
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                     if (c.selectedType.value == BannerType.defaultBanner) {
//                       return Column(
//                         children: [
//                           Container(),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('Redirect URL'),
//                           SizedBox(height: 10),
//                           CustomWidgets().dropdownStyledTextField(
//                               context: context,
//                               hint: '',
//                               controller: c.urlController),
//                           SizedBox(height: 10),
//                           CustomWidgets().labelWithAsterisk('Visible To:'),
//                           SizedBox(height: 10),
//                           MultiSelector<VisibleTo>(
//                             items: VisibleTo.values
//                                 .where((e) => e != VisibleTo.all)
//                                 .toList(),
//                             allValue: VisibleTo.all,
//                             labelBuilder: (v) => c.getLabel(v),
//                             initial: List<VisibleTo>.from(c.selected),
//                             onChanged: (val) {
//                               c.selected.assignAll(val);
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                     return SizedBox();
//                   })
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       mini: true,
//       backgroundColor: context.theme.colorScheme.primary,
//       child: Icon(
//         Icons.add,
//         color: context.theme.colorScheme.onPrimary,
//       ),
//     );
//   }
// }

// class CustomCard extends StatelessWidget {
//   final String? title;
//   final Widget? content;
//   final bool isImportant;
//   final List<Widget>? actions;
//   final List<VisibleTo>? visibleTo;
//   final SettingsController c;

//   const CustomCard({
//     super.key,
//     this.title,
//     this.content,
//     required this.c,
//     this.isImportant = false,
//     this.actions,
//     this.visibleTo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: cs.onPrimary,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: cs.outline.withOpacity(.5),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: cs.shadow.withOpacity(.03),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// HEADER
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: cs.primary.withOpacity(.08),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Icon(
//                   Icons.image_outlined,
//                   color: cs.primary,
//                   size: 22,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title ?? '',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall!
//                           .copyWith(color: cs.onSurface),
//                     ),
//                     if (isImportant) ...[
//                       SizedBox(height: 6),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: cs.error.withOpacity(.08),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Text(
//                           "IMPORTANT",
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall!
//                               .copyWith(letterSpacing: 1, color: cs.error),
//                         ),
//                       ),
//                     ]
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           if (content != null) ...[
//             SizedBox(height: 14),
//             content!,
//           ],

//           if ((visibleTo ?? []).isNotEmpty) ...[
//             SizedBox(height: 14),
//             Text(
//               "VISIBLE TO",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleSmall!
//                   .copyWith(letterSpacing: 1, color: cs.outline),
//             ),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: (visibleTo ?? []).map((v) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: cs.primary.withOpacity(.08),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     c.getLabel(v),
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(color: cs.primary),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],

//           if (actions != null && actions!.isNotEmpty) ...[
//             SizedBox(height: 14),
//             Divider(
//               height: 1,
//               color: cs.outline.withOpacity(.08),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: actions!,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class MultiSelector<T> extends StatefulWidget {
//   final List<T> items;
//   final List<T> initial;
//   final Function(List<T>) onChanged;

//   /// Optional "All" item (can be enum OR string OR model)
//   final T? allValue;

//   /// Label builder (important for enums / objects)
//   final String Function(T) labelBuilder;

//   const MultiSelector({
//     super.key,
//     required this.items,
//     required this.initial,
//     required this.onChanged,
//     required this.labelBuilder,
//     this.allValue,
//   });

//   @override
//   State<MultiSelector<T>> createState() => _MultiSelectorState<T>();
// }

// class _MultiSelectorState<T> extends State<MultiSelector<T>> {
//   late List<T> selected;

//   @override
//   void initState() {
//     super.initState();
//     selected = List<T>.from(widget.initial);
//   }

//   void toggle(T value) {
//     setState(() {
//       final hasAll = widget.allValue != null;

//       final allExceptAll = hasAll
//           ? widget.items.where((e) => e != widget.allValue).toList()
//           : widget.items;

//       if (hasAll && value == widget.allValue) {
//         final isAllSelected = selected.toSet().containsAll(allExceptAll);

//         if (isAllSelected) {
//           selected.clear(); // unselect all
//         } else {
//           selected = List<T>.from(allExceptAll);
//         }
//       } else {
//         if (selected.contains(value)) {
//           selected.remove(value);
//         } else {
//           selected.add(value);
//         }

//         // if all items selected manually → keep them all (NOT collapse to "All")
//         if (hasAll && selected.toSet().containsAll(allExceptAll)) {
//           selected = List<T>.from(allExceptAll);
//         }
//       }
//     });

//     widget.onChanged(List<T>.from(selected));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     final displayList = widget.allValue != null
//         ? [widget.allValue as T, ...widget.items]
//         : widget.items;

//     return Wrap(
//       spacing: 10,
//       runSpacing: 6,
//       children: displayList.map((v) {
//         final isSelected = widget.allValue != null && v == widget.allValue
//             ? selected.toSet().containsAll(widget.items)
//             : selected.contains(v);
//         return InkWell(
//           borderRadius: BorderRadius.circular(10),
//           onTap: () => toggle(v),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//             decoration: BoxDecoration(
//               color:
//                   isSelected ? cs.primaryContainer : cs.surfaceContainerHighest,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: isSelected ? cs.primary : cs.outlineVariant,
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   isSelected ? Icons.check_box : Icons.check_box_outline_blank,
//                   size: 18,
//                   color: isSelected ? cs.primary : cs.onSurfaceVariant,
//                 ),
//                 SizedBox(width: 6),
//                 Text(
//                   widget.labelBuilder(v),
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
