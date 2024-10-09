import 'dart:convert';
import 'package:ujiza/constant.dart';
import 'package:ujiza/models/pharmacieModel.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getPharmacieLists() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse(getAllPharmacie),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => pharmacieModel.fromJson(e))
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

Future<ApiResponse> getPharmacieId(String id) async {
  ApiResponse apiResponse = ApiResponse();
  print("oooooooooooooooooooooooooooooooo");
  try {
    final response = await http.get(
      Uri.parse('$getAllPharmacieQte/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => pharmacieModel.fromJson(e))
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
  print("oooooooooooooooooooooooooooooooo");

  return apiResponse;
}
