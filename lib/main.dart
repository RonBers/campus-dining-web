import 'package:campus_dining_web/firebase_options.dart';
import 'package:campus_dining_web/screens/dashboard_screen.dart';
import 'package:campus_dining_web/screens/item_details_screen.dart';
import 'package:campus_dining_web/screens/login_screen.dart';
import 'package:campus_dining_web/screens/settings_screen.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:sidebarx/sidebarx.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ToastificationWrapper(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const Dashboard()),
    GoRoute(
        path: '/item_details/:mealId',
        builder: (context, state) {
          final mealId = state.pathParameters['mealId']!;
          return ItemDetailsScreen(mealId: mealId);
        })
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final isAuthenticated = AuthService().isAuthenticated();
    final isLoggingIn = state.matchedLocation == '/login';
    if (!isAuthenticated && !isLoggingIn) {
      return '/login';
    }
    if (isAuthenticated && isLoggingIn) {
      return '/dashboard';
    }

    return null;
  },
);

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   final SidebarXController _controller = SidebarXController(selectedIndex: 0);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [

//           SidebarX(
//             controller: _controller,
//             theme: SidebarXTheme(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             items: const [
//               SidebarXItem(icon: Icons.home, label: 'Dashboard'),
//               SidebarXItem(icon: Icons.settings, label: 'Settings'),
//             ],
//             : (index) {
//               switch (index) {
//                 case 0:
//                   context.go('/');
//                   break;
//                 case 1:
//                   context.go('/settings');
//                   break;
//               }
//             },
//           ),
//           Expanded(
//             child: Navigator(
//               key: GlobalKey<NavigatorState>(),
//               onGenerateRoute: (settings) {
//                 final screen = router.routeInformationProvider.go(location);

//                 return MaterialPageRoute(
//                   builder: (context) {
//                     if (settings.name == '/') {
//                       return const DashboardScreen();
//                     } else if (settings.name == '/settings') {
//                       return const SettingsScreen();
//                     } else {
//                       return const DashboardScreen();
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Dashboard();
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Settings();
//   }
// }
