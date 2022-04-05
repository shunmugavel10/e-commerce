import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Admin/uploadItems.dart';
import 'package:shop_app/Authentication/authenication.dart';
import 'package:shop_app/Widgets/customTextField.dart';
import 'package:shop_app/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              gradient: LinearGradient(
                colors: [Colors.greenAccent[200], Colors.blue[100]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          title: Text("E-Shopping App", style: TextStyle(color: Colors.black, fontSize: 22,),
          ),
          centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "images/admin.png",
              height: 230,
              width: 230,
            )
            ,),
          Padding(padding: EdgeInsets.all(20),
          child: Text(" Admin Login",
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "Admin name or ID",
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
              SizedBox(height: 80),
                 RaisedButton(onPressed: (){
                _adminIDTextEditingController.text.isNotEmpty && _passwordTextEditingController.text.isNotEmpty
                ? loginAdmin()
                : showDialog(context: context,
                builder: (c){
                  return ErrorAlertDialog(message: "Type Email and Password",);
                });
              },
              color: Colors.blueGrey[300],
              child: Text("Log IN", style: TextStyle(color: Colors.black,),
              ),
              ),
              SizedBox(height: 90),
              Container(
                height: 2.5,
                width: _screenWidth * 0.7,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
              FlatButton.icon(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthenticScreen())),
              icon: (Icon(Icons.person, color: Colors.grey[750])),
              label: Text("I'm not Admin", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

              ),
              SizedBox(height: 30)
        ],
      ),)
    );
  }
  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) { 
        if(result.data["id"] != _adminIDTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Incorrect ID"),));
        }

        else if(result.data["password"] != _passwordTextEditingController.text.trim())
        {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Incorrect Password"),));
        }
        else{
           Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome" + result.data["name"] + "...!"),));

           setState(() {
             _adminIDTextEditingController.text = "";
             _passwordTextEditingController.text = "";
           });

           Route route = MaterialPageRoute(builder: (c)=> UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
