import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/genre_block/genre_bloc.dart';
import 'package:movie_viewer/bloc/genre_block/genre_bloc_event.dart';
import 'package:movie_viewer/bloc/genre_block/genre_bloc_state.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movie_viewer/models/genre.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;
  // 28 because 28 refers to action genre
  const BuildWidgetCategory({this.selectedGenre = 28, key}) : super(key: key);

  @override
  _BuildWidgetCategoryState createState() => _BuildWidgetCategoryState();
}

class _BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  late int selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<GenreBloc, GenreState>(
          builder: (context, state) {
            if (state is GenreLoading) {
              return Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              );
            } else if (state is GenreLoaded) {
              List<Genre> genres = state.genreList;
              return Container(
                height: 45,
                child: ListView.separated(
                  separatorBuilder: (context, index) => VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    Genre genre = genres[index];
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            // makes it so that only the selectedGenre is colored in
                            color: (genre.id == selectedGenre)
                                ? Colors.black45
                                : Colors.white,
                          ),
                          child: Text(
                            genre.name!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (genre.id == selectedGenre)
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: 10),
        Container(
          child: Text(
            'Movies By Category:'.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return Center();
            } else if (state is MovieLoaded) {
              return Center();
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
