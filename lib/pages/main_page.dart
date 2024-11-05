import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_partouche_app/model/text.main.info.dart';
import 'package:travel_partouche_app/pages/Main_Info_Page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class MyCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;

  const MyCard({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainPageState extends State<MainPage> {
  get textMainInfo => null;

  Widget buildContainer(List<TextMainInfo> collectibles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: collectibles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          TextMainInfo collectible = collectibles[i];

          return MyCard(
            title: collectible.title,
            description: collectible.description,
            price: collectible.price,
            imageUrl: collectible.photoUrl,
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainInfoPage(
                        textMainInfo: textMainInfo, collectible: collectible),
                  ));
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffF62F10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Shop cart",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: screenSize.width * 0.08,
              height: screenSize.width * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffF62F10),
              ),
              child: const Center(
                child: Text(
                  "1",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "33",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Shop',
                  style: TextStyle(
                    fontFamily: "Roboto Serif",
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
