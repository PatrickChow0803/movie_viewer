import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/infrastructure/api_service.dart';
import 'package:movie_viewer/models/movie.dart';

import 'movie_bloc_event.dart';
import 'movie_bloc_state.dart';

// this is what you want the bloc to do

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    // initial state
    // calls the .getNowPlayingMovie method on start up
    yield MovieLoading();
    try {
      late List<Movie> movieList;
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
      }

      yield MovieLoaded(movieList);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}
