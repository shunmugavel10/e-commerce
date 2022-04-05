
import 'package:shop_app/Config/config.dart';
import 'package:shop_app/Widgets/customAppBar.dart';
import 'package:shop_app/Models/address.dart';
import 'package:flutter/material.dart';




class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(formKey.currentState.validate()){
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cHomeNumber.text,
                city: cCity.text.trim(),

              ).toJson();

              EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
              .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
              .collection(EcommerceApp.subCollectionAddress)
              .document(DateTime.now().millisecondsSinceEpoch.toString())
              .setData(model).then((value){
                final snack = SnackBar(content: Text("Address addded"));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
            }
        },
         label: Text("Done"),
         backgroundColor: Colors.grey,
         icon: Icon(Icons.check),
         ),
         body: SingleChildScrollView(
           child: Column(
             children: [
               Align(alignment : Alignment.centerLeft,
               child: Padding(
                 padding: EdgeInsets.all(8),
                 child: Text("Add New Address", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),),
               ),
               ),
               Form(
                 key: formKey,
                 child: Column(children: [
                   MyTextField(
                     hint: "Name",
                     controller: cName,
                   ),
                   MyTextField(
                     hint: "Mobile Number",
                     controller: cPhoneNumber,
                   ),
                   MyTextField(
                     hint: "Home Number",
                     controller: cHomeNumber,
                   ),
                   MyTextField(
                     hint: "City",
                     controller: cCity,
                   ),
                   MyTextField(
                     hint: "State",
                     controller: cState,
                   ),
                   MyTextField(
                     hint: "PinCode",
                     controller: cPinCode,
                   ),
                 ],))
             ],
           ),
         ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {

  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Feild Cannot be empty." : null,
      ),

    );
  }}