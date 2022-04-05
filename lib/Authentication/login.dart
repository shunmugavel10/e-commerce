import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Admin/adminLogin.dart';
import 'package:shop_app/Widgets/customTextField.dart';
import 'package:shop_app/DialogBox/errorDialog.dart';
import 'package:shop_app/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:shop_app/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "images/login.png",
              height: 230,
              width: 230,
            )
            ,),
          Padding(padding: EdgeInsets.all(20),
          child: Text(" User Login",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                   CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.vpn_key,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
              ),
              SizedBox(height: 20),
                 RaisedButton(onPressed: (){
                _emailTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty
                ? loginUser()
                : showDialog(context: context,
                builder: (c){
                  return ErrorAlertDialog(message: "Type Email and Password",);
                });
              },
              color: Colors.blueGrey[200],
              child: Text("Log IN", style: TextStyle(color: Colors.black,),
              ),
              ),
              SizedBox(height: 70),
              Container(
                height: 2.5,
                width: _screenWidth * 0.7,
                color: Colors.blue[300],
              ),
              SizedBox(height: 20),
              FlatButton.icon(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminSignInPage())),
              icon: (Icon(Icons.person, color: Colors.grey[750])),
              label: Text("Admin", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

              ),
        ],
      ),)
    );
  }
 FirebaseAuth _auth = FirebaseAuth.instance;
 void  loginUser() async {
   showDialog(context: context,
   builder: (c)
   {
     return LoadingAlertDialog(message: "Please Wait...");
   }
   );
  
   FirebaseUser firebaseUser;
   await _auth.signInWithEmailAndPassword(
     email: _emailTextEditingController.text.trim(),
     password: _passwordTextEditingController.text.trim(),
   ).then((authUser){
     firebaseUser = authUser.user;
   }).catchError((error){
      Navigator.pop(context);
        showDialog(context: context,
        builder: (c){
          return ErrorAlertDialog(message: error.message.toString(),);
        }
        );
   });
   if(firebaseUser != null)
   {
     readData(firebaseUser).then((s){
       Navigator.pop(context);
       Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
     });
   }
  }
  Future readData(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);

        List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
        await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
        
    });
  }
}
