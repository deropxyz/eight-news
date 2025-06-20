import 'package:eight_news/services/api_service.dart';
import 'package:eight_news/views/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/routes/route_name.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  String? avatar;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await ApiService.fetchUserProfile();

    if (data != null) {
      setState(() {
        name = data['name'] ?? 'No Name';
        email = data['email'] ?? 'No Email';
        avatar =
            data['photo'] ??
            'https://ui-avatars.com/api/?name=${data['name'] ?? 'User'}';
        isLoading = false;
      });
    } else {
      // jika gagal ambil data, logout
      await ApiService.logout();
      if (context.mounted) context.goNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: cBg,
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child:
              isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: NetworkImage(avatar!),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              name!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              email!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      buildMenuItem(Icons.bookmark, "Bookmarks", onTap: () {}),
                      buildMenuItem(Icons.settings, "Settings", onTap: () {}),
                      buildMenuItem(Icons.info_outline, "About", onTap: () {}),
                      buildMenuItem(
                        Icons.logout,
                        "Logout",
                        onTap: () async {
                          await ApiService.logout();
                          if (context.mounted)
                            context.goNamed(RouteNames.login);
                        },
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
