import 'package:flutter/material.dart';
import 'package:peliculas_app/src/pages/detail_page.dart';

import 'package:peliculas_app/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => MovieDetail(),
      } 
    );
  }
}
