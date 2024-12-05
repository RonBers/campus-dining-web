import 'package:campus_dining_web/services/auth_service.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:go_router/go_router.dart';

class Layout extends StatefulWidget {
  final Widget child;

  const Layout({Key? key, required this.child}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final SidebarXController _controller =
      SidebarXController(selectedIndex: 0, extended: false);

  Future<void> signOut(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Campus Dining App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                EvaIcons.bell,
                color: Colors.white,
              )),
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          SidebarX(
            controller: _controller,
            theme: const SidebarXTheme(
              iconTheme: const IconThemeData(color: AppColors.primaryColor),
              selectedIconTheme: IconThemeData(color: AppColors.appGrayBG),
              selectedItemDecoration:
                  BoxDecoration(color: AppColors.primaryColor),
              decoration: const BoxDecoration(
                color: AppColors.appGrayBG,
              ),
            ),
            extendedTheme: const SidebarXTheme(
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.appGrayBG,
                ),
                textStyle: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                ),
                selectedTextStyle:
                    TextStyle(color: AppColors.appGrayBG, fontSize: 16),
                selectedItemTextPadding: EdgeInsets.only(left: 20),
                itemTextPadding: const EdgeInsets.only(left: 20),
                hoverTextStyle: TextStyle(fontSize: 16)),
            items: [
              SidebarXItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                onTap: () => context.go('/dashboard'),
              ),
              SidebarXItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
