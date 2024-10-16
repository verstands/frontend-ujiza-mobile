import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujiza/constant.dart';
import 'package:ujiza/models/VilleModel.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> SignInService(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(PostSignIn),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    switch (response.statusCode) {
      case 201:
        SharedPreferences pref = await SharedPreferences.getInstance();
        String token = jsonDecode(response.body)['access_token'] ?? '';
        pref.setString('token', token);
        Map<String, dynamic> agent = jsonDecode(response.body)['agent'] ?? {};
        pref.setString('agent', jsonEncode(agent));
        await pref.commit();
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
