import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/CommonResponse.dart';
import '../helpers/utillls.dart';
import '../nwdata/service/home_service.dart';
import '../screens/contractor/model/PortfolioData.dart';

final contractorControllerProvider = ChangeNotifierProvider((ref) => ContractorControler());
enum PortfolioListStatus {  loading, loaded, error }
enum AddPortFolioStatus {  loading, loaded, error }
enum SubmitListStatus {  loading, loaded, error }
enum UpdateProfileStatus {  loading, loaded, error }

class ContractorControler extends ChangeNotifier {
  PortfolioListStatus portfolioListStatus = PortfolioListStatus.loading;
  AddPortFolioStatus addPortFolioStatus = AddPortFolioStatus.loading;
  UpdateProfileStatus updateProfileStatus = UpdateProfileStatus.loading;

  List<PortfolioList>? portfolioList;

  Future<CommonResponse> getPortfolioList() async {
    try {
      portfolioListStatus = PortfolioListStatus.loading;
      notifyListeners();

      PortfolioData vendorListResponse = await new HomeService()
          .getportFoliolist();
      if (vendorListResponse.hasError == true) {
        portfolioListStatus = PortfolioListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        portfolioList = vendorListResponse.result!.portfolioList;

        Utills.customPrint('eventList  response: ${portfolioList!.length}');

        portfolioListStatus = PortfolioListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      portfolioListStatus = PortfolioListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> addPortfolio(fdata) async {
    try {
      addPortFolioStatus = AddPortFolioStatus.loading;
      notifyListeners();

      var vendorListResponse = await HomeService()
          .addPortfolio(fdata);
      if (vendorListResponse['HasError'] == true) {
        addPortFolioStatus = AddPortFolioStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse['Message'] ?? "");
      } else {
        // portfolioList = vendorListResponse.result!.portfolioList;
        //
        // Utills.customPrint('eventList  response: ${portfolioList!.length}');

        addPortFolioStatus = AddPortFolioStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse['Message'] ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      addPortFolioStatus = AddPortFolioStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> updateProfile(fdata) async {
    Utills.customPrint("profile submit 22");

    try {
      updateProfileStatus = UpdateProfileStatus.loading;
      notifyListeners();

      var vendorListResponse = await HomeService()
          .updateProfile(fdata);
      if (vendorListResponse['HasError'] == true) {
        updateProfileStatus = UpdateProfileStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse["Message"] ?? "");
      } else {
        // portfolioList = vendorListResponse.result!.portfolioList;
        //
        // Utills.customPrint('eventList  response: ${portfolioList!.length}');

        updateProfileStatus = UpdateProfileStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse["Message"] ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      updateProfileStatus = UpdateProfileStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }

}