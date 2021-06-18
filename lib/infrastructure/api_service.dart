import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_viewer/models/cast_list.dart';
import 'package:movie_viewer/models/genre.dart';
import 'package:movie_viewer/models/movie.dart';
import 'package:movie_viewer/models/movie_detail.dart';
import 'package:movie_viewer/models/movie_image.dart';
import 'package:movie_viewer/models/person.dart';

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

  // Action Genre Id is 28
  // Assume Action is the default category
  Future<List<Movie>> getMovieByGenre({int genreId = 28}) async {
    try {
      final url =
          '$baseUrl/discover/movie?with_genres=$genreId&api_key=$apiKey';
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

  // https://api.themoviedb.org/3/trending/person/week?api_key=<<api_key>>
  // gets trending people by week
  Future<List<Person>> getTrendingPerson() async {
    try {
      final url = '$baseUrl/trending/person/week?api_key=$apiKey';
      final response = await _dio.get(url);
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      return personList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // https://api.themoviedb.org/3/movie/100?api_key={api_key}
  // gets the movie details where the movieId is 100
  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId?api_key=$apiKey';
      final response = await _dio.get(url);
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      movieDetail.trailerId = await getYoutubeId(movieId);
      movieDetail.movieImage = await getMovieImage(movieId);
      movieDetail.castList = await getCastList(movieId);

      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // https://api.themoviedb.org/3/movie/{movie_id}/videos?api_key=<<api_key>>
  // Get the first video available
  // key is the extension to the URL that you need to add to watch the specific video
  // for example: https://www.youtube.com/embed/{key} is how you'd get the video
  // Example key: N1XmtdMZdL8
  Future<String> getYoutubeId(int id) async {
    try {
      final url = '$baseUrl/movie/$id/videos?api_key=$apiKey';
      final response = await _dio.get(url);
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // https://api.themoviedb.org/3/movie/200/images?api_key={api_key}}
  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/images?api_key=$apiKey';
      final response = await _dio.get(url);
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }

  // https://api.themoviedb.org/3/movie/200/credits?api_key={api_key}}
  Future<List<Cast>> getCastList(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/credits?api_key=$apiKey';
      final response = await _dio.get(url);
      // cast here to go into the json map
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
              name: c['name'],
              profilePath: c['profile_path'],
              character: c['character']))
          .toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception accoured: $error with stacktrace: $stacktrace');
    }
  }
}
