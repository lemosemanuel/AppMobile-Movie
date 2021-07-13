import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyectopeliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;
  MovieHorizontal({required this.peliculas, required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // este page controller se va a disparar cada vez que mueva el scroll horizontal
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent) siguientePagina();
    });
    return Container(
      //necesito que sea el 20% de la tarjeta de arriba
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, i) {
          return crearTarjeta(context, peliculas[i]);
        },
        controller: _pageController,
        // children: _tajertas(context),
      ),
    );
  }

  Widget crearTarjeta(BuildContext context, Pelicula e) {
    e.uniqueId = '${e.id}-poster';

    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      // vamos a mostrar las imagenes en el chil
      child: Column(
        children: [
          Hero(
            tag: e.uniqueId.toString(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/no-image.jpg"),
                image: NetworkImage(e.getPosterImg()),
                fit: BoxFit.cover,
                height: 160,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            e.title.toString(),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(
          context,
          'detalle',
          arguments: e,
        );
        print('ID de la pelicula ${e.title}');
      },
    );
  }

  // List<Widget> _tajertas(BuildContext context) {
  //   return peliculas.map((e) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       // vamos a mostrar las imagenes en el chil
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20),
  //             child: FadeInImage(
  //               placeholder: AssetImage("assets/no-image.jpg"),
  //               image: NetworkImage(e.getPosterImg()),
  //               fit: BoxFit.cover,
  //               height: 160,
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Text(
  //             e.title.toString(),
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
