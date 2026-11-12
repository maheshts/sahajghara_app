import 'package:sahajghara/screens/utils/JsonHelper.dart';

class HomePageResponse {
  Result? result;
  bool? hasError;
  String? message;

  HomePageResponse({this.result, this.hasError, this.message});

  HomePageResponse.fromJson(Map<String, dynamic> json) {
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
      JsonHelper.objectList(json['imagegalleryList']).forEach((v) {
        imagegalleryList!.add(new ImagegalleryList.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      JsonHelper.objectList(json['category']).forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['brand'] != null) {
      brand = <Brand>[];
      JsonHelper.objectList(json['brand']).forEach((v) {
        brand!.add(new Brand.fromJson(v));
      });
    }
    enableVendor = JsonHelper.toNullableBool(json['enable_vendor']);
    enableContractor = JsonHelper.toNullableBool(json['enable_contractor']);
    contractorCode = JsonHelper.toStringValue(json['contractor_code']);
    vendorCode = JsonHelper.toStringValue(json['vendor_code']);
    requestVendor = JsonHelper.toNullableBool(json['request_vendor']);
    requestContractor = JsonHelper.toNullableBool(json['request_contractor']);
    if (json['vendorSummery'] != null) {
      vendorSummery = <VendorSummery>[];
      JsonHelper.objectList(json['vendorSummery']).forEach((v) {
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
    sId = JsonHelper.toStringValue(json['_id']);
    title = JsonHelper.toStringValue(json['title']);
    description = JsonHelper.toStringValue(json['description']);
    status = JsonHelper.toStringValue(json['status']);
    photoUrl = JsonHelper.toStringValue(json['photo_url']);
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
    sId = JsonHelper.toStringValue(json['_id']);
    title = JsonHelper.toStringValue(json['title']);
    description = JsonHelper.toStringValue(json['description']);
    status = JsonHelper.toStringValue(json['status']);
    createdAt = json['createdAt'] is Map
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] is Map
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    cloudinaryId = JsonHelper.toStringValue(json['cloudinary_id']);
    photoUrl = JsonHelper.toStringValue(json['photo_url']);
    subcategory = JsonHelper.stringList(json['subcategory']);
    cloudinaryIdIcon = JsonHelper.toStringValue(json['cloudinary_id_icon']);
    photoUrlIcon = JsonHelper.toStringValue(json['photo_url_icon']);
    units = JsonHelper.stringList(json['units']);
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
    date = json[r'$date'] is Map ? new Date.fromJson(json[r'$date']) : null;
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
    numberLong = JsonHelper.toStringValue(json[r'$numberLong']);
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
    sId = JsonHelper.toStringValue(json['_id']);
    title = JsonHelper.toStringValue(json['title']);
    description = JsonHelper.toStringValue(json['description']);
    status = JsonHelper.toStringValue(json['status']);
    createdAt = json['createdAt'] is Map
        ? new CreatedAt.fromJson(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] is Map
        ? new CreatedAt.fromJson(json['updatedAt'])
        : null;
    cloudinaryId = JsonHelper.toStringValue(json['cloudinary_id']);
    photoUrl = JsonHelper.toStringValue(json['photo_url']);
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
    level = JsonHelper.toStringValue(json['level']);
    status = JsonHelper.toInt(json['status']);
    count = JsonHelper.toInt(json['count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}
