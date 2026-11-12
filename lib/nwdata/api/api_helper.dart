import 'package:sahajghara/screens/utils/JsonHelper.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_contants.dart';

class APIHelper {
  Dio dio = Dio()
    ..interceptors.add(InterceptorsWrapper(onResponse: (response, handler) {
      try {
        if (response.data is String || response.data is Map) {
          final data = JsonHelper.toMap(response.data);
          for (final key in ['HasError', 'success', 'sucess']) {
            if (data.containsKey(key)) {
              data[key] = JsonHelper.toNullableBool(data[key]);
            }
          }
          response.data = data;
        }
        handler.next(response);
      } catch (error) {
        handler.reject(DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: error));
      }
    }));

  withOutTokenGetMethod({url}) async {
    return await dio
        .get(url,
            options: Options(headers: {
              "accept": "application/json",
              "Content-Type": "application/json"
            }))
        .then((value) => value);
  }
  // get request

  getMethod({url}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = '';

    return await dio
        .get(url,
            options: Options(
                headers: token == ""
                    ? {
                        "accept": "application/json",
                        "Content-Type": "application/json"
                      }
                    : {
                        "Accept": 'application/json',
                        "Content-Type": 'application/json',
                        "Authorization": "Bearer $token",
                      }))
        .then((value) => value);
  }

  // post request

  postMethod({url, var body}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";
    // Utills.customPrint("postmethod 1 $token");

    return await dio
        .post(
          url,
          data: body,
          options: Options(headers: {
            "Accept": 'application/json',
            "Content-Type": 'application/json',
            "Authorization": "Bearer $token",
          }),
        )
        .then((value) => value);
  }

  postRequest({url, var body}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = "";
    // Utills.customPrint("postmethod 1 $token");

    var headers = {'Content-Type': 'application/json'};

    var response = await dio.request(
      url,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );
    return await dio
        .post(
          url,
          data: body,
          options: Options(headers: {
            "Accept": 'application/json',
            "Content-Type": 'application/json',
            "Authorization": "Bearer $token",
          }),
        )
        .then((value) => value);
  }

  // put request

  putMethod({url, body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(APIConstants.token) ?? "";
    return await dio
        .put(
          url,
          data: body,
          options: Options(
              headers: token == ""
                  ? {
                      "accept": "application/json",
                      "Content-Type": "application/json"
                    }
                  : {
                      "Accept": 'application/json',
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer $token",
                    }),
        )
        .then((value) => value);
  }

// put request

  deleteMethod({url, details}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(APIConstants.token) ?? "";
    return await dio
        .delete(
          url,
          data: details,
          options: Options(
              headers: token == ""
                  ? {
                      "accept": "application/json",
                      "Content-Type": "application/json"
                    }
                  : {
                      "Accept": 'application/json',
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer $token",
                    }),
        )
        .then((value) => value);
  }
}
