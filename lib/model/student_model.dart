class Student {
  String? studentId;
  String? contact;
  String? whatsapp;
  int? classHours;
  int? classesTaken;
  int? standard;
  int? totalHour;
  double? amount;
  double? amountPerHour;
  double? totalAmount;
  double? regFee;
  double? totalPaid;
  double? balance;
  String? course;
  String? subjects;
  String? syllabus;
  String? advisor;
  String? status;
  String? name;
  String? category;
  String? email;
  DateTime? admissionDate;
  String? type; // Batch / TBA
  DateTime joinedAt;
  int? totalSession;

  Student({
    this.name,
    this.email,
    this.admissionDate,
    this.status,
    this.type,
   required this.joinedAt,
    this.studentId,
    this.contact,
    this.whatsapp,
    this.classHours,
    this.classesTaken,
    this.standard,
    this.amount,
    this.totalAmount,
    this.totalPaid,
    this.balance,
    this.course,
    this.advisor,
    this.subjects,
    this.syllabus,
    this.category,
    this.regFee,
    this.amountPerHour,
    this.totalHour,
    this.totalSession,});
}
