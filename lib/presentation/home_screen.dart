import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_event.dart';
import 'package:movie_viewer/bloc/movie_bloc/movie_bloc_state.dart';
import 'package:movie_viewer/bloc/person_bloc/person_bloc.dart';
import 'package:movie_viewer/bloc/person_bloc/person_event.dart';
import 'package:movie_viewer/bloc/person_bloc/person_state.dart';
import 'package:movie_viewer/core/const.dart';
import 'package:movie_viewer/models/movie.dart';
import 'package:movie_viewer/models/person.dart';
import 'package:movie_viewer/presentation/category_screen.dart';
import 'package:movie_viewer/presentation/movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
            create: (_) => MovieBloc()..add(MovieEventStarted(0, ''))),
        BlocProvider<PersonBloc>(
            create: (_) => PersonBloc()..add(PersonEventStated())),
      ],
      child: Scaffold(
        // appBar: AppBar(
        //   titleSpacing: 0,
        //   centerTitle: true,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: Icon(
        //     Icons.menu,
        //     color: Colors.black54,
        //   ),
        //   actions: [
        //     Text('        '),
        //   ],
        //   title: Align(
        //     alignment: Alignment.center,
        //     child: Text(
        //       'The Movie Database',
        //       style: Theme.of(context).textTheme.caption!.copyWith(
        //             color: Colors.black54,
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold,
        //           ),
        //     ),
        //   ),
        // ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                    if (state is MovieLoading) {
                      return Center(
                        child: Platform.isAndroid
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                      );
                    } else if (state is MovieLoaded) {
                      List<Movie> movies = state.movieList;
                      // print(movies.length);
                      return Column(
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 500),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                            ),
                            itemCount: movies.length,
                            itemBuilder: (context, index, _) {
                              Movie movie = movies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(movie: movie)));
                                },
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: <Widget>[
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        // The Center and the SizedBox widet are needed to
                                        // adjust the size of the CircularProgressIndicator
                                        placeholder: (context, url) => Center(
                                          child: SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: Platform.isAndroid
                                                ? CircularProgressIndicator()
                                                : CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/img_not_found.jpg'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 15,
                                        left: 15,
                                      ),
                                      child: Text(
                                        movie.title!.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          // adds black outline to the text
                                          shadows: textOutline,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 12),
                                BuildWidgetCategory(),
                                Text(
                                  'Trending persons this week'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 12),
                                Column(
                                  children: [
                                    BlocBuilder<PersonBloc, PersonState>(
                                        builder: (context, state) {
                                      if (state is PersonLoading) {
                                        return Center();
                                      } else if (state is PersonLoaded) {
                                        List<Person> personList =
                                            state.personList;
                                        // print('PersonList: ${personList.length}');
                                        return Container(
                                            height: 110,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: personList.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      VerticalDivider(
                                                color: Colors.transparent,
                                                width: 10,
                                              ),
                                              itemBuilder: (context, index) {
                                                Person person =
                                                    personList[index];
                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        // Adds shadows to the images
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 5,
                                                                color:
                                                                    Colors.grey,
                                                                spreadRadius: 1)
                                                          ],
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 40.0,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                            'https://image.tmdb.org/t/p/w200${person.profilePath}',
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Center(
                                                        child: Text(
                                                          '${person.name}'
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ));
                                      } else {
                                        return Container();
                                      }
                                    })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text('This broken'),
                      );
                    }
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
