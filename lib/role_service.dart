import 'package:albedo_app/model/users/user_model.dart';

class RoleService {
  static bool isAdmin(Users? user) => user?.role == "admin";

  static bool isCoordinator(Users? user) => user?.role == "coordinator";

  static bool isTeacher(Users? user) => user?.role == "teacher";

  static bool isMentor(Users? user) => user?.role == "mentor";
}