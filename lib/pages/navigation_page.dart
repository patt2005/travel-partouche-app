import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_partouche_app/pages/main_page.dart';
import 'package:travel_partouche_app/pages/notes_page.dart';
import 'package:travel_partouche_app/pages/profile_page.dart';
import 'package:travel_partouche_app/pages/puzzle_list_page.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.white,
      tabBar: CupertinoTabBar(
        activeColor: const Color(0xFFF62F10),
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bolt),
            label: 'Puzzle',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.hand_raised),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const MainPage();
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return PuzzleGamePage();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const NotesPage();
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const AddProfilePage();
              },
            );
          default:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return const MainPage();
              },
            );
        }
      },
    );
  }
}
