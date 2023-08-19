import 'package:flutter/material.dart';
import '../provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(1, 3),
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavItem(
            icon: Icons.home_outlined,
            label: "Home",
            index: NavigationIndex.home.index,
          ),
          BottomNavItem(
            icon: Icons.message_outlined,
            label: "Message",
            index: NavigationIndex.message.index,
          ),
          BottomNavItem(
            icon: Icons.calendar_month_rounded,
            label: "Appointment",
            index: NavigationIndex.appointment.index,
          ),
          BottomNavItem(
            icon: Icons.settings_outlined,
            label: "Setting",
            index: NavigationIndex.setting.index,
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<NavigationProvider>(context);
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: provider.currentIndex == index
                ? Colors.blue
                : Colors.grey.withOpacity(0.9),
            splashFactory: NoSplash.splashFactory,
            padding: EdgeInsets.zero),
        onPressed: () => index == NavigationIndex.setting.index
            ? provider.changeIndex(index, context: context)
            : provider.changeIndex(index),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon), FittedBox(child: Text(label))],
          ),
        ),
      ),
    );
  }
}
