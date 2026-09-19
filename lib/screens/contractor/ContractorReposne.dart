import '../profile/contractor/ContractorDetailData.dart';

class ContractorResponse {
  Result? result;
  bool? hasError;
  String? message;

  ContractorResponse({this.result, this.hasError, this.message});

  ContractorResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    hasError = json['HasError'];
    message = json['Message'];
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
      json['contractorlist'].forEach((v) {
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
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    _sId = json['_id']?.toString();
    _name = json['name']?.toString();
    _companyName = json['company_name']?.toString();
    _phone = json['phone']?.toString();
    _email = json['email']?.toString();
    _alternateNumber = json['alternate_number']?.toString();
    _experience = json['experience']?.toString();
    _grade = json['grade']?.toString();
    _city = json['city']?.toString();

    // Safely handled int fields
    numberofproject = _parseInt(json['numberofproject']);
    _minProjectBudget = _parseInt(json['min_project_budget']);
    _maxProjectBudget = _parseInt(json['max_project_budget']);
    _aadhaarVerified = _parseInt(json['aadhaar_verified']);
    _gstVerified = _parseInt(json['gst_verified']);
    _bankVerified = _parseInt(json['bank_verified']);
    _enableContractor = _parseInt(json['enable_contractor']);
    _enableVendor = _parseInt(json['enable_vendor']);
    _isActive = _parseInt(json['is_active']);

    _addressDetails = json['address_details']?.toString();
    _lat = json['lat']?.toString();
    _long = json['long']?.toString();

    // Safe handling for string lists to prevent crashes if key is null
    if (json['specializations'] != null) {
      _specializations = List<String>.from(json['specializations'].map((x) => x.toString()));
    } else {
      _specializations = null;
    }

    _bio = json['bio']?.toString();
    _type = json['type']?.toString();
    _contractorCode = json['contractor_code']?.toString();
    _password = json['password']?.toString();
    _locale = json['locale']?.toString();

    // Safely parse boolean field
    if (json['is_sample'] is bool) {
      _isSample = json['is_sample'];
    } else if (json['is_sample'] != null) {
      _isSample = json['is_sample'].toString().toLowerCase() == 'true';
    } else {
      _isSample = null;
    }

    _cloudinaryId = json['cloudinary_id']?.toString();
    _coverCloudinaryId = json['cover_cloudinary_id']?.toString();
    _coverUrl = json['cover_url']?.toString();
    _profileUrl = json['profile_url']?.toString();

    // Safely parse double field
    _ratingAvg = json['rating_avg'] == null
        ? null
        : double.tryParse(json['rating_avg'].toString());

    _ratingCount = _parseInt(json['rating_count']);

    if (json['portfolioList'] != null) {
      _portfolioList = <PortfolioList>[];
      json['portfolioList'].forEach((v) {
        _portfolioList!.add(new PortfolioList.fromJson(v));
      });
    }
    _remark = json['remark']?.toString();
    _requestContractor = json['request_contractor']?.toString();
    _vendorCode = json['vendor_code']?.toString();
    _requestVendor = _parseInt(json['request_vendor']);

    _fcmToken = json['fcm_token']?.toString();
    _fcmTokenUpdateAt = json['fcm_token_update_at']?.toString();
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


