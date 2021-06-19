import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/genre_bloc/genre_bloc.dart';
import 'package:movie_viewer/bloc/genre_bloc/genre_bloc_event.dart';
import 'package:movie_viewer/bloc/genre_bloc/genre_bloc_state.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movie_viewer/models/genre.dart';
import 'package:movie_viewer/models/movie.dart';

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
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Genre genre = genres[index];
                              selectedGenre = genre.id!;
                              context
                                  .read<MovieBloc>()
                                  .add(MovieEventStarted(selectedGenre, ''));
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
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
              List<Movie> movieList = state.movieList;
              print('MoviesList Length: ${movieList.length}');
              return Container(
                height: 300,
                width: double.infinity,
                child: ListView.separated(
                  separatorBuilder: (context, index) => VerticalDivider(
                    color: Colors.transparent,
                    width: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: movieList.length,
                  itemBuilder: (context, index) {
                    Movie movie = movieList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: 180,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              );
                            },
                            placeholder: (context, url) => Container(
                              width: 180,
                              height: 250,
                              child: Center(
                                child: Platform.isAndroid
                                    ? CircularProgressIndicator()
                                    : CupertinoActivityIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 180,
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/img_not_found.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 180,
                          child: Text(
                            movie.title!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              Text(
                                movie.voteAverage!,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
