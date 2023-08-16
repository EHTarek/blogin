import 'dart:convert';

import 'package:blogin/navigation/preference_method.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:blogin/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../bloc/login/login_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _employeeIdController = TextEditingController(text: 'tarikul');
  final _passwordController = TextEditingController(text: '1234');
  NotificationService notificationService = NotificationService();
  final db = FirebaseFirestore.instance;

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.setupInteractMessage(context);
    notificationService.foregroundMessage();
    notificationService.isTokenRefreshed();
    notificationService.getDeviceToken().then((value) {
      print('Device Token: $value');
      db.collection('device_token').doc('token').set({'key': value.toString()}).onError(
          (error, _) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString()))));
    });

    getDeviceInfo();
    // context.read<CartItemBloc>().add(CartItemLoadDataEvent());
    userLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          actions: [
            IconButton(
              onPressed: () {
                notificationService.getDeviceToken().then((value) async {
                  var data = {
                    'to': value.toString(),
                    'priority': 'high',
                    'notification': {
                      'title': 'Test notification title',
                      'body': 'Test notification body...'
                    },
                    'data': {'type': 'shopping', 'id': 'abc123'}
                  };
                  await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAP1I-GyI:APA91bEwiBXSfJObP7Hq0W48T2cIG61PtgbsjWNo_eVu1wnF3Gi7SL_tt6gtuXVpUxX3W3P9xEzppGIMlfPmSCwvzb97oNnuKLdHOlVwxsGmjamgd7btidAXWOdKId9sOikbvDp4JRAi'
                    },
                  );
                });
              },
              icon: const Icon(Icons.notifications_active),
            ),
          ],
        ),
        // body: BlocListener<LoginBloc, LoginState>(
        body: BlocConsumer<LoginBloc, LoginState>(
          // listenWhen: (previous, current) => previous != current && previous is LoginInitial,
          listener: (context, loginState) {
            if (loginState is LoginFailure) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loginState.error)),
              );
            }

            if (loginState is LoginInitial) {
              context.loaderOverlay.show();
            }

            if (loginState is LoginSuccess) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful')));

              // Navigator.pushReplacementNamed(context, '/home');
              // Navigator.pushNamed(context, Routes.kHome);
              // Navigator.pushNamed(context, Routes.kShopping);
              Navigator.pushReplacementNamed(context, Routes.kShopping);
            }
          },
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        final employeeId = _employeeIdController.text;
                        final password = _passwordController.text;
                        context.read<LoginBloc>().add(LoginButtonPressed(
                              employeeId: employeeId,
                              password: password,
                            ));
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    print(androidInfo.id);
  }

  void userLoggedIn() async {
    PreferenceMethod preferenceMethod = PreferenceMethod();
    String token = await preferenceMethod.getTokenAccess();
    if (token.isNotEmpty) {
      bool hasExpired = JwtDecoder.isExpired(token);
      if (!hasExpired) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, Routes.kShopping);
        }
      }
    }
  }
}
