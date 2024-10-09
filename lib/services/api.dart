import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Future<Response> getRequest(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(Uri.parse(url), headers: {
      "Accept": 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (kDebugMode) {
      print("GET URL : $url");
      print("GET STATUS CODE : ${response.statusCode}");
      print("GET RESPONSE : ${response.body}");
    }

    return response;
  }

// postRequest( "www.alsaee.dev" , {"username" : Controller.text}) || {}

  Future<Response> postRequest(String url, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.post(
        Uri.parse(
          url,
        ),
        body: jsonEncode(body),
        headers: {
          "Accept": 'application/json',
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    if (kDebugMode) {
      print("POST URL : $url");
      print("POST BODY : ${body}");
      print("POST STATUS CODE : ${response.statusCode}");
      print("POST RESPONSE : ${response.body}");
    }
    return response;
  }

  Future<Response> putRequest(String url, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    final response = await http.put(
        Uri.parse(
          url,
        ),
        body: jsonEncode(body),
        headers: {
          "Accept": 'application/json',
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    if (kDebugMode) {
      print("PUT URL : $url");
      print("PUT BODY : ${body}");
      print("PUT STATUS CODE : ${response.statusCode}");
      print("PUT RESPONSE : ${response.body}");
    }
    return response;
  }

  Future<Response> deleteRequest(String url, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    final response = await http.delete(
        Uri.parse(
          url,
        ),
        body: jsonEncode(body),
        headers: {
          "Accept": 'application/json',
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        });
    if (kDebugMode) {
      print("DELETE URL : $url");
      print("DELETE BODY : ${body}");
      print("DELETE STATUS CODE : ${response.statusCode}");
      print("DELETE RESPONSE : ${response.body}");
    }
    return response;
  }
}
