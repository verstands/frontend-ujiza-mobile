class ApiResponse<T> {
  T? data;
  String? erreur;

  ApiResponse({this.data, this.erreur});
}
