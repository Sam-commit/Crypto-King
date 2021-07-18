//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class info_page extends StatefulWidget {
  info_page({this.name, this.icon, this.description, this.links, this.id});

  var name;
  var icon;
  var description;
  var links;
  var id;

  @override
  _info_pageState createState() => _info_pageState();
}

class _info_pageState extends State<info_page> {
  var name;
  var icon;
  var description;
  var links;
  var id;

  String news = "https://economictimes.indiatimes.com/markets/cryptocurrency";

  update_info() {
    name = widget.name;
    icon = widget.icon;
    description = widget.description;
    links = widget.links;
    id = widget.id;
  }

  @override
  void initState() {
    update_info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "INFO",
          style: TextStyle(
              color: Color(0xFFF29603),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        )),
        backgroundColor: Color(0xFF2E2E30),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/b.jpg"), fit: BoxFit.fill)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  border: Border.all(color: Color(0xFF595959), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(icon),
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  id,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF383557),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 19,
                              fontFamily: 'newstyle',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF383557),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.globe,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                      onPressed: () async{

                                        await canLaunch(links) ? await launch(links) : throw " Could not Launch ";

                                      },
                                      child: Text(
                                        links,
                                        style: TextStyle(fontSize: 18),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidNewspaper,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                      onPressed: () async{

                                        await canLaunch(news) ? await launch(news) : throw " Could not launch ";

                                      },
                                      child: Text(
                                        "Latest News",
                                        style: TextStyle(fontSize: 18),
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
