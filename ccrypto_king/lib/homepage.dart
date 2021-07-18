import 'dart:convert';

import 'package:ccrypto_king/constants.dart';
import 'package:ccrypto_king/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'getdata.dart';
import 'btc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';


const String api_key = "418EA998-629C-472A-A3EE-7D784B1767FB";

class Homepage extends StatefulWidget {
  Homepage({@required this.data, this.favourites});
  final data;
  final favourites;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List data = [];
  List datatoshow = [];
  Set favourites = {};
  List favstoshow = [];

  updatedata(dynamic apidata, dynamic fav) {
    data = apidata;
    datatoshow = data;
    favourites = fav;
    favstoshow = favourites.toList();
  }

  @override
  void initState() {
    super.initState();
    updatedata(widget.data, widget.favourites);
  }

  Widget search_bar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: TextField(
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            value = value.toLowerCase();
            setState(() {
              datatoshow = data.where((element) {
                var bannername = element["name"].toString().toLowerCase();
                return bannername.contains(value);
              }).toList();
            });
          },
          decoration: kinputdecoration.copyWith(
            icon: Icon(
              Icons.search,
              color: Color(0xFFeeeeee),
            ),
            hintText: "Search...",
            hintStyle: TextStyle(color: Color(0xFFbdbdbd)),
            fillColor: Color(0x35FDE8B05),
          )),
    );
  }

  Widget search_bar_fav() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  value = value.toLowerCase();
                  setState(() {
                    favstoshow = favourites.toList().where((element) {
                      var bannername = element["name"].toString().toLowerCase();
                      return bannername.contains(value);
                    }).toList();
                  });
                },
                decoration: kinputdecoration.copyWith(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFFeeeeee),
                  ),
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Color(0xFFbdbdbd)),
                  fillColor: Color(0x35FDE8B05),
                )),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  favstoshow = favourites.toList();
                });
              },
              icon: Icon(Icons.refresh),color: Color(0xFFeeeeee),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Firstpage() ), (route) => false);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(FontAwesomeIcons.signOutAlt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Color(0xFFF29603),
            labelColor: Color(0xFFF29603),
            // indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ALL",
                  style: TextStyle(
                      // color: Color(0xFFF29603),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Text(
                "FAVORITES",
                style: TextStyle(
                    // color: Color(0xFFF29603),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          backgroundColor: Color(0xFF2E2E30),
          elevation: 0,
        ),
        body: TabBarView(children: [
          Container(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       // Color(0xFF414855),
                  //       Color(0xFF191B28),
                  //       Color(0xFF181C1F)
                  //     ]),
                  image: DecorationImage(
                      image: AssetImage("images/b.jpg"), fit: BoxFit.fill)),
              child: ListView.builder(
                itemCount: datatoshow.length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? search_bar()
                      : mycard(
                          map: datatoshow[index - 1],
                          fav: favourites,
                          favtoshow: favstoshow,
                          isfav: true,
                        );
                },
              )),
          Container(
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       // Color(0xFF414855),
                  //       Color(0xFF191B28),
                  //       Color(0xFF181C1F)
                  //     ]),
                  image: DecorationImage(
                      image: AssetImage("images/b.jpg"), fit: BoxFit.fill)),
              child: ListView.builder(
                itemCount: favstoshow.toList().length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? search_bar_fav()
                      : mycard(
                          map: favstoshow.toList()[index - 1],
                          isfav: false,
                          fav: favourites,
                          favtoshow: favstoshow,
                        );
                },
              )),
        ]),
      ),
    );
  }
}

class mycard extends StatelessWidget {
  mycard({this.map, this.fav, this.favtoshow, this.isfav});

  final map;
  final fav;
  final favtoshow;
  final isfav;

  Future addtofav(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isfav) {
            return AlertDialog(
              title: Text("Add To Favourite ? "),
              actions: [
                TextButton(
                    onPressed: () async {
                      fav.add(map);

                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();

                      _prefs.setString(
                          map["name"].toString(), map["name"].toString());

                      Navigator.pop(context);
                    },
                    child: Text("yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("no"))
              ],
            );
          } else {
            return AlertDialog(
              title: Text("Delete from Favourite ? "),
              actions: [
                TextButton(
                    onPressed: () async {
                      fav.remove(map);

                      SharedPreferences _prefs =
                          await SharedPreferences.getInstance();

                      _prefs.remove(map["name"]);

                      Navigator.pop(context);
                    },
                    child: Text("yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("no"))
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: RawMaterialButton(
        onPressed: () async {




          String id = map["id"].toString();
          String name = map["name"].toString();

          if (name == "VeChain (pre-swap)") name = "VeChain";

          Response response = await get(Uri.parse(
              "https://rest.coinapi.io/v1/ohlcv/$id/USD/latest?period_id=1DAY&limit=2&apikey=$api_key"));
          Response response2 = await get(Uri.parse(
              "https://rest.coinapi.io/v1/ohlcv/$id/USD/latest?period_id=1HRS&limit=12&apikey=$api_key"));



          if (response.statusCode != 200) {
            print(response.statusCode);
          } else {
            print(response.statusCode);
            print(response.body);

            var info = jsonDecode(response.body);
            var today = info[0]["price_close"];
            var prev = info[1]["price_close"];

            var change = today - prev;
            Widget text;
            if (change < 0) {
              var ans = (change / prev) * 100;
              text = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ans.toStringAsFixed(2) + "% ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                        fontFamily: 'mystyle',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.trending_down,
                    color: Colors.red,
                  ),
                ],
              );
            } else {
              var ans = (change / prev) * 100;
              text = Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    ans.toStringAsFixed(2) + "% ",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mystyle'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.trending_up,
                    color: Colors.green,
                  ),
                ],
              );
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BTC(
                  high: info[0]["price_high"],
                  low: info[0]["price_low"],
                  close: info[0]["price_close"],
                  open: info[0]["price_open"],
                  percent: text,
                  id: name,
                  chartdata: jsonDecode(response2.body),
                  icon: map["icon"],
                  current: map["price"],
                  fav: fav,
                ),
              ),
            );
          }
        },
        fillColor: Color(0xFF2B3141).withOpacity(0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Color(0xFF595959),
            width: 2,
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: 100,
          maxWidth: 100,
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 7,
            ),
            Image(
              image: NetworkImage(
                map["icon"],
              ),
              height: 70,
              width: 70,
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  map["name"] == "VeChain (pre-swap)" ? "VeChain" : map["name"],
                  style: TextStyle(
                      fontFamily: 'mystyle',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  map["id"],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  map["price"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'mystyle',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("USD",
                style:TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                )
              ],
            ),
            // SizedBox(
            //   width: 20,
            // ),
            IconButton(
              icon: Icon(Icons.star,color: Colors.white54,),
              onPressed: () async {
                await addtofav(context);
                print(fav);

                //print(4000000);
              },
            ),
          ],
        ),
      ),
    );
  }
}
