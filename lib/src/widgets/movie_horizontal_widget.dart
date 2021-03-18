import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  
  final List<Movie> movies;
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );
  final Function siguientePagina;

  MovieHorizontal({ @required this.movies, @required this.siguientePagina });

  @override
  Widget build(BuildContext context) {

    final _screensize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screensize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        // children: _tarjetas(context),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int i) {
          return _tarjeta(movies[i], context);
        },
        controller: _pageController,
      ),
    );
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   return movies.map((movie) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       child: Column(
  //         children: <Widget>[
  //           Hero(
  //             tag: movie.id,
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(20.0),
  //               child: FadeInImage(
  //                 placeholder: AssetImage('assets/no-image.jpg'), 
  //                 image: NetworkImage(movie.getPosterImg()),
  //                 fit: BoxFit.cover,
  //                 height: 160.0,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 5.0,),
  //           Text(
  //             movie.originalTitle,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }

  Widget _tarjeta(Movie movie, BuildContext context) {
    movie.uniqueId = '${movie.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            movie.originalTitle,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: movie)
    );
  }
}