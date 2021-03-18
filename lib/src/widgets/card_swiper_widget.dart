import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Movie> peliculas;

  CardSwiper({@required this.peliculas });

  @override
  Widget build(BuildContext context) {

    // con esto obtenemos las dimensiones del telefono
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-card';
          return Hero(
            tag: peliculas[index].uniqueId,
            child: GestureDetector(
              onTap: () {
                print('Hizo click a ${peliculas[index].originalTitle}');
                Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: AssetImage('assets/no-image.jpg'),
                  fit: BoxFit.cover,
                )
              ),
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl()
      ),
    );
  }
}