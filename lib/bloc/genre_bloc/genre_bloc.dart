import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/genre_bloc/genre_bloc_event.dart';
import 'package:movie_viewer/bloc/genre_bloc/genre_bloc_state.dart';
import 'package:movie_viewer/infrastructure/api_service.dart';
import 'package:movie_viewer/models/genre.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreLoading());

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if (event is GenreEventStarted) {
      yield* _mapMovieEventStateToState();
    }
  }

  Stream<GenreState> _mapMovieEventStateToState() async* {
    final service = ApiService();
    yield GenreLoading();
    try {
      List<Genre> genreList = await service.getGenreList();

      yield GenreLoaded(genreList);
    } on Exception catch (e) {
      // print(e);
      yield GenreError();
    }
  }
}
