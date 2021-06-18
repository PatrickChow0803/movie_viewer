import 'package:movie_viewer/models/movie_image.dart';

import 'cast_list.dart';

class MovieDetail {
  final String? id;
  final String? title;
  final String? backdropPath;
  final String? budget;
  final String? homePage;
  final String? originalTitle;
  final String? overview;
  final String? releaseDate;
  final String? runtime;
  final String? voteAverage;
  final String? voteCount;

  // for getting the video
  late String trailerId;

  late MovieImage movieImage;

  late List<Cast> castList;

  MovieDetail({
    this.id,
    this.title,
    this.backdropPath,
    this.budget,
    this.homePage,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
        id: json['id'].toString(),
        title: json['title'],
        backdropPath: json['backdrop_path'],
        budget: json['budget'].toString(),
        homePage: json['home_page'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        runtime: json['runtime'].toString(),
        voteAverage: json['vote_average'].toString(),
        voteCount: json['vote_count'].toString());
  }
}
