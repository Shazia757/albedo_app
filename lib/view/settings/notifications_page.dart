// import 'package:albedo_app/controller/notifications_controller.dart';
// import 'package:albedo_app/controller/settings_controller.dart';
// import 'package:albedo_app/view/settings/banner_ads_page.dart';
// import 'package:albedo_app/widgets/responsive.dart';
// import 'package:albedo_app/widgets/widgets.dart';
// import 'package:albedo_app/widgets/custom_appbar.dart';
// import 'package:albedo_app/widgets/drawer_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';

// class NotificationsPage extends StatelessWidget {
//   final c = Get.put(NotificationsController());

//   NotificationsPage({super.key}) {
//     c.getNotifications();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = Responsive.isDesktop(context);

//     return Scaffold(
//       appBar: const CustomAppBar(),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       floatingActionButton: addNotificationBtn(context),
//       body: Row(
//         children: [
//           if (isDesktop) const DrawerMenu(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Obx(() {
//                 final data = c.msgs;

//                 if (c.isLoading.value) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (data.isEmpty) {
//                   return Center(child: Text("No notifications found"));
//                 }

//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     int crossAxisCount = 1;

//                     if (constraints.maxWidth > 1200) {
//                       crossAxisCount = 3;
//                     } else if (constraints.maxWidth > 700) {
//                       crossAxisCount = 2;
//                     }

//                     return MasonryGridView.count(
//                       padding: const EdgeInsets.all(12),
//                       crossAxisCount: crossAxisCount,
//                       mainAxisSpacing: 12,
//                       crossAxisSpacing: 12,
//                       itemCount: data.length,
//                       itemBuilder: (_, i) {
//                         final item = data[i];
//                         final controller = Get.find<SettingsController>();

//                         return CustomCard(
//                           c: controller,
//                           title: item.title ?? '',
//                           visibleTo: item.dashboardTarget
//                               ?.map((e) => c.visibleToFromString(e))
//                               .toList(),
//                           content: Text(
//                             item.message ?? '',
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurface
//                                         .withOpacity(0.7)),
//                           ),
//                           isImportant: item.isImportant,
//                           actions: [
//                             CustomWidgets().iconBtn(
//                               icon: Icons.edit,
//                               color: Theme.of(context).colorScheme.primary,
//                               onTap: () {
//                                 editNotification(context);
//                               },
//                             ),
//                             CustomWidgets().iconBtn(
//                               icon: Icons.delete,
//                               color: Theme.of(context).colorScheme.error,
//                               onTap: () => CustomWidgets().showDeleteDialog(
//                                 dltText: Obx(
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
//                                 title: 'Are you sure?',
//                                 context: context,
//                                 text: 'Delete this notification?',
//                                 onConfirm: () => c.delete(item.id),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void editNotification(BuildContext context) {
//                         final controller = Get.find<SettingsController>();

//     CustomWidgets().showCustomDialog(
//       context: context,
//       title: Text('Edit Notification'),
//       icon: Icons.edit,
//       formKey: GlobalKey<FormState>(),
//       sections: [
//         CustomWidgets().labelWithAsterisk('Title'),
//         SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context,
//             hint: 'Enter notification title',
//             controller: c.titleController),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Message'),
//         SizedBox(height: 10),
//         CustomWidgets().dropdownStyledTextField(
//             context: context,
//             hint: 'Enter notification message',
//             controller: c.messageController),
//         SizedBox(height: 10),
//         CustomWidgets().labelWithAsterisk('Visible to:'),
//         SizedBox(height: 10),
//         VisibleToSelector(
//           c: controller,
//           initial: List<VisibleTo>.from(c.selected),
//           onChanged: (val) {
//             c.selected.assignAll(val);
//           },
//         ),
//       ],
//       onSubmit: () {},
//     );
//   }

//   FloatingActionButton addNotificationBtn(BuildContext context) {
//                         final controller = Get.find<SettingsController>();

//     return FloatingActionButton(
//       onPressed: () => CustomWidgets().showCustomDialog(
//         context: context,
//         title: Text("Add Notification"),
//         formKey: GlobalKey<FormState>(),
//         onSubmit: () {},
//         sections: [
//           CustomWidgets().labelWithAsterisk('Title'),
//           SizedBox(height: 10),
//           CustomWidgets().dropdownStyledTextField(
//               context: context, hint: 'Enter notification title'),
//           SizedBox(height: 10),
//           CustomWidgets().labelWithAsterisk('Message'),
//           SizedBox(height: 10),
//           CustomWidgets().dropdownStyledTextField(
//               context: context, hint: 'Enter notification message'),
//           SizedBox(height: 10),
//           CustomWidgets().labelWithAsterisk('Visible to:'),
//           SizedBox(height: 10),
//           VisibleToSelector(
//             c: controller,
//             initial: [],
//             onChanged: (val) {
//               c.selected.assignAll(val);
//             },
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

// class VisibleToSelector extends StatefulWidget {
//   final SettingsController c;
//   final List<VisibleTo> initial;
//   final Function(List<VisibleTo>) onChanged;

//   const VisibleToSelector({
//     super.key,
//     required this.c,
//     required this.initial,
//     required this.onChanged,
//   });

//   @override
//   State<VisibleToSelector> createState() => _VisibleToSelectorState();
// }

// class _VisibleToSelectorState extends State<VisibleToSelector> {
//   late List<VisibleTo> selected;

//   @override
//   void initState() {
//     super.initState();
//     selected = List<VisibleTo>.from(widget.initial);
//   }

//   void toggle(VisibleTo value) {
//     setState(() {
//       final allExceptAll =
//           VisibleTo.values.where((e) => e != VisibleTo.all).toList();

//       if (value == VisibleTo.all) {
//         if (selected.contains(VisibleTo.all)) {
//           selected.clear();
//         } else {
//           selected = List<VisibleTo>.from(VisibleTo.values);
//         }
//       } else {
//         selected.remove(VisibleTo.all);

//         if (selected.contains(value)) {
//           selected.remove(value);
//         } else {
//           selected.add(value);
//         }

//         // auto select ALL if everything selected
//         if (selected.toSet().containsAll(allExceptAll)) {
//           selected = [VisibleTo.all];
//         }
//       }
//     });

//     widget.onChanged(List<VisibleTo>.from(selected));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Wrap(
//           spacing: 10,
//           runSpacing: 6,
//           children: VisibleTo.values.map((v) {
//             final isSelected = selected.contains(v);

//             return InkWell(
//               borderRadius: BorderRadius.circular(10),
//               onTap: () => toggle(v),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? cs.primaryContainer
//                       : cs.surfaceContainerHighest,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected ? cs.primary : cs.outlineVariant,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       isSelected
//                           ? Icons.check_box
//                           : Icons.check_box_outline_blank,
//                       size: 18,
//                       color: isSelected ? cs.primary : cs.onSurfaceVariant,
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       widget.c.getLabel(v),
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
