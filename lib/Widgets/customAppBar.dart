import 'package:flutter/material.dart';
import 'package:shop_app/Store/cartPage.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.grey,
        ),
        flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue[200],
              gradient: LinearGradient(
                colors: [Colors.greenAccent[200], Colors.blue[100]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          centerTitle: true,
          title: Text("E-Shopping App", style: TextStyle(color: Colors.black, fontSize: 22,),
          ),
          bottom: bottom,
                    actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartItem());
                  Navigator.pushReplacement(context, route);
                },
                  
                
                ),
                
              ]
            )
          ],
      
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
