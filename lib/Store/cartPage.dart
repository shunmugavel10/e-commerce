// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Address/address.dart';
import 'package:shop_app/Config/config.dart';
import 'package:shop_app/Counters/cartitemCounter.dart';
import 'package:shop_app/Counters/totalMoney.dart';
import 'package:shop_app/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Widgets/customAppBar.dart';
import 'package:shop_app/Widgets/loadingWidget.dart';
import 'package:shop_app/Widgets/myDrawer.dart';
import 'storehome.dart';

class CartItem extends StatefulWidget {
  @override
  _CartItemState createState() => _CartItemState();

  static void addItem(String title, String shortInfo, int price) {}
}

class _CartItemState extends State<CartItem> {
  double totalAmount;

  void iniState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Check Out"),
        backgroundColor: Colors.blue,
        icon: Icon(Icons.navigate_next_outlined),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
            return Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total Price ₹ ${amountProvider.totalAmount.toString()}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        )),
            );
          })),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapShot) {
              return !snapShot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapShot.data.documents.length == 0
                      ? beginbuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                snapShot.data.documents[index].data);

                            if (index == 0) {
                              totalAmount = 0;
                              totalAmount = model.price + totalAmount;
                            } else {
                              totalAmount = model.price + totalAmount;
                            }

                            if (snapShot.data.documents.length - 1 == index) {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false)
                                    .display(totalAmount);
                              });
                            }

                            return sourceInfo(model, context,
                                removeCartFunction: () =>
                                    removeItemFromCart(model.shortInfo));
                          },
                          childCount: snapShot.hasData
                              ? snapShot.data.documents.length
                              : 0,
                        ));
            },
          )
        ],
      ),
    );
  }

  beginbuildingCart() {
    return SliverToBoxAdapter(
        child: Card(
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_emoticon, color: Colors.white),
            Text("Cart is Empty"),
            Text("Start Adding items toyoour cart.")
          ],
        ),
      ),
    ));
  }

  removeItemFromCart(String shortInfoAsId) {
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({EcommerceApp.userCartList: tempCartList}).then((v) {
      Fluttertoast.showToast(msg: 'Item removed from Cart');
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}
