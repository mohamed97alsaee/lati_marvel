import 'package:flutter/material.dart';
import 'package:lati_marvel/helpers/consts.dart';
import 'package:lati_marvel/helpers/functions_helper.dart';
import 'package:lati_marvel/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<MoviesProvider>(context, listen: false).getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
          actions: [
            SizedBox(width: 16),
            CustomIconButton(
                asset: "assets/icons/favoriteIcon.png", onTap: () {}),
            SizedBox(width: 8),
            CustomIconButton(asset: "assets/icons/inboxIcon.png", onTap: () {}),
            SizedBox(width: 16),
          ],
          title: Image.asset(
            "assets/marvelLogo.png",
            width: getSize(context).width * 0.2,
          )),
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.asset, required this.onTap});
  final String asset;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: mainColor.withOpacity(0.1), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              asset,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
