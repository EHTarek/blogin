import 'package:blogin/navigation/preference_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String tempText = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        if (homeState is HomeUpdateDone) {
          tempText = homeState.updateText;
        } else {
          tempText = 'Not updated';
        }
        print(tempText);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: () async {
                  PreferenceMethod preferenceMethod = PreferenceMethod();
                  print('Home Page');
                  String token = await preferenceMethod.getTokenAccess();
                  print(token);
                  // context.loaderOverlay.show();
                  // context.loaderOverlay.hide();
                },
                icon: const Icon(Icons.get_app),
              ),
            ],
          ),
          body: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, homeState) {
              if (homeState is HomeUpdateDone) {
                tempText = homeState.updateText;
              } else {
                tempText = 'Not updated';
              }
              print(tempText);
            },
            builder: (context, state) {
              return Column(
                children: [
                  Text(tempText),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Change App Title'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
