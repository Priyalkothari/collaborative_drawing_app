import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/drawing_screen.dart';
import 'viewModel/drawing_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBAxPcWkB1g4PdFNrIWeJ5EqMe_Z21fu-U',
        appId: '1:1014528668729:android:533efd07d5dedd0cb449e8',
        messagingSenderId: '1014528668729',
        projectId: 'drawingapp-e760d',
        storageBucket: 'drawingapp-e760d.firebasestorage.app',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DrawingViewModel(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Collaborative Drawing App',
        home: DrawingScreen(),
      ),
    );
  }
}
