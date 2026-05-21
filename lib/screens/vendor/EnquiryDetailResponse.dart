class EnquiryDetailResponse {
  bool? hasError;
  String? message;
  EnquiryResult? result;

  EnquiryDetailResponse({this.hasError, this.message, this.result});

  EnquiryDetailResponse.fromJson(Map<String, dynamic> json) {
    hasError = json['HasError'];
    message = json['Message'];
    result =
    json['result'] != null ? new EnquiryResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasError'] = this.hasError;
    data['Message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class EnquiryResult {
  EnquiryDetails? details;

  EnquiryResult({this.details});

  EnquiryResult.fromJson(Map<String, dynamic> json) {
    details =
    json['details'] != null ? new EnquiryDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class EnquiryDetails {
  final String? sId;
  final String? type;
  final String? name;
  final String? phone;
  final String? email;
  final int? orderQuantity;
  final String? location;
  final String? requirmentUrgency;
  final String? comments;
  final int? status;
  final int? code;
  final String? createdAt;
  final String? adminComments;
  final int? approvedQuantity;
  final double? pricePerQuantity;
  final String? transportApplicable;
  final double? transportPrice;
  final String? transportService;
  final String? vendorComments;
  final String? categoryName;
  final String? brandName;
  final String? vendorName;
  final String? vendorCode;
  final String? customerName;
  final String? statusMessage;
  final String? projectType;
  final String? projectSize;

  EnquiryDetails({
    this.sId,
    this.type,
    this.name,
    this.phone,
    this.email,
    this.orderQuantity,
    this.location,
    this.requirmentUrgency,
    this.comments,
    this.status,
    this.code,
    this.createdAt,
    this.adminComments,
    this.approvedQuantity,
    this.pricePerQuantity,
    this.transportApplicable,
    this.transportPrice,
    this.transportService,
    this.vendorComments,
    this.categoryName,
    this.brandName,
    this.vendorName,
    this.vendorCode,
    this.customerName,
    this.statusMessage,
    this.projectType,
    this.projectSize
  });

  factory EnquiryDetails.fromJson(Map<String, dynamic> json) {
    return EnquiryDetails(
      sId: json['_id'] as String?,
      type: json['type'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      orderQuantity: _toInt(json['order_quantity']),
      location: json['location'] as String?,
      requirmentUrgency: json['requirment_urgency'] as String?,
      comments: json['comments']?.toString(),
      status: _toInt(json['status']),
      code: _toInt(json['code']),
      createdAt: json['createdAt'] as String?,
      adminComments: json['admin_comments'] as String?,
      approvedQuantity: _toInt(json['approved_quantity']),
      pricePerQuantity: _toDouble(json['price_per_quantity']),
      transportApplicable: json['transport_applicable'] as String?,
      transportPrice: _toDouble(json['transport_price']),
      transportService: json['transport_service'] as String?,
      vendorComments: json['vendor_comments'] as String?,
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      vendorName: json['vendor_name'] as String?,
      vendorCode: json['vendor_code'] as String?,
      customerName: json['customer_name'] as String?,
      statusMessage: json['status_message'] as String?,
        projectType :json['project_type'] as String?,
        projectSize :json['project_size'] as String?,

    );
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'type': type,
    'name': name,
    'phone': phone,
    'email': email,
    'order_quantity': orderQuantity,
    'location': location,
    'requirment_urgency': requirmentUrgency,
    'comments': comments,
    'status': status,
    'code': code,
    'createdAt': createdAt,
    'admin_comments': adminComments,
    'approved_quantity': approvedQuantity,
    'price_per_quantity': pricePerQuantity,
    'transport_applicable': transportApplicable,
    'transport_price': transportPrice,
    'transport_service': transportService,
    'vendor_comments': vendorComments,
    'category_name': categoryName,
    'brand_name': brandName,
    'vendor_name': vendorName,
    'vendor_code': vendorCode,
    'customer_name': customerName,
    'status_message': statusMessage,
  'project_type':projectType,
  'project_size':this.projectSize,
  };

  /// 🔥 SAFE TYPE CONVERTERS

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

