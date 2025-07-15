// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:mime/mime.dart';
//
// import '../../../utils/app_string.dart';
// import '../../../utils/validation_string.dart';
// import '../../../widget/device_detection.dart';
// import '../../core/common/app_preferences.dart';
// import '../../core/common/global_mobile_controller.dart';
// import '../../core/common/logger.dart';
// import '../../core/common/url_provider.dart';
// import '../../modules/login/model/login_model.dart';
// import '../../routes/app_pages.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mime/mime.dart';

import '../../../utils/app_string.dart';
import '../../../utils/validation_string.dart';
import '../../../widget/device_detection.dart';
import '../../core/common/app_preferences.dart';
import '../../core/common/global_mobile_controller.dart';
import '../../core/common/logger.dart';
import '../../core/common/url_provider.dart';
import '../../modules/login/model/login_model.dart';
import '../../routes/app_pages.dart';

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
      customPrint("callStringPost throw $e");
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
      customPrint("callPost throw $e");
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
      customPrint("callPostWithoutHeader throw $e");
      throw handleDioException(e);
    } catch (e) {
      customPrint("API response is $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPut(String url, Map<String, dynamic> params) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
      customPrint("param:- $params");
    }
    try {
      var response = await dio.put(UrlProvider.baseUrl + url, data: params, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 3000));
      customPrint("put response := $response");
      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("callPut throw $e");
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPutWithoutError(String url, Map<String, dynamic> params) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      var response = await dio.put(UrlProvider.baseUrl + url, data: params, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      customPrint("put response := $response");
      return response.data;
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("callPutWithoutError throw $e");
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
      customPrint("callPostMultipartDio throw $e");
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPostMultiPartDioListOfFiles({required String url, required Map<String, dynamic> params, required Map<String, List<File>> files, required String token}) async {
    customPrint("URL is :- $url");
    customPrint("files is :- $files");
    customPrint("params is :- $params");
    customPrint("token is :- $token");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      FormData formData = FormData.fromMap(params);

      for (String key in files.keys) {
        for (File file in files[key]!) {
          String mimeType = lookupMimeType(file.path) ?? "";

          formData.files.add(MapEntry(key, await MultipartFile.fromFile(file.path, contentType: DioMediaType.parse(mimeType))));
        }
      }

      if (getApiHeader() != null) {
        dio.options.headers["Content-Type"] = "multipart/form-data";
        dio.options.headers["Authorization"] = "Bearer $token";
        customPrint("header is:- ${dio.options.headers}");
      }

      customPrint("formdata is $formData");
      customPrint("header is ${dio.options.headers}");

      var response = await dio.post(UrlProvider.baseUrl + url, data: formData);

      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("callPostMultiPartDioListOfFiles throw $e");
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callPutMultiPartDioListOfFiles({required String url, required Map<String, dynamic> params, required Map<String, List<File>> files, required String token}) async {
    customPrint("URL is :- $url");
    customPrint("files is :- $files");
    customPrint("params is :- $params");
    customPrint("token is :- $token");

    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
    }
    try {
      FormData formData = FormData.fromMap(params);

      for (String key in files.keys) {
        for (File file in files[key]!) {
          String mimeType = lookupMimeType(file.path) ?? "";

          formData.files.add(MapEntry(key, await MultipartFile.fromFile(file.path, contentType: DioMediaType.parse(mimeType))));
        }
      }

      if (getApiHeader() != null) {
        dio.options.headers["Content-Type"] = "multipart/form-data";
        dio.options.headers["Authorization"] = "Bearer $token";
        customPrint("header is:- ${dio.options.headers}");
      }

      customPrint("formdata is $formData");
      customPrint("header is ${dio.options.headers}");

      var response = await dio.put(UrlProvider.baseUrl + url, data: formData);

      return getResponse(response.data);
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("callPutMultiPartDioListOfFiles throw $e");
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callGet(String url, {Map<String, dynamic>? queryParameters}) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
      customPrint("queryParameters: $queryParameters");
    }
    try {
      // customPrint("-------------------------------");
      // customPrint("queryParameters: $queryParameters");
      // customPrint("header is ${getApiHeader()}");
      // customPrint("url is : $url");
      // customPrint("-------------------------------");
      var response = await dio.get(UrlProvider.baseUrl + url, queryParameters: queryParameters, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
      // customPrint("-------------------------------");
      // customPrint("API response $response");
      // customPrint("-------------------------------");
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
      customPrint("callGet throw $e");
      throw handleDioException(e);
    } catch (e) {
      customPrint("use is not authorised ");
      customPrint("catch $e");
      rethrow;
    }
  }

  // FutureOr<Map<String, dynamic>> callGetDownloadPDF(String url, {Map<String, dynamic>? queryParameters}) async {
  //   if (kDebugMode) {
  //     print(UrlProvider.baseUrl + url);
  //     print("queryParameters: $queryParameters");
  //   }
  //
  //   try {
  //     customPrint("-------------------------------");
  //     customPrint("queryParameters: $queryParameters");
  //     customPrint("header is ${getApiHeader()}");
  //     customPrint("url is : $url");
  //     customPrint("-------------------------------");
  //
  //     var response = await dio.get(UrlProvider.baseUrl + url, queryParameters: queryParameters, options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 30));
  //
  //     customPrint("-------------------------------");
  //     customPrint("API response $response");
  //     customPrint("-------------------------------");
  //
  //     // Handle response based on the type
  //     if (response.data is List) {
  //       return {"data": response.data}; // If the data is a List, wrap it in a Map
  //     }
  //
  //     // If response.data is a String, it could be an error message or PDF in base64
  //     if (response.data is String) {
  //       // Here, handle the string appropriately based on what you expect it to be:
  //       // If it's an error message, return the error.
  //       // If it's a base64 PDF, decode and save it.
  //       try {
  //         // Check if the String is a valid JSON object (Map or List)
  //         var jsonData = jsonDecode(response.data);
  //         if (jsonData is Map<String, dynamic>) {
  //           return jsonData; // Return it if it's a valid JSON Map
  //         } else {
  //           return {"data": response.data}; // Otherwise, return as raw string data
  //         }
  //       } catch (e) {
  //         // If it's not valid JSON, it could be a base64-encoded PDF or some other data
  //         customPrint("Error decoding JSON: $e");
  //         // Here, you could decide to handle it as a base64 string and save it as a PDF, for example
  //         return {"data": response.data}; // or handle as you need
  //       }
  //     }
  //
  //     // If the response data is a Future, await it
  //     if (response.data is Future) {
  //       return await response.data; // Await and return the result as Map<String, dynamic>
  //     }
  //
  //     // If it's a Map<String, dynamic>, return the data as is
  //     return response.data;
  //   } on TimeoutException {
  //     throw ValidationString.validationRequestTimeout;
  //   } on SocketException {
  //     throw ValidationString.validationNoInternetFound;
  //   } on DioException catch (e) {
  //     customPrint("DioException $e");
  //     throw handleDioException(e);
  //   } catch (e) {
  //     customPrint("catch $e");
  //     rethrow;
  //   }
  // }

  Future<Uint8List> callGetDownloadPDF(String url, {Map<String, dynamic>? queryParameters}) async {
    if (kDebugMode) {
      customPrint(UrlProvider.baseUrl + url);
      customPrint("queryParameters: $queryParameters");
    }

    try {
      customPrint("-------------------------------");
      customPrint("queryParameters: $queryParameters");
      customPrint("header is ${getApiHeader()}");
      customPrint("url is : $url");
      customPrint("-------------------------------");

      // Set responseType to bytes for PDF download
      var response = await dio
          .get(
            UrlProvider.baseUrl + url,
            queryParameters: queryParameters,
            options: Options(
              headers: getApiHeader(),
              responseType: ResponseType.bytes, // This is crucial for PDF downloads
            ),
          )
          .timeout(const Duration(seconds: 30));

      customPrint("-------------------------------");
      customPrint("API response received with length: ${response.data.length}");
      customPrint("-------------------------------");

      // Directly return the bytes for PDF
      if (response.data is Uint8List) {
        return response.data;
      }

      // Handle case where response might still be a Map (shouldn't happen with responseType: bytes)
      if (response.data is Map<String, dynamic>) {
        throw Exception("Unexpected JSON response for PDF download");
      }

      // Handle other unexpected cases
      throw Exception("Unknown response format for PDF download");
    } on TimeoutException {
      throw ValidationString.validationRequestTimeout;
    } on SocketException {
      throw ValidationString.validationNoInternetFound;
    } on DioException catch (e) {
      customPrint("DioException $e");
      customPrint("callGetDownloadPDF throw $e");
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
      var response = await dio.delete(UrlProvider.baseUrl + url, queryParameters: queryParameters, data: jsonEncode(data), options: Options(headers: getApiHeader())).timeout(const Duration(seconds: 120));

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
      customPrint("callDelete throw $e");
      throw handleDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> getResponse(Map<String, dynamic> data) {
    Map<String, dynamic> response = Map.from(data);
    // if (response["response_type"] == "error") {
    //   throw response["message"] ?? "Something went wrong";
    // }
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

    // Map<String, String> headers = {"accept": "application/json"};
    Map<String, String> headers = {"accept": "*/*", "Content-Type": "application/json"};

    customPrint("header is $headers");
    return headers.isEmpty ? null : headers;
  }

  Future<String> handleDioException(DioException e) async {
    if (e.response?.statusCode == 401) {
      // NavigatorKey.instance.routeToNamedReplacement(AppRoute.login);

      String deviceType = await getDeviceType(Get.context!);

      if (deviceType == 'iPhone' || deviceType == 'Android Phone') {
        unAuthorisedMobileLogOut();
      } else {
        unAuthorisedLogOut();
      }

      throw e.response?.data["message"];
    }

    if (e.response?.statusCode == 400) {
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

    if (e.response?.data is Map) {
      if (e.response?.data["response_type"] == "error") {
        throw e.response?.data["message"] ?? "Something went wrong";
      }
    }
    throw e.message ?? ValidationString.validationSomethingWentWrong;
  }

  void unAuthorisedMobileLogOut() async {
    await AppPreference.instance.removeKey(AppString.prefKeyUserLoginData);
    await AppPreference.instance.removeKey(AppString.prefKeyToken);

    Get.delete<GlobalMobileController>();
    Get.offAllNamed(Routes.LOGIN_VIEW_MOBILE);
  }
}
