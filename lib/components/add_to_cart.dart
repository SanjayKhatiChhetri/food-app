import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/checkout.dart';
import 'package:food_app/components/loading.dart';
import 'package:food_app/pages/frontend/MyHomePage.dart';
import 'package:food_app/pages/services/auth.dart';

class AddToCart extends StatefulWidget {
  final List<String> cartList;
  AddToCart({Key? key, required this.cartList}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> textFieldValue = {};
  Map<String, String> productPrice = {};

  List<Map<String, dynamic>> allOrders = [];
  Map<String, String> everyThing = {};
  Map<String, String> reOne = {};
  double totalCost = 0;

  late List<TextEditingController> controllers;

  reMap() async{
      var firestore = FirebaseFirestore.instance;
      var snapshot = await firestore.collection("food").get();
      int count = 0;
    textFieldValue.forEach((key, value) {
      reOne = {};

      List<DocumentSnapshot> dataByDoc = snapshot.docs.where((element) => element.id == key).toList();

      // reOne['food_id'] = key;
      // reOne['name'] = dataByDoc[0]['type'].substring(0,1).toUpperCase() + dataByDoc[0]['type'].substring(1) + ' ' + dataByDoc[0]['name'];
      // reOne['quantity'] = value;
      // reOne['price'] = productPrice[key]!;
      // allOrders.add(reOne);

      everyThing['food_id $count'] = key;
      everyThing['name $count'] = dataByDoc[0]['type'].substring(0,1).toUpperCase() + dataByDoc[0]['type'].substring(1) + ' ' + dataByDoc[0]['name'];
      everyThing['quantity $count'] = value;
      everyThing['price $count'] = productPrice[key]!;

      count++;
    });
      if(!everyThing.containsKey('toalOrders')){
        everyThing['toalOrders'] = textFieldValue.length.toString();
      }
      // allOrders.add(everyThing);
      // print(everyThing);

  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.cartList.length, (i) => TextEditingController());
  }

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print(textFieldValue);
    print(productPrice);

    total(){
      totalCost = 0;
      for (String id in textFieldValue.keys) {
        int qty = int.parse(textFieldValue[id]!);
        double price = double.parse(productPrice[id]!);
        totalCost += qty * price;
      }

      return totalCost;
    }

    return Scaffold(
        bottomNavigationBar: Container(
          height: 63,
          color: Colors.black12,
          child: InkWell(
            onTap: () => print('tap on close'),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total Cost = ${total()}', style: TextStyle(
                              color: Colors.black,
                              fontSize: 21
                          ),),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      child:
                      GestureDetector(
                        onTap: (){
                          if(totalCost != 0){
                            reMap();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(allOrders: everyThing, totalCost: totalCost,),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.payment_sharp,
                              color: Colors.blue,
                              size: 27,
                            ),
                            Text('Checkout', style: TextStyle(
                                color: Colors.black,
                                fontSize: 18
                            ),)
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),

        appBar: AppBar(
          title: Text('Add to cart'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('food').snapshots(),
            builder: (context, snapshot) {

              if(snapshot.data == null){
                return const Loading();
              }

              List<DocumentSnapshot> cDocuments = snapshot.data!.docs
                  .where((doc) => widget.cartList.contains(doc.id))
                  .toList();

              return snapshot.data == null ? Loading() :
                ListView.builder(
                  itemCount: cDocuments.length,
                  itemBuilder: (context, index) {
                    // print(cDocuments[index]['image']);

                    return ListTile(
                      title:
                      Text(
                          '${cDocuments[index]['type'].substring(0, 1).toUpperCase() + cDocuments[index]['type'].substring(1)} ${cDocuments[index]['name']}',
                        style: TextStyle(
                          fontSize: 21,
                        ),
                      ),
                      subtitle: Text('Price: ${cDocuments[index]['price']}', style: TextStyle(
                        fontSize: 18
                      ),),
                      trailing: SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                              controller: controllers[index],
                                decoration: InputDecoration(hintText: 'Quantity'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if(value.isEmpty){
                                    value = '0';
                                  }
                                  setState(() {
                                    textFieldValue[cDocuments[index].id] = value;
                                    productPrice[cDocuments[index].id] = cDocuments[index]['price'].toString();
                                  });
                                  print(textFieldValue);
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red,),
                                onPressed: () {
                                  setState(() {
                                    widget.cartList.remove(cDocuments[index].id);
                                    textFieldValue.remove(cDocuments[index].id);
                                    productPrice.remove(cDocuments[index].id);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
