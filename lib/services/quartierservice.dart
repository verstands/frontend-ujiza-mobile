import 'dart:convert';
import 'package:ujiza/constant.dart';
import 'package:ujiza/models/CommuneModel.dart';
import 'package:ujiza/models/QuartierModel.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getQuartierCommune(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$getAllQuartierByCommune/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => QuartierModel.fromJson(e))
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
