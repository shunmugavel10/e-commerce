import 'package:shop_app/Address/addAddress.dart';
import 'package:shop_app/Authentication/authenication.dart';
import 'package:shop_app/Config/config.dart';
import 'package:shop_app/Orders/myOrders.dart';
import 'package:shop_app/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Store/cartPage.dart';


class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 24, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.black
              ,
              gradient: LinearGradient(
                colors: [Colors.greenAccent[200], Colors.blue[100]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
            child: Column(children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(65)),
                elevation: 6,
                child: Container(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                    ),),
                ),
              ),
              SizedBox(height:14),
              Text(
                EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                style: TextStyle(color: Colors.black, fontSize: 23),
              )
            ],),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top:0),
          
            child: Column(children: [
              ListTile(
                leading: Icon(Icons.home, color: Colors.grey),
                title: Text("Home", style: TextStyle(color: Colors.black),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
                },
              ),
              Divider(height:12, color: Colors.grey, thickness: 1),

              

                  ListTile(
                leading: Icon(Icons.reorder, color: Colors.grey),
                title: Text("My Orders", style: TextStyle(color: Colors.black),),
                onTap: () {
                  Route route = MaterialPageRoute(builder: (c)=> OrderPage());
          Navigator.pushReplacement(context, route);  
                }
              ),
              Divider(height:12, color: Colors.grey, thickness: 1),

                  ListTile(
                leading: Icon(Icons.shopping_cart_outlined, color: Colors.grey),
                title: Text("My Cart", style: TextStyle(color: Colors.black),),
                onTap: () {
                  Route route = MaterialPageRoute(builder: (c)=> CartItem());
          Navigator.pushReplacement(context, route);  
                }
              ),
              
              Divider(height:12, color: Colors.grey, thickness: 1),

              ListTile(
                leading: Icon(Icons.location_city_outlined, color: Colors.grey),
                title: Text("Add Address", style: TextStyle(color: Colors.black),),
                onTap: () {
                  Route route = MaterialPageRoute(builder: (c)=> AddAddress());
          Navigator.pushReplacement(context, route);  
                }
              ),
              
              Divider(height:12, color: Colors.grey, thickness: 1),

                  ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.grey),
                title: Text("Logout", style: TextStyle(color: Colors.black),),
                onTap: (){
                  EcommerceApp.auth.signOut().then((c){
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen());
          Navigator.pushReplacement(context, route);  
                  });
                },
              ),
              Divider(height:12, color: Colors.grey, thickness: 1),
            ],),
          )
        ],
      ),
    );
  }
}
