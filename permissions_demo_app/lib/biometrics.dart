import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Biometrics extends StatefulWidget {
  const Biometrics({Key? key}) : super(key: key);

  @override
  _BiometricsState createState() => _BiometricsState();
}
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometrics'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }*/

class _BiometricsState extends State<Biometrics> {
  late LocalAuthentication _localAth;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _localAth = LocalAuthentication();
    _localAth.canCheckBiometrics.then((b) {
      setState(() {
        _isBiometricAvailable = b;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Location"),
        ),
        body: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text("Verificar huella digital"),
              onPressed: () async {
                if(_isBiometricAvailable) {
                  bool didAuthenticate = await _localAth
                      .authenticateWithBiometrics(
                      localizedReason: "Iniciar sesion con huella");
                  if (didAuthenticate) {
                    mostrarAlerta(context, "Autenticación correcta");
                  } else {
                    mostrarAlerta(context, "Autenticación incorrecta");
                  }
                }else{
                  mostrarAlerta(context, "el dispositivo no cuenta con esta función");
                }
              },
              //icon: const Icon( Icons.fingerprint,),
            ),
          ),
        ),
    );
  }

  void mostrarAlerta(BuildContext context, String texto){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Autenticación"),
          content: Text(texto),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("OK")
            )
          ],
        );
      },
    );
  }
}