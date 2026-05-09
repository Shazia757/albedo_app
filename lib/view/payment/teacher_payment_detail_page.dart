import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class TeacherPaymentDetailsPage extends StatelessWidget {
  const TeacherPaymentDetailsPage({
    super.key,
    required this.teacher,
  });

  final TeacherPaymentModel teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            /// teacher profile
            /// monthly earnings
            /// withdrawal history
            /// payout summary
            /// pending requests
          ],
        ),
      ),
    );
  }
}
