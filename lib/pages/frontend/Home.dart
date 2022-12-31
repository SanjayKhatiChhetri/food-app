import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<List<DocumentSnapshot>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // do something with the data
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data![index];

                  if (document['type'] == "chicken") {
                    return Column(
                      children: [
                        Text(document['name']),
                        Text(document['type']),
                      ],
                    );
                  }
                  else if( document['type'] == "veg" ){
                    return Column(
                      children: [
                        Text(document['name']),
                        Text(document['type']),
                      ],
                    );
                  }
                  return Container();
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // return loading indicator while data is being fetched
            return Center(child: CircularProgressIndicator());
          },
        )
    );
  }
}

Future<List<DocumentSnapshot>> fetchData() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot snapshot = await firestore.collection("food").get();
  return snapshot.docs;
}

