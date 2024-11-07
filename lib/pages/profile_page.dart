import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:travel_partouche_app/constants/consts.dart';
import 'package:travel_partouche_app/model/app_provider.dart';
import 'package:travel_partouche_app/model/user.dart';
import 'package:travel_partouche_app/pages/profile_info_page.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? imageFilePath;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, value, child) {
        if (value.userInfo != null) {
          return const ProfileInfoPage();
        }
        return Scaffold(
          backgroundColor: Colors.redAccent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
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
              TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<AppProvider>(context, listen: false);
                  provider.setUserInfo(
                    User(
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                      email: _emailController.text,
                      imageFilePath: imageFilePath!,
                    ),
                  );
                },
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenSize.height * 0.06),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final imagePicker = ImagePicker();
                        final image = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (image != null) {
                          final cacheDir = await getTemporaryDirectory();
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          final filePath = path.join(
                              cacheDir.path, 'profile_picture_$timestamp.png');
                          final newFile = File(filePath);

                          if (await newFile.exists()) {
                            await newFile.delete();
                          }

                          await File(image.path).copy(filePath);
                          setState(() {
                            imageFilePath = filePath;
                          });
                        }
                      },
                      child: imageFilePath == null
                          ? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.pink.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.black,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.file(
                                width: 150,
                                height: 150,
                                File(imageFilePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.05),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Your name",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Your age",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Your email",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Terms of Use",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              "Developer Website",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              "Privacy Policy",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
