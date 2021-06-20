class Movie {
  final int? id;
  final String? backdropPath;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final num? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final int? voteCount;
  final String? voteAverage;
  final bool? adult;

  late String error;

  Movie(
      {this.id,
      this.backdropPath,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteCount,
      this.voteAverage,
      this.adult});

  factory Movie.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Movie();
    }

    return Movie(
        id: json['id'],
        backdropPath: json['backdrop_path'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        title: json['title'],
        video: json['video'],
        voteCount: json['vote_count'],
        voteAverage: json['vote_average'].toString(),
        adult: json['adult']);
  }
}
