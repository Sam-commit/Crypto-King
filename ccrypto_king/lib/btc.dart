//import 'dart:html';

import 'dart:ffi';

import 'package:ccrypto_king/infopage.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:ccrypto_king/getdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class BTC extends StatefulWidget {
  BTC(
      {@required this.high,
      @required this.low,
      @required this.open,
      @required this.close,
      @required this.volume,
      @required this.percent,
      @required this.chartdata,
      @required this.id,
      @required this.icon,
      @required this.current,
      @required this.fav});

  final high;
  final low;
  final open;
  final close;
  final volume;
  final percent;
  final chartdata;
  final id;
  final icon;
  final current;
  final fav;

  @override
  _BTCState createState() => _BTCState();
}

class _BTCState extends State<BTC> {
  var high;
  var low;
  var open;
  var close;
  var volume;
  var percent;
  var chartdata;
  var id;
  var icon;
  var current;
  var fav;
  bool ispresent = false;

  List<double> data = [];
  List finaldata = [];
  double yaxis = 0;

  List<Color> gradient = [
    Color(0xFFcc2b5e),
    Color(0xFF753a88),
  ];

  makinglist() {
    for (var i in chartdata) {
      data.add(i["price_close"]);
    }
  }

  datamaping(List list) {
    // this function is to map all data of closed prices

    var highest = list.cast<num>().reduce(max);
    var lowest = list.cast<num>().reduce(min);
    print(highest);
    print(lowest);
    var div = highest - lowest;
    if (div < 0.06) div = 0.06;
    print(div);
    yaxis = div / 5.0;
    for (var i in list) {
      finaldata.add((((i - lowest) / div) * 5) + 1);
    }
  }

  checkfav(){

    for(var i in fav) {
      if (id == i["name"]){
        setState(() {
          ispresent=true;
        });
        break;
      }

    }


  }


  @override
  void initState() {
    super.initState();

    high = widget.high;
    low = widget.low;
    open = widget.open;
    close = widget.close;
    percent = widget.percent;
    volume = widget.volume;
    chartdata = widget.chartdata;
    id = widget.id;
    icon = widget.icon;
    current = widget.current;
    fav = widget.fav;

    makinglist();
    datamaping(data);
    print(data);
    print(finaldata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2E30),
        elevation: 0,
        title: Center(
          child: Text(
            id.toString().toUpperCase(),
            style: TextStyle(
                fontSize: 24,
                color: Color(0xFFF29603),
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [

          IconButton(
            onPressed: () async {
              Map info =
                  await Get_data(slug: id.toString().toLowerCase()).getinfo();
              print(info);

              Map map1 = info["data"];
              var list1 = map1.keys.toList();
              var idnum = list1[0];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => info_page(
                    name: id.toString(),
                    description:
                        info["data"]["$idnum"]["description"].toString(),
                    links:
                        info["data"]["$idnum"]["urls"]["website"][0].toString(),
                    icon: icon,
                    id: info["data"]["$idnum"]["symbol"].toString(),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.info_sharp,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/b.jpg"), fit: BoxFit.fill)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(icon),
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF595959), width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  r"$ " + current.toString(),
                                  style: TextStyle(
                                      color: Color(0xFFF29603),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                percent,
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF595959), width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text("Open", style: knormaltext),
                                SizedBox(height: 8,),
                                Text(r"$ " + open.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2,height: 50,child: Container(color: Color(0xFF595959),),),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Close",
                                  style: knormaltext,
                                ),
                                SizedBox(height: 8,),
                                Text(r"$ " + close.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2,height: 50,child: Container(color: Color(0xFF595959),),),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "High",
                                  style:
                                      knormaltext.copyWith(color: Colors.green),
                                ),
                                SizedBox(height: 8,),
                                Text(r"$ " + high.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 2,height: 50,child: Container(color: Color(0xFF595959),),),

                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Low",
                                  style: knormaltext.copyWith(color: Colors.red),
                                ),
                                SizedBox(height: 8,),
                                Text(
                                  r"$ " + low.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("Last 12 hrs data below",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                  left: 8,
                  bottom: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2E30).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 8, bottom: 10),
                    child: LineChart(LineChartData(
                      minX: 1,
                      maxX: 12,
                      minY: 0,
                      maxY: 6,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                            getTextStyles: (value) =>
                                TextStyle(color: Colors.white),
                            margin: 8,
                            showTitles: true,
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 1:
                                  return '12HRS';
                                case 3:
                                  return '10HRS';
                                case 5:
                                  return '8HRS';
                                case 7:
                                  return '6HRS';
                                case 9:
                                  return '4HRS';
                                case 11:
                                  return '2HRS';
                              }
                              return "";
                            }),
                        leftTitles: SideTitles(
                            getTextStyles: (value) =>
                                TextStyle(color: Colors.white),
                            reservedSize: 60,
                            //margin: 8,
                            showTitles: true,
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 1:
                                  return data
                                      .cast<num>()
                                      .reduce(min)
                                      .toStringAsFixed(2);
                                case 2:
                                  return (data.cast<num>().reduce(min) + yaxis)
                                      .toStringAsFixed(2);
                                case 3:
                                  return (data.cast<num>().reduce(min) +
                                          2 * yaxis)
                                      .toStringAsFixed(2);
                                case 4:
                                  return (data.cast<num>().reduce(min) +
                                          3 * yaxis)
                                      .toStringAsFixed(2);
                                case 5:
                                  return (data.cast<num>().reduce(min) +
                                          4 * yaxis)
                                      .toStringAsFixed(2);
                                case 6:
                                  return data
                                      .cast<num>()
                                      .reduce(max)
                                      .toStringAsFixed(2);
                              }
                              return "";
                            }),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.symmetric(
                          horizontal:
                              BorderSide(width: 1, color: Color(0x299e9e9e)),
                        ),
                      ),
                      gridData: FlGridData(
                          show: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                                strokeWidth: 2, color: Color(0x299e9e9e));
                          }),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(12, finaldata[0] ?? 0),
                            FlSpot(11, finaldata[1] ?? 0),
                            FlSpot(10, finaldata[2] ?? 0),
                            FlSpot(9, finaldata[3] ?? 0),
                            FlSpot(8, finaldata[4] ?? 0),
                            FlSpot(7, finaldata[5] ?? 0),
                            FlSpot(6, finaldata[6] ?? 0),
                            FlSpot(5, finaldata[7] ?? 0),
                            FlSpot(4, finaldata[8] ?? 0),
                            FlSpot(3, finaldata[9] ?? 0),
                            FlSpot(2, finaldata[10] ?? 0),
                            FlSpot(1, finaldata[11] ?? 0),
                          ],
                          isCurved: true,
                          barWidth: 2,
                          dotData: FlDotData(show: false),
                          colors: gradient,
                          belowBarData: BarAreaData(
                            show: true,
                            colors: gradient
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ],
                    )),
                  ),
                  //decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
