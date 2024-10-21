import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/constant.dart';
import 'package:medigo/models/pharmacieModel.dart';
import 'package:medigo/services/api_response.dart';
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
  return apiResponse;
}

Future<ApiResponse> CreatePharmacieService(
    String nom, String commune, String avenue, String quartier, user) async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  debugPrint(token);
  try {
    final response = await http.post(
      Uri.parse(createPharmacie),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'nom': nom,
        'commune': commune,
        'communeavenu': avenue,
        "id_quartier": quartier,
        "id_user": "a",
        "image": "a",
        "agentsId": user.toString()
      },
    );

    switch (response.statusCode) {
      case 201:
        Map<String, dynamic> agent = jsonDecode(response.body) ?? {};
        break;
      case 400:
        final errors = jsonDecode(response.body)['message'];
        if (errors is List) {
          apiResponse.erreur = errors.join("\n");
        } else {
          apiResponse.erreur = "Une erreur inattendue est survenue";
        }
        break;
      case 401:
        apiResponse.erreur =
            "Non autorisé : veuillez vérifier vos informations d'identification.";
        break;

      case 409:
        final conflictError = jsonDecode(response.body)['message'];
        apiResponse.erreur =
            conflictError is String ? conflictError : "Conflit détecté";
        break;
      default:
        apiResponse.erreur =
            "Une erreur s'est produite, veuillez réessayer plus tard.";
        break;
    }
  } catch (e) {
    apiResponse.erreur =
        "Erreur du serveur : impossible de contacter le serveur.";
  }
  return apiResponse;
}

Future<ApiResponse> getPharmacieUserID(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getUserPharmacie/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            pharmacieModel.fromJson(jsonDecode(response.body)['data']);
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

Future<ApiResponse> getPharmacierIDUser(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getPharmacieIdD/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            pharmacieModel.fromJson(jsonDecode(response.body)['data']);
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
