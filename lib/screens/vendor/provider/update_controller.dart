import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/nwdata/service/profile_service.dart';
import '../../../helpers/CommonResponse.dart';
import '../../../nwdata/service/home_service.dart';

final vendorQuotationProvider =
StateNotifierProvider<VendorQuotationController,
    AsyncValue<CommonResponse?>>(
      (ref) => VendorQuotationController(ref),
);

final homeServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});


class VendorQuotationController
    extends StateNotifier<AsyncValue<CommonResponse?>> {
  final Ref ref;

  VendorQuotationController(this.ref)
      : super(const AsyncData(null));

  Future<CommonResponse> addVendorQuotation(body) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response =
      await ref.read(homeServiceProvider).addVendorQuotation(body);

      // Utills.customPrint("addVendorQuotation response: $response");

      if (response['HasError'] == true) {
        return CommonResponse(
          isSuccess: false,
          message: response['Message'] ?? "Server Error",
        );
      } else {
        return CommonResponse(
          isSuccess: true,
          message: response['Message'] ?? "",
        );
      }
    });

    /// ✅ RETURN STORED VALUE
    return state.value ??
        CommonResponse(
          isSuccess: false,
          message: "Something went wrong",
        );
  }

}

final contractorQuotationProvider =
StateNotifierProvider<ContractorQuotationController,
    AsyncValue<CommonResponse?>>(
      (ref) => ContractorQuotationController(ref),
);

class ContractorQuotationController
    extends StateNotifier<AsyncValue<CommonResponse?>> {
  final Ref ref;

  ContractorQuotationController(this.ref)
      : super(const AsyncData(null));

  Future<void> addContractorQuotation(dynamic fdata) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response =
      await ref.read(homeServiceProvider).addContractorQuotation();

      if (response['HasError'] == true) {
        throw Exception(response['Message'] ?? "Something went wrong");
      }

      return CommonResponse(
        isSuccess: true,
        message: response['Message'] ?? "",
      );
    });
  }
}

