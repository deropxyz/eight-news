import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/views/splash.dart';
import 'package:eight_news/views/intro.dart';
import 'package:eight_news/views/login.dart';
import 'package:eight_news/views/register.dart';
import 'package:eight_news/views/main.dart';
import 'route_name.dart';

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  factory AppRouter() {
    _instance.goRouter = goRouterSetup();

    return _instance;
  }

  GoRouter? goRouter;

  static GoRouter goRouterSetup() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          pageBuilder: (context, state) => MaterialPage(child: Splash()),
        ),
        GoRoute(
          path: '/intro',
          name: RouteNames.intro,
          pageBuilder: (context, state) => MaterialPage(child: Intro()),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          pageBuilder: (context, state) => MaterialPage(child: Login()),
          routes: [
            GoRoute(
              path: "/register",
              name: RouteNames.register,
              pageBuilder: (_, __) => MaterialPage(child: Register()),
            ),
          ],
        ),
        GoRoute(
          path: '/main',
          name: RouteNames.main,
          pageBuilder: (context, state) => MaterialPage(child: Main()),
        ),
      ],
    );
  }
}
