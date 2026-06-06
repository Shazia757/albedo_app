class Advisor {
  final String id;
  final String name;
  final String? empId;
  final String? email;
  final String? phone;
  final String? photo;
  final bool? isResigned;
  DateTime? assignedAt;

  Advisor({
    required this.id,
    required this.name,
    this.empId,
    this.email,
    this.phone,
    this.photo,
    this.assignedAt,
    this.isResigned = false,
  });

  factory Advisor.fromJson(Map<String, dynamic> json) {
    return Advisor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      empId: json['emp_id'],
      email: json['email'],
      phone: json['phone_number'],
      photo: json['photo'],
      assignedAt: json['assignment_date'] != null
          ? DateTime.tryParse(json['assignment_date'])
          : null,
      isResigned: json['is_resigned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emp_id': empId,
      'email': email,
      'phone_number': phone,
      'photo': photo,
      'is_resigned': isResigned,
    };
  }
}

class PaginatedAdvisorResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Advisor> results;

  PaginatedAdvisorResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });
}
