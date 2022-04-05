import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Admin/adminOrderCard.dart';
import 'package:shop_app/Orders/OrderDetailsPage.dart';
import 'package:shop_app/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';


class OrderCard extends StatelessWidget {

  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({Key key, this.itemCount, this.data, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter == 0){
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => OrderDetails(orderID: orderID));
        }
        Navigator.push(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                colors: [Colors.greenAccent[200], Colors.blue[100]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            height: itemCount * 180.0,
            child: ListView.builder(
              itemCount: itemCount,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (c, index){
                ItemModel model = ItemModel.fromJson(data[index].data);
                return sourceOrderInfo(model, context);
              },
            ),
      ),
    );
  }
}



Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
    color: Colors.grey[200],
    height: 180,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 180),
            SizedBox(width: 4),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.shortInfo,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Text(
                                "Total Price: ₹",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                "₹ ",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                              Text(
                                (model.price).toString(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                
                Divider(height: 5, color: Colors.grey)
              ],
            ))
          ],
        ),
  );
}
