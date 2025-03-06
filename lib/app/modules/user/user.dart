import 'package:flutter/material.dart';
import 'package:for_you_hyper_mart/app/modules/user/user_controller.dart';
import 'package:get/get.dart';

class UserManagementPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => ListTile(
                  leading: Icon(Icons.person, size: 50, color: Colors.blue),
                  title: Text(userController.userName.value,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Text(userController.email.value),
                )),
            const SizedBox(height: 20),

            // Edit User Details Button
            ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text("Edit Profile"),
              onPressed: () => _showEditDialog(context),
            ),

            // Change Password Button
            ElevatedButton.icon(
              icon: Icon(Icons.lock),
              label: Text("Change Password"),
              onPressed: () =>
                  Get.snackbar("Change Password", "Feature coming soon!"),
            ),

            // Delete User Button
            ElevatedButton.icon(
              icon: Icon(Icons.delete, color: Colors.red),
              label:
                  Text("Delete Account", style: TextStyle(color: Colors.red)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Get.defaultDialog(
                  title: "Confirm Deletion",
                  content:
                      Text("Are you sure you want to delete your account?"),
                  confirm: ElevatedButton(
                    child: Text("Yes, Delete",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      userController.deleteUser();
                      Get.back();
                    },
                  ),
                  cancel: TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Get.back(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Edit Profile Dialog
  void _showEditDialog(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: userController.userName.value);
    TextEditingController emailController =
        TextEditingController(text: userController.email.value);
    TextEditingController phoneController =
        TextEditingController(text: userController.phoneNumber.value);

    Get.defaultDialog(
      title: "Edit Profile",
      content: Column(
        children: [
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name")),
          TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email")),
          TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone")),
        ],
      ),
      confirm: ElevatedButton(
        child: Text("Save"),
        onPressed: () {
          userController.updateUser(
              nameController.text, emailController.text, phoneController.text);
          Get.back();
        },
      ),
      cancel: TextButton(child: Text("Cancel"), onPressed: () => Get.back()),
    );
  }
}
