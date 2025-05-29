import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/routes/route_name.dart';
import 'utils/helper.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.goNamed(RouteNames.intro);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      body: Center(child: Image.asset('assets/images/logo.png', width: 250)),
    );
  }
}
