import '../models/user_model.dart';

class AuthController {
  static UserModel? registeredUser;
  static bool rememberMe = false;

  static void registerUser(UserModel user) {
    registeredUser = user;
  }

  static bool login(String email, String password) {
    if (registeredUser == null) {
      return false;
    }

    return registeredUser!.email == email && registeredUser!.password == password;
  }

  static void logout() {
    rememberMe = false;
  }
}