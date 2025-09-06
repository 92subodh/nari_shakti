import 'package:flutter/material.dart';
import 'package:safeher/constants/navbar_constants.dart';

class MainBottomNavBar extends StatefulWidget {
  final String selectedRoute;
  const MainBottomNavBar({super.key, required this.selectedRoute});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _selectedIndex = 0;
  List<NavItem> navItems = getNavItems();

  @override
  void initState() {
    _selectedIndex = navItems.indexWhere(
      (e) => e.navLink == widget.selectedRoute,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navItems
          .map<BottomNavigationBarItem>(
            (item) => BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSecondary,
                  BlendMode.srcIn,
                ),
                child: Image.asset(item.icon2, scale: 1.8),
              ),
              label: item.label,
              activeIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
                child: Image.asset(item.icon, scale: 1.8),
              ),
            ),
          )
          .toList(),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      unselectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      elevation: 0,
      onTap: (value) {
        // setState(() {
        //   _selectedIndex = value;
        // });

        Navigator.pushNamed(context, navItems[value].navLink);
      },
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xffF3F4F6),
    );
  }
}
