import 'package:dio/dio.dart';

import '../../helpers/utillls.dart';

class CustomException implements Exception {
  late String message;

  CustomException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.unknown:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.badResponse:
        message = _handleError(dioError);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  _handleError(DioError? error) {
    if (error?.response != null) {
      Utills.customPrint('CustomException | ${error?.response!.statusCode}');
      // return json.decode(json.decode(error?.response!.data['message']));
      String err = Utills.stripHtmlIfNeeded(error?.response!.data);
      return err;
    } else {
      String err = Utills.stripHtmlIfNeeded(error!.message.toString());
      return err;
    }

    // switch (statusCode) {
    //   case 400:
    //     return 'Bad request';
    //   case 404:
    //     return 'The requested resource was not found';
    //   case 409:
    //     return 'User Alreadty exists';
    //   case 500:
    //     return 'Internal server error';
    //   default:
    //     return 'Oops something went wrong';
    // }
  }

  @override
  String toString() => message;
}
