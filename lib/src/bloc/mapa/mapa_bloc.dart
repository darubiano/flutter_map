import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/src/themes/UberMap.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());
  // Controlador del mapa
  GoogleMapController _mapController;

  // Polylines
  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'),
    color: Colors.transparent,
    width: 4,
  );


  void initMapa(GoogleMapController controller){
    if(!state.mapaListo){
      _mapController = controller;
      _mapController.setMapStyle(jsonEncode(uberMap));
    }
    add(OnMapaListo());
  }

  void moverCamara(LatLng destino){
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {

    if(event is OnMapaListo){
      print('Mapa listo');
      yield state.copyWith(mapaListo: true);

    } else if(event is OnNuevaUbicacion){
      yield* _onNuevaUbicacion(event);

    }else if(event is OnMarcarRecorrido){
      yield* _onMarcarRecorrido(event);

    }else if (event is OnSeguirUbicacion){
      if (!state.seguirUbicacion){
        moverCamara(_miRuta.points[_miRuta.points.length-1]);
      }
      yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
    } else if (event is OnMovioMapa){
      print(event.centroMapa);
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async*{
      if (state.seguirUbicacion){
        moverCamara(event.ubicacion);
      }
      //print("Nueva ubicacion: ${event.ubicacion}");
      List<LatLng> points = [..._miRuta.points, event.ubicacion];
      _miRuta = _miRuta.copyWith(pointsParam: points);

      final currentPolylines = state.polylines;
      currentPolylines['mi_ruta'] = _miRuta;

      yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async*{
    if(!state.dibujarRecorrido){
      _miRuta = _miRuta.copyWith(colorParam:Colors.black87);
    }else{
      _miRuta = _miRuta.copyWith(colorParam:Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    
    yield state.copyWith(polylines: currentPolylines,
      dibujarRecorrido: !state.dibujarRecorrido);
  }

}
