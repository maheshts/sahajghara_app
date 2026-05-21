class PortfolioData {
  Result? result;
  bool? hasError;
  String? message;

  PortfolioData({this.result, this.hasError, this.message});

  PortfolioData.fromJson(Map<String, dynamic> json) {
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
  List<PortfolioList>? portfolioList;

  Result({this.portfolioList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['portfolioList'] != null) {
      portfolioList = <PortfolioList>[];
      json['portfolioList'].forEach((v) {
        portfolioList!.add(new PortfolioList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.portfolioList != null) {
      data['portfolioList'] =
          this.portfolioList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PortfolioList {
  String? sId;
  String? name;
  String? title;
  String? location;
  String? description;
  String? userId;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  List<Imagepath>? imagepath;

  PortfolioList(
      {this.sId,
        this.name,
        this.title,
        this.location,
        this.description,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.imagepath});

  PortfolioList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    title = json['title'];
    location = json['location'];
    description = json['description'];
    userId = json['user_id'];
    createdAt = json['createdAt'] != null
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
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
    data['name'] = this.name;
    data['title'] = this.title;
    data['location'] = this.location;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    if (this.imagepath != null) {
      data['imagepath'] = this.imagepath!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedAt {
  Date? date;

  CreatedAt({this.date});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['$date'] != null ? new Date.fromJson(json['$date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) {
      data['$date'] = this.date!.toJson();
    }
    return data;
  }
}

class Date {
  String? numberLong;

  Date({this.numberLong});

  Date.fromJson(Map<String, dynamic> json) {
    numberLong = json['$numberLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$numberLong'] = this.numberLong;
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
