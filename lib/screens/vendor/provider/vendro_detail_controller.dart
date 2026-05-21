import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/CommonResponse.dart';
import '../../../helpers/utillls.dart';
import '../../../nwdata/service/profile_service.dart';

final vendorDetailProvider =
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
          data: response.result!.details,
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

}


