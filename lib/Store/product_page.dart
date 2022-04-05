import 'package:shop_app/Widgets/customAppBar.dart';
import 'package:shop_app/Widgets/myDrawer.dart';
import 'package:shop_app/Models/item.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1,
                          width: double.infinity,
                        ),
                      )
                    ]),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemModel.title,
                              style: boldTextStyle,
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.itemModel.longDescription,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "₹ " + widget.itemModel.price.toString(),
                              style: boldTextStyle,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                          child: InkWell(
                            onTap: () => checkItemInCart(
                                widget.itemModel.shortInfo, context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.greenAccent[200],
                                      Colors.blue[100]
                                    ],
                                    begin: FractionalOffset(0, 1),
                                    end: FractionalOffset(1, 0),
                                    stops: [0, 1],
                                    tileMode: TileMode.clamp,
                                  )),
                              width: MediaQuery.of(context).size.width - 40,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  checkItemInCart(String shortInfo, BuildContext context) {}
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
