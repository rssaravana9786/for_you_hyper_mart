import 'package:get/get.dart';

class UserController extends GetxController {
  var userName = "John Doe".obs;
  var email = "johndoe@example.com".obs;
  var phoneNumber = "1234567890".obs;

  // Update User Info
  void updateUser(String newName, String newEmail, String newPhone) {
    userName.value = newName;
    email.value = newEmail;
    phoneNumber.value = newPhone;
  }

  // Delete User (Mock)
  void deleteUser() {
    userName.value = "";
    email.value = "";
    phoneNumber.value = "";
    Get.snackbar("User Deleted", "Your account has been removed.");
  }
}
