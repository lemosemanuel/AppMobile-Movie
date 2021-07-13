import 'dart:async';
import 'dart:convert';

import 'package:proyectopeliculas/src/models/actores_model.dart';
import 'package:proyectopeliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = 'b8a8b5a17d6617fa6ad022de5d11929d';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-Es';

  int _popularesPage = 0;
  bool _cargando = false;

  // manejo del stream
  List<Pelicula> _populares = [];

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();
  // el sink es para insertar info
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  // stream para escuchar
  Stream<List<Pelicula>> get popularesStram =>
      _popularesStreamController.stream;

  void disposeStrams() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _lenguage});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopular() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _lenguage,
      'page': _popularesPage.toString()
    });
    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    // utilizo el sink para mandarlo
    popularesSink(_populares);
    _cargando = false;
    return respuesta;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _lenguage});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _lenguage, 'query': query});

    return await _procesarRespuesta(url);
  }
}
