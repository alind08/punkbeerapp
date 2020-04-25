import 'package:firebase_auth/firebase_auth.dart';
import 'package:punkbeerapp/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.black,
          title: Text("\n\nPunk Beer"),
          centerTitle: true,

        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30,),
                Center(
                  child: Icon(Icons.person_pin,color: Colors.black,size: 100,),
                ),
                SizedBox(height: 30,),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(30),
                    margin: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide an email';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                          onSaved: (input) => _email = input,
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          validator: (input) {
                            if(input.length < 6){
                              return 'Longer password please';
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                          ),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                        ),
                        SizedBox(height: 50,),
                        RaisedButton(
                          color: Colors.black,
                          elevation: 50,
                          onPressed: signIn,
                          child: Text('Sign in',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
      );
  }

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
      }catch(e){
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: <Widget>[
              FlatButton(child: Text("OK"),
                onPressed: () {
                Navigator.pop(context);
              },)
            ],
          ),
        );
      }
    }
  }
}