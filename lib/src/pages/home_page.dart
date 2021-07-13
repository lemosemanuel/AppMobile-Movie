import 'package:flutter/material.dart';
import 'package:proyectopeliculas/src/models/pelicula_model.dart';
import 'package:proyectopeliculas/src/providers/peliculas_providers.dart';
import 'package:proyectopeliculas/src/search/search_delegate.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:proyectopeliculas/src/widgets/card_swiper.dart';
import 'package:proyectopeliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopular();
    return Scaffold(
      appBar: AppBar(
          title: Text('Catalogo Pelis'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
              onPressed: () {
                // showSearch(context: context, delegate: delegate)
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(Icons.search),
            ),
          ]),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(
            height: 5,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStram,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopular,
                );
              } else {
                return Container(
                    height: 400.0,
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          )
        ],
      ),
    );
  }
}
