class HomePageResponse {
  Result? result;
  bool? hasError;
  String? message;

  HomePageResponse({this.result, this.hasError, this.message});

  HomePageResponse.fromJson(Map<String, dynamic> json) {
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
  List<ImagegalleryList>? imagegalleryList;
  List<Category>? category;
  List<Brand>? brand;
  bool? enableVendor;
  bool? enableContractor;
  String? contractorCode;
  String? vendorCode;
  bool? requestVendor;
  bool? requestContractor;
  List<VendorSummery>? vendorSummery;

  Result(
      {this.imagegalleryList,
        this.category,
        this.brand,
        this.enableVendor,
        this.enableContractor,
        this.contractorCode,
        this.vendorCode,
        this.requestVendor,
        this.requestContractor,
        this.vendorSummery});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['imagegalleryList'] != null) {
      imagegalleryList = <ImagegalleryList>[];
      json['imagegalleryList'].forEach((v) {
        imagegalleryList!.add(new ImagegalleryList.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['brand'] != null) {
      brand = <Brand>[];
      json['brand'].forEach((v) {
        brand!.add(new Brand.fromJson(v));
      });
    }
    enableVendor = json['enable_vendor'];
    enableContractor = json['enable_contractor'];
    contractorCode = json['contractor_code'];
    vendorCode = json['vendor_code'].toString();
    requestVendor = json['request_vendor'];
    requestContractor = json['request_contractor'];
    if (json['vendorSummery'] != null) {
      vendorSummery = <VendorSummery>[];
      json['vendorSummery'].forEach((v) {
        vendorSummery!.add(new VendorSummery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imagegalleryList != null) {
      data['imagegalleryList'] =
          this.imagegalleryList!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.map((v) => v.toJson()).toList();
    }
    data['enable_vendor'] = this.enableVendor;
    data['enable_contractor'] = this.enableContractor;
    data['contractor_code'] = this.contractorCode;
    data['vendor_code'] = this.vendorCode;
    data['request_vendor'] = this.requestVendor;
    data['request_contractor'] = this.requestContractor;
    if (this.vendorSummery != null) {
      data['vendorSummery'] =
          this.vendorSummery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagegalleryList {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? photoUrl;

  ImagegalleryList(
      {this.sId, this.title, this.description, this.status, this.photoUrl});

  ImagegalleryList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}

class Category {
  String? sId;
  String? title;
  String? description;
  String? status;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  String? cloudinaryId;
  String? photoUrl;
  List<String>? subcategory;
  String? cloudinaryIdIcon;
  String? photoUrlIcon;
  List<String>? units;

  Category(
      {this.sId,
        this.title,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.cloudinaryId,
        this.photoUrl,
        this.subcategory,
        this.cloudinaryIdIcon,
        this.photoUrlIcon,this.units});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'] != null
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    cloudinaryId = json['cloudinary_id'];
    photoUrl = json['photo_url'];
    subcategory = json['subcategory'].cast<String>();
    cloudinaryIdIcon = json['cloudinary_id_icon'];
    photoUrlIcon = json['photo_url_icon'];
    units = json['units'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    data['cloudinary_id'] = this.cloudinaryId;
    data['photo_url'] = this.photoUrl;
    data['subcategory'] = this.subcategory;
    data['cloudinary_id_icon'] = this.cloudinaryIdIcon;
    data['photo_url_icon'] = this.photoUrlIcon;
    data['units'] = this.units;
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

class Brand {
  String? sId;
  String? title;
  String? description;
  String? status;
  CreatedAt? createdAt;
  CreatedAt? updatedAt;
  String? cloudinaryId;
  String? photoUrl;

  Brand(
      {this.sId,
        this.title,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.cloudinaryId,
        this.photoUrl});

  Brand.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'] != null
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    cloudinaryId = json['cloudinary_id'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    if (this.createdAt != null) {
      data['createdAt'] = this.createdAt!.toJson();
    }
    if (this.updatedAt != null) {
      data['updatedAt'] = this.updatedAt!.toJson();
    }
    data['cloudinary_id'] = this.cloudinaryId;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}

class VendorSummery {
  String? level;
  int? status;
  int? count;

  VendorSummery({this.level, this.status, this.count});

  VendorSummery.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}
