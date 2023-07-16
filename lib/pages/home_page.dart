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
  TextEditingController titleEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, homeState) {
        if (homeState is HomeUpdateDone) {
          tempText = homeState.updateText;
        }
        print(tempText);
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(tempText),
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: titleEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (vale){
                    context.read<HomeBloc>().add(HomeTextUpdate(newText: titleEditingController.text));
                  },
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(HomeTextUpdate(newText: titleEditingController.text));
                    },
                    child: const Text('Change App Title'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
