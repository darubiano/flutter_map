import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/src/bloc/mapa/mapa_bloc.dart';

class RutaButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    return Container(
      margin: EdgeInsets.only(bottom:10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius:25,
        child:IconButton(
          icon:Icon(Icons.more_horiz, color:Colors.black87),
          onPressed: (){
            mapaBloc.add(OnMarcarRecorrido());
          },
        )
      ),
    );
  }
}