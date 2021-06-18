import 'package:equatable/equatable.dart';
import 'package:movie_viewer/models/screen_shot.dart';

class MovieImage extends Equatable {
  final List<Screenshot>? backdrops;
  final List<Screenshot>? posters;

  const MovieImage({this.backdrops, this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return MovieImage();
    }

    return MovieImage(
      backdrops: (json['backdrops'] as List)
          .map((b) => Screenshot.fromJson(b))
          .toList(),
      posters:
          (json['posters'] as List).map((b) => Screenshot.fromJson(b)).toList(),
    );
  }

  @override
  List<Object?> get props => [backdrops, posters];
}
