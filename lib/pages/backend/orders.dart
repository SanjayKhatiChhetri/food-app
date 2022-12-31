import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/backend/map_delivery.dart';
import 'package:food_app/pages/backend/single_order_detail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/loading.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  late Future<List<DocumentSnapshot>> _data;

  late String lat;
  late String long;
  String error = '';

  late LatLng currentLocation;
  late LatLng destinationLocation;

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
  void initState() {
    super.initState();
    _data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
          future: _data,
          builder: (context, snapshot){

            // print(snapshot.data?[0]['latitude']);

            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {

                return snapshot.data == null ? Loading() :
                  ListTile(
                  title: Text(snapshot.data![index]['user_name']),
                  subtitle: Text('Total Orders = ${snapshot.data![index]['toalOrders']}'),
                    trailing: SizedBox(
                      width: 250,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleOrderDetail(data: snapshot.data![index],)
                                ),
                              );
                            },
                            child: Text('See All'),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              backgroundColor: MaterialStateProperty.all(Colors.blue)
                            ),
                          )),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                            onPressed: () async{

                              await _getCurrentLocation()
                                .then((value) {

                                  setState(() {
                                    lat = '${value.latitude}';
                                    long = '${value.longitude}';
                                  });
                                });

                              if(lat.isNotEmpty && long.isNotEmpty){

                                setState(() {
                                  destinationLocation = LatLng(
                                      double.parse(snapshot.data![index]['latitude']),
                                      double.parse(snapshot.data![index]['longitude'])
                                  );

                                  currentLocation = LatLng(
                                      double.parse(lat),
                                      double.parse(long)
                                  );
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapDelivery(
                                      currentLocation: currentLocation,
                                      destinationLocation: destinationLocation,
                                    ),
                                  ),
                                );

                              }

                            },
                            label: Text('Deliver Now'),
                            icon: Icon(Icons.delivery_dining),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(Colors.red)
                            ),
                          )),

                          SizedBox(width: 10,),
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
                );
              },
            );
          }
      )


    );
  }
}

Future<List<DocumentSnapshot>> fetchData() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot snapshot = await firestore.collection("data").orderBy('created_at', descending: true).get();
  return snapshot.docs;
}