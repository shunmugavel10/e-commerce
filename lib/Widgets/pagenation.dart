// import 'package:admin/models/chef_model.dart';
// import 'package:admin/models/customer_model.dart';
// import 'package:admin/models/customer_model.dart';
// import 'package:admin/models/customer_model.dart';
// import 'package:admin/models/customer_model.dart';
// import 'package:admin/models/customer_model.dart';
// import 'package:admin/models/organization_model.dart';
// import 'package:admin/utilities/apiClient.dart';
// import 'package:admin/utilities/api_list.dart';
// import 'package:admin/utilities/themes.dart';
// import 'package:admin/widgets/display_card1.dart';
// import 'package:admin/widgets/display_card3.dart';
// import 'package:admin/widgets/display_card5.dart';
// import 'package:admin/widgets/shimmers.dart';
// import 'package:admin/widgets/toast_msg.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:easy_localization/easy_localization.dart';

// class CustomerListing extends StatefulWidget {

//   @override
//   _CustomerListingState createState() => _CustomerListingState();
// }

// class _CustomerListingState extends State<CustomerListing> {

//   ScrollController _scrollController = ScrollController();
//   late int currentpage =-1,totalPage=2,type=1;
//   late Future <CustomerModel?> customerData;


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     customerData=getOrganizationNetwork();
//     _scrollController.addListener(() {
//       if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
//         getOrganizationNetwork();
//       }
//     });
//   }
//   Future<CustomerModel?> getOrganizationNetwork() async {
//     if(totalPage>currentpage) {
//       currentpage++;
//       Response response;
//       try {
//         final _dio = apiClient();
//         var data= await _dio.then((value) async {
//           response = await value.get(customerEndpoint, queryParameters: {
//             "page": currentpage.toString(),
//           });
//           if (response.statusCode == 200) {
//             if(currentpage==0){
//               totalPage=CustomerModel.fromJson(response.data).value==null?
//               2:CustomerModel.fromJson(response.data).value!.totalPages!;
//               return CustomerModel.fromJson(response.data);
//             }else {
//               setState(() {
//                 List<CustomerContent>? content = CustomerModel.
//                 fromJson(response.data).value!.content;
//                 customerData.then((value) {
//                   value!.value!.content!.addAll(content!);
//                 });
//               });
//             }
//           } else {
//             showtoast("Failed");
//           }
//         });
//         return data;
//       } catch (e) {
//         print(e);
//         showtoast("Failed1");
//       }
//     } else {
//       showtoast("No more customers");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     var _width = MediaQuery.of(context).size.width;
//     var orientation =MediaQuery.of(context).orientation;

//     return Container(height: double.infinity,

//       child: Column(
//           children: [
//             Expanded(flex: 1, child: Container(height: 50,
//               child: Row(children: [
//                 IconButton(onPressed: () {setState(() {
//                   type=1;
//                 });}, icon: Icon(FeatherIcons.list,
//                   color: type == 1 ? primaryColor : Colors.grey,),),
//                 IconButton(onPressed: () {
//                   setState(() {
//                     type=2;
//                   });
//                 }, icon: Icon(FeatherIcons.grid),
//                   color: type == 2 ? primaryColor : Colors.grey,),
//                 IconButton(onPressed: () {
//                   setState(() {
//                     type=3;
//                   });
//                 }, icon: Icon(FeatherIcons.map),
//                   color: type == 3 ? primaryColor : Colors.grey,)
//               ],),),),
//             Expanded(flex: 8,
//               child: FutureBuilder(
//                   future: customerData,
//                   builder: (context, AsyncSnapshot<CustomerModel?> snapshot) {
//                     if(snapshot.connectionState==ConnectionState.done) {
//                       if (snapshot.hasData && snapshot.data!.value!=null)
//                         return type == 1 ? ListView.builder(
//                             shrinkWrap: true,
//                             padding: EdgeInsets.only(left: 8, right: 8),
//                             itemCount: snapshot.data!.value!.content!.length,
//                             itemBuilder: (context, index) {
//                               return tile(context, snapshot
//                                   .data!.value!.content![index]);
//                             })
//                             : type == 2 ? StaggeredGridView.countBuilder(
//                           controller: _scrollController,
//                           crossAxisCount: Orientation.portrait == orientation
//                               ? 2
//                               : 3,
//                           itemCount: snapshot.data!.value!.content!.length,
//                           itemBuilder: (BuildContext context, int index) =>
//                               displayCard3(context, snapshot.data!.value!
//                                   .content![index]),
//                           staggeredTileBuilder: (int index) =>
//                               StaggeredTile.fit(1),
//                           mainAxisSpacing: 1.0,
//                           crossAxisSpacing: 1.0,
//                         ) : Container();
//                       else return Center(child: Text("No Data",style: styleBody1,),);
//                     }
//                     else
//                       return ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: 3,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               width: _width,
//                               height: ((_width - 32) / 4.17),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 color: Colors.white,
//                               ),
//                               margin: EdgeInsets.only(
//                                   left: 16, right: 16, top: 8),
//                               child: shimmerEffects(context),
//                             );
//                           });
//                   }),
//             ),
//           ]),
//     );
//   }
// }


// Widget tile(BuildContext context,CustomerContent customerData){
//   var _width= MediaQuery.of(context).size.width;

//   Future<ChefModel?> deleteProductsNetwork() async {
//     Response response;
//     try {
//       final _dio = apiClient();
//       var data = await _dio.then((value) async {
//         response = await value.delete("url_get_products"+"/");
//         print(response.data);
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           print("done");
//         } else {
//           showtoast("Failed");
//         }
//       });
//       return data;
//     } catch (e) {
//       print(e);
//       showtoast("Failed1");
//     }
//   }

//   return Card(
//     child: ListTile(
//         title: Text(customerData.name!.english!),
//         subtitle: Text(customerData.name!.english!),
//         trailing: SizedBox(width:100,
//           child: Row(children: [
//             IconButton(
//               icon: Icon(Icons.edit_outlined,size: 25,color: primaryColor,),
//               onPressed: (){
//                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProducts(
//                 //   productData: chefData,
//                 // )));
//               },),
//             IconButton(
//               icon: Icon(Icons.delete_outline_sharp,size: 25,color: primaryColor,),
//               onPressed: (){
//                 showModalBottomSheet(
//                     context: context,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
//                     builder: (context) {
//                       return Container(
//                         child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text("fd_delete_msg",style: styleBody1,).tr(),
//                             SizedBox(width: _width/2.5,height: _width/2.5,
//                               child: CachedNetworkImage(
//                                 useOldImageOnUrlChange: true,
//                                 imageUrl:customerData.thumbnail!.url!,
//                                 placeholder: (context, url) => shimmerEffects(context),
//                                 errorWidget: (context, url, error) => Icon(FeatherIcons.image,size: 50,color: Colors.grey.shade300,),
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                       width: _width/2.5,
//                                       height: _width/2.5,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover),
//                                       ),
//                                     ),
//                               ),
//                             ),
//                             // ignore: deprecated_member_use
//                             Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children:[
//                                   // ignore: deprecated_member_use
//                                   FlatButton(child: Text("fd_cancel_msg",style: styleBody2.copyWith(color: primaryColor),).tr(),
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
//                                         side: BorderSide(color: primaryColor)),
//                                     minWidth:120,
//                                     height: 45,
//                                     color: Colors.transparent,splashColor: primaryColor,
//                                     onPressed: (){
//                                       Navigator.pop(context);
//                                     },),
//                                   // ignore: deprecated_member_use
//                                   FlatButton(child: Text("fd_delete_button",style: styleBody2.copyWith(color:Colors.white),).tr(),
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                     minWidth:120,
//                                     height: 45,
//                                     color: primaryColor,splashColor: Colors.white,
//                                     onPressed: ()async {
//                                       deleteProductsNetwork();
//                                       Navigator.pop(context);
//                                     },),
//                                 ]
//                             ),
//                           ],),
//                       );
//                     });
//               },),
//           ],),
//         )
//     ),
//   );
// }
