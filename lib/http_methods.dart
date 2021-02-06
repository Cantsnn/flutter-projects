import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> httpPost(String url, {String itemBody}) async {
  http.Response response = await http.post(
    url,
    headers: <String, String>{
      "Content-type": "application/json",
      "api-key": "captainjacksparrowsayshi",
    },
    body: itemBody,
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> httpGet(String url) async {
  http.Response response = await http.get(
    url,
    headers: <String, String>{
      "Content-type": "application/json",
      "api-key": "captainjacksparrowsayshi",
    },
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> httpPut(String url, String itemBody) async {
  http.Response response = await http.put(
    url,
    headers: <String, String>{
      "Content-type": "application/json",
      "api-key": "captainjacksparrowsayshi",
    },
    body: itemBody,
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> httpDelete(String url) async {
  http.Response response = await http.delete(
    url,
    headers: <String, String>{
      "Content-type": "application/json",
      "api-key": "captainjacksparrowsayshi",
    },
  );
  return json.decode(response.body);
}
