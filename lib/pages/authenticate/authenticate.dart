import 'package:flutter/material.dart';
import 'package:food_app/pages/authenticate/register.dart';
import 'package:food_app/pages/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toogleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(showSignIn){
      return SignIn(toogleView: toogleView);
    }else{
      return Register(toogleView: toogleView);
    }


  }
}
