import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/constant.dart';
import 'package:medigo/models/RegistreModel.dart';
import 'package:medigo/models/VilleModel.dart';
import 'package:medigo/services/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse<Map<String, dynamic>>> SignInService(
    String email, String password) async {
  ApiResponse<Map<String, dynamic>> apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(PostSignIn),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 201:
        final responseData = jsonDecode(response.body);
        apiResponse.data = {
          'token': responseData['access_token'],
          'agent_id': responseData['agent']['id'],
          'agent_nom': responseData['agent']['nom'],
          'agent_prenom': responseData['agent']['prenom'],
          'agent_telephone': responseData['agent']['telephone'],
          'agent_email': responseData['agent']['email'],
        };
        break;
      case 400:
        final errors = jsonDecode(response.body)['message'];
        apiResponse.erreur = errors is List
            ? errors.join("\n")
            : "Une erreur inattendue est survenue";
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

Future<ApiResponse> RegistreService(String email, String password, String nom,
    String prenom, String telephone) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(PostSignUp),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'mdp': password,
        'prenom': prenom,
        "nom": nom,
        "telephone": telephone,
        "id_fonction": "a",
        "statut": "1"
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
