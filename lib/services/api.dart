import 'dart:convert';
import 'dart:io';

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
    if (response.statusCode == 401) {
      await refreshToken().then((refreshed) {
        if (refreshed) {
          getRequest(
            url,
          );
        }
      });
    }
    return response;
  }

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
    if (response.statusCode == 401) {
      await refreshToken().then((refreshed) {
        if (refreshed) {
          postRequest(url, body);
        }
      });
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

    if (response.statusCode == 401) {
      await refreshToken().then((refreshed) {
        if (refreshed) {
          putRequest(url, body);
        }
      });
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

    if (response.statusCode == 401) {
      await refreshToken().then((refreshed) {
        if (refreshed) {
          deleteRequest(url, body);
        }
      });
    }
    return response;
  }

  Future<bool> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? oldToken = prefs.getString("token");

    print("REFRESH OLDTOKEN : ${oldToken}");

    final response = await http
        .post(Uri.parse("https://lati.kudo.ly/api/refresh"), headers: {
      "Accept": 'application/json',
      "content-type": "application/json",
      "Authorization": "Bearer $oldToken"
    });

    if (response.statusCode == 200) {
      var decodedToken = json.decode(response.body)['access_token'];
      prefs.setString("token", decodedToken);
      if (kDebugMode) {
        print("REFRESH STATUS CODE : ${response.statusCode}");
        print("REFRESH RESPONSE : ${response.body}");
      }
      return true;
    } else {
      if (kDebugMode) {
        print("REFRESH STATUS CODE : ${response.statusCode}");
        print("REFRESH RESPONSE : ${response.body}");
      }
      return false;
    }
  }

  upload(File file, String url) {}
}
