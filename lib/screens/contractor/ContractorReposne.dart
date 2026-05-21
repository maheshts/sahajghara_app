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
  String? sId;
  String? type;
  String? name;
  String? email;
  String? phone;
  String? alternateNumber;
  String? experience;
  String? grade;
  String? numberofproject;
  String? minProjectBudget;
  String? maxProjectBudget;
  String? lat;
  String? long;
  String? addressDetails;
  String? remark;
  String? password;
  String? cloudinaryId;
  String? profileUrl;
  List<PortfolioList>? portfolioList;

  Contractorlist(
      {this.sId,
        this.type,
        this.name,
        this.email,
        this.phone,
        this.alternateNumber,
        this.experience,
        this.grade,
        this.numberofproject,
        this.minProjectBudget,
        this.maxProjectBudget,
        this.lat,
        this.long,
        this.addressDetails,
        this.remark,
        this.password,
        this.cloudinaryId,
        this.profileUrl,
        this.portfolioList});

  Contractorlist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    alternateNumber = json['alternate_number'];
    experience = json['experience'];
    grade = json['grade'];
    numberofproject = json['numberofproject'];
    minProjectBudget = json['min_project_budget'];
    maxProjectBudget = json['max_project_budget'];
    lat = json['lat'];
    long = json['long'];
    addressDetails = json['address_details'];
    remark = json['remark'];
    password = json['password'];
    cloudinaryId = json['cloudinary_id'];
    profileUrl = json['profile_url'];
    if (json['portfolioList'] != null) {
      portfolioList = <PortfolioList>[];
      json['portfolioList'].forEach((v) {
        portfolioList!.add(new PortfolioList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['alternate_number'] = this.alternateNumber;
    data['experience'] = this.experience;
    data['grade'] = this.grade;
    data['numberofproject'] = this.numberofproject;
    data['min_project_budget'] = this.minProjectBudget;
    data['max_project_budget'] = this.maxProjectBudget;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address_details'] = this.addressDetails;
    data['remark'] = this.remark;
    data['password'] = this.password;
    data['cloudinary_id'] = this.cloudinaryId;
    data['profile_url'] = this.profileUrl;
    if (this.portfolioList != null) {
      data['portfolioList'] =
          this.portfolioList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PortfolioList {
  String? sId;
  String? userId;
  String? name;
  String? title;
  String? location;
  String? description;
  List<Imagepath>? imagepath;

  PortfolioList(
      {this.sId,
        this.userId,
        this.name,
        this.title,
        this.location,
        this.description,
        this.imagepath});

  PortfolioList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    name = json['name'];
    title = json['title'];
    location = json['location'];
    description = json['description'];
    if (json['imagepath'] != null) {
      imagepath = <Imagepath>[];
      json['imagepath'].forEach((v) {
        imagepath!.add(new Imagepath.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['location'] = this.location;
    data['description'] = this.description;
    if (this.imagepath != null) {
      data['imagepath'] = this.imagepath!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Imagepath {
  String? profileUrl;
  String? cloudinaryId;

  Imagepath({this.profileUrl, this.cloudinaryId});

  Imagepath.fromJson(Map<String, dynamic> json) {
    profileUrl = json['profile_url'];
    cloudinaryId = json['cloudinary_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_url'] = this.profileUrl;
    data['cloudinary_id'] = this.cloudinaryId;
    return data;
  }
}
