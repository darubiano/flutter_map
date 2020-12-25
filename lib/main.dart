import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/src/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/src/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/src/pages/AccesoGPSPage.dart';
import 'package:mapa_app/src/pages/LoadingPage.dart';
import 'package:mapa_app/src/pages/MapaPage.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>MiUbicacionBloc(),),
        BlocProvider(create: (_)=>MapaBloc(),)
      ],
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(
          primaryColor:Colors.blue
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingPage.id,
        routes: {
          LoadingPage.id:(BuildContext context)=> LoadingPage(),
          MapaPage.id:(BuildContext context)=> MapaPage(),
          AccesoGPSPage.id:(BuildContext context)=> AccesoGPSPage(),
        },
      ),
    );
  }
}