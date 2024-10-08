import 'package:flutter/material.dart';
import 'package:lati_marvel/helpers/consts.dart';
import 'package:lati_marvel/helpers/functions_helper.dart';
import 'package:lati_marvel/models/movie_model.dart';
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
    return Consumer<MoviesProvider>(builder: (context, moviesConsumer, child) {
      return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
            actions: [
              SizedBox(width: 16),
              CustomIconButton(
                  asset: "assets/icons/favoriteIcon.png", onTap: () {}),
              SizedBox(width: 8),
              CustomIconButton(
                  asset: "assets/icons/inboxIcon.png", onTap: () {}),
              SizedBox(width: 16),
            ],
            title: Image.asset(
              "assets/marvelLogo.png",
              width: getSize(context).width * 0.2,
            )),
        body: AnimatedSwitcher(
          duration: animationDuration,
          child: moviesConsumer.isFailed
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_outlined,
                          color: mainColor,
                          size: getSize(context).width * 0.33),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SOMTHING WENT WRONG!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(24),
                  itemCount: moviesConsumer.busy
                      ? 12
                      : moviesConsumer.moviesList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.7),
                  itemBuilder: (context, index) {
                    return AnimatedSwitcher(
                      duration: animationDuration,
                      child: moviesConsumer.busy
                          ? Center(child: CircularProgressIndicator()) //
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.network(
                                    moviesConsumer.moviesList[index].coverUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ])),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 100,
                                            ),
                                            Text(
                                              Duration(
                                                      minutes: moviesConsumer
                                                          .moviesList[index]
                                                          .duration)
                                                  .toString()
                                                  .substring(0, 4),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              moviesConsumer
                                                  .moviesList[index].title,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  }),
        ),
      );
    });
  }
}

class MovieCardWithGridTile extends StatelessWidget {
  const MovieCardWithGridTile({super.key, required this.movieModel});
  final MovieModel movieModel;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(color: Colors.black12),
          child: Image.network(
            movieModel.coverUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent])),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  Duration(minutes: movieModel.duration)
                      .toString()
                      .substring(0, 4),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15),
                ),
                Text(
                  movieModel.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ),
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
