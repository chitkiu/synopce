import 'package:synoapi/synoapi.dart';

import 'models/api_error_exception.dart';

Future<T> wrapRequest<T>(Future<APIResponse<T>> request) async {
  APIResponse<T> result = await request;
  if (result.success) {
    return result.data!;
  } else {
    throw ApiErrorException(result.error ?? {});
  }
}