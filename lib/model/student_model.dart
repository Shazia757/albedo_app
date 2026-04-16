class Student {
  String? studentId;
  String? phone;
  String? whatsapp;
  String? parentName;
  String? parentOccupation;
  String? gender;
  String? mentor;
  String? timezone;
  String? address;
  String? place;
  String? referredBy;
  int? classHours;
  int? pincode;
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
  String name;
  String? category;
  String? email;
  DateTime? admissionDate;
  String? type; // Batch / TBA
  DateTime joinedAt;
  int? totalSession;

  Student({
    required this.name,
    this.email,
    this.admissionDate,
    this.parentName,
    this.parentOccupation,
    this.status,
    this.mentor,
    this.type,
    this.address,
    this.gender,
    this.timezone,
    this.place,
    required this.joinedAt,
    this.studentId,
    this.phone,
    this.whatsapp,
    this.classHours,
    this.classesTaken,
    this.standard,
    this.amount,
    this.totalAmount,
    this.referredBy,
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
    this.totalSession,
  });
}
