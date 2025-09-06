class NavItem {
  final String icon;
  final String icon2;
  final String label;
  final String navLink;

  const NavItem({
    required this.icon,
    required this.icon2,
    required this.label,
    required this.navLink,
  });
}

List<NavItem> getNavItems() {
  return [
    NavItem(icon: 'assets/icons/homeLogo2.png',icon2: 'assets/icons/homeLogo.png', label: 'Home', navLink: "/home"),
    NavItem(
      icon: "assets/icons/serviceLogo2.png",
      icon2: 'assets/icons/servicesLogoOutline.png',
      label: 'Services',
      navLink: "/services",
    ),
    NavItem(
      icon: "assets/icons/pharmacyLogo2.png",
      icon2: "assets/icons/pharmacyLogoOutline.png",
      label: 'Pharmacy',
      navLink: "/pharmacy",
    ),
    NavItem(
      icon: "assets/icons/learningsLogo2.png",
      icon2: "assets/icons/learningBoneLogoOutline.png",
      label: 'Learning',
      navLink: "/learning",
    ),
    NavItem(
      icon: "assets/icons/proflieLogo2.png",
      icon2: "assets/icons/pawPrintOutline.png",
      label: 'Pet Profile',
      navLink: "/pet-profile",
    ),
  ];
}
