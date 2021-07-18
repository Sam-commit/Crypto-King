import 'dart:convert';

import 'package:http/http.dart';

const String api_key ="418EA998-629C-472A-A3EE-7D784B1767FB"; // CoinAPI key
const String api_key2 = "cd7f4fcc-e999-47b8-8e80-c9cb9fe9f568"; // Coinmarketcap key

class Get_data {
  
  Get_data({this.slug});
  
  final slug;


  Future getdata() async {
    Response response = await get(
        Uri.parse("https://rest.coinapi.io/v1/assets?apikey=$api_key"));
    if (response.statusCode == 200) {
      print(response.statusCode);
      //print(response.body);
      return jsonDecode(response.body);
    }
    else {
      print(response.statusCode);
    }
  }

  Future geticon() async {
    Response response = await get(Uri.parse(
        "https://rest.coinapi.io/v1/assets/icons/%7B30%7D?apikey=$api_key"));
    if (response.statusCode == 200) {
      print(response.statusCode);
     // print(response.body);
      return jsonDecode(response.body);
    }
    else {
      print(response.statusCode);
    }
  }
  
  Future getinfo() async {
    
    Response response = await get(Uri.parse("https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?slug=$slug&CMC_PRO_API_KEY=$api_key2"));
    if(response.statusCode==200){

      return jsonDecode(response.body);

    }
    else{
      print(response.statusCode);
    }
    
  }
  
}



