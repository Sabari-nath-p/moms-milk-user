import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:mommilk_user/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponseModel {
  int statusCode;
  var data;

  ResponseModel({required this.statusCode, required this.data});
}

enum Api { POST, GET, PATCH, PUT, DELETE }

class ApiService {
  static String baseUrl = (true)
      ? "https://api.momsmilk.app"
      : "https://staging.momsmilk.app";

  static Future<String?> getAuthToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("AUTHKEY");
  }

  static Future<void> request({
    required String endpoint,
    Api method = Api.POST,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(ResponseModel data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$endpoint');
    final Map<String, String> requestHeaders = headers ?? {};
    requestHeaders['Content-Type'] = 'application/json';
    requestHeaders["Accept"] = 'application/json';

    if (requiresAuth) {
      final String? token = await getAuthToken();
      log("TOKEN = $token");
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
      } else if (onUnauthenticated != null) {
        onUnauthenticated();
        return;
      }
    }

    http.Response response;

    switch (method) {
      case Api.GET:
        response = await http.get(uri, headers: requestHeaders);
        break;
      case Api.POST:
        response = await http.post(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case Api.PUT:
        response = await http.put(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case Api.DELETE:
        response = await http.delete(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case Api.PATCH:
        response = await http.patch(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    // ─── LOG EVERY RESPONSE SO WE CAN SEE REAL ERRORS ───────────────────
    log("[ $method ] $endpoint ==> ${response.statusCode}");
    log("RAW RESPONSE BODY: ${response.body}");
    // ────────────────────────────────────────────────────────────────────

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = json.decode(response.body);

      if (decoded is Map && decoded["success"] == false) {
        if (onUnauthenticated != null) {
          onUnauthenticated();
        } else {
          Fluttertoast.showToast(
            msg: decoded["message"] ?? "Something went wrong".tr,
          );
        }
        return;
      }

      if (onSuccess != null) {
        onSuccess(
          ResponseModel(statusCode: response.statusCode, data: decoded),
        );
      }
    } else if (response.statusCode == 401) {
      if (onUnauthenticated != null) {
        onUnauthenticated();
      } else {
        Get.deleteAll();
        Get.offAll(
          () => Authenticationscreen(),
          transition: Transition.rightToLeft,
        );
        Fluttertoast.showToast(
          msg: 'You need to log in to continue. Please sign in and try again.'
              .tr,
        );
      }
    } else if (response.statusCode >= 500) {
      // ─── SAFELY PARSE ERROR MESSAGE — handles Map, List, or plain text ──
      String errorMessage = 'Server error occurred';
      try {
        if (response.body.isNotEmpty) {
          final decoded = json.decode(response.body);
          if (decoded is Map) {
            // e.g. {"statusCode":500,"message":"Internal server error"}
            final msg = decoded["message"];
            if (msg is String) {
              errorMessage = msg;
            } else if (msg is List) {
              // e.g. {"message": ["field must be a string", ...]}  — NestJS validation
              errorMessage = msg.join(', ');
            } else {
              errorMessage = decoded["error"]?.toString() ?? response.body;
            }
          } else if (decoded is List) {
            // raw list response — join all string items
            errorMessage = decoded.map((e) => e.toString()).join(', ');
          } else {
            errorMessage = response.body;
          }
        }
      } catch (_) {
        // body is not valid JSON — use raw text
        errorMessage = response.body.isNotEmpty
            ? response.body
            : 'Server error occurred';
      }
      log("SERVER ERROR DETAIL: $errorMessage");
      // ────────────────────────────────────────────────────────────────────

      if (onServerError != null) {
        onServerError(response.statusCode, errorMessage);
      } else {
        Fluttertoast.showToast(
          msg: 'Something went wrong on our end. Please try again later.'.tr,
        );
      }
    } else {
      // 400–499 errors — treat as server/validation errors, NOT success
      String errorMessage = 'Request failed';
      try {
        if (response.body.isNotEmpty) {
          final decoded = json.decode(response.body);
          if (decoded is Map) {
            final msg = decoded["message"];
            if (msg is String) {
              errorMessage = msg;
            } else if (msg is List) {
              // NestJS validation errors: {"message": ["field must be X", ...]}
              errorMessage = msg.join('\n');
            } else {
              errorMessage = decoded["error"]?.toString() ?? response.body;
            }
          } else {
            errorMessage = response.body;
          }
        }
      } catch (_) {
        errorMessage = response.body.isNotEmpty
            ? response.body
            : 'Request failed';
      }
      log("CLIENT ERROR ${response.statusCode}: $errorMessage");

      if (onServerError != null) {
        onServerError(response.statusCode, errorMessage);
      } else {
        Fluttertoast.showToast(msg: errorMessage);
      }
    }
  }

  // ── Convenience methods ───────────────────────────────────────────────────

  Future<void> get({
    required String endpoint,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.GET,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.POST,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> put({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.PUT,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> delete({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.DELETE,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }

  Future<void> patch({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
    Function(dynamic data)? onSuccess,
    Function()? onUnauthenticated,
    Function(int statusCode, String message)? onServerError,
    Function(String message)? onNetworkError,
    Function(dynamic error)? onError,
  }) async {
    await request(
      endpoint: endpoint,
      method: Api.PATCH,
      body: body,
      headers: headers,
      requiresAuth: requiresAuth,
      onSuccess: onSuccess,
      onUnauthenticated: onUnauthenticated,
      onServerError: onServerError,
      onNetworkError: onNetworkError,
      onError: onError,
    );
  }
}
