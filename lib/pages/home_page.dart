import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: LoaderOverlay(
        child: Center(
          child: ElevatedButton(onPressed: (){
            // context.loaderOverlay.show();
            // context.loaderOverlay.hide();
          }, child: Text('Click'),),
        ),
      ),
    );
  }
}
