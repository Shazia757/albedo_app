// import 'package:albedo_app/controller/request_controller.dart';
// import 'package:albedo_app/widgets/custom_appbar.dart';
// import 'package:albedo_app/widgets/drawer_menu.dart';
// import 'package:albedo_app/widgets/widgets.dart';
// import 'package:flutter/material.dart';

// class UserRequestsPage extends StatelessWidget {
//   UserRequestsPage({super.key});

//   final c = RequestController();


//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = MediaQuery.of(context).size.width > 900;

//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: const CustomAppBar(),
//       body: Row(
//         children: [
//           if (isDesktop) const DrawerMenu(),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15.0, vertical: 12),
//                   child: Text(
//                     'Refund Requests',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                   child: CustomWidgets().premiumSearch(
//                     context,
//                     hint: "Search requests...",
//                     onChanged: (v) => c.searchQuery.value = v,
//                   ),
//                 ),

//                 /// 🔹 LIST
//                 Expanded(
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       int crossAxisCount = constraints.maxWidth > 1200 ? 3 : 1;

//                       return GridView.builder(
//                         padding: const EdgeInsets.all(12),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           mainAxisSpacing: 12,
//                           crossAxisSpacing: 12,
//                           childAspectRatio: 3.2,
//                         ),
//                         itemCount: requests.length,
//                         itemBuilder: (context, index) {
//                           final r = requests[index];

//                           return RefundRequestCard(data: r);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RefundRequestCard extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const RefundRequestCard({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Stack(
//       children: [
//         /// 🔹 MAIN CARD
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: cs.onPrimary,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: cs.outline.withOpacity(0.5), width: 1),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               )
//             ],
//           ),
//           child: Row(
//             children: [
//               /// 🔹 STUDENT
//               Expanded(
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         width: 44,
//                         height: 44,
//                         color: cs.primaryContainer.withOpacity(0.4),
//                         child: Image.asset(
//                           "assets/images/logo.png",
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Student",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: cs.onSurfaceVariant,
//                             ),
//                           ),
//                           Text(
//                             data["studentName"],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             data["studentId"],
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: cs.onSurfaceVariant,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               /// 🔸 DIVIDER
//               Container(
//                 width: 1,
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 color: cs.outline.withOpacity(0.2),
//               ),

//               /// 🔹 MENTOR
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Mentor",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: cs.onSurfaceVariant,
//                             ),
//                           ),
//                           Text(
//                             data["mentorName"],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             data["mentorId"],
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: cs.onSurfaceVariant,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         width: 44,
//                         height: 44,
//                         color: cs.primaryContainer.withOpacity(0.4),
//                         child: Image.asset(
//                           "assets/images/logo.png",
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         /// 🔴 REFUND BADGE
//         Positioned(
//             top: 10,
//             right: 10,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color: (data["refundCount"] > 2
//                         ? Theme.of(context).colorScheme.error
//                         : Theme.of(context).colorScheme.primary)
//                     .withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 "${data["refundCount"]} refunds",
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                   color: data["refundCount"] > 2
//                       ? Theme.of(context).colorScheme.error
//                       : Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             )),
//       ],
//     );
//   }
// }
