import 'package:logger/web.dart';

var logging = Logger(
  level: Level.info,
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 8)
);
