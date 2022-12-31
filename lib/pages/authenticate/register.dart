import 'package:flutter/material.dart';
import 'package:food_app/components/constants.dart';
import 'package:food_app/components/loading.dart';

import '../services/auth.dart';

class Register extends StatefulWidget {
  final Function toogleView;

  const Register({Key? key, required this.toogleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign up'),
        actions: [
          ElevatedButton.icon(
              onPressed: () async{
                widget.toogleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign in'))
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 18.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val){
                    if (val != null && val.isEmpty) {
                      return "Enter an email";
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 18.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                  validator: (val){
                    if (val != null && val.length < 6) {
                      return "Enter an password with at least 6+ characters long";
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 18.0,),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue)
                    ),
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            error = "please supply a valid email";
                            loading = false;
                          });
                        }
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),

                SizedBox(height: 12.0,),
              Text(
              error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0
                ),
          )


              ],
            ),
          )
      ),
    );
  }
}
