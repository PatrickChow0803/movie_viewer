import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_viewer/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_viewer/bloc/movie_detail_bloc/movie_detail_event.dart';
import 'package:movie_viewer/bloc/movie_detail_bloc/movie_detail_state.dart';
import 'package:movie_viewer/models/movie.dart';
import 'package:movie_viewer/models/movie_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(MovieDetailEventStarted(movie.id!)),
      child: WillPopScope(
        child: Scaffold(
          body: _buildDialogBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDialogBody(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
      if (state is MovieDetailLoading) {
        return Center(
          child: Platform.isAndroid
              ? CircularProgressIndicator()
              : CupertinoActivityIndicator(),
        );
      } else if (state is MovieDetailLoaded) {
        MovieDetail movieDetail = state.detail;
        return Stack(
          children: [
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/original/${movieDetail.backdropPath}',
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/img_not_found.jpg'))),
                ),
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 120),
                  child: GestureDetector(
                    onTap: () async {
                      final youtubeUrl =
                          'https://www.youtube.com/embed/${movieDetail.trailerId}';
                      if (await canLaunch(youtubeUrl)) {
                        await launch(youtubeUrl);
                      }
                    },
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.yellow,
                            size: 65,
                          ),
                          Text(
                            movieDetail.title!.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
