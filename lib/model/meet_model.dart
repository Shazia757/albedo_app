import 'package:albedo_app/model/users/user_model.dart';

class Meet {
  final String id;
  final String title;
  final String? description;

  final String status;
  final String? startsIn;

  final DateTime? sessionDate;
  final String? startTime;
  final String? endTime;
  final String? duration;

  final String? googleCalendarUrl;
  final String? googleEventId;
  final String? googleMeetLink;

  final bool? selectAllMentors;
  final bool? selectAllTeachers;
  final bool? selectAllStudents;
  final bool? selectAllAssistants;
  final bool? selectAllOtherUsers;

  final List<Users> mentors;
  final List<Users> teachers;
  final List<Users> students;
  final List<Users> assistants;
  final List<Users> otherUsers;

  final Creator? creator;

  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  Meet({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.startsIn,
    this.sessionDate,
    this.startTime,
    this.endTime,
    this.duration,
    this.googleCalendarUrl,
    this.googleEventId,
    this.googleMeetLink,
    this.selectAllMentors,
    this.selectAllTeachers,
    this.selectAllStudents,
    this.selectAllAssistants,
    this.selectAllOtherUsers,
    this.mentors = const [],
    this.teachers = const [],
    this.students = const [],
    this.assistants = const [],
    this.otherUsers = const [],
    this.creator,
    this.dateAdded,
    this.dateUpdated,
  });

  factory Meet.fromJson(Map<String, dynamic> json) {
    List<Users> parseUsers(List<dynamic>? data) {
      return (data ?? [])
          .map(
            (e) => Users(
              id: e['id'] ?? '',
              name: e['name'] ?? '',
              email: e['email'] ?? '',
              role: e['role'] ?? '',
              contact: e['emp_id'] ?? '',
              profileImage: e['photo'],
            ),
          )
          .toList();
    }

    return Meet(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? '',
      startsIn: json['starts_in'],
      sessionDate: json['session_date'] != null
          ? DateTime.tryParse(json['session_date'])
          : null,
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      googleCalendarUrl: json['google_calendar_url'],
      googleEventId: json['google_event_id'],
      googleMeetLink: json['google_meet_link'],
      selectAllMentors: json['select_all_mentors'],
      selectAllTeachers: json['select_all_teachers'],
      selectAllStudents: json['select_all_students'],
      selectAllAssistants: json['select_all_assistants'],
      selectAllOtherUsers: json['select_all_other_users'],
      mentors: parseUsers(json['mentors']),
      teachers: parseUsers(json['teachers']),
      students: parseUsers(json['students']),
      assistants: parseUsers(json['assistants']),
      otherUsers: parseUsers(json['other_users']),
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
      dateAdded: json['date_added'] != null
          ? DateTime.tryParse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.tryParse(json['date_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status,
        "starts_in": startsIn,
        "session_date": sessionDate?.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "duration": duration,
        "google_calendar_url": googleCalendarUrl,
        "google_event_id": googleEventId,
        "google_meet_link": googleMeetLink,
        "select_all_mentors": selectAllMentors,
        "select_all_teachers": selectAllTeachers,
        "select_all_students": selectAllStudents,
        "select_all_assistants": selectAllAssistants,
        "select_all_other_users": selectAllOtherUsers,
        "mentors": mentors
            .map(
              (e) => {
                "id": e.id,
                "name": e.name,
                "email": e.email,
                "role": e.role,
                "contact": e.contact,
                "profileImage": e.profileImage,
              },
            )
            .toList(),
        "teachers": teachers
            .map(
              (e) => {
                "id": e.id,
                "name": e.name,
                "email": e.email,
                "role": e.role,
                "contact": e.contact,
                "profileImage": e.profileImage,
              },
            )
            .toList(),
        "students": students
            .map(
              (e) => {
                "id": e.id,
                "name": e.name,
                "email": e.email,
                "role": e.role,
                "contact": e.contact,
                "profileImage": e.profileImage,
              },
            )
            .toList(),
      };
}

class Creator {
  final int id;
  final String? email;
  final String? username;
  final String? roleName;

  Creator({
    required this.id,
    this.email,
    this.username,
    this.roleName,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? 0,
      email: json['email'],
      username: json['username'],
      roleName: json['role_name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "role_name": roleName,
      };
}