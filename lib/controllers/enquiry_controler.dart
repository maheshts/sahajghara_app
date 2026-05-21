import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/CommonResponse.dart';
import '../helpers/utillls.dart';
import '../nwdata/service/home_service.dart';
import '../screens/contractor/model/PortfolioData.dart';

final enquiryControllerProvider = ChangeNotifierProvider((ref) => EnquiryController());
enum VendorQuotationStatus {  loading, loaded, error }
enum ContractorQuotationStatus {  loading, loaded, error }
enum VendorQuotationUpdateStatus {  loading, loaded, error }

class EnquiryController extends ChangeNotifier {
  VendorQuotationStatus vendorQuotationStatus = VendorQuotationStatus.loading;
  ContractorQuotationStatus contractorQuotationStatus = ContractorQuotationStatus.loading;
  VendorQuotationUpdateStatus vendorQuotationUpdateStatus = VendorQuotationUpdateStatus.loading;

  List<PortfolioList>? portfolioList;

  Future<CommonResponse> addVendorQuotation() async {
    try {
      vendorQuotationStatus = VendorQuotationStatus.loading;
      notifyListeners();

      PortfolioData vendorListResponse = await new HomeService()
          .getportFoliolist();
      if (vendorListResponse.hasError == true) {
        vendorQuotationStatus = VendorQuotationStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        // 
        vendorQuotationStatus = VendorQuotationStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      vendorQuotationStatus = VendorQuotationStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> addContractorQuotation(fdata) async {
    try {
      contractorQuotationStatus = ContractorQuotationStatus.loading;
      notifyListeners();

      var vendorListResponse = await HomeService()
          .addPortfolio(fdata);
      if (vendorListResponse['HasError'] == true) {
        contractorQuotationStatus = ContractorQuotationStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        // portfolioList = vendorListResponse.result!.portfolioList;
        //
        // Utills.customPrint('eventList  response: ${portfolioList!.length}');

        contractorQuotationStatus = ContractorQuotationStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      contractorQuotationStatus = ContractorQuotationStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }

}