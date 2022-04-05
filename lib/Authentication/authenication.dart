import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';



class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue[200],
              gradient: LinearGradient(
                colors: [Colors.blue[100], Colors.greenAccent[200]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          title: Text("E-Shopping App", style: TextStyle(color: Colors.black, fontSize: 25,),
          ),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.lock_outline, color: Colors.black),
              
              child: Text("Log In", style: TextStyle(color: Colors.black, fontSize: 15),),
            ),
            Tab(
              icon: Icon(Icons.person_add_alt_1_outlined, color: Colors.black),
              child: Text("Register", style: TextStyle(color: Colors.black, fontSize: 15),),
            )
          ],
          indicatorColor: Colors.white38,
          indicatorWeight: 4,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: TabBarView(children: [
            Login(),
            Register(),
          ],),
        )
      ),
    );
  }
}
