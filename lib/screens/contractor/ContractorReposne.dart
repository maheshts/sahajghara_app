import 'package:sahajghara/screens/utils/JsonHelper.dart';

import '../profile/contractor/ContractorDetailData.dart';

class ContractorResponse {
  Result? result;
  bool? hasError;
  String? message;

  ContractorResponse({this.result, this.hasError, this.message});

  ContractorResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] is Map ? new Result.fromJson(json['result']) : null;
    hasError = JsonHelper.toNullableBool(json['HasError']);
    message = JsonHelper.toStringValue(json['Message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['HasError'] = this.hasError;
    data['Message'] = this.message;
    return data;
  }
}

class Result {
  List<Contractorlist>? contractorlist;

  Result({this.contractorlist});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['contractorlist'] != null) {
      contractorlist = <Contractorlist>[];
      JsonHelper.objectList(json['contractorlist']).forEach((v) {
        contractorlist!.add(new Contractorlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contractorlist != null) {
      data['contractorlist'] =
          this.contractorlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contractorlist {
  String? _sId;
  String? _name;
  String? _companyName;
  String? _phone;
  String? _email;
  String? _alternateNumber;
  String? _experience;
  String? _grade;
  String? _city;
  int? _numberofproject;
  String? _addressDetails;
  String? _lat;
  String? _long;
  List<String>? _specializations;
  String? _bio;
  int? _minProjectBudget;
  int? _maxProjectBudget;
  int? _aadhaarVerified;
  int? _gstVerified;
  int? _bankVerified;
  String? _type;
  int? _enableContractor;
  int? _enableVendor;
  int? _isActive;
  String? _contractorCode;
  String? _password;
  String? _locale;
  bool? _isSample;

  String? _cloudinaryId;
  String? _coverCloudinaryId;
  String? _coverUrl;
  String? _profileUrl;
  double? _ratingAvg;
  int? _ratingCount;

  List<PortfolioList>? _portfolioList;
  String? _remark;
  String? _requestContractor;
  String? _vendorCode;
  int? _requestVendor;
  String? _fcmToken;
  String? _fcmTokenUpdateAt;

  Contractorlist(
      {String? sId,
        String? name,
        String? companyName,
        String? phone,
        String? email,
        String? alternateNumber,
        String? experience,
        String? grade,
        String? city,
        int? numberofproject,
        String? addressDetails,
        String? lat,
        String? long,
        List<String>? specializations,
        String? bio,
        int? minProjectBudget,
        int? maxProjectBudget,
        int? aadhaarVerified,
        int? gstVerified,
        int? bankVerified,
        String? type,
        int? enableContractor,
        int? enableVendor,
        int? isActive,
        String? contractorCode,
        String? password,
        String? locale,
        bool? isSample,

        String? cloudinaryId,
        String? coverCloudinaryId,
        String? coverUrl,
        String? profileUrl,
        double? ratingAvg,

        int? ratingCount,
        List<PortfolioList>? portfolioList,
        String? remark,
        String? requestContractor,
        String? vendorCode,
        int? requestVendor,

        String? fcmToken,
        String? fcmTokenUpdateAt}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (name != null) {
      this._name = name;
    }
    if (companyName != null) {
      this._companyName = companyName;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (email != null) {
      this._email = email;
    }
    if (alternateNumber != null) {
      this._alternateNumber = alternateNumber;
    }
    if (experience != null) {
      this._experience = experience;
    }
    if (grade != null) {
      this._grade = grade;
    }
    if (city != null) {
      this._city = city;
    }
    if (numberofproject != null) {
      this._numberofproject = numberofproject;
    }
    if (addressDetails != null) {
      this._addressDetails = addressDetails;
    }
    if (lat != null) {
      this._lat = lat;
    }
    if (long != null) {
      this._long = long;
    }
    if (specializations != null) {
      this._specializations = specializations;
    }
    if (bio != null) {
      this._bio = bio;
    }
    if (minProjectBudget != null) {
      this._minProjectBudget = minProjectBudget;
    }
    if (maxProjectBudget != null) {
      this._maxProjectBudget = maxProjectBudget;
    }

    if (aadhaarVerified != null) {
      this._aadhaarVerified = aadhaarVerified;
    }
    if (gstVerified != null) {
      this._gstVerified = gstVerified;
    }
    if (bankVerified != null) {
      this._bankVerified = bankVerified;
    }
    if (type != null) {
      this._type = type;
    }
    if (enableContractor != null) {
      this._enableContractor = enableContractor;
    }
    if (enableVendor != null) {
      this._enableVendor = enableVendor;
    }
    if (isActive != null) {
      this._isActive = isActive;
    }
    if (contractorCode != null) {
      this._contractorCode = contractorCode;
    }
    if (password != null) {
      this._password = password;
    }
    if (locale != null) {
      this._locale = locale;
    }
    if (isSample != null) {
      this._isSample = isSample;
    }

    if (cloudinaryId != null) {
      this._cloudinaryId = cloudinaryId;
    }
    if (coverCloudinaryId != null) {
      this._coverCloudinaryId = coverCloudinaryId;
    }
    if (coverUrl != null) {
      this._coverUrl = coverUrl;
    }
    if (profileUrl != null) {
      this._profileUrl = profileUrl;
    }
    if (ratingAvg != null) {
      this._ratingAvg = ratingAvg;
    }

    if (ratingCount != null) {
      this._ratingCount = ratingCount;
    }

    if (portfolioList != null) {
      this._portfolioList = portfolioList;
    }
    if (remark != null) {
      this._remark = remark;
    }
    if (requestContractor != null) {
      this._requestContractor = requestContractor;
    }
    if (vendorCode != null) {
      this._vendorCode = vendorCode;
    }
    if (requestVendor != null) {
      this._requestVendor = requestVendor;
    }

    if (fcmToken != null) {
      this._fcmToken = fcmToken;
    }
    if (fcmTokenUpdateAt != null) {
      this._fcmTokenUpdateAt = fcmTokenUpdateAt;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get companyName => _companyName;
  set companyName(String? companyName) => _companyName = companyName;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get alternateNumber => _alternateNumber;
  set alternateNumber(String? alternateNumber) =>
      _alternateNumber = alternateNumber;
  String? get experience => _experience;
  set experience(String? experience) => _experience = experience;
  String? get grade => _grade;
  set grade(String? grade) => _grade = grade;
  String? get city => _city;
  set city(String? city) => _city = city;
  int? get numberofproject => _numberofproject;
  set numberofproject(int? numberofproject) =>
      _numberofproject = numberofproject;
  String? get addressDetails => _addressDetails;
  set addressDetails(String? addressDetails) =>
      _addressDetails = addressDetails;
  String? get lat => _lat;
  set lat(String? lat) => _lat = lat;
  String? get long => _long;
  set long(String? long) => _long = long;
  List<String>? get specializations => _specializations;
  set specializations(List<String>? specializations) =>
      _specializations = specializations;
  String? get bio => _bio;
  set bio(String? bio) => _bio = bio;
  int? get minProjectBudget => _minProjectBudget;
  set minProjectBudget(int? minProjectBudget) =>
      _minProjectBudget = minProjectBudget;
  int? get maxProjectBudget => _maxProjectBudget;
  set maxProjectBudget(int? maxProjectBudget) =>
      _maxProjectBudget = maxProjectBudget;

  int? get aadhaarVerified => _aadhaarVerified;
  set aadhaarVerified(int? aadhaarVerified) =>
      _aadhaarVerified = aadhaarVerified;
  int? get gstVerified => _gstVerified;
  set gstVerified(int? gstVerified) => _gstVerified = gstVerified;
  int? get bankVerified => _bankVerified;
  set bankVerified(int? bankVerified) => _bankVerified = bankVerified;
  String? get type => _type;
  set type(String? type) => _type = type;
  int? get enableContractor => _enableContractor;
  set enableContractor(int? enableContractor) =>
      _enableContractor = enableContractor;
  int? get enableVendor => _enableVendor;
  set enableVendor(int? enableVendor) => _enableVendor = enableVendor;
  int? get isActive => _isActive;
  set isActive(int? isActive) => _isActive = isActive;
  String? get contractorCode => _contractorCode;
  set contractorCode(String? contractorCode) =>
      _contractorCode = contractorCode;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get locale => _locale;
  set locale(String? locale) => _locale = locale;
  bool? get isSample => _isSample;
  set isSample(bool? isSample) => _isSample = isSample;

  String? get cloudinaryId => _cloudinaryId;
  set cloudinaryId(String? cloudinaryId) => _cloudinaryId = cloudinaryId;
  String? get coverCloudinaryId => _coverCloudinaryId;
  set coverCloudinaryId(String? coverCloudinaryId) =>
      _coverCloudinaryId = coverCloudinaryId;
  String? get coverUrl => _coverUrl;
  set coverUrl(String? coverUrl) => _coverUrl = coverUrl;
  String? get profileUrl => _profileUrl;
  set profileUrl(String? profileUrl) => _profileUrl = profileUrl;
  double? get ratingAvg => _ratingAvg;
  set ratingAvg(double? ratingAvg) => _ratingAvg = ratingAvg;

  int? get ratingCount => _ratingCount;
  set ratingCount(int? ratingCount) => _ratingCount = ratingCount;

  List<PortfolioList>? get portfolioList => _portfolioList;
  set portfolioList(List<PortfolioList>? portfolioList) =>
      _portfolioList = portfolioList;
  String? get remark => _remark;
  set remark(String? remark) => _remark = remark;
  String? get requestContractor => _requestContractor;
  set requestContractor(String? requestContractor) =>
      _requestContractor = requestContractor;
  String? get vendorCode => _vendorCode;
  set vendorCode(String? vendorCode) => _vendorCode = vendorCode;
  int? get requestVendor => _requestVendor;
  set requestVendor(int? requestVendor) => _requestVendor = requestVendor;

  String? get fcmToken => _fcmToken;
  set fcmToken(String? fcmToken) => _fcmToken = fcmToken;
  String? get fcmTokenUpdateAt => _fcmTokenUpdateAt;
  set fcmTokenUpdateAt(String? fcmTokenUpdateAt) =>
      _fcmTokenUpdateAt = fcmTokenUpdateAt;

  Contractorlist.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse integer fields
_sId = JsonHelper.toStringValue(json['_id']);
    _name = JsonHelper.toStringValue(json['name']);
    _companyName = JsonHelper.toStringValue(json['company_name']);
    _phone = JsonHelper.toStringValue(json['phone']);
    _email = JsonHelper.toStringValue(json['email']);
    _alternateNumber = JsonHelper.toStringValue(json['alternate_number']);
    _experience = JsonHelper.toStringValue(json['experience']);
    _grade = JsonHelper.toStringValue(json['grade']);
    _city = JsonHelper.toStringValue(json['city']);

    // Safely handled int fields
    numberofproject = JsonHelper.toInt(json['numberofproject']);
    _minProjectBudget = JsonHelper.toInt(json['min_project_budget']);
    _maxProjectBudget = JsonHelper.toInt(json['max_project_budget']);
    _aadhaarVerified = JsonHelper.toInt(json['aadhaar_verified']);
    _gstVerified = JsonHelper.toInt(json['gst_verified']);
    _bankVerified = JsonHelper.toInt(json['bank_verified']);
    _enableContractor = JsonHelper.toInt(json['enable_contractor']);
    _enableVendor = JsonHelper.toInt(json['enable_vendor']);
    _isActive = JsonHelper.toInt(json['is_active']);

    _addressDetails = JsonHelper.toStringValue(json['address_details']);
    _lat = JsonHelper.toStringValue(json['lat']);
    _long = JsonHelper.toStringValue(json['long']);

    // Safe handling for string lists to prevent crashes if key is null
    if (json['specializations'] != null) {
      _specializations = JsonHelper.stringList(json['specializations']);
    } else {
      _specializations = null;
    }

    _bio = JsonHelper.toStringValue(json['bio']);
    _type = JsonHelper.toStringValue(json['type']);
    _contractorCode = JsonHelper.toStringValue(json['contractor_code']);
    _password = JsonHelper.toStringValue(json['password']);
    _locale = JsonHelper.toStringValue(json['locale']);

    // Safely parse boolean field
    _isSample = JsonHelper.toNullableBool(json['is_sample']);

    _cloudinaryId = JsonHelper.toStringValue(json['cloudinary_id']);
    _coverCloudinaryId = JsonHelper.toStringValue(json['cover_cloudinary_id']);
    _coverUrl = JsonHelper.toStringValue(json['cover_url']);
    _profileUrl = JsonHelper.toStringValue(json['profile_url']);

    // Safely parse double field
    _ratingAvg = JsonHelper.toDouble(json['rating_avg']);

    _ratingCount = JsonHelper.toInt(json['rating_count']);

    if (json['portfolioList'] != null) {
      _portfolioList = <PortfolioList>[];
      JsonHelper.objectList(json['portfolioList']).forEach((v) {
        _portfolioList!.add(new PortfolioList.fromJson(v));
      });
    }
    _remark = JsonHelper.toStringValue(json['remark']);
    _requestContractor = JsonHelper.toStringValue(json['request_contractor']);
    _vendorCode = JsonHelper.toStringValue(json['vendor_code']);
    _requestVendor = JsonHelper.toInt(json['request_vendor']);

    _fcmToken = JsonHelper.toStringValue(json['fcm_token']);
    _fcmTokenUpdateAt = JsonHelper.toStringValue(json['fcm_token_update_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['company_name'] = this._companyName;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['alternate_number'] = this._alternateNumber;
    data['experience'] = this._experience;
    data['grade'] = this._grade;
    data['city'] = this._city;
    data['numberofproject'] = this._numberofproject;
    data['address_details'] = this._addressDetails;
    data['lat'] = this._lat;
    data['long'] = this._long;
    data['specializations'] = this._specializations;
    data['bio'] = this._bio;
    data['min_project_budget'] = this._minProjectBudget;
    data['max_project_budget'] = this._maxProjectBudget;

    data['aadhaar_verified'] = this._aadhaarVerified;
    data['gst_verified'] = this._gstVerified;
    data['bank_verified'] = this._bankVerified;
    data['type'] = this._type;
    data['enable_contractor'] = this._enableContractor;
    data['enable_vendor'] = this._enableVendor;
    data['is_active'] = this._isActive;
    data['contractor_code'] = this._contractorCode;
    data['password'] = this._password;
    data['locale'] = this._locale;
    data['is_sample'] = this._isSample;

    data['cloudinary_id'] = this._cloudinaryId;
    data['cover_cloudinary_id'] = this._coverCloudinaryId;
    data['cover_url'] = this._coverUrl;
    data['profile_url'] = this._profileUrl;
    data['rating_avg'] = this._ratingAvg;

    data['rating_count'] = this._ratingCount;

    if (this._portfolioList != null) {
      data['portfolioList'] =
          this._portfolioList!.map((v) => v.toJson()).toList();
    }
    data['remark'] = this._remark;
    data['request_contractor'] = this._requestContractor;
    data['vendor_code'] = this._vendorCode;
    data['request_vendor'] = this._requestVendor;

    data['fcm_token'] = this._fcmToken;
    data['fcm_token_update_at'] = this._fcmTokenUpdateAt;
    return data;
  }
}


