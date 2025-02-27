import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import '../../../utils/app_string.dart';
import '../../../utils/validation_string.dart';
import '../../core/common/app_preferences.dart';
import '../../core/common/logger.dart';
import '../../core/common/url_provider.dart';
import '../../modules/login/model/login_model.dart';

class ApiProvider {
  static final ApiProvider _apiProvider = ApiProvider._internal();

  ApiProvider._internal();

  static ApiProvider get instance => _apiProvider;

  final Dio dio = Dio();

  Future<bool> callStringPost(String url, {Map<String, dynamic>? params}) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response = await dio.post(UrlProvider.baseUrl + url, data: params, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      var res = response.data is String;
      return res;
      // return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPost(String url, {Map<String, dynamic>? params}) async {
    customPrint("API parameter is $params");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response = await dio.post(UrlProvider.baseUrl + url, data: jsonEncode(params), options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      customPrint("API response is $response");
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("API response is $e");
      throw handleDioException(e);
    } catch (e) {
      customPrint("API response is $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPostWithoutHeader(String url, {Map<String, dynamic>? params}) async {
    customPrint("API parameter is $params");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response = await dio.post(UrlProvider.baseUrl + url, data: jsonEncode(params), options: Options(headers: getApiHeaderWithoutToken())).timeout(const Duration(seconds: 30));
      customPrint("API response is $response");
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("API response is $e");
      throw handleDioException(e);
    } catch (e) {
      customPrint("API response is $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPut(String url, Map<String, dynamic> params) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response = await dio.put(UrlProvider.baseUrl + url, data: params, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPostMultiPartDio(String url, Map<String, dynamic> params, Map<String, File> files, String mimeTye, String token) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      FormData formData = FormData.fromMap(params);

      for (String key in files.keys) {
        formData.files.add(MapEntry(key, await MultipartFile.fromFile(files[key]!.path, contentType: DioMediaType.parse(mimeTye))));
      }

      if (getApiHeader() != null) {
        dio.options.headers["Content-Type"] = "multipart/form-data";
        dio.options.headers["Authorization"] = "Bearer $token";
        customPrint("header is:- ${dio.options.headers}");
      }

      customPrint("formdata is ${formData.files.first.value}");
      customPrint("header is ${dio.options.headers}");

      var response = await dio.post(UrlProvider.baseUrl + url, data: formData);

      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPostMultiPartDioListOfFiles({required String url, required Map<String, dynamic> params, required Map<String, List<File>> files, required String token}) async {
    customPrint("URL is :- ${url}");
    customPrint("files is :- ${files}");
    customPrint("params is :- ${params}");
    customPrint("token is :- ${token}");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      FormData formData = FormData.fromMap(params);

      for (String key in files.keys) {
        for (File file in files[key]!) {
          String mimeType = lookupMimeType(file.path) ?? "";

          formData.files.add(MapEntry(
            key,
            await MultipartFile.fromFile(file.path, contentType: DioMediaType.parse(mimeType)),
          ));
        }
      }

      if (getApiHeader() != null) {
        dio.options.headers["Content-Type"] = "multipart/form-data";
        dio.options.headers["Authorization"] = "Bearer $token";
        customPrint("header is:- ${dio.options.headers}");
      }

      customPrint("formdata is ${formData}");
      customPrint("header is ${dio.options.headers}");

      var response = await dio.post(UrlProvider.baseUrl + url, data: formData);

      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPutMultiPartDioListOfFiles({required String url, required Map<String, dynamic> params, required Map<String, List<File>> files, required String token}) async {
    customPrint("URL is :- ${url}");
    customPrint("files is :- ${files}");
    customPrint("params is :- ${params}");
    customPrint("token is :- ${token}");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      FormData formData = FormData.fromMap(params);

      for (String key in files.keys) {
        for (File file in files[key]!) {
          String mimeType = lookupMimeType(file.path) ?? "";

          formData.files.add(MapEntry(
            key,
            await MultipartFile.fromFile(file.path, contentType: DioMediaType.parse(mimeType)),
          ));
        }
      }

      if (getApiHeader() != null) {
        dio.options.headers["Content-Type"] = "multipart/form-data";
        dio.options.headers["Authorization"] = "Bearer $token";
        customPrint("header is:- ${dio.options.headers}");
      }

      customPrint("formdata is ${formData}");
      customPrint("header is ${dio.options.headers}");

      var response = await dio.put(UrlProvider.baseUrl + url, data: formData);

      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callGet(String url, {Map<String, dynamic>? queryParameters}) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      customPrint("-------------------------------");
      customPrint("queryParameters: $queryParameters");
      customPrint("url is : $url");
      customPrint("-------------------------------");
      var response = await dio.get(UrlProvider.baseUrl + url, queryParameters: queryParameters, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      customPrint("-------------------------------");
      customPrint("API response $response");
      customPrint("-------------------------------");
      if (response.data is List) {
        return {"data": response.data};
      }
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("DioException $e");
      throw handleDioException(e);
    } catch (e) {
      customPrint("catch $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callDelete({required String url, Map<String, dynamic>? queryParameters, required Map<String, dynamic> data}) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response =
          await dio.delete(UrlProvider.baseUrl + url, queryParameters: queryParameters, data: jsonEncode(data), options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 120));

      if (response.data is List) {
        return {"data": response.data};
      } else if (response.data is String) {
        return {"data": response.data};
      }
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> getResponse(Map<String, dynamic> data) {
    Map<String, dynamic> response = Map.from(data);
    if (response["response_type"] == "error") {
      throw response["message"] ?? "Something went wrong";
    }
    return response;
  }

  Map<String, String>? getApiHeader() {
    customPrint("getApiHeader");
    String token = "";
    String loginKey = AppPreference.instance.getString(AppString.prefKeyUserLoginData);
    if (loginKey.isNotEmpty) {
      LoginModel loginModel = LoginModel.fromJson(jsonDecode(loginKey));
      token = loginModel.responseData?.token ?? "";
    } else {}

    // Initialize the headers map
    Map<String, String> headers = {"accept": "*/*", "Content-Type": "application/json"};

    // Add x-session header if token exists
    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    customPrint("header is $headers");
    return headers.isEmpty ? null : headers;
  }

  Map<String, String>? getApiHeaderWithoutToken() {
    customPrint("getApiHeader");

    // Initialize the headers map
    Map<String, String> headers = {"accept": "*/*", "Content-Type": "application/json"};

    customPrint("header is $headers");
    return headers.isEmpty ? null : headers;
  }

  String handleDioException(DioException e) {
    if (e.response?.data is Map) {
      if (e.response?.data["response_type"] == "error") {
        throw e.response?.data["message"] ?? "Something went wrong";
      }
    }
    if (e.response?.statusCode == 400) {
      throw e.response?.data["message"];
    }
    if (e.response?.statusCode == 401) {
      // NavigatorKey.instance.routeToNamedReplacement(AppRoute.login);
      throw e.response?.data["message"];
    }
    if (e.response?.statusCode == 422) {
      throw e.response?.data["data"];
    }
    if (e.response?.statusCode == 403) {
      /*TFAStatusModel tfaStatusModel = TFAStatusModel.fromJson(e.response?.data["data"]);
      if (tfaStatusModel.statusCode == 5001) {
        if (!(tfaStatusModel.twoFactorStatus ?? true) && ((tfaStatusModel.twoFactorEnabled ?? false) || (tfaStatusModel.org2faEnabled ?? false))) {
          NavigatorKey.instance.routeToNamedReplacement(AppRoutes.enforced_2fa);
        } else if ((tfaStatusModel.twoFactorStatus ?? false) && (tfaStatusModel.twoFactorVerified ?? false)) {
          NavigatorKey.instance.routeToNamedReplacement(AppRoutes.two_factor_auth);
        }
        throw "";
      }*/
      throw e.response?.data["data"];
    }
    throw e.message ?? ValidationString.validationSomethingWentWrong;
  }
}
