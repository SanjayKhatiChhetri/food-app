import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/add_to_cart.dart';
import 'package:food_app/models/user.dart';
import 'package:food_app/pages/authenticate/authenticate.dart';
import 'package:food_app/pages/backend/orders.dart';

import 'package:food_app/pages/frontend/Home.dart';

import 'package:food_app/pages/frontend/MyHomePage.dart';
import 'package:food_app/pages/frontend/wrapper.dart';
import 'package:food_app/pages/services/auth.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      // value: AuthService().user,
      // initialData: null,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // define the routes
        routes: {
          '/': (context) => Wrapper(),
          '/auth': (context) => Authenticate(),
          '/orders': (context) => Orders(),
          '/home': (context) => MyHomePage()
        },
        // set the initial route
        initialRoute: '/',
      ),
    );
  }
}