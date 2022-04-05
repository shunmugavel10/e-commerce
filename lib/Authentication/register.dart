import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Widgets/customTextField.dart';
import 'package:shop_app/DialogBox/errorDialog.dart';
import 'package:shop_app/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:shop_app/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 28),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.14,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile==null ? null : FileImage(_imageFile),
                child: _imageFile == null ? 
                Icon(Icons.add_a_photo_outlined, size: _screenWidth * 0.10, color: Colors.black, )
                : null,
                
              ),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "name",
                    isObsecure: false,
                  ),
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
                   CustomTextField(
                    controller: _confirmPasswordTextEditingController,
                    data: Icons.vpn_key,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  )
                ],
              ),
              ),
              SizedBox(height: 25),
              RaisedButton(onPressed: (){
                uploadAndSaveImage();
              },
              color: Colors.blue,
              child: Text("Sign Up", style: TextStyle(color: Colors.white),
              ),
              ),
              SizedBox(height: 100),
              Container(
                height: 2.5,
                width: _screenWidth * 0.7,
                color: Colors.blue,
              ),
              SizedBox(height: 50),
        ],)
      )
    );

  }

  Future<void> _selectAndPickImage() async 
  {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(context: context,
      builder: (c)
      {
        return ErrorAlertDialog(
          message: "Upload Image",
        );
      }
      );
    }
    else {
      _passwordTextEditingController.text == _confirmPasswordTextEditingController.text ? 
      _emailTextEditingController.text.isNotEmpty && 
      _passwordTextEditingController.text.isNotEmpty && 
      _confirmPasswordTextEditingController.text.isNotEmpty && 
      _nameTextEditingController.text.isNotEmpty

      ? uploadToStorage()

      : displayDailog("Fill all the feilds")

      : displayDailog("Password not match");
    }
  }
  displayDailog(String msg)
  {
    showDialog(context: context,
    builder: (c){
      return ErrorAlertDialog(message: msg,);
    });
  }
    uploadToStorage() async{
      showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: "Loading...",);
        }
      );

      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);

      StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      await taskSnapshot.ref.getDownloadURL().then((urlImage){
        userImageUrl = urlImage;

        _registerUser();
      });
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    void _registerUser() async{
      FirebaseUser firebaseUser;

      await _auth.createUserWithEmailAndPassword(email: _emailTextEditingController.text.trim(), password: _passwordTextEditingController.text.trim(),
      ).then((auth){
        firebaseUser = auth.user;
      }).catchError((error){
        Navigator.pop(context);
        showDialog(context: context,
        builder: (c){
          return ErrorAlertDialog(message: error.message.toString(),);
        }
        );
      });
      if (firebaseUser != null){
        saveUserInfoToFireStore(firebaseUser).then((value){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> StoreHome());
          Navigator.pushReplacement(context, route);
        });
      }

     
    }

     Future saveUserInfoToFireStore(FirebaseUser fUser) async {
        Firestore.instance.collection("users").document(fUser.uid).setData({
          "uid": fUser.uid,
          "email": fUser.email,
          "name": _nameTextEditingController.text.trim(),
          "url": userImageUrl,
          EcommerceApp.userCartList: ["garbageValue"]
        });
        await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text);
        await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
        await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
      }
}

