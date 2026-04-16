import 'package:albedo_app/controller/payment_controller.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/widgets/widgets.dart';
import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  final PaymentUserType type;

  PaymentPage({super.key, required this.type}) {
    if (type == PaymentUserType.student) {
      c.fetchStudents();
    } else {
      c.fetchTeachers();
    }
  }

  final PaymentController c = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isStudent = type == PaymentUserType.student;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
         appBar: const CustomAppBar(),

      drawer: isDesktop ? null : const DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomWidgets().premiumSearch(
              context,
              hint: isStudent ? "Search students..." : "Search teachers...",
              onChanged: (p0) => c.searchQuery.value = p0,
            ),
          ),
          _tabs(),
          Expanded(
            child: Obx(() => ListView.builder(
                  // padding: const EdgeInsets.all(16),
                  itemCount: isStudent
                      ? c.filteredStudentPayments.length
                      : c.filteredTeacherPayments.length,
                  itemBuilder: (_, i) => _card(
                    context,
                    (type == PaymentUserType.student)
                        ? c.filteredStudentPayments[i]
                        : null,
                    (type == PaymentUserType.teacher)
                        ? c.filteredTeacherPayments[i]
                        : null,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(Get.context!).colorScheme.shadow.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            _tabItem("Pending", 0),
            _tabItem("Approved", 1),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    return Expanded(
      child: Obx(() {
        final isSelected = c.selectedTab.value == index;

        return GestureDetector(
          onTap: () => c.selectedTab.value = index,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(Get.context!).colorScheme.onPrimary
                      : Theme.of(Get.context!).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _card(
      BuildContext context, StudentPaymentModel? s, TeacherPaymentModel? t) {
    final isStudent = (type == PaymentUserType.student);

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(Get.context!).colorScheme.shadow.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      isStudent ? s!.name[0] : t!.name[0],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isStudent ? s!.name : t!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(isStudent ? s!.id : t!.id,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 11)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEAF1FB), Color(0xFFF7F9FF)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(children: [
                Text(
                  isStudent
                      ? "₹${s?.balance?.toStringAsFixed(2)}"
                      : "₹${t?.balance?.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D6CDF),
                  ),
                ),
                const SizedBox(height: 4),
                Text("Current Balance",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .shadow
                            .withOpacity(0.8),
                        fontSize: 12)),
                const SizedBox(height: 8),
                Divider(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                if (type == PaymentUserType.student)
                  _fullTile(context, "₹${s?.admissionFee}", "Adm. Fee"),
                const SizedBox(height: 8),
                _rowTiles(
                    context,
                    isStudent ? s!.depTxns.toString() : t!.total.toString(),
                    isStudent ? "Dep Txns" : "Total",
                    isStudent ? s!.credTxns.toString() : t!.pending.toString(),
                    isStudent ? "Cred Txns" : "Pending"),
                const SizedBox(height: 8),
                if (isStudent)
                  _rowTiles(context, "₹${s?.deposited}", "Deposited",
                      "₹${s?.creditLimit}", "Credit Limit"),
                if (isStudent) const SizedBox(height: 8),
                if (isStudent)
                  _rowTiles(context, "₹${s?.depPending}", "Dep Pending",
                      "₹${s?.creditAmount}", "Credit"),
                if (!isStudent)
                  _fullTile(context, "${t?.totalWithdawal}", 'Total Withdrawal')
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _fullTile(BuildContext context, String value, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline, fontSize: 12))
        ],
      ),
    );
  }

  Widget _rowTiles(
      BuildContext context, String v1, String l1, String v2, String l2) {
    return Row(
      children: [
        Expanded(child: _smallTile(context, v1, l1)),
        const SizedBox(width: 12),
        Expanded(child: _smallTile(context, v2, l2)),
      ],
    );
  }

  Widget _smallTile(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline, fontSize: 11))
        ],
      ),
    );
  }
}
