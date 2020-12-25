import 'package:flutter/material.dart';
import 'package:mapa_app/src/pages/LoadingPage.dart';
import 'package:mapa_app/src/pages/MapaPage.dart';
import 'package:permission_handler/permission_handler.dart';

class AccesoGPSPage extends StatefulWidget {
  static const String id = 'AccesoGPS';
  @override
  _AccesoGPSPageState createState() => _AccesoGPSPageState();
}

class _AccesoGPSPageState extends State<AccesoGPSPage> with WidgetsBindingObserver{

  bool popup = false;

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
    print('=>>> $state');
    if(state == AppLifecycleState.resumed && !popup){
      if(await Permission.location.isGranted){
        Navigator.pushReplacementNamed(context, LoadingPage.id);
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta app'),
            MaterialButton(
              child: Text('Solicitar Acceso',
                  style: TextStyle(color: Colors.white)),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              onPressed: () async{
                popup = true;
                final status = await Permission.location.request();
                await accesoGPS(status);
                popup = false;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future accesoGPS( PermissionStatus status) async{
    switch (status) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, LoadingPage.id);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.undetermined:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        break;
    }
  }
}
