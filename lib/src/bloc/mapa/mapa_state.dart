part of 'mapa_bloc.dart';

@immutable
class MapaState{
  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  // polylines
  final Map<String, Polyline> polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = false,
    this.ubicacionCentral,
    Map<String, Polyline> polylines
  }): this.polylines = polylines ?? new Map();

  copyWith({
    bool mapaListo,
    bool dibujarRecorrido,
    bool seguirUbicacion,
    LatLng ubicacionCentral,
    Map<String, Polyline> polylines
  })=>MapaState(
    mapaListo: mapaListo ?? this.mapaListo,
    ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
    dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
    seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
    polylines:polylines ?? this.polylines
  );
}
