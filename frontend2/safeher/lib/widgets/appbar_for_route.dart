import 'package:flutter/material.dart';
import 'package:safeher/constants/app_constants.dart';

AppBar? getAppbarForRoute(
  String route,
  BuildContext context,
  GlobalKey<ScaffoldState> key,
) {
  Map<String, AppBar?> routes = {
    "/home": AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: getTitleLogo(),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu), // Temporary fix: Use material icon instead of missing asset
        // icon: Image.asset('assets/icons/hamburgerMenu.png', scale: 1.8),
        onPressed: () => key.currentState!.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.location_pin),
          onPressed: () {
            Navigator.pushNamed(context, "/location");
          },
        ),
      ],
    ),

    "/services": AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        "Book a service",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.chevron_left),
      ),
    ),
    "/learning": AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        "Learnings",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.chevron_left),
      ),
    ),
    "/diagnostics": AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text("Diagnostics", style: Theme.of(context).textTheme.titleMedium),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.chevron_left),
      ),
    ),
  };

  return routes[route];
}
