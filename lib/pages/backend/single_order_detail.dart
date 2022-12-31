import 'package:flutter/material.dart';

class SingleOrderDetail extends StatefulWidget {
  final data;
  const SingleOrderDetail({Key? key, this.data}) : super(key: key);

  @override
  State<SingleOrderDetail> createState() => _SingleOrderDetailState();
}

class _SingleOrderDetailState extends State<SingleOrderDetail> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${widget.data['user_name']}', style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                  ),),
                  SizedBox(height: 6,),
                  Text('Address: ${widget.data['address']}', style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                  ),),
                  SizedBox(height: 6,),
                  Text('Total Cost: ${widget.data['totalCost']}', style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                  ),),
                  SizedBox(height: 27,),
                  Center(
                    child: Text('Total Orders: ${widget.data['toalOrders']}', style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      color: Colors.blue
                    ),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: int.parse(widget.data["toalOrders"]),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.data['name $index']}', style: TextStyle(
                                    fontSize: 27,
                                    letterSpacing: 2
                                ),),
                                SizedBox(height: 8,),
                                Text('Quantity: ${widget.data['quantity $index']}', style: TextStyle(
                                    fontSize: 27,
                                    letterSpacing: 2
                                ),),
                                SizedBox(height: 8,),
                                Text('Price: ${widget.data['price $index']}', style: TextStyle(
                                    fontSize: 27,
                                    letterSpacing: 2
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
              ),
            )

          ],
        ),
      )
    );
  }
}
