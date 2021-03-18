import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas_app/src/models/actor_model.dart';
import 'package:peliculas_app/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Movie> _populares = new List();

  final _popularesStreamController = StreamController<List<Movie>>.broadcast(); // se pone el .broadcast para que muchas personas
  // puedan escuchar el stream

  // Para introducir los datos
  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;

  // Para escuchar los datos
  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close(); // se pone el ? por si el stream es null
  }

  Future<List<Movie>> _processResp(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  // Obtener peliculas que estan en carteleras
  Future<List<Movie>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });
    return await _processResp(url);
  }

  // Obtener peliculas populares
  Future<List<Movie>> getPopulares() async {

    if (_cargando) {
      return [];
    } else {
      _cargando = true;
      _popularesPage++;

      print('Cargando siguientes');

      final url = Uri.https(_url, '3/movie/popular', {
        'api_key': _apiKey,
        'language': _language,
        'page': _popularesPage.toString()
      });

      final resp = await _processResp(url);

      _populares.addAll(resp);
      popularesSink(_populares);

      _cargando = false;

      return resp;
    }
  }

  // Obtener el cast de una pelicula especifica
  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language
    });
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }

  // Buscar la pelicula a traves de TheMovieDB
  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    return await _processResp(url);
  }
}