import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

class FooterNav extends StatelessWidget {
  final int currentIndex;

  const FooterNav({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    String route;
    switch (index) {
      case 0:
        route = AppRoutes.home;
        break;
      case 1:
        route = AppRoutes.shareLocation;
        break;
      case 2:
        route = AppRoutes.sos;
        break;
      case 3:
        route = AppRoutes.fakeCall;
        break;
      case 4:
        route = AppRoutes.profile;
        break;
      default:
        return;
    }

    if (index != currentIndex) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share_location),
            label: AppStrings.shareLocation,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: AppStrings.sos,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: AppStrings.fakeCall,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
