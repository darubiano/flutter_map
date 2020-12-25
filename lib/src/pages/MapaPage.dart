import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/src/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/src/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapa_app/src/widgets/LocationButton.dart';
import 'package:mapa_app/src/widgets/RutaButtton.dart';
import 'package:mapa_app/src/widgets/SeguirButton.dart';

class MapaPage extends StatefulWidget {
  static const String id = 'Mapa';

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
          builder: (_, state) => crearMapa(state),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            LocationButton(),
            SeguirButton(),
            RutaButton(),
          ],
        ),
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    if (!state.existeUbicacion){
      return Center(
        child: Text("Ubicando dispositivo"),
      );
    }else{
      final mapaBloc = BlocProvider.of<MapaBloc>(context);
      mapaBloc.add(OnNuevaUbicacion(state.ubicacion));
      final cameraPosition = new CameraPosition(
        target: state.ubicacion,
        zoom: 15,
      );
      return GoogleMap(
        initialCameraPosition: cameraPosition,
        //mapType: MapType.normal,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller){
          mapaBloc.initMapa(controller);
        },
        polylines: mapaBloc.state.polylines.values.toSet(),
        onCameraMove: (position){
          // obtener la posicion del centro de la camara cada vez que se mueve
          mapaBloc.add(OnMovioMapa(position.target));
        },
        onCameraIdle: (){
          // Cuando la camara se queda quieta
          print('MapaIDle');
        },
      );
    }
  }
}
