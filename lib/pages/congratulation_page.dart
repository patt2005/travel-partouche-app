import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_partouche_app/constants/consts.dart';
import 'package:travel_partouche_app/model/app_provider.dart';

class CongratulationsPage extends StatelessWidget {
  final int coinsEarned;

  const CongratulationsPage({super.key, required this.coinsEarned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.03),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: screenSize.height * 0.15,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFB2EBB2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            // Main content
            const Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You put the puzzle together",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "You've earned",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$coinsEarned coins",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<AppProvider>(context, listen: false);
                  provider.addCoins(33);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFEFEF), // Light gray
                  foregroundColor: Colors.black, // Text color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Back to main page",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.05),
          ],
        ),
      ),
    );
  }
}
