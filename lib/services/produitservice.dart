import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/constant.dart';
import 'package:medigo/models/produitPharModel.dart';
import 'package:medigo/services/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getProduitListsByPharmacie(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getAllProduitByPharmacie/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => ProduitPharModel.fromJson(e))
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

Future<ApiResponse> getProduitList() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse(getAllproductList),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => ProduitPharModel.fromJson(e))
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

Future<ApiResponse> getCountmedicament(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('${countMedicament}/${id}'),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['count'];
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

Future<ApiResponse> getsommePrix(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('${sommeMedicament}/${id}'),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['total'];
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

Future<ApiResponse> getMyProduit(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getUserMyMedicament/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => ProduitPharModel.fromJson(e))
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

Future<ApiResponse> CreateMymediment(String nom, String dosage, String prix,
    String description, String pharmacie) async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await http.post(
      Uri.parse(getAllproductList),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'nom': nom,
        'dosage': dosage,
        'prix': prix,
        "description": description,
        "id_pharmacie": pharmacie,
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

Future<ApiResponse> UpdateProduitUser(String nom, String dosage, String prix,
    String description, String id) async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await http.put(
      Uri.parse('$getAllproductList/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'nom': nom,
        'dosage': dosage,
        'prix': prix,
        'description': description,
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
        apiResponse.erreur = jsonDecode(response.body)['message'];
        break;
    }
  } catch (e) {
    apiResponse.erreur =
        "Erreur du serveur : impossible de contacter le serveur.";
  }
  return apiResponse;
}

Future<ApiResponse> DeleteProduitUser(String id) async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await http.delete(
      Uri.parse('$getAllproductList/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
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
        apiResponse.erreur = jsonDecode(response.body)['message'];
        break;
    }
  } catch (e) {
    apiResponse.erreur =
        "Erreur du serveur : impossible de contacter le serveur.";
  }
  return apiResponse;
}
