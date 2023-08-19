import 'package:logger/logger.dart';

dynamic Log(dynamic log) {
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 1,
        // Number of method calls to be displayed
        errorMethodCount: 8,
        // Number of method calls if stacktrace is provided
        lineLength: 220,
        // Width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  logger.d(log);
}
