import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  const BottomNavBar({
    super.key,
    required this.index
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: Colors.teal,
      destinations: [
        NavigationDestination(
          selectedIcon: Icon(Icons.home, size: MediaQuery.of(context).size.width * 0.07),
          icon: Icon(Icons.home_outlined, size: MediaQuery.of(context).size.width * 0.07),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_cart, size: MediaQuery.of(context).size.width * 0.07),
          ),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.receipt_long, size: MediaQuery.of(context).size.width * 0.07)),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.person, size: MediaQuery.of(context).size.width * 0.07)),
          label: 'Profile',
        ),
      ],
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/cart');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/orders');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      selectedIndex: widget.index,
    );
  }
}
