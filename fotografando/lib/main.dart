import 'package:flutter/material.dart';
import 'package:fotografando/principal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    home: home()
  ));
}
