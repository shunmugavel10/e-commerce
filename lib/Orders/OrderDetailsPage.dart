import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/Address/address.dart';
import 'package:shop_app/Config/config.dart';
import 'package:shop_app/Widgets/loadingWidget.dart';
import 'package:shop_app/Widgets/orderCard.dart';
import 'package:shop_app/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/main.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({Key key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹" +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Ordered At:" +
                                  DateFormat("dd mmm, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          Divider(height: 2),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents)
                                  : Center(child: circularProgress());
                            },
                          ),
                          Divider(height: 2),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(child: circularProgress());
                            },
                          )
                        ],
                      ),
                    )
                  : Center(child: circularProgress());
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    // ignore: unnecessary_statements
    status ? iconData = Icons.done : Icons.cancel_outlined;
    status ? msg = "Successfull" : msg = "Unsuccessfull";
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[200],
          gradient: LinearGradient(
            colors: [Colors.greenAccent[200], Colors.blue[100]],
            begin: FractionalOffset(0, 1),
            end: FractionalOffset(1, 0),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          )),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(),
          ),
          SizedBox(width: 20),
          Text(
            "Order placed " + msg,
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(width: 5),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.black,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            "Shipping Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
            width: screenWidth,
            child: Table(children: [
              TableRow(children: [KeyText(msg: "Name"), Text(model.name)]),
              TableRow(children: [
                KeyText(msg: "Phone Number"),
                Text(model.phoneNumber)
              ]),
              TableRow(children: [
                KeyText(msg: "House Number"),
                Text(model.flatNumber)
              ]),
              TableRow(children: [KeyText(msg: "City"), Text(model.city)]),
              TableRow(children: [KeyText(msg: "State"), Text(model.state)]),
              TableRow(
                  children: [KeyText(msg: "PinCode"), Text(model.pincode)]),
            ])),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmedUserOrderRecieved(context, getOrderId);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                      colors: [Colors.greenAccent[200], Colors.blue[100]],
                      begin: FractionalOffset(0, 1),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    )),
                width: MediaQuery.of(context).size.width - 50,
                child: Center(
                  child: Text(
                    "Order Again",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmedUserOrderRecieved(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Order Confirmed");
  }
}
