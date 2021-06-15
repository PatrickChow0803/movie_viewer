import 'package:equatable/equatable.dart';
import 'package:movie_viewer/models/movie.dart';

// these are the different states that the movie bloc has. Ex: loading and loaded.

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movieList;
  const MovieLoaded(this.movieList);

  @override
  List<Object> get props => [movieList];
}

class MovieError extends MovieState {}
