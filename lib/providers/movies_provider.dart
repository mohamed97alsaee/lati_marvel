import 'dart:convert';

import 'package:lati_marvel/models/movie_model.dart';
import 'package:lati_marvel/providers/base_provider.dart';

class MoviesProvider extends BaseProvider {
  List<MovieModel> moviesList = [];
  // TODO Fix Error Here
  getMovies() async {
    setBusy(true);
    final response =
        await api.getRequest("https://mcuapi.herokuapp.com/api/v1/movies");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body)['data'];

      // for (var x in decodedData) {
      //   moviesList.add(MovieModel.fromJson(x));
      // }

      moviesList = List<MovieModel>.from(
          decodedData.map((item) => MovieModel.fromJson(item))).toList();
    } else {}
    setBusy(false);
  }
}
