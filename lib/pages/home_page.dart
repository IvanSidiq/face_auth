import 'package:face_auth/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic imagePath;
  dynamic faces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaceAuth'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(32.0),
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width,
              //     height: 4 * MediaQuery.of(context).size.height / 8,
              //     child: imagePath != null
              //         ? Column(
              //             children: [
              //               Text(faces),
              //               Image.file(
              //                 File(imagePath),
              //                 fit: BoxFit.cover,
              //               ),
              //             ],
              //           )
              //         : const Center(
              //             child: Text('No image selected'),
              //           ),
              //   ),
              // ),
              ElevatedButton(
                onPressed: () async {
                  GetIt.I<NavigationServiceMain>().pushNamed('/camera');
                },
                child: const Text('Take a picture'),
              ),
              ElevatedButton(
                onPressed: () {
                  GetIt.I<NavigationServiceMain>().pushNamed('/choose_nisn');
                },
                child: const Text('Keyboard'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
