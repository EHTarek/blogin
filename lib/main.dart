import 'package:blogin/app_observer.dart';
import 'package:blogin/navigation/route_generator.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'login/login_bloc.dart';

// ToDo: name route, onGenerate route, go route, BlocConsumer, BlocObserver, Repository Pattern, Internet State checker,

void main() {
  Bloc.observer = const AppObserver();
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
      ],
      child: GlobalLoaderOverlay(
        child: MaterialApp(
          title: 'Login App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: Routes.kHome,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
