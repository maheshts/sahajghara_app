import '../../utils/JsonHelper.dart';

class ContractorDetailData {
  Result? _result;
  bool? _hasError;
  String? _message;

  ContractorDetailData({Result? result, bool? hasError, String? message}) {
    if (result != null) {
      this._result = result;
    }
    if (hasError != null) {
      this._hasError = hasError;
    }
    if (message != null) {
      this._message = message;
    }
  }

  Result? get result => _result;
  set result(Result? result) => _result = result;
  bool? get hasError => _hasError;
  set hasError(bool? hasError) => _hasError = hasError;
  String? get message => _message;
  set message(String? message) => _message = message;

  ContractorDetailData.fromJson(Map<String, dynamic> json) {
    _result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    _hasError = json['HasError'];
    _message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._result != null) {
      data['result'] = this._result!.toJson();
    }
    data['HasError'] = this._hasError;
    data['Message'] = this._message;
    return data;
  }
}

class Result {
  Details? _details;

  Result({Details? details}) {
    if (details != null) {
      this._details = details;
    }
  }

  Details? get details => _details;
  set details(Details? details) => _details = details;

  Result.fromJson(Map<String, dynamic> json) {
    _details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._details != null) {
      data['details'] = this._details!.toJson();
    }
    return data;
  }
}

class Details {
  String? _sId;
  String? _name;
  String? _companyName;
  String? _contractorCode;
  String? _experience;
  String? _city;
  String? _grade;
  List<String>? _specializations;
  String? _profileUrl;
  String? _coverUrl;
  String? _bio;
  int? _numberofproject;
  double? _ratingAvg;
  int? _ratingCount;
  int? _isActive;
  Verifications? _verifications;
  String? _phone;
  String? _email;
  String? _alternateNumber;
  String? _addressDetails;
  String? _lat;
  String? _long;
  int? _minProjectBudget;
  int? _maxProjectBudget;
  List<Pricing>? _pricing;
  RatingBreakdown? _ratingBreakdown;
  RatingStars? _ratingStars;
  List<PortfolioList>? _portfolioList;
  PortfolioCounts? _portfolioCounts;
  List<PortfolioPhotos>? _portfolioPhotos;
  List<RecentReviews>? _recentReviews;
  Stats? _stats;

  Details(
      {String? sId,
        String? name,
        String? companyName,
        String? contractorCode,
        String? experience,
        String? city,
        String? grade,
        List<String>? specializations,
        String? profileUrl,
        String? coverUrl,
        String? bio,
        int? numberofproject,
        double? ratingAvg,
        int? ratingCount,
        int? isActive,
        Verifications? verifications,
        String? phone,
        String? email,
        String? alternateNumber,
        String? addressDetails,
        String? lat,
        String? long,
        int? minProjectBudget,
        int? maxProjectBudget,
        List<Pricing>? pricing,
        RatingBreakdown? ratingBreakdown,
        RatingStars? ratingStars,
        List<PortfolioList>? portfolioList,
        PortfolioCounts? portfolioCounts,
        List<PortfolioPhotos>? portfolioPhotos,
        List<RecentReviews>? recentReviews,
        Stats? stats}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (name != null) {
      this._name = name;
    }
    if (companyName != null) {
      this._companyName = companyName;
    }
    if (contractorCode != null) {
      this._contractorCode = contractorCode;
    }
    if (experience != null) {
      this._experience = experience;
    }
    if (city != null) {
      this._city = city;
    }
    if (grade != null) {
      this._grade = grade;
    }
    if (specializations != null) {
      this._specializations = specializations;
    }
    if (profileUrl != null) {
      this._profileUrl = profileUrl;
    }
    if (coverUrl != null) {
      this._coverUrl = coverUrl;
    }
    if (bio != null) {
      this._bio = bio;
    }
    if (numberofproject != null) {
      this._numberofproject = numberofproject;
    }
    if (ratingAvg != null) {
      this._ratingAvg = ratingAvg;
    }
    if (ratingCount != null) {
      this._ratingCount = ratingCount;
    }
    if (isActive != null) {
      this._isActive = isActive;
    }
    if (verifications != null) {
      this._verifications = verifications;
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
    if (addressDetails != null) {
      this._addressDetails = addressDetails;
    }
    if (lat != null) {
      this._lat = lat;
    }
    if (long != null) {
      this._long = long;
    }
    if (minProjectBudget != null) {
      this._minProjectBudget = minProjectBudget;
    }
    if (maxProjectBudget != null) {
      this._maxProjectBudget = maxProjectBudget;
    }
    if (pricing != null) {
      this._pricing = pricing;
    }
    if (ratingBreakdown != null) {
      this._ratingBreakdown = ratingBreakdown;
    }
    if (ratingStars != null) {
      this._ratingStars = ratingStars;
    }
    if (portfolioList != null) {
      this._portfolioList = portfolioList;
    }
    if (portfolioCounts != null) {
      this._portfolioCounts = portfolioCounts;
    }
    if (portfolioPhotos != null) {
      this._portfolioPhotos = portfolioPhotos;
    }
    if (recentReviews != null) {
      this._recentReviews = recentReviews;
    }
    if (stats != null) {
      this._stats = stats;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get companyName => _companyName;
  set companyName(String? companyName) => _companyName = companyName;
  String? get contractorCode => _contractorCode;
  set contractorCode(String? contractorCode) =>
      _contractorCode = contractorCode;
  String? get experience => _experience;
  set experience(String? experience) => _experience = experience;
  String? get city => _city;
  set city(String? city) => _city = city;
  String? get grade => _grade;
  set grade(String? grade) => _grade = grade;
  List<String>? get specializations => _specializations;
  set specializations(List<String>? specializations) =>
      _specializations = specializations;
  String? get profileUrl => _profileUrl;
  set profileUrl(String? profileUrl) => _profileUrl = profileUrl;
  String? get coverUrl => _coverUrl;
  set coverUrl(String? coverUrl) => _coverUrl = coverUrl;
  String? get bio => _bio;
  set bio(String? bio) => _bio = bio;
  int? get numberofproject => _numberofproject;
  set numberofproject(int? numberofproject) =>
      _numberofproject = numberofproject;
  double? get ratingAvg => _ratingAvg;
  set ratingAvg(double? ratingAvg) => _ratingAvg = ratingAvg;
  int? get ratingCount => _ratingCount;
  set ratingCount(int? ratingCount) => _ratingCount = ratingCount;
  int? get isActive => _isActive;
  set isActive(int? isActive) => _isActive = isActive;
  Verifications? get verifications => _verifications;
  set verifications(Verifications? verifications) =>
      _verifications = verifications;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get alternateNumber => _alternateNumber;
  set alternateNumber(String? alternateNumber) =>
      _alternateNumber = alternateNumber;
  String? get addressDetails => _addressDetails;
  set addressDetails(String? addressDetails) =>
      _addressDetails = addressDetails;
  String? get lat => _lat;
  set lat(String? lat) => _lat = lat;
  String? get long => _long;
  set long(String? long) => _long = long;
  int? get minProjectBudget => _minProjectBudget;
  set minProjectBudget(int? minProjectBudget) =>
      _minProjectBudget = minProjectBudget;
  int? get maxProjectBudget => _maxProjectBudget;
  set maxProjectBudget(int? maxProjectBudget) =>
      _maxProjectBudget = maxProjectBudget;
  List<Pricing>? get pricing => _pricing;
  set pricing(List<Pricing>? pricing) => _pricing = pricing;
  RatingBreakdown? get ratingBreakdown => _ratingBreakdown;
  set ratingBreakdown(RatingBreakdown? ratingBreakdown) =>
      _ratingBreakdown = ratingBreakdown;
  RatingStars? get ratingStars => _ratingStars;
  set ratingStars(RatingStars? ratingStars) => _ratingStars = ratingStars;
  List<PortfolioList>? get portfolioList => _portfolioList;
  set portfolioList(List<PortfolioList>? portfolioList) =>
      _portfolioList = portfolioList;
  PortfolioCounts? get portfolioCounts => _portfolioCounts;
  set portfolioCounts(PortfolioCounts? portfolioCounts) =>
      _portfolioCounts = portfolioCounts;
  List<PortfolioPhotos>? get portfolioPhotos => _portfolioPhotos;
  set portfolioPhotos(List<PortfolioPhotos>? portfolioPhotos) =>
      _portfolioPhotos = portfolioPhotos;
  List<RecentReviews>? get recentReviews => _recentReviews;
  set recentReviews(List<RecentReviews>? recentReviews) =>
      _recentReviews = recentReviews;
  Stats? get stats => _stats;
  set stats(Stats? stats) => _stats = stats;

  Details.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    _sId = json['_id'];
    _name = json['name'];
    _companyName = json['company_name'];
    _contractorCode = json['contractor_code'];
    _experience = json['experience'];
    _city = json['city'];
    _grade = json['grade'];
    _specializations = json['specializations'].cast<String>();
    _profileUrl = json['profile_url'];
    _coverUrl = json['cover_url'];
    _bio = json['bio'];
    _numberofproject = _parseInt(json['numberofproject']);
    _ratingAvg = json['rating_avg'] == null
        ? null
        : double.tryParse(json['rating_avg'].toString());
    _ratingCount = json['rating_count'];
    _isActive = json['is_active'];
    _verifications = json['verifications'] != null
        ? new Verifications.fromJson(json['verifications'])
        : null;
    _phone = json['phone'];
    _email = json['email'];
    _alternateNumber = json['alternate_number'];
    _addressDetails = json['address_details'];
    _lat = json['lat']?.toString();
    _long = json['long']?.toString();
    _minProjectBudget =  _parseInt(json['min_project_budget']);
    _maxProjectBudget = _parseInt(json['max_project_budget']);
    if (json['pricing'] != null) {
      _pricing = <Pricing>[];
      json['pricing'].forEach((v) {
        _pricing!.add(new Pricing.fromJson(v));
      });
    }
    _ratingBreakdown = json['rating_breakdown'] != null
        ? new RatingBreakdown.fromJson(json['rating_breakdown'])
        : null;
    _ratingStars = json['rating_stars'] != null
        ? new RatingStars.fromJson(json['rating_stars'])
        : null;
    if (json['portfolioList'] != null) {
      _portfolioList = <PortfolioList>[];
      json['portfolioList'].forEach((v) {
        _portfolioList!.add(new PortfolioList.fromJson(v));
      });
    }
    _portfolioCounts = json['portfolio_counts'] != null
        ? new PortfolioCounts.fromJson(json['portfolio_counts'])
        : null;
    if (json['portfolio_photos'] != null) {
      _portfolioPhotos = <PortfolioPhotos>[];
      json['portfolio_photos'].forEach((v) {
        _portfolioPhotos!.add(new PortfolioPhotos.fromJson(v));
      });
    }
    if (json['recent_reviews'] != null) {
      _recentReviews = <RecentReviews>[];
      json['recent_reviews'].forEach((v) {
        _recentReviews!.add(new RecentReviews.fromJson(v));
      });
    }
    _stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    data['company_name'] = this._companyName;
    data['contractor_code'] = this._contractorCode;
    data['experience'] = this._experience;
    data['city'] = this._city;
    data['grade'] = this._grade;
    data['specializations'] = this._specializations;
    data['profile_url'] = this._profileUrl;
    data['cover_url'] = this._coverUrl;
    data['bio'] = this._bio;
    data['numberofproject'] = this._numberofproject;
    data['rating_avg'] = this._ratingAvg;
    data['rating_count'] = this._ratingCount;
    data['is_active'] = this._isActive;
    if (this._verifications != null) {
      data['verifications'] = this._verifications!.toJson();
    }
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['alternate_number'] = this._alternateNumber;
    data['address_details'] = this._addressDetails;
    data['lat'] = this._lat;
    data['long'] = this._long;
    data['min_project_budget'] = this._minProjectBudget;
    data['max_project_budget'] = this._maxProjectBudget;
    if (this._pricing != null) {
      data['pricing'] = this._pricing!.map((v) => v.toJson()).toList();
    }
    if (this._ratingBreakdown != null) {
      data['rating_breakdown'] = this._ratingBreakdown!.toJson();
    }
    if (this._ratingStars != null) {
      data['rating_stars'] = this._ratingStars!.toJson();
    }
    if (this._portfolioList != null) {
      data['portfolioList'] =
          this._portfolioList!.map((v) => v.toJson()).toList();
    }
    if (this._portfolioCounts != null) {
      data['portfolio_counts'] = this._portfolioCounts!.toJson();
    }
    if (this._portfolioPhotos != null) {
      data['portfolio_photos'] =
          this._portfolioPhotos!.map((v) => v.toJson()).toList();
    }
    if (this._recentReviews != null) {
      data['recent_reviews'] =
          this._recentReviews!.map((v) => v.toJson()).toList();
    }
    if (this._stats != null) {
      data['stats'] = this._stats!.toJson();
    }
    return data;
  }
}

class Verifications {
  int? _aadhaar;
  int? _gst;
  int? _bank;

  Verifications({int? aadhaar, int? gst, int? bank}) {
    if (aadhaar != null) {
      this._aadhaar = aadhaar;
    }
    if (gst != null) {
      this._gst = gst;
    }
    if (bank != null) {
      this._bank = bank;
    }
  }

  int? get aadhaar => _aadhaar;
  set aadhaar(int? aadhaar) => _aadhaar = aadhaar;
  int? get gst => _gst;
  set gst(int? gst) => _gst = gst;
  int? get bank => _bank;
  set bank(int? bank) => _bank = bank;

  Verifications.fromJson(Map<String, dynamic> json) {
    _aadhaar = json['aadhaar'];
    _gst = json['gst'];
    _bank = json['bank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadhaar'] = this._aadhaar;
    data['gst'] = this._gst;
    data['bank'] = this._bank;
    return data;
  }
}

class Pricing {
  String? _category;
  int? _min;
  int? _max;
  String? _unit;

  Pricing({String? category, int? min, int? max, String? unit}) {
    if (category != null) {
      this._category = category;
    }
    if (min != null) {
      this._min = min;
    }
    if (max != null) {
      this._max = max;
    }
    if (unit != null) {
      this._unit = unit;
    }
  }

  String? get category => _category;
  set category(String? category) => _category = category;
  int? get min => _min;
  set min(int? min) => _min = min;
  int? get max => _max;
  set max(int? max) => _max = max;
  String? get unit => _unit;
  set unit(String? unit) => _unit = unit;

  Pricing.fromJson(Map<String, dynamic> json) {
    _category = json['category'];
    _min = json['min'];
    _max = json['max'];
    _unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this._category;
    data['min'] = this._min;
    data['max'] = this._max;
    data['unit'] = this._unit;
    return data;
  }
}

class RatingBreakdown {
  double? _qualityOfWork;
  double? _timelyCompletion;
  double? _communication;

  RatingBreakdown(
      {double? qualityOfWork,
        double? timelyCompletion,
        double? communication}) {
    if (qualityOfWork != null) {
      this._qualityOfWork = qualityOfWork;
    }
    if (timelyCompletion != null) {
      this._timelyCompletion = timelyCompletion;
    }
    if (communication != null) {
      this._communication = communication;
    }
  }

  double? get qualityOfWork => _qualityOfWork;
  set qualityOfWork(double? qualityOfWork) => _qualityOfWork = qualityOfWork;
  double? get timelyCompletion => _timelyCompletion;
  set timelyCompletion(double? timelyCompletion) =>
      _timelyCompletion = timelyCompletion;
  double? get communication => _communication;
  set communication(double? communication) => _communication = communication;

  RatingBreakdown.fromJson(Map<String, dynamic> json) {
    _qualityOfWork = json['quality_of_work'];
    _timelyCompletion = json['timely_completion'];
    _communication = json['communication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quality_of_work'] = this._qualityOfWork;
    data['timely_completion'] = this._timelyCompletion;
    data['communication'] = this._communication;
    return data;
  }
}

class RatingStars {
  int? _i1;
  int? _i2;
  int? _i3;
  int? _i4;
  int? _i5;

  RatingStars({int? i1, int? i2, int? i3, int? i4, int? i5}) {
    if (i1 != null) {
      this._i1 = i1;
    }
    if (i2 != null) {
      this._i2 = i2;
    }
    if (i3 != null) {
      this._i3 = i3;
    }
    if (i4 != null) {
      this._i4 = i4;
    }
    if (i5 != null) {
      this._i5 = i5;
    }
  }

  int? get i1 => _i1;
  set i1(int? i1) => _i1 = i1;
  int? get i2 => _i2;
  set i2(int? i2) => _i2 = i2;
  int? get i3 => _i3;
  set i3(int? i3) => _i3 = i3;
  int? get i4 => _i4;
  set i4(int? i4) => _i4 = i4;
  int? get i5 => _i5;
  set i5(int? i5) => _i5 = i5;

  RatingStars.fromJson(Map<String, dynamic> json) {
    _i1 = json['1'];
    _i2 = json['2'];
    _i3 = json['3'];
    _i4 = json['4'];
    _i5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this._i1;
    data['2'] = this._i2;
    data['3'] = this._i3;
    data['4'] = this._i4;
    data['5'] = this._i5;
    return data;
  }
}

class PortfolioList {
  String? _sId;
  String? _userId;
  String? _name;
  String? _title;
  String? _location;
  String? _description;
  String? _status;
  String? _completedOn;
  List<Imagepath>? _imagepath;
  bool? _isSample;
  CreatedAt? _createdAt;
  CreatedAt? _updatedAt;
  int? _imageCount;

  PortfolioList(
      {String? sId,
        String? userId,
        String? name,
        String? title,
        String? location,
        String? description,
        String? status,
        String? completedOn,
        List<Imagepath>? imagepath,
        bool? isSample,
        CreatedAt? createdAt,
        CreatedAt? updatedAt,
        int? imageCount}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (name != null) {
      this._name = name;
    }
    if (title != null) {
      this._title = title;
    }
    if (location != null) {
      this._location = location;
    }
    if (description != null) {
      this._description = description;
    }
    if (status != null) {
      this._status = status;
    }
    if (completedOn != null) {
      this._completedOn = completedOn;
    }
    if (imagepath != null) {
      this._imagepath = imagepath;
    }
    if (isSample != null) {
      this._isSample = isSample;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (imageCount != null) {
      this._imageCount = imageCount;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get location => _location;
  set location(String? location) => _location = location;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get completedOn => _completedOn;
  set completedOn(String? completedOn) => _completedOn = completedOn;
  List<Imagepath>? get imagepath => _imagepath;
  set imagepath(List<Imagepath>? imagepath) => _imagepath = imagepath;
  bool? get isSample => _isSample;
  set isSample(bool? isSample) => _isSample = isSample;
  CreatedAt? get createdAt => _createdAt;
  set createdAt(CreatedAt? createdAt) => _createdAt = createdAt;
  CreatedAt? get updatedAt => _updatedAt;
  set updatedAt(CreatedAt? updatedAt) => _updatedAt = updatedAt;
  int? get imageCount => _imageCount;
  set imageCount(int? imageCount) => _imageCount = imageCount;

  PortfolioList.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _userId = json['user_id'];
    _name = json['name'];
    _title = json['title'];
    _location = json['location'];
    _description = json['description'];
    _status = json['status'];
    _completedOn = json['completed_on'];
    if (json['imagepath'] != null) {
      _imagepath = <Imagepath>[];
      json['imagepath'].forEach((v) {
        _imagepath!.add(new Imagepath.fromJson(v));
      });
    }
    _isSample = json['is_sample'];
    _createdAt = json['createdAt'] != null
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    _updatedAt = json['updatedAt'] != null
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    _imageCount = json['image_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['user_id'] = this._userId;
    data['name'] = this._name;
    data['title'] = this._title;
    data['location'] = this._location;
    data['description'] = this._description;
    data['status'] = this._status;
    data['completed_on'] = this._completedOn;
    if (this._imagepath != null) {
      data['imagepath'] = this._imagepath!.map((v) => v.toJson()).toList();
    }
    data['is_sample'] = this._isSample;
    if (this._createdAt != null) {
      data['createdAt'] = this._createdAt!.toJson();
    }
    if (this._updatedAt != null) {
      data['updatedAt'] = this._updatedAt!.toJson();
    }
    data['image_count'] = this._imageCount;
    return data;
  }
}

class Imagepath {
  String? _profileUrl;
  String? _cloudinaryId;

  Imagepath({String? profileUrl, String? cloudinaryId}) {
    if (profileUrl != null) {
      this._profileUrl = profileUrl;
    }
    if (cloudinaryId != null) {
      this._cloudinaryId = cloudinaryId;
    }
  }

  String? get profileUrl => _profileUrl;
  set profileUrl(String? profileUrl) => _profileUrl = profileUrl;
  String? get cloudinaryId => _cloudinaryId;
  set cloudinaryId(String? cloudinaryId) => _cloudinaryId = cloudinaryId;

  Imagepath.fromJson(Map<String, dynamic> json) {
    _profileUrl = json['profile_url'];
    _cloudinaryId = json['cloudinary_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_url'] = this._profileUrl;
    data['cloudinary_id'] = this._cloudinaryId;
    return data;
  }
}

class CreatedAt {
  Date? _date;

  CreatedAt({Date? date}) {
    if (date != null) {
      this._date = date;
    }
  }

  Date? get date => _date;
  set date(Date? date) => _date = date;

  CreatedAt.fromJson(Map<String, dynamic> json) {
    _date = json['$date'] != null ? new Date.fromJson(json['$date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._date != null) {
      data['$date'] = this._date!.toJson();
    }
    return data;
  }
}

class Date {
  String? _numberLong;

  Date({String? numberLong}) {
    if (numberLong != null) {
      this._numberLong = numberLong;
    }
  }

  String? get numberLong => _numberLong;
  set numberLong(String? numberLong) => _numberLong = numberLong;

  Date.fromJson(Map<String, dynamic> json) {
    _numberLong = json['$numberLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$numberLong'] = this._numberLong;
    return data;
  }
}

class PortfolioCounts {
  int? _all;
  int? _completed;
  int? _inprogress;
  int? _photos;

  PortfolioCounts({int? all, int? completed, int? inprogress, int? photos}) {
    if (all != null) {
      this._all = all;
    }
    if (completed != null) {
      this._completed = completed;
    }
    if (inprogress != null) {
      this._inprogress = inprogress;
    }
    if (photos != null) {
      this._photos = photos;
    }
  }

  int? get all => _all;
  set all(int? all) => _all = all;
  int? get completed => _completed;
  set completed(int? completed) => _completed = completed;
  int? get inprogress => _inprogress;
  set inprogress(int? inprogress) => _inprogress = inprogress;
  int? get photos => _photos;
  set photos(int? photos) => _photos = photos;

  PortfolioCounts.fromJson(Map<String, dynamic> json) {
    _all = json['all'];
    _completed = json['completed'];
    _inprogress = json['inprogress'];
    _photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all'] = this._all;
    data['completed'] = this._completed;
    data['inprogress'] = this._inprogress;
    data['photos'] = this._photos;
    return data;
  }
}

class PortfolioPhotos {
  String? _url;
  String? _title;

  PortfolioPhotos({String? url, String? title}) {
    if (url != null) {
      this._url = url;
    }
    if (title != null) {
      this._title = title;
    }
  }

  String? get url => _url;
  set url(String? url) => _url = url;
  String? get title => _title;
  set title(String? title) => _title = title;

  PortfolioPhotos.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this._url;
    data['title'] = this._title;
    return data;
  }
}

class RecentReviews {
  String? _sId;
  String? _customerName;
  String? _customerId;
  int? _rating;
  int? _qualityOfWork;
  int? _timelyCompletion;
  int? _communication;
  String? _comment;
  String? _createdAt;

  RecentReviews(
      {String? sId,
        String? customerName,
        String? customerId,
        int? rating,
        int? qualityOfWork,
        int? timelyCompletion,
        int? communication,
        String? comment,
        String? createdAt}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (customerName != null) {
      this._customerName = customerName;
    }
    if (customerId != null) {
      this._customerId = customerId;
    }
    if (rating != null) {
      this._rating = rating;
    }
    if (qualityOfWork != null) {
      this._qualityOfWork = qualityOfWork;
    }
    if (timelyCompletion != null) {
      this._timelyCompletion = timelyCompletion;
    }
    if (communication != null) {
      this._communication = communication;
    }
    if (comment != null) {
      this._comment = comment;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get customerName => _customerName;
  set customerName(String? customerName) => _customerName = customerName;
  String? get customerId => _customerId;
  set customerId(String? customerId) => _customerId = customerId;
  int? get rating => _rating;
  set rating(int? rating) => _rating = rating;
  int? get qualityOfWork => _qualityOfWork;
  set qualityOfWork(int? qualityOfWork) => _qualityOfWork = qualityOfWork;
  int? get timelyCompletion => _timelyCompletion;
  set timelyCompletion(int? timelyCompletion) =>
      _timelyCompletion = timelyCompletion;
  int? get communication => _communication;
  set communication(int? communication) => _communication = communication;
  String? get comment => _comment;
  set comment(String? comment) => _comment = comment;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;

  RecentReviews.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _customerName = json['customer_name'];
    _customerId = json['customer_id'];
    _rating = json['rating'];
    _qualityOfWork = json['quality_of_work'];
    _timelyCompletion = json['timely_completion'];
    _communication = json['communication'];
    _comment = json['comment'];
    _createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['customer_name'] = this._customerName;
    data['customer_id'] = this._customerId;
    data['rating'] = this._rating;
    data['quality_of_work'] = this._qualityOfWork;
    data['timely_completion'] = this._timelyCompletion;
    data['communication'] = this._communication;
    data['comment'] = this._comment;
    data['createdAt'] = this._createdAt;
    return data;
  }
}

class Stats {
  int? _projects;
  int? _projectsCompleted;
  int? _projectsInprogress;
  int? _activeRequests;
  int? _completed;
  int? _totalRequests;
  int? _responseHours;
  String? _responseLabel;

  Stats(
      {int? projects,
        int? projectsCompleted,
        int? projectsInprogress,
        int? activeRequests,
        int? completed,
        int? totalRequests,
        int? responseHours,
        String? responseLabel}) {
    if (projects != null) {
      this._projects = projects;
    }
    if (projectsCompleted != null) {
      this._projectsCompleted = projectsCompleted;
    }
    if (projectsInprogress != null) {
      this._projectsInprogress = projectsInprogress;
    }
    if (activeRequests != null) {
      this._activeRequests = activeRequests;
    }
    if (completed != null) {
      this._completed = completed;
    }
    if (totalRequests != null) {
      this._totalRequests = totalRequests;
    }
    if (responseHours != null) {
      this._responseHours = responseHours;
    }
    if (responseLabel != null) {
      this._responseLabel = responseLabel;
    }
  }

  int? get projects => _projects;
  set projects(int? projects) => _projects = projects;
  int? get projectsCompleted => _projectsCompleted;
  set projectsCompleted(int? projectsCompleted) =>
      _projectsCompleted = projectsCompleted;
  int? get projectsInprogress => _projectsInprogress;
  set projectsInprogress(int? projectsInprogress) =>
      _projectsInprogress = projectsInprogress;
  int? get activeRequests => _activeRequests;
  set activeRequests(int? activeRequests) => _activeRequests = activeRequests;
  int? get completed => _completed;
  set completed(int? completed) => _completed = completed;
  int? get totalRequests => _totalRequests;
  set totalRequests(int? totalRequests) => _totalRequests = totalRequests;
  int? get responseHours => _responseHours;
  set responseHours(int? responseHours) => _responseHours = responseHours;
  String? get responseLabel => _responseLabel;
  set responseLabel(String? responseLabel) => _responseLabel = responseLabel;

  Stats.fromJson(Map<String, dynamic> json) {
    _projects = json['projects'];
    _projectsCompleted = json['projects_completed'];
    _projectsInprogress = json['projects_inprogress'];
    _activeRequests = json['active_requests'];
    _completed = json['completed'];
    _totalRequests = json['total_requests'];
    _responseHours = json['response_hours'];
    _responseLabel = json['response_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projects'] = this._projects;
    data['projects_completed'] = this._projectsCompleted;
    data['projects_inprogress'] = this._projectsInprogress;
    data['active_requests'] = this._activeRequests;
    data['completed'] = this._completed;
    data['total_requests'] = this._totalRequests;
    data['response_hours'] = this._responseHours;
    data['response_label'] = this._responseLabel;
    return data;
  }
}
