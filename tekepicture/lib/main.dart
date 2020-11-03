import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:tekepicture/principal.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`

  WidgetsFlutterBinding.ensureInitialized();
/*
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
*/
  runApp(MaterialApp(
      debugShowCheckedModeBanner: true,
      home: home() //principal(camera: firstCamera),
      ));
}
