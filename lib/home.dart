import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:punkbeerapp/favourite.dart';


class Home extends StatefulWidget {
  const Home({Key key,this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isFavourite = false;
  ScrollController _scrollController= ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBeers(1);
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
  Future<List<Beer>> _getBeers(int i) async{
    var data= await http.get("https://api.punkapi.com/v2/beers");
    var jsonData= json.decode(data.body);

    List<Beer> beers =[];
    for(var b in jsonData){
      Beer beer =Beer(b["id"],b["name"],b["tagline"],b["image_url"]);

      beers.add(beer);

    }
    return beers;
  }
  List<Beer> beerL;
  int currentPage = 1;
  int page;

  bool onNotify(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (_scrollController.position.maxScrollExtent > _scrollController.offset &&
          _scrollController.position.maxScrollExtent - _scrollController.offset <=
              25) {
        print('End Scroll');
        _getBeers(currentPage + 1).then((val) {
          setState(() {
            beerL.addAll(beerL);
          });
        });
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text("\nTop Beers",style: appTitleTextStyle,),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0,top:10.0),
              child: IconButton(
                icon: Icon(Icons.favorite,color: Colors.amberAccent,size: 40,),
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Favourite()));
                  },
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getBeers(1),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data==null){
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            }else {
              return NotificationListener(
                onNotification: onNotify,
                child: ListView.builder(
                  controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            isThreeLine: true,
                            dense: false,
                            title: Text(snapshot.data[index].name,style: titleTextStyle,),
                            subtitle: Text(snapshot.data[index].tagline,style: subTitleTextStyle,),
                            leading: Container(
                              constraints: BoxConstraints.tightFor(width: 25,height: 60),
                              child: Image.network(snapshot.data[index].image_url,fit: BoxFit.fill,),
                            ),
                            trailing:GestureDetector(
                              child:Icon(
                                Icons.favorite,
                                size: 30,
                                color: _isFavourite ? Colors.red:Colors.grey,),
                              onTap: (){
                                setState(() {
                                  print("tapped at $index");
                                  _isFavourite=true;
                                });
                              },
                              onDoubleTap: (){
                                setState(() {
                                  print("double tapped at $index");
                                  _isFavourite =false;
                                });
                              },
                              ),
                          ),
                          Divider(height: 15,)
                        ],
                      );
                    }
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Beer{
  final int id;
  final String name;
  final String tagline;
  final String image_url;

  Beer(this.id,this.name,this.tagline,this.image_url);

}

TextStyle appTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: Colors.white);

TextStyle titleTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: Colors.black87);

TextStyle subTitleTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 21,
    color: Colors.grey);
//${widget.user.email}