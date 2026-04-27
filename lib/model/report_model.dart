class PackageReportModel {
  final String studentName;
  final String studentId;
  final String contact;
  final String whatsapp;
  final int classHours;
  final int classesTaken;
  final int standard;
  final double amount;
  final double totalAmount;
  final double totalPaid;
  final double balance;
  final String course;
  final String advisor;
  final String status;
  final String type;
  int? totalHour;
  double? amountPerHour;
  double? regFee;
  String? subjects;
  String? syllabus;
  String? category;
  String? email;
  DateTime? admissionDate;
  DateTime? joinedAt;
  int? totalSession;


  PackageReportModel({
    required this.studentName,
    required this.studentId,
    required this.type,
    required this.contact,
    required this.whatsapp,
    required this.classHours,
    required this.classesTaken,
    required this.amount,
    required this.totalAmount,
    required this.totalPaid,
    required this.balance,
    required this.course,
    required this.standard,
    required this.advisor,
    required this.status,
    this.totalHour,
    this.amountPerHour,
    this.regFee,
    this.subjects,
    this.syllabus,
  });
}
