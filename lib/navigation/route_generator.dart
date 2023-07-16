import 'package:blogin/navigation/routes.dart';
import 'package:blogin/pages/home_page.dart';
import 'package:blogin/pages/login_page.dart';
import 'package:blogin/pages/message_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.kRoot:
        return MaterialPageRoute(builder: (_) => const LoginPage());
/*      case Routes.kHome:
          return MaterialPageRoute(
            builder: (_) => HomePage(
              token: args as String,
            ),
          );*/

      case Routes.kHome:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.kMessage:
        return MaterialPageRoute(builder: (_) => const MessagePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Route Error'),
        ),
      );
    });
  }
}
