import 'package:flutter/material.dart';
import 'package:for_you_hyper_mart/app/modules/NavBar/navigation_controller.dart';
import 'package:get/get.dart'; // Import the controller

class CustomBottomNavigationBar extends StatelessWidget {
  final BottomNavigationController controller =
      Get.put(BottomNavigationController());

  CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeIndex,
        selectedItemColor: Colors.green,
        // Selected item color
        unselectedItemColor: Colors.grey,
        // Unselected item color
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'WishList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
