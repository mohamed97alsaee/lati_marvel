import 'dart:convert';

import 'package:lati_marvel/models/user_model.dart';
import 'package:lati_marvel/providers/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends BaseProvider {
  bool authenticated = false;
  UserModel? currentUser;
  initializeAuthProvider() async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    authenticated = (token != null);




    
    if (authenticated) {
      api.refreshToken();
    }
    print("Bearer Token is : $token");
    print("Auth Status is : $authenticated");

    // if (token == null) {
    //   authenticated = false;
    // } else {
    //   authenticated = true;
    // }

    setBusy(false);
  }

  Future<List> register(Map body) async {
    setBusy(true);

    final response =
        await api.postRequest("https://lati.kudo.ly/api/register", body);

    if (response.statusCode == 200) {
      setFailed(false);
      setBusy(false);

      return [true, json.decode(response.body)['data']];
    } else {
      setFailed(true);
      setBusy(false);

      return [false, json.decode(response.body)['message']];
    }
  }

  Future<List> login(Map body) async {
    setBusy(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response =
        await api.postRequest("https://lati.kudo.ly/api/login", body);

    if (response.statusCode == 200) {
      prefs.setString("token", json.decode(response.body)['access_token']);
      setFailed(false);
      setBusy(false);

      return [true, "Logged in successfully"];
    } else {
      prefs.clear();
      setFailed(true);
      setBusy(false);

      return [false, "Login failed!"];
    }
  }

  logout() async {
    setBusy(true);

    final response =
        await api.postRequest("https://lati.kudo.ly/api/logout", {});

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      setFailed(false);
      setBusy(false);
      return true;
    } else {
      setFailed(true);
      setBusy(false);
      return false;
    }
  }

  refreshToken() async {}

  Future<UserModel?> getCurrentUser() async {
    setBusy(true);

    final response = await api.getRequest("https://lati.kudo.ly/api/user");

    if (response.statusCode == 200) {
      currentUser = UserModel.fromJson(json.decode(response.body)['data']);
      setBusy(false);
      setFailed(false);
      return currentUser;
    } else {
      setBusy(false);
      setFailed(true);
      return null;
    }
  }

  Future<List> updateUserProfile(UserModel um) async {
    setBusy(true);

    final response = await api.putRequest(
        "https://lati.kudo.ly/api/users/update", um.toJson());

    if (response.statusCode == 200) {
      getCurrentUser();
      return [true, json.decode(response.body)['data']];
    } else {
      return [false, json.decode(response.body)['message']];
    }
  }
}
