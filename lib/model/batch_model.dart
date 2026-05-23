import 'package:albedo_app/model/package_model.dart';
import 'package:albedo_app/model/payment_model.dart';
import 'package:albedo_app/model/users/coordinator_model.dart';
import 'package:albedo_app/model/users/mentor_model.dart';
import 'package:albedo_app/model/users/student_model.dart';

class Batch {
  String? id;
  String? batchID;
  String? batchName;
  String? mode;
  List<Student>? student;
  List<PaymentItem>? payment;
  String? course;
  List? materials;
  String? imageUrl;
  int? students;
  int? totalFee;
  int? totalPaid;
  int? balance;
  int? expenseRatio;
  int? duration;
  Mentor? mentor;
  Coordinator? coordinator;
  final String? coordinatorId;
  List<Package>? packages;
  final String? syllabus;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status;
  String? amountPaid;
  DateTime? paidDate;

  Batch({
    this.id,
    this.batchID,
    this.batchName,
    this.materials,
    this.paidDate,
    this.mode,
    this.amountPaid,
    this.balance,
    this.student,
    this.totalFee,
    this.totalPaid,
    this.expenseRatio,
    this.students,
    this.payment,
    this.coordinatorId,
    this.coordinator,
    this.imageUrl,
    this.mentor,
    this.course,
    this.duration,
    this.packages,
    this.syllabus,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
  });

  // ✅ From JSON
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      batchID: json['batchID'],
      batchName: json['batchName'],
      duration: json['duration'],
      packages: json['package'],
      syllabus: json['syllabus'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
    );
  }

  // ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batchID': batchID,
      'batchName': batchName,
      'duration': duration,
      'package': packages,
      'syllabus': syllabus,
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}

class BatchDetail {
  final String? id;
  final String? name;
  final String? code;
  final Mentor? mentor;
  final FinancialSummary? financialSummary;

  BatchDetail({
    this.id,
    this.name,
    this.code,
    this.mentor,
    this.financialSummary,
  });

  factory BatchDetail.fromJson(Map<String, dynamic> json) {
    return BatchDetail(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      mentor: json['mentor'] != null
          ? Mentor.fromJson(json['mentor'])
          : null,
      financialSummary: json['financial_summary'] != null
          ? FinancialSummary.fromJson(json['financial_summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'mentor': mentor?.toJson(),
      'financial_summary': financialSummary?.toJson(),
    };
  }

  static List<Batch> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Batch.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}


class FinancialSummary {
  final double? totalFee;
  final double? totalPaid;
  final double? totalPending;
  final double? totalDeclined;
  final double? balance;
  final int? studentCount;
  final int? pendingCount;
  final int? approvedCount;
  final int? declinedCount;

  FinancialSummary({
    this.totalFee,
    this.totalPaid,
    this.totalPending,
    this.totalDeclined,
    this.balance,
    this.studentCount,
    this.pendingCount,
    this.approvedCount,
    this.declinedCount,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalFee: (json['total_fee'] ?? 0).toDouble(),
      totalPaid: (json['total_paid'] ?? 0).toDouble(),
      totalPending: (json['total_pending'] ?? 0).toDouble(),
      totalDeclined: (json['total_declined'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      studentCount: json['student_count'],
      pendingCount: json['pending_count'],
      approvedCount: json['approved_count'],
      declinedCount: json['declined_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_fee': totalFee,
      'total_paid': totalPaid,
      'total_pending': totalPending,
      'total_declined': totalDeclined,
      'balance': balance,
      'student_count': studentCount,
      'pending_count': pendingCount,
      'approved_count': approvedCount,
      'declined_count': declinedCount,
    };
  }
}
