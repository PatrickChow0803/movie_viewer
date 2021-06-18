import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/person_bloc/person_event.dart';
import 'package:movie_viewer/bloc/person_bloc/person_state.dart';
import 'package:movie_viewer/infrastructure/api_service.dart';
import 'package:movie_viewer/models/person.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is PersonEventStated) {
      yield* _mapMovieEventStartedToState();
    }
  }

  Stream<PersonState> _mapMovieEventStartedToState() async* {
    final apiRepository = ApiService();
    yield PersonLoading();
    try {
      final List<Person> movies = await apiRepository.getTrendingPerson();
      yield PersonLoaded(movies);
    } catch (_) {
      yield PersonError();
    }
  }
}
