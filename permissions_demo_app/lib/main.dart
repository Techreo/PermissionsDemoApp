import 'package:flutter/material.dart';
import 'package:permissions_demo_app/biometrics.dart';
import 'package:permissions_demo_app/camera.dart';
import 'package:permissions_demo_app/geolocation.dart';
import 'package:permissions_demo_app/network.dart';
import 'package:permissions_demo_app/storage.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Permissions Demo',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Demo'),
      ),
      body: Center(
          child: Wrap(
            spacing: 20, // to apply margin in the main axis of the wrap
            runSpacing: 20, // to apply margin in the cross axis of the wrap
            children: <Widget>[
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Biometrics'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Biometrics()),
                      );
                    },
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Camera'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Camera()),
                      );
                    },
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Geolocation'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Geolocation()),
                      );
                    },
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Storage'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Storage()),
                      );
                    },
                  )
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Upload / Download files'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Network()),
                      );
                    },
                  )
              )
            ],
          )
      ),
    );
  }
}