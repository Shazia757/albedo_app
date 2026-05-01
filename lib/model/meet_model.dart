import 'package:albedo_app/model/users/user_model.dart';

class Meet {
  final String id;
  final String title;
  final String status;

  final DateTime? date;
  final String? startTime;
  final String? endTime;
   final List<Users> members;

  Meet({
    required this.id,
    required this.title,
     this.date,
    this.startTime,
    this.endTime,
   this.status='completed',
   this.members = const [],
  });

  factory Meet.fromJson(Map<String, dynamic> json) {
    return Meet(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'])
          : null,
      startTime: json['start_time'],
      endTime: json['end_time'],
       members: (json['members'] as List<dynamic>? ?? [])
          .map((e) => Users(
                id: e['id'],
                name: e['name'],
                email: e['email'],
                role: e['role'],
                contact: e['contact'],
                profileImage: e['profileImage'],
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title":title,
        "status":status,
            "date": date?.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "members": members
            .map((e) => {
                  "id": e.id,
                  "name": e.name,
                  "email": e.email,
                  "role": e.role,
                  "contact": e.contact,
                  "profileImage": e.profileImage,
                })
            .toList(),
    
      };
}