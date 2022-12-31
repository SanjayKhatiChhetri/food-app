import 'package:flutter/material.dart';
import 'package:food_app/components/loading.dart';
import 'package:food_app/pages/services/auth.dart';
import 'package:food_app/components/constants.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;
  const SignIn({Key? key, required this.toogleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign in'),
        actions: [
          ElevatedButton.icon(
              onPressed: () async{
                widget.toogleView();
              },
              icon: Icon(Icons.person),
              label: Text('Register'))
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
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                      if(result == null){
                        setState(() {
                          error = "COULD NOT SIGN IN WITH THOSE CREDENTIALS";
                          loading = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    'Sign in',
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
