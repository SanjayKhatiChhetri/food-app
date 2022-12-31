import 'package:flutter/material.dart';
import 'package:food_app/pages/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import 'MyHomePage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthService>(context).fuser;
    // print('wrapper $user');

    if(user == null){
      return const Authenticate();
    }else{
      return MyHomePage();
    }
  }
}
