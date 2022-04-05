import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
        
        child: Container(
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
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 10, right:10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(children: [
                  Padding(padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.search,
                  color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Search"),)
                ],),
              ),
            ),
        ),
      );



  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


