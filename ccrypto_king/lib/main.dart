//mport 'dart:html';
import 'dart:ui';
//import 'dart:ffi';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'getdata.dart';
import 'homepage.dart';
import 'package:http/http.dart';
import 'package:ccrypto_king/constants.dart';
import 'package:ccrypto_king/registeration.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

const String api_key = "418EA998-629C-472A-A3EE-7D784B1767FB";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Firstpage(),
    );
  }
}

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  var data;
  var icondata;
  String email = "";
  String password = "";

  String error="";

  bool _spinning = false;

  List<Map<String, String>> list = [];
  Set<Map<String, String>> fav = {};
  Map<String, String> iconmap = {};

  gettingdata() async{

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    data = await Get_data().getdata();
    icondata = await Get_data().geticon();

    for (var i in icondata){
      iconmap[i["asset_id"].toString()]=i["url"].toString();
    }


    for(var i in data ) {
    //  print(1);

      if (i["type_is_crypto"] == 1 && i["price_usd"] != null && iconmap[i["asset_id"].toString()]!=null ) {

         String name =  _prefs.getString(i["name"].toString()) ?? "null";

         if(name!="null"){

           fav.add(
               {
                 "name": i["name"].toString(),
                 "id": i["asset_id"].toString(),
                 "price": i["price_usd"].toStringAsFixed(2),
                 "icon" : iconmap[i["asset_id"].toString()] ?? "https://cdn.icon-icons.com/icons2/1386/PNG/512/generic-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment_95642.png"
               }
           );

         }

        list.add({

          "name": i["name"].toString(),
          "id": i["asset_id"].toString(),
          "price": i["price_usd"].toStringAsFixed(2),
          "icon" : iconmap[i["asset_id"].toString()] ?? "https://cdn.icon-icons.com/icons2/1386/PNG/512/generic-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment_95642.png"
        });



      }
    }

  }


  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2E30),
        elevation: 0,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _spinning,
        child: Container(
          decoration: BoxDecoration(

            image: DecorationImage(
              image: AssetImage("images/b.jpg"),
              fit: BoxFit.fill
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Image(
                    // height: 400,
                    // width: 200,
                    image: AssetImage(
                      "images/logo2.gif",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(error,
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ),
                ),
                TextField(
                  decoration: kinputdecoration.copyWith(hintText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  decoration: kinputdecoration.copyWith(hintText: "Password"),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 30.0),
                RawMaterialButton(
                  onPressed: () async {

                    setState(() {
                      _spinning = true;
                    });

                   await gettingdata();

                    final user = await Login_functions(email: email,password: password).Signin_func();

                    setState(() {
                      _spinning =false;
                    });

                    if(user==null){

                      setState(() {
                        error =  "Incorrect email or password";
                      });

                    }

                    else {

                      setState(() {
                        error = "";
                      });

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) => Homepage(data: list,favourites: fav,),
                      ),
                              (Route<dynamic> route) => false
                      );
                    }



                  },
                  constraints: BoxConstraints(minHeight: 50, minWidth: 400),
                  elevation: 10,
                  fillColor: Color(0xFFFDE8B05),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Text("Sign In",style: kbuttontext,),
                ), SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 50,),
                    Text("Do not have an account ?"),
                    TextButton(

                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Register() ),
                        );
                      },
                      child: Text("Register here"),

                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 2,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: () async {

                    setState(() {
                      _spinning = true;
                    });

                    await gettingdata();

                    setState(() {
                      _spinning = false;
                    });

                    FirebaseAuth _auth = FirebaseAuth.instance;

                    OAuthCredential credentials = await Login_functions().Singingoogle();

                    setState(() {
                      _spinning = true;
                    });

                    await _auth.signInWithCredential(credentials);

                    final user = _auth.currentUser;

                    setState(() {
                      _spinning = false;
                    });

                    if(user!=null){

                      print(_auth.currentUser);

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Homepage(data: list,favourites: fav,)),
                              (Route<dynamic> route) => false
                      );
                    }
                    else{

                      print("error");

                    }
                  },
                  constraints: BoxConstraints(minHeight: 50, minWidth: 400),
                  elevation: 10,
                  fillColor: Color(0x35FDE8B05),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In With Google",
                        style: kbuttontext.copyWith(fontWeight: FontWeight.normal,color: Colors.white.withOpacity(0.6)),
                      ),
                      SizedBox(width: 20,),
                      Icon(FontAwesomeIcons.google, color: Color(0xFFFDE8B05),),
                      //SizedBox(width: 30,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//