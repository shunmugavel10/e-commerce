import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Widgets/loadingWidget.dart';
import 'package:shop_app/Widgets/orderCard.dart';
import '../Store/storehome.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Colors.blue[200],
              gradient: LinearGradient(
                colors: [Colors.greenAccent[200], Colors.blue[100]],
                begin: FractionalOffset(0, 1),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              )),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => StoreHome());
            Navigator.pushReplacement(context, route);
          },
        ),
        centerTitle: true,
        title: Text(
          "My Order",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: EcommerceApp.firestore
            .collection(EcommerceApp.collectionUser)
            .document(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
            .collection(EcommerceApp.collectionOrders)
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance
                          .collection("items")
                          .where("shortInfo",
                              whereIn: snapshot.data.documents[index]
                                  .data[EcommerceApp.productID])
                          .getDocuments(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? OrderCard(
                                itemCount: snap.data.documents.length,
                                data: snap.data.documents,
                                orderID:
                                    snapshot.data.documents[index].documentID,
                              )
                            : Center(
                                child: circularProgress(),
                              );
                      },
                    );
                  },
                )
              : Center(
                  child: circularProgress(),
                );
        },
      ),
    );
  }
}
