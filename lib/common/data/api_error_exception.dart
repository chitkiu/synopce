class ApiErrorException implements Exception {
  final Map<String, dynamic> errorType;

  const ApiErrorException([this.errorType = const {}]);

}