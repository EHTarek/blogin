import 'package:blogin/app_observer.dart';
import 'package:blogin/bloc/cart_item/cart_item_bloc.dart';
import 'package:blogin/bloc/message/message_bloc.dart';
import 'package:blogin/bloc/mqtt_bloc/mqtt_bloc.dart';
import 'package:blogin/navigation/route_generator.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import 'bloc/home/home_bloc.dart';
import 'bloc/login/login_bloc.dart';

// ToDo: name route, onGenerate route, go route, BlocConsumer, BlocObserver, Repository Pattern, Internet State checker,

main() {
  Bloc.observer = const AppObserver();

  /* final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  final allInfo = deviceInfo.data;

  print(allInfo);*/

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
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(),
        ),
        BlocProvider<CartItemBloc>(
          create: (context) => CartItemBloc(),
        ),
        BlocProvider<MqttBloc>(
          create: (context) => MqttBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Login App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.kRoot,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
