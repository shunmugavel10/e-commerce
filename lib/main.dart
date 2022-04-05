import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Counters/cartitemCounter.dart';
import 'package:shop_app/Counters/changeAddresss.dart';
import 'Authentication/authenication.dart';
import 'package:shop_app/Config/config.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c) => CartItemCounter()),
      ChangeNotifierProvider(create: (c) => ItemQuantity()),
      ChangeNotifierProvider(create: (c) => TotalAmount()),
      ChangeNotifierProvider(create: (c) => AddressChanger()),
    ],
    child: MaterialApp(
            title: 'Shopping App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
            ),
            home: SplashScreen()
    ),
    
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState(){
    super.initState();

    displaySplash();
  }

  displaySplash(){
    Timer(Duration(seconds: 5), ()async {
      if(await EcommerceApp.auth.currentUser()!= null){
        Route route = MaterialPageRoute(builder: (e) => StoreHome());
        Navigator.pushReplacement(context, route);
      }else {
        Route route = MaterialPageRoute(builder: (e) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue[200], Colors.greenAccent[100]],
          begin: FractionalOffset(0,0),
          end: FractionalOffset(0,1),
          stops: [0,5],
          tileMode: TileMode.clamp,
          )),
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(height:20),
              Text("Welcome to Online Shopping", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),),
              
            ],
          ),),
      ),
    );
  }
}
