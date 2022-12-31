import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/frontend/MyHomePage.dart';
import 'package:food_app/pages/frontend/wrapper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../pages/services/auth.dart';
import 'constants.dart';

class Checkout extends StatefulWidget {
  // final orders;
  final totalCost;
  final allOrders;
  const Checkout({Key? key, this.allOrders, this.totalCost, }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String mobileNumber = '';
  String address = '';

  Map<String, String> entryPoint = {};

  late String lat;
  late String long;
  String error = '';

  Future<Position> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Locations permissions are denied");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permission are permanently denied, we cannot request permissions");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthService>(context).fuser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 18.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Full Name"),
                  validator: (val){
                    if (val != null && val.isEmpty) {
                      return "Enter your Name";
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      fullName = val;
                    });
                  },
                ),

                SizedBox(height: 18.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Mobile Number"),
                  validator: (val){
                    if (val != null && val.isEmpty) {
                      return "Enter your Mobile Number";
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      mobileNumber = val;
                    });
                  },
                ),

                SizedBox(height: 18.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Address"),
                  validator: (val){
                    if (val != null && val.isEmpty) {
                      return "Enter your Address";
                    }
                    return null;
                  },
                  onChanged: (val){
                    setState(() {
                      address = val;
                    });
                  },
                ),

                SizedBox(height: 18.0,),
                ElevatedButton.icon(
                  onPressed: () async{
                    await _getCurrentLocation().then((value) {
                      setState(() {
                      lat = '${value.latitude}';
                      long = '${value.longitude}';
                      });
                    });

                    print(lat);
                    print(long);
                  },
                  icon: Icon(Icons.location_on),
                  label: Text("Allow Your GPS location"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                  ),
                ),

                SizedBox(height: 18.0,),
                ElevatedButton(
                  onPressed: () async{

                    if(_formKey.currentState!.validate()){
                      if(error.isNotEmpty){
                        setState(() {
                          error = "";
                        });
                        DateTime currentDate = DateTime.now();

                        for(int i=0; i < int.parse(widget.allOrders['toalOrders']); i++){
                          entryPoint['food_id $i'] = widget.allOrders['food_id $i'];
                          entryPoint['name $i'] = widget.allOrders['name $i'];
                          entryPoint['quantity $i'] = widget.allOrders['quantity $i'];
                          entryPoint['price $i'] = widget.allOrders['price $i'];
                        }
                        entryPoint['toalOrders'] = widget.allOrders['toalOrders'];
                        entryPoint['user_id'] = user?.uid as String;
                        entryPoint['user_name'] = fullName;
                        entryPoint['mobile'] = mobileNumber;
                        entryPoint['address'] = address;
                        entryPoint['latitude'] = lat;
                        entryPoint['longitude'] = long;
                        entryPoint['totalCost'] = widget.totalCost.toString();
                        entryPoint['created_at'] = currentDate.toIso8601String();
                        entryPoint['status'] = 'null';

                        FirebaseFirestore.instance.collection('data').add(entryPoint).then((value) {

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
                              ModalRoute.withName('/home')
                          );

                        }).catchError((error) {
                          print('Error: $error');
                        });
                      }
                      else{
                        setState(() {
                          error = "Please Allow Your GPS location";
                        });
                      }
                    }
                  },
                  child: Text('Submit')
                ),

                SizedBox(height: 27.0,),
                Text(
                  error,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0
                  ),
                )

              ],
            )
          ),
        ),
      ),
    );
  }
}
