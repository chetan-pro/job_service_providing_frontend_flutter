// ignore_for_file: constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables, unused_import

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hindustan_job/services/services_constant/constant.dart'
    as constant;
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import '../connection.dart';
import 'package:http/http.dart' as http;

enum Status {
  Success,
  Loading,
  NetworkError,
  Error,
}

class ApiProvider {
  // for all get request
  static Future get(String url,
      {Map<String, dynamic>? queryParam, headers}) async {
    var dio = Dio();
    var _response;
    if (!kIsWeb) {
      if (!await Connection.isConnected()) {
        toast("No Internet Connection");
        EasyLoading.dismiss();
        return ApiResponse.fromJson(
            {'status': 400, 'body': 'No Internet Connection'});
      }
    }
    EasyLoading.show(status: 'loading...');
    if (queryParam == null) {
      try {
        _response = await dio.get(
          '${constant.url}$url',
          options: Options(
            headers: headers,
          ),
        );
      } on DioError catch (e) {
        EasyLoading.dismiss();

        if (e.response!.statusCode == 400) {
          return ApiResponse.fromJson(
              {'status': e.response!.statusCode, 'body': e.response!.data});
        }

        return ApiResponse.fromJson(
          {
            'status': e.response!.statusCode,
            'body': e.response!.data,
          },
        );
      }
    } else {
      queryParam['Authorization'] = constant.api;

      try {
        _response =
            await http.get(Uri.parse('${constant.url}$url'), headers: headers);
      } on DioError catch (e) {
        return;

        // EasyLoading.dismiss();
        // return ApiResponse.fromJson(
        //     {'status': e.response!.statusCode, 'body': e.response!.data});
      }
    }

    EasyLoading.dismiss();
    return ApiResponse.fromJson(
        {'status': _response.statusCode, 'body': _response.data});
  }

  static Future getWithBaseUrl(String url,
      {Map<String, dynamic>? queryParam, headers}) async {
    var dio = Dio();
    var _response;
    if (!kIsWeb) {
      if (!await Connection.isConnected()) {
        toast("No Internet Connection");
        EasyLoading.dismiss();
        return ApiResponse.fromJson(
            {'status': 400, 'body': 'No Internet Connection'});
      }
    }
    try {
      _response = await dio.get(url,
          options: Options(
            headers: headers,
          ));

      //      _response =
      // await http.get(Uri.parse('${constant.url}$url'), headers: headers);

    } on DioError catch (e) {
      return;

      // EasyLoading.dismiss();
      // if (e.response!.statusCode == 400) {
      //   return ApiResponse.fromJson(
      //       {'status': e.response!.statusCode, 'body': e.response!.data});
      // }

      // return ApiResponse.fromJson({
      //   'status': e.response!.statusCode,
      //   'body': e.response!.data,
      // });
    }

    EasyLoading.dismiss();

    return ApiResponse.fromJson(
        {'status': _response.statusCode, 'body': _response.data});
  }

  static Future delete(String url,
      {Map<String, dynamic>? queryParam, headers}) async {
    var dio = Dio();
    var _response;
    if (!kIsWeb) {
      if (!await Connection.isConnected()) {
        toast("No Internet Connection");
        EasyLoading.dismiss();
        return ApiResponse.fromJson(
            {'status': 400, 'body': 'No Internet Connection'});
      }
    }
    EasyLoading.show(status: 'deleting...');
    if (queryParam == null) {
      try {
        _response = await dio.delete(
          '${constant.url}$url',
          options: Options(
            headers: headers,
          ),
        );

        //      _response =
        // await http.get(Uri.parse('${constant.url}$url'), headers: headers);

      } on DioError catch (e) {
        return;

        EasyLoading.dismiss();
        if (e.response!.statusCode == 400) {
          return ApiResponse.fromJson(
              {'status': e.response!.statusCode, 'body': e.response!.data});
        }

        return ApiResponse.fromJson({
          'status': e.response!.statusCode,
          'body': {"message": "Internal Server error"}
        });
      }
    } else {
      queryParam['Authorization'] = constant.api;
      // 'BdyRCBgXrI5PqGJc5oIWdUxd0zmjSEFQ9Ftv14rcplfWsdBU38hdjA3WaIDjBMlWtO1g6setNT4p1edBHNTRRoSg6Jl1vZJeTJSa';

      try {
        _response =
            await http.get(Uri.parse('${constant.url}$url'), headers: headers);
      } on DioError catch (e) {
        return;
        EasyLoading.dismiss();
        return ApiResponse.fromJson(
            {'status': e.response!.statusCode, 'body': e.response!.data});
      }
    }

    EasyLoading.dismiss();
    return ApiResponse.fromJson(
        {'status': _response.statusCode, 'body': _response.data});
  }

  // for all post request
  static Future post(
      {String? url,
      Map<String, dynamic> body = const {},
      bool media = false,
      bool isSendNullValue = false,
      headers,
      loaderShow = true}) async {
    if (!kIsWeb) {
      if (!await Connection.isConnected()) {
        toast("No Internet Connection");
        EasyLoading.dismiss();
        return ApiResponse.fromJson(
            {'status': 400, 'body': 'No Internet Connection'});
      }
    }

    try {
      if (body.isNotEmpty && !isSendNullValue) {
        body = removeNullEmptyKey(body);
      }
      var dio = Dio();
      FormData? formData;
      if (media) formData = FormData.fromMap(body);
      if (loaderShow) {
        EasyLoading.show(status: 'loading...');
      }
      var _response = await dio.post(
        '${constant.url}$url',
        data: media ? formData : body,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            EasyLoading.dismiss();
            return status! < 500;
          },
          headers: headers,
        ),
      );
      EasyLoading.dismiss();
      return ApiResponse.fromJson(
          {'status': _response.statusCode, 'body': _response.data});
    } catch (e) {
      EasyLoading.dismiss();
      return ApiResponse.fromJson({
        'status': 500,
        'body': {'message': 'Internal Server error'}
      });
    }
  }
}
