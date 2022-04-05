import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Config/config.dart';
import 'package:shop_app/Models/address.dart';
import 'package:shop_app/Orders/placeOrderPayment.dart';
import 'package:shop_app/Widgets/customAppBar.dart';
import 'package:shop_app/Widgets/loadingWidget.dart';
import 'package:shop_app/Widgets/wideButton.dart';
import 'package:shop_app/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{

  final double totalAmount;
  const Address({ Key key, this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(padding: EdgeInsets.all(8),
              child: Text(
                "Select Address",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),

              ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c){
              return Flexible(child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.subCollectionAddress).snapshots(),

                builder: (context, snapshot){
                  return !snapshot.hasData ? Center(
                    child: circularProgress(),
                  ) : snapshot.data.documents.length == 0 ? noAddressCard() : ListView.builder(
                    itemCount:snapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return AddressCard(
                        currentIndex: address.count,
                        value: index,
                        addressId: snapshot.data.documents[index].documentID,
                        totalAmount: widget.totalAmount,
                        model: AddressModel.fromJson(snapshot.data.documents[index].data),
                      );
                    }, );
                },
              ));
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          Route route =
          MaterialPageRoute(builder: (c) => AddAddress());
      Navigator.pushReplacement(context, route);
        }, 
        label: Text("Add New Address"),
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add_location_outlined),),
      ),

    );
  }

  noAddressCard() {
    return Card(
      color: Colors.blue,
      child: Container(
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_outlined, color: Colors.white),
            Text("Shippment Not saved"),
            Text("Add shippment address"),
        ],),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {

  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;


  AddressCard({Key key, this.model,this.addressId,this.totalAmount,this.currentIndex,this.value}) : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context, listen: false).displayResylt(widget.value);

      },
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.blueAccent,
                  onChanged: (val){
                    Provider.of<AddressChanger>(context, listen: false).displayResylt(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name"),
                              Text(widget.model.name)
                            ]
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "Phone Number"),
                              Text(widget.model.phoneNumber)
                            ]
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "House Number"),
                              Text(widget.model.flatNumber)
                            ]
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "City"),
                              Text(widget.model.city)
                            ]
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "State"),
                              Text(widget.model.state)
                            ]
                          ),
                          TableRow(
                            children: [
                              KeyText(msg: "PinCode"),
                              Text(widget.model.pincode)
                            ]
                          ),
                          
                        ]
                      )
                    )
                  ],
                )
              ]
            ),
            widget.value == Provider.of<AddressChanger>(context).count ?
            WideButton(
              message: "Proceed",
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => PaymentPage(
                  addressId: widget.addressId,
                  totalAmount: widget.totalAmount,
                ));
                Navigator.push(context, route);
              },
            ) : Container()
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {

  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
    );
  }
}