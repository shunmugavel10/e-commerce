import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Widgets/loadingWidget.dart';
import 'package:shop_app/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
   TextEditingController _titleTextEditingController = TextEditingController();
    TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen(){
    return Scaffold(
      appBar: AppBar(
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
          actions: [
            FlatButton(child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            onPressed: (){
               Route route = MaterialPageRoute(builder: (c)=> SplashScreen());
          Navigator.pushReplacement(context, route);
            },
            ),

          ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }
  getAdminHomeScreenBody(){
    return Container(
      decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shop_two, color: Colors.grey[700], size: 160,),
                Padding(padding: EdgeInsets.only(top: 18),
                child: RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                child: Text("Add New Items", style: TextStyle(fontSize: 18, color: Colors.white),),
                color: Colors.blue,
                onPressed: ()=> takeImage(context),
                ),
                )
              ],
            ),),
    );
  }

  takeImage(mcontext){
    return showDialog(context: mcontext,
    builder: (con){
      return SimpleDialog(
        title: Text("Item Image", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),),
        children: [
          SimpleDialogOption(
            child: Text("Capture Image", style: TextStyle(color: Colors.blue,),
            ),
            onPressed: capturePhotoWithCamera,
          ),
          SimpleDialogOption(
            child: Text("Select From Gallery", style: TextStyle(color: Colors.blue,),
            ),
            onPressed: picPhotoFromGallery,
          ),
           SimpleDialogOption(
            child: Text("cancel", style: TextStyle(color: Colors.blue,),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
    });

  }
  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFle = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600, maxWidth: 900);

    setState(() {
      file = imageFle;
    });
  }

  picPhotoFromGallery() async{
    Navigator.pop(context);
    File imageFle = await ImagePicker.pickImage(source: ImageSource.gallery,);

    setState(() {
      file = imageFle;
    });

  }
  displayAdminUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue[100]],
                begin: FractionalOffset(0,1),
                end: FractionalOffset(1,0),
                stops: [0,1],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back), 
          onPressed: clearFormInfo,
          ),
          title: Text("New Product", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
          actions: [
            FlatButton(
              onPressed: uploading ? null : ()=> uploadImageAndSaveItemInfo(),
              child: Text("Add",style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), ),)
          ],
      ),
      body: ListView(children: [
        uploading ? linearProgress() : Text(""),
        Container(
          height: 220,
          width: MediaQuery.of(context).size.width * 1,
          child: Center(child: 
          AspectRatio(
            aspectRatio: 16/7,
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
            ),
          ),),
        ),
        Padding(padding: EdgeInsets.only(top: 12)),

        ListTile(
          leading: Icon(Icons.info_outline, color: Colors.grey,),
          title: Container(
            width: 250,
            child: TextField(
              style: TextStyle(color: Colors.blueGrey),
              controller: _shortInfoTextEditingController,
              decoration: InputDecoration(
                hintText: "Product Info",
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey),

                ListTile(
          leading: Icon(Icons.title_outlined, color: Colors.grey,),
          title: Container(
            width: 250,
            child: TextField(
              style: TextStyle(color: Colors.blueGrey),
              controller: _titleTextEditingController,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey),

                ListTile(
          leading: Icon(Icons.description_outlined, color: Colors.grey,),
          title: Container(
            width: 250,
            child: TextField(
              style: TextStyle(color: Colors.blueGrey),
              controller: _descriptionTextEditingController,
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey),

                ListTile(
          leading: Icon(Icons.monetization_on_outlined, color: Colors.grey,),
          title: Container(
            width: 250,
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.blueGrey),
              controller: _priceTextEditingController,
              decoration: InputDecoration(
                hintText: "Price",
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(color: Colors.grey),
      ],),
      );

  }
  clearFormInfo(){
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot takeSnapshot = await uploadTask.onComplete;
    String downloadUrl = await takeSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
        "shortInfo": _shortInfoTextEditingController.text.trim(),
        "longDescription": _descriptionTextEditingController.text.trim(),
        "price": int.parse(_priceTextEditingController.text),
        "publishedDate": DateTime.now(),
        "status": "Available",
        "thumbnailUrl": downloadUrl,
        "title": _titleTextEditingController.text.trim(),

    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}
