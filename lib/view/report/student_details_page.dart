// import 'package:albedo_app/model/users/student_model.dart';
// import 'package:albedo_app/widgets/custom_appbar.dart';
// import 'package:flutter/material.dart';

// class StudentDetailsPage extends StatelessWidget {
//   final Student student;

//   const StudentDetailsPage({super.key, required this.student});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: CustomAppBar(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _profileHeader(context),
//             SizedBox(height: 16),
//             _financialSummary(context),
//             SizedBox(height: 16),
//             _detailsSection(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget studentOverview(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _profileHeader(context),
//           SizedBox(height: 16),
//           _financialSummary(context),
//           SizedBox(height: 16),
//           _detailsSection(context),
//         ],
//       ),
//     );
//   }

//   Widget _profileHeader(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.primary,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // NAME + STATUS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 student.name,
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(//                   //                   //                   color: cs.onPrimary,
//),
//               ),
//               _statusBadge(context),
//             ],
//           ),

//           SizedBox(height: 6),

//           Text(
//             student.studentId ?? "",
//             style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: cs.onPrimary.withOpacity(0.7)),
//           ),

//           SizedBox(height: 12),

//           // CONTACT
//           Row(
//             children: [
//               Icon(Icons.phone, size: 16, color: cs.onPrimary),
//               SizedBox(width: 6),
//               Text(student.phone ?? "", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: cs.onPrimary)),
//               SizedBox(width: 16),
//               Icon(Icons.chat, size: 16, color: cs.onPrimary),
//               SizedBox(width: 6),
//               Text(student.whatsapp ?? "",
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: cs.onPrimary)),
//             ],
//           ),

//           SizedBox(height: 10),

//           Text(
//             "Joined: ${student.joinedAt.toString().split(" ")[0]}",
//             style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: cs.onPrimary.withOpacity(0.7)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _statusBadge(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     final isAssigned = student.status == "assigned";

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: isAssigned ? Colors.green : Colors.orange,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         isAssigned ? "Assigned" : "Unassigned",
//         style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
//       ),
//     );
//   }

//   Widget _financialSummary(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: _moneyCard(context, "Total", student.totalAmount)),
//         SizedBox(width: 10),
//         Expanded(child: _moneyCard(context, "Paid", student.totalPaid)),
//         SizedBox(width: 10),
//         Expanded(child: _moneyCard(context, "Balance", student.balance)),
//       ],
//     );
//   }

//   Widget _moneyCard(BuildContext context, String title, double? value) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: cs.shadow.withOpacity(0.06),
//             blurRadius: 10,
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(title,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(//                 //                 color: cs.onSurface.withOpacity(0.6),
//)),
//           SizedBox(height: 6),
//           Text(
//             "₹${(value ?? 0).toStringAsFixed(0)}",
//             style: Theme.of(context).textTheme.titleMedium!.copyWith(//               //               //               color: cs.primary,
//),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _detailsSection(BuildContext context) {
//     return Column(
//       children: [
//         _section(context, "People", [
//           _tile("Mentor", student.mentorName),
//           _tile("Mentor ID", student.mentorId),
//           _tile("Coordinator", student.coordinatorName),
//           _tile("Advisor", student.advisorName),
//         ]),
//         SizedBox(height: 16),
//         _section(context, "Package Info", [
//           _tile("Reg Fee", "₹${student.regFee}"),
//           _tile("Class Hours", "${student.classHours}"),
//           _tile("Amount/Hour", "₹${student.amountPerHour}"),
//           _tile("Classes Taken", "${student.classesTaken}"),
//         ]),
//       ],
//     );
//   }

//   Widget _section(BuildContext context, String title, List<Widget> children) {
//     final cs = Theme.of(context).colorScheme;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cs.surface,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   Theme.of(context).textTheme.titleMedium),
//           SizedBox(height: 12),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: children,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _tile(String title, dynamic value) {
//     return Container(
//       width: 150,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: Theme.of(context).textTheme.labelSmall),
//           SizedBox(height: 4),
//           Text(value != null && value.toString().isNotEmpty ? "$value" : "-",
//               style: Theme.of(context).textTheme.titleSmall),
//         ],
//       ),
//     );
//   }
// }
