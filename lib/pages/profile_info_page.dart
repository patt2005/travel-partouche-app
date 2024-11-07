import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_partouche_app/constants/consts.dart';
import 'package:travel_partouche_app/model/app_provider.dart';
import 'package:travel_partouche_app/pages/edit_profile_page.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture and Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        FileImage(File(value.userInfo!.imageFilePath)),
                  ),
                  const SizedBox(height: 16),
                  // Name and Age
                  Text(
                    "${value.userInfo!.name}, ${value.userInfo!.age}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Text(
                    value.userInfo!.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.03),
                  // Transaction History Section
                  GestureDetector(
                    onTap: () {
                      // Navigate to transaction history
                      print("History of transactions tapped");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history, color: Colors.black54),
                          SizedBox(width: 16),
                          Text(
                            "History of transactions with coins",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.13),
                  // Footer Links
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Terms of Use",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "Developer Website",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
