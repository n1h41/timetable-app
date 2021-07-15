import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Webservices {
  Future userLogin(data) async {
    final url = Uri.parse('${host}authentication/login');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    return response;
  }
  Future registerUser(data) async {
    final url = Uri.parse('${host}authentication/register');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    return response;
  }
  Future getEntryList() async {
    final url = Uri.parse('${host}home/entry/view/all');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth-token');
    final response = await http.get(url, headers: {'auth-token': token!});
    return response;
  }
  Future addEntry(data) async {
    final url = Uri.parse('${host}home/entry/add');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth-token');
    final response = await http.post(url, headers: {'auth-token': token!, "Content-Type": "application/json"}, body: data);
    return response;
  }
  Future deleteEntry(id) async {
    final url = Uri.parse('${host}home/entry/delete?id=$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth-token');
    final response = await http.delete(url, headers: {'auth-token': token!});
    return response;
  }
  Future getAllUsers() async {
    final url = Uri.parse('${host}admin/user/list');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth-token');
    final response = await http.get(url, headers: {'auth-token': token!});
    return response;
  }
  Future getUserEntries(id) async {
    final url = Uri.parse('${host}admin/user/entries?id=$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth-token');
    final response = await http.get(url, headers: {'auth-token': token!});
    return response;
  }
}
