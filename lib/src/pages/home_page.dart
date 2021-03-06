import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/movie_model.dart';
import 'package:peliculas_app/src/providers/movies_provider.dart';
import 'package:peliculas_app/src/search/search_delegate.dart';
import 'package:peliculas_app/src/widgets/card_swiper_widget.dart';
import 'package:peliculas_app/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatelessWidget {

  final _moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    _moviesProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        title: Text('In Cinemas'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch()
              );
            }
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      )
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: _moviesProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            peliculas: snapshot.data,
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Popular', style: Theme.of(context).textTheme.subtitle1,)
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: _moviesProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  movies: snapshot.data,
                  siguientePagina: _moviesProvider.getPopulares,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator()
                );
              }
            },
          ),
        ],
      ),
    );
  }

}