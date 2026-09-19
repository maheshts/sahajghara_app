import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/helpers/custom_toast.dart';

import '../../../helpers/CommonResponse.dart';
import '../../../helpers/utillls.dart';
import '../../../nwdata/service/profile_service.dart';

final vendorDetailProvider =
StateNotifierProvider<VendorEnquiryDetailController,
    AsyncValue<CommonResponse?>>(
      (ref) => VendorEnquiryDetailController(ref),
);
final reviewSubmitProvider =
StateNotifierProvider<VendorEnquiryDetailController,
    AsyncValue<CommonResponse?>>(
      (ref) => VendorEnquiryDetailController(ref),
);

final homeServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});


class VendorEnquiryDetailController
    extends StateNotifier<AsyncValue<CommonResponse?>> {
  final Ref ref;

  VendorEnquiryDetailController(this.ref)
      : super(const AsyncData(null));


  Future<void> getEnquiryDetail(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final response =
        await ref.read(homeServiceProvider)
            .getEnquiryDetailsData(id);

        /// 1️⃣ API Error
        if (response.hasError == true) {
          throw Exception(response.message ?? "Server Error");
        }

        /// 2️⃣ Null result check
        if (response.result == null) {
          throw Exception("Result is null");
        }

        /// 3️⃣ Null details check
        if (response.result!.details == null) {
          throw Exception("Details data is missing");
        }

        return CommonResponse(
          isSuccess: true,
          message: response.message ?? "",
          data: response.result!,
        );

      } catch (e,stackTrace) {
        /// 4️⃣ Model parsing or unexpected error
         Utills.customPrint("Error in getEnquiryDetail: $stackTrace");
        throw Exception("Data parsing error: $e");
      }
    });
  }
  Future<void> getContractorEnquiryDetailsData(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final response =
        await ref.read(homeServiceProvider)
            .getContractorEnquiryDetailsData(id);

        /// 1️⃣ API Error
        if (response.hasError == true) {
          throw Exception(response.message ?? "Server Error");
        }

        /// 2️⃣ Null result check
        if (response.result == null) {
          throw Exception("Result is null");
        }

        /// 3️⃣ Null details check
        if (response.result!.details == null) {
          throw Exception("Details data is missing");
        }

        return CommonResponse(
          isSuccess: true,
          message: response.message ?? "",
          data: response.result!.details,
        );

      } catch (e,stackTrace) {
        /// 4️⃣ Model parsing or unexpected error
         Utills.customPrint("Error in getEnquiryDetail: $stackTrace");
        throw Exception("Data parsing error: $e");
      }
    });
  }
  Future<CommonResponse?> submitReview(Map<String, Object> data) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<CommonResponse>(() async {
      try {
        final response =
        await ref.read(homeServiceProvider)
            .submitReviews(data);

        Utills.customPrint("review response: $response");
        /// 1️⃣ API Error
        if (response['HasError'] == true) {
         // CustomToast.displayWarningToast(content: response['Message'] ?? "Server Error");
         // throw Exception(response.message ?? "Server Error");
          return CommonResponse(
            isSuccess: false,
            message: response['Message'] ?? "Server Error",
           // data: null,
          );
        }else{
          return CommonResponse(
            isSuccess: true,
            message: response.message ?? "",
            data: response['result'],
          );
        }

        /// 2️⃣ Null result check
        if (response.result == null) {
          throw Exception("Result is null");
        }


      } catch (e,stackTrace) {
        /// 4️⃣ Model parsing or unexpected error
         Utills.customPrint("Error in getEnquiryDetail: $stackTrace");
         return CommonResponse(
           isSuccess: true,
           message: "error",

         );
       // throw Exception("Data parsing error: $e");
      }
    });
    return state.value;
  }

}


