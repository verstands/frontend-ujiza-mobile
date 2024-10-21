import 'dart:convert';
import 'package:medigo/services/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/constant.dart';
import 'package:medigo/models/CommuneModel.dart';
import 'package:medigo/models/VilleModel.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getCommuneByVille(String id) async {
  ApiResponse apiResponse = ApiResponse();
  print('$getCommuneByVille/$id');
  try {
    final response = await http.get(
      Uri.parse('$getAllCommuneByVille/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => CommuneModel.fromJson(e))
            .toList();
        break;
      case 422:
        final errors = jsonDecode(response.body)['code'];
        apiResponse.erreur = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.erreur = unauthorized;
        break;
      default:
        apiResponse.erreur = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.erreur = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> getCommuneAll() async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await http.get(
      Uri.parse(getAllCommune),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => CommuneModel.fromJson(e))
            .toList();
        break;
      case 422:
        final errors = jsonDecode(response.body)['code'];
        apiResponse.erreur = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.erreur = unauthorized;
        break;
      default:
        apiResponse.erreur = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.erreur = serverError;
  }

  return apiResponse;
}
