import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/components/add_to_cart.dart';
import 'package:food_app/components/loading.dart';
import 'package:food_app/pages/backend/orders.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<DocumentSnapshot>> _data;
  List<String> cartList = [];

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Food App'),
        elevation: 0.0,
        actions: [
          ElevatedButton.icon(
            label: Text("Admin"),
            icon: Icon(Icons.admin_panel_settings_sharp),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Orders()
                ),
              );
            },
          ),
          ElevatedButton.icon(
            onPressed: (){
              if(cartList.length > 0){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddToCart(cartList: cartList),
                  ),
                );
              }
            },
            icon: Icon(Icons.shopping_cart, color: Colors.white,),
            label: Text(cartList.length != 0 ? cartList.length.toString() : "", style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),)
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async{
              await _auth.signOutAnon();
            },
          )
        ],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // split the data into two lists: one for "chicken" documents and one for "veg" documents
            List<DocumentSnapshot> chickenDocuments = snapshot.data!
                .where((doc) => doc['type'] == 'chicken')
                .toList();
            List<DocumentSnapshot> vegDocuments =
                snapshot.data!.where((doc) => doc['type'] == 'veg').toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  // first row: display "chicken" documents
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text('Chicken', style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),),
                        SizedBox(height: 8),
                        Container(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chickenDocuments.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = chickenDocuments[index];
                              return Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        document['image'],
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 200,
                                      ),
                                    ),
                                    Text(document['name'], style: TextStyle(
                                      fontSize: 18
                                    ),),
                                    ElevatedButton.icon(
                                      label: cartList.contains(document.id) ? Text("") : Text('Add to cart'),
                                      onPressed: () {
                                        // cartList.add(document.id);
                                        setState(() {
                                          if (cartList.contains(document.id)) {
                                            cartList.remove(document.id);
                                          } else {
                                            cartList.add(document.id);
                                          }
                                        });
                                        print(cartList);
                                      },
                                      icon: cartList.contains(document.id) ? Icon(Icons.check_sharp, color: Colors.white) : Icon(Icons.shopping_cart, color: Colors.white,),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // second row: display "veg" documents
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text('Veg', style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),),
                        SizedBox(height: 8),
                        Container(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: vegDocuments.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = vegDocuments[index];
                              return Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        document['image'],
                                        fit: BoxFit.cover,
                                        width: 300,
                                        height: 200,
                                      ),
                                    ),
                                    Text(document['name'], style: TextStyle(
                                        fontSize: 18
                                    ),),
                                    ElevatedButton.icon(
                                      label: cartList.contains(document.id) ? Text("") : Text('Add to cart'),
                                      onPressed: () {
                                        // cartList.add(document.id);
                                        setState(() {
                                          if (cartList.contains(document.id)) {
                                            cartList.remove(document.id);
                                          } else {
                                            cartList.add(document.id);
                                          }
                                        });
                                        print(cartList);
                                      },
                                      icon: cartList.contains(document.id) ? Icon(Icons.check_sharp, color: Colors.white) : Icon(Icons.shopping_cart, color: Colors.white,),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // return loading indicator while data is being fetched
          return Loading();
        },
      ),
    );
  }
}

Future<List<DocumentSnapshot>> fetchData() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot snapshot = await firestore.collection("food").get();
  return snapshot.docs;
}
