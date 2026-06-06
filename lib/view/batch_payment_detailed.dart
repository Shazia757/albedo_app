import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class BatchPaymentDetailPage extends StatelessWidget {
  final BatchPaymentModel batchModel;
  final String activeTab;

  const BatchPaymentDetailPage({
    super.key,
    required this.batchModel,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // ── Header ─────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: cs.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(batchModel.name  ?? "",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(batchModel.id ?? ""),
              ],
            ),
          ),

          SizedBox(height: 10),

          // ── Payments List ─────────────────────
          // Expanded(
          //   child: ListView.separated(
          //     padding: const EdgeInsets.all(16),
          //     itemCount: batchModel.,
          //     separatorBuilder: (_, __) => SizedBox(height: 10),
          //     itemBuilder: (_, i) {
          //       final p = batchModel.payments[i];

          //       return PaymentCard(payment: p);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final PaymentItem payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(payment.studentName,
              style: Theme.of(context).textTheme.titleSmall),
          Text(payment.studentId,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: cs.onSurfaceVariant)),
          SizedBox(height: 8),
          Text("Amount: ₹${payment.amount}"),
          Text("Balance: ₹${payment.balance}"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payment.paymentDate.toString().split(" ").first,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              DropdownButton<String>(
                value: payment.status,
                items: const [
                  DropdownMenuItem(value: "pending", child: Text("Pending")),
                  DropdownMenuItem(
                      value: "completed", child: Text("Completed")),
                  DropdownMenuItem(value: "declined", child: Text("Declined")),
                ],
                onChanged: (val) {
                  payment.status = val!;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
