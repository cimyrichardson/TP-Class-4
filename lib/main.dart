import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:HomeScreeen()
    );
  }
}

  // void getValue() async {
  //   final storage = FlutterSecureStorage();
  //   await storage.read(key: 'username');
  // }

class HomeScreeen extends StatelessWidget {
  const HomeScreeen({super.key});

  @override
  Widget build(BuildContext context) {

    final storage = FlutterSecureStorage();

    storage.write(key: 'username', value: 'JohnDoe');

    // ignore: unused_element
    void getValue() async {
    await storage.read(key: 'username');
  }

    return Scaffold(
      appBar: AppBar(title: Text("Classe 4"),),
      body: Container(
        child: Column(
          children: [
            // Image.asset pour charger une image depuis les assets de l'application
            Image.asset(
              'assets/images/tp.png',
            ),

            Divider(),

            // Image.network  pour charger une image depuis une URL

            // Image.network(
            //   'https://sco.wikipedia.org/wiki/Lionel_Messi',
            //   //lazy loading
            //   loadingBuilder: (context, child, loadingProgress){
            //     if(loadingProgress == null){
            //       return child;
            //     }else{
            //       return CircularProgressIndicator();
            //     }
            //   },
            //   width: 320.0,
            //   height: 240.0,
            // ),

            Divider(),

            // Image.file

            // Image.file(File('path/to/your/image.png')),
          ],
        ),
      ),
    );
  }
}