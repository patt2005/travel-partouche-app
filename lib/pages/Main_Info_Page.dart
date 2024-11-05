import 'package:flutter/material.dart';
import 'package:travel_partouche_app/model/text.main.info.dart';

class MainInfoPage extends StatefulWidget {
  const MainInfoPage(
      {super.key,
      required TextMainInfo textMainInfo,
      required TextMainInfo collectible});

  @override
  State<MainInfoPage> createState() => _MainInfoPageState();
}

class _MainInfoPageState extends State<MainInfoPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Column(
        children: [],
      )),
    );
  }
}
