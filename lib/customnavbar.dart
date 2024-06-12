import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  ViewController _viewController = Get.put(ViewController());
  int selectedIndex = 2;

  List<IconData> listOfIconData = [
    Icons.search,
    Icons.chat_bubble_outline,
    Icons.home,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff26252b),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          listOfIconData.length,
          (index) =>
              _buildNavItem(listOfIconData[index], index == selectedIndex),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = listOfIconData.indexOf(icon);
          if (selectedIndex == 0) {
            _viewController.mainSelected.value = false;
          }
          if (selectedIndex == 2) {
            _viewController.mainSelected.value = true;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0xfffbb018) : Colors.black,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}

class ViewController extends GetxController {
  var mainSelected = true.obs;

  toggleSelection() {
    mainSelected.value = !mainSelected.value;
  }
}
