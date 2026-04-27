class Advisor {
    final String id;
  final String name;
  String? email;
  String? status;
  String? gender;
  final DateTime joinedAt;
  String? phone;
  String? whatsapp;
  int? convertedStudents;
  int? convertedTotalAmount;
  String? imageUrl;
  String? dob;
  String? qualification;
  String? place;
  String? pincode;
  String? address;
  String? coordinatorId;
String? mentorId;


  Advisor(
      {required this.name,
      required this.id,
      required this.joinedAt,
      this.email,
      this.gender,
      this.status,
      this.coordinatorId,
      this.mentorId,
      this.convertedStudents,
      this.convertedTotalAmount,
      this.imageUrl,
      this.phone,
      this.whatsapp,
      this.address,
      this.dob,
      this.pincode,
      this.place,
      this.qualification,
      });
}