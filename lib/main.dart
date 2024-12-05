import 'package:campus_dining_web/firebase_options.dart';
import 'package:campus_dining_web/screens/item_details_screen.dart';
import 'package:campus_dining_web/screens/login_screen.dart';
import 'package:campus_dining_web/screens/settings_screen.dart';
import 'package:campus_dining_web/screens/dashboard_screen.dart';
import 'package:campus_dining_web/layout.dart';
import 'package:campus_dining_web/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

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
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const Settings(),
        ),
        GoRoute(
          path: '/item_details/:mealId',
          builder: (context, state) {
            final mealId = state.pathParameters['mealId']!;
            return ItemDetailsScreen(mealId: mealId);
          },
        ),
      ],
    ),
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
