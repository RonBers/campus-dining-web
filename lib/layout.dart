import 'package:campus_dining_web/services/auth_service.dart';
import 'package:campus_dining_web/utils/constants/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        titleSpacing: 50,
        title: Text(
          "AdduEats",
          style: GoogleFonts.poppins(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                EvaIcons.bell,
                color: Colors.white,
              )),
          const SizedBox(
            width: 30,
          ),
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 50,
          )
        ],
      ),
      body: Row(
        children: [
          SidebarX(
            controller: _controller,
            theme: const SidebarXTheme(
                iconTheme: IconThemeData(color: AppColors.primaryColor),
                hoverIconTheme: IconThemeData(color: AppColors.primaryColor),
                selectedItemDecoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                decoration: BoxDecoration(
                  color: AppColors.appGrayBG,
                ),
                selectedIconTheme: IconThemeData(color: AppColors.appGrayBG)),
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
                itemTextPadding: EdgeInsets.only(left: 20),
                hoverTextStyle:
                    TextStyle(fontSize: 16, color: AppColors.primaryColor),
                hoverIconTheme: IconThemeData(color: AppColors.primaryColor)),
            items: [
              SidebarXItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                onTap: () => context.go('/dashboard'),
              ),
              SidebarXItem(
                  icon: MingCute.fork_spoon_fill,
                  label: 'Add meal',
                  onTap: () => context.go('/add_meal')),
              SidebarXItem(
                  icon: MingCute.book_2_fill,
                  label: 'Manage Meals',
                  onTap: () {}),
              SidebarXItem(
                  icon: MingCute.comment_2_fill,
                  label: 'Meal Insights',
                  onTap: () {}),
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
