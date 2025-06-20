import 'dart:convert';
import 'package:eight_news/routes/route_name.dart';
import 'package:eight_news/views/author_news.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:eight_news/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // Fetch user profile email from AuthService
  Future<void> fetchUserProfile() async {
    try {
      final fetchedEmail = await context.read<AuthService>().getUserEmail();
      setState(() {
        email = fetchedEmail ?? 'not logged in';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        email = 'Gagal mengambil email';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cTextGreyLight,
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('assets/images/image 1.png'),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Author", //
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: cTextGreyLight,
                      ),
                    ),
                    Text(
                      isLoading ? "Loading..." : email,
                      style: TextStyle(fontSize: 14, color: cTextGrey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              //author page
              buildMenuItem(
                Icons.article,
                "Author Page",
                onTap: () {
                  final authService = context.read<AuthService>();

                  // Check if the user is logged in
                  if (authService.token == null || authService.token!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Silakan login terlebih dahulu untuk mengakses Author Page.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AuthorNews()),
                    );
                  }
                },
              ),

              //logout
              buildMenuItem(
                Icons.logout,
                "Logout",
                onTap: () async {
                  await context.read<AuthService>().logout();
                  if (context.mounted) {
                    context.goNamed(RouteNames.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //style
  Widget buildMenuItem(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: cWhite),
          title: Text(
            title,
            style: TextStyle(color: cTextGreyLight, fontSize: 16),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap: onTap,
        ),
        Divider(color: Colors.grey[700], height: 0),
      ],
    );
  }
}
