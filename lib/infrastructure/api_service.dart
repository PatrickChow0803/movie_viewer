import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_viewer/models/genre.dart';
import 'package:movie_viewer/models/movie.dart';

class ApiService {
  final Dio _dio = Dio();

  // https://api.themoviedb.org/3/movie/now_playing?api_key={api_key_here}&language=en-US&page=1
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static final String apiKey = dotenv.env['API_KEY']!;

  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      final url = '$baseUrl/movie/now_playing?api_key=$apiKey';
      final response = await _dio.get(url);
      // 'results' is used to get into the 'results' part of the json
      var movies = response.data['results'] as List;
      // converts the List<dynamic> into a List<Movie>
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // https://api.themoviedb.org/3/genre/movie/list?api_key={api_key}&language=en-US
  Future<List<Genre>> getGenreList() async {
    try {
      final url = '$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US';
      final response = await _dio.get(url);
      // 'genres' is used to get into the 'genres' part of the json
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();
      return genreList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }
}
