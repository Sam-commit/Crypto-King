//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ccrypto_king/homepage.dart';
import 'constants.dart';
import 'getdata.dart';
import 'login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var data;
  var icondata;

  String email = "";
  String password = "";
  String confirm = "";
  String error = "";

  bool _spinner = false;

  List<Map<String, String>> list = [];
  Set<Map<String, String>> fav = {};
  Map<String, String> iconmap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2E30),
        elevation: 0,
      ),
      body: ModalProgressHUD(
      inAsyncCall: _spinner,
        child: SingleChildScrollView(
          child: Container(
            height: 700,
            decoration: BoxDecoration(image: DecorationImage(
                image: AssetImage("images/b.jpg"),
                fit: BoxFit.fill
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 30,),
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
                    TextField(
                      decoration: kinputdecoration.copyWith(hintText: "Email "),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(error, style: TextStyle(color: Colors.red),),
                    ),
                    TextField(
                      decoration: kinputdecoration.copyWith(hintText: "Password"),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: kinputdecoration.copyWith(hintText: "Confirm Password"),
                      obscureText: true,
                      onChanged: (value) {
                        confirm = value;

                        if(confirm!=password){

                          setState(() {
                            error = "Password do not match Confirm Password";
                          });

                        }
                        else {
                          setState(() {
                            error = "";
                          });
                        }

                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text("Atleast 6 characters long",style: TextStyle(color: Colors.white30),),
                    ) ,
                    SizedBox(height: 20.0),
                    RawMaterialButton(
                      onPressed: () async {


                        setState(() {
                          _spinner = true;
                        });

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

                        await Login_functions(email: email,password: password).Register_func();

                        setState(() {
                          _spinner=false;
                        });

                        Navigator.pushAndRemoveUntil(

                            context,
                            MaterialPageRoute(
                                builder: (context) => Homepage(data: list,favourites: fav,)),
                                (Route<dynamic> route) => false
                        );
                      },
                      constraints: BoxConstraints(minHeight: 50, minWidth: 400),
                      elevation: 10,
                      fillColor: Color(0xFFFDE8B05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text("Register",style: kbuttontext,),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
