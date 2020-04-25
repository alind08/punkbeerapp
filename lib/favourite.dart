import 'package:flutter/material.dart';
import 'package:punkbeerapp/home.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.black,
          title: Text("\nFavourite Beers",style: appTitleTextStyle,),
          centerTitle: true,
        ),
      ),
      body: Container(
        child: Center(
          child: Text("Coming Soon...",style: TextStyle(fontSize: 30,color: Colors.blueAccent),),
        ),
      )
    );
  }
}
