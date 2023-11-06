import 'dart:developer';
import 'dart:io';
//import 'package:dio/dio.dart';
import 'package:ant_pay/constants/api.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpService {
  static String host = Api.baseUrl;
  static di.Dio dio = di.Dio();

  //for get api calls
  /* static Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    return dio.get(
      uri,
    );
  }*/

  //for post api calls
  static Future<di.Response> postFromDio(
    String url,
    body, {
    String accessToken = "",
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    Map<String, String> header = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };
    print(url);
    return dio.post(uri, data: body, options: di.Options(headers: header));
  }

  //for post api calls with file upload
  static Future<di.Response> postWithFiles(String url, body,
      {String accessToken = ""}) async {
    //preparing the api uri/url
    String uri = "$host$url";
    Map<String, String> header = {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    };
    di.Response response;
    try {
      response = await dio.post(uri,
          data: di.FormData.fromMap(body),
          options: di.Options(headers: header));
    } catch (error) {
      response = error as di.Response;
    }

    return response;
  }

  //for patch api calls
  /*Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    return dio.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }*/

  //for delete api calls
  /*Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";
    return dio.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }*/

  /*Response formatDioExecption(DioError ex) {
    var response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    try {
      if (ex.type == DioErrorType.connectTimeout) {
        response.data = {
          "message":
              "Connection timeout. Please check your internet connection and try again",
        };
      } else {
        response.data = {
          "message": ex.message ??
              "Please check your internet connection and try again",
        };
      }
    } catch (error) {
      response.statusCode = 400;
      response.data = {
        "message": error.message ??
            "Please check your internet connection and try again",
      };
    }

    return response;
  }*/

  static Future<Response> getRequest(String? endPoint,
      {bool bearerToken = false, String accessToken = ""}) async {
    Map<String, String>? headers;
    Response response;
    //var accessToken = getStringAsync(access);

    if (bearerToken) {
      headers = {
        HttpHeaders.acceptHeader: 'application/json',
        "Authorization": "Bearer $accessToken"
      };
    }

    String uri = "$host$endPoint";

    if (bearerToken) {
      response = await get(Uri.parse('$uri'), headers: headers);
    } else {
      response = await get(Uri.parse('$uri'));
    }

    //debugPrint('Response: ${response.statusCode} ${response.body}');
    return response;
  }

  static postRequest(String endPoint, Map? requestBody,
      {bool bearerToken = false,
      String accessToken = "",
      bool validationUrl = false}) async {
    Response? response;
    String uri = validationUrl ? endPoint : "$host$endPoint";

    var headers = {
      HttpHeaders.acceptHeader: 'application/json',
    };

    if (bearerToken) {
      var header = {"Authorization": "Bearer $accessToken"};
      headers.addAll(header);
    }
    try {
      response =
          await post(Uri.parse('$uri'), body: requestBody, headers: headers);
    } catch (e) {
      log(e.toString());
    }
    //debugPrint('Response: ${response.statusCode} ${response.body}');
    return response;
  }

  static putRequest(String endPoint, Map request,
      {bool bearerToken = true, String accessToken = ""}) async {
    late Response response;
    String uri = "$host$endPoint";

    var headers = {
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };

    if (bearerToken) {
      var header = {"Authorization": "Bearer $accessToken"};
      headers.addAll(header);
    }
    try {
      response = await put(Uri.parse('$uri'), body: request, headers: headers);
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('Response: ${response.statusCode} ${response.body}');
    return response;
  }
}
