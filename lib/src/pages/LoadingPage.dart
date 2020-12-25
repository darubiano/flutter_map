import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapa_app/src/helpers/NavegarFadeIn.dart';
import 'package:mapa_app/src/pages/AccesoGPSPage.dart';
import 'package:mapa_app/src/pages/MapaPage.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  static const String id = 'Loading';

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if(state == AppLifecycleState.resumed){
      if(await GeolocatorPlatform.instance.isLocationServiceEnabled()){
        Navigator.pushReplacement(context, navegarFadeIn(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkGPS(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            return Center(child:Text(snapshot.data));
          }else{
            return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    CircularProgressIndicator(strokeWidth: 2),
                    CircularProgressIndicator(strokeWidth: 2),
                  ],
                ),
                CircularProgressIndicator(strokeWidth: 2),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future checkGPS(BuildContext context) async {
    //Permiso GPS
    final permisosGPS = await Permission.location.isGranted;
    //GPS activo
    final gpsActivo = await GeolocatorPlatform.instance.isLocationServiceEnabled();
    if(permisosGPS && gpsActivo){
      Navigator.pushReplacement(context, navegarFadeIn(context, MapaPage()));
      return '';
    }else if(!permisosGPS){
      Navigator.pushReplacement(context, navegarFadeIn(context, AccesoGPSPage()));
      return 'Es necesario el permiso GPS';
    }else {
      return 'Active el GPS';
    }
  }
}
