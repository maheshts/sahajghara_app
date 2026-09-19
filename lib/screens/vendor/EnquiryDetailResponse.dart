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
  EnquiryTracking? tracking;
  Map<String, StatusMessage>? messages;

  EnquiryResult({this.details, this.tracking, this.messages});

  EnquiryResult.fromJson(Map<String, dynamic> json) {
    details = json['details'] != null
        ? new EnquiryDetails.fromJson(json['details'])
        : null;
    tracking = json['tracking'] != null
        ? new EnquiryTracking.fromJson(json['tracking'])
        : null;
    if (json['messages'] != null) {
      final Map<String, dynamic> raw = json['messages'];
      messages = raw.map(
            (key, value) => MapEntry(
          key,
          StatusMessage.fromJson(value as Map<String, dynamic>),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    if (this.tracking != null) {
      data['tracking'] = this.tracking!.toJson();
    }
    if (this.messages != null) {
      data['messages'] =
          this.messages!.map((key, value) => MapEntry(key, value.toJson()));
    }
    return data;
  }
}

class EnquiryDetails {
  final String? sId;
  final String? subcategory;
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
  final String? contractorName;
  final String? contractorCode;
  final String? vendorCode;
  final String? customerName;
  final String? statusMessage;
  final String? projectType;
  final String? projectSize;

  EnquiryDetails({
    this.sId,
    this.subcategory,
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
    this.contractorName,
    this.contractorCode,
    this.customerName,
    this.statusMessage,
    this.projectType,
    this.projectSize,
  });

  factory EnquiryDetails.fromJson(Map<String, dynamic> json) {
    return EnquiryDetails(
      sId: json['_id'] as String?,
      subcategory: json['subcategory'] as String?,
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
      adminComments: json['admin_comments']?.toString(),
      approvedQuantity: _toInt(json['approved_quantity']),
      pricePerQuantity: _toDouble(json['price_per_quantity']),
      transportApplicable: json['transport_applicable'] as String?,
      transportPrice: _toDouble(json['transport_price']),
      transportService: json['transport_service'] as String?,
      vendorComments: json['vendor_comments']?.toString(),
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      vendorName: json['vendor_name'] as String?,
      vendorCode: json['vendor_code'] as String?,
      contractorName: json['contractor_name'] as String?,
      contractorCode: json['contractor_code'] as String?,
      customerName: json['customer_name'] as String?,
      statusMessage: json['status_message'] as String?,
      projectType: json['project_type'] as String?,
      projectSize: json['project_size'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'subcategory': subcategory,
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
    'contractor_code': contractorCode,
    'contractor_name': contractorName,
    'vendor_code': vendorCode,
    'customer_name': customerName,
    'status_message': statusMessage,
    'project_type': projectType,
    'project_size': projectSize,
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

class EnquiryTracking {
  final int? status;
  final String? statusLabel;
  final String? statusLabelAdmin;
  final bool? isCancelled;
  final bool? isClosed;
  final List<TrackingStep>? steps;
  final List<TimelineEvent>? timeline;

  EnquiryTracking({
    this.status,
    this.statusLabel,
    this.statusLabelAdmin,
    this.isCancelled,
    this.isClosed,
    this.steps,
    this.timeline,
  });

  factory EnquiryTracking.fromJson(Map<String, dynamic> json) {
    return EnquiryTracking(
      status: EnquiryDetails._toInt(json['status']),
      statusLabel: json['status_label'] as String?,
      statusLabelAdmin: json['status_label_admin'] as String?,
      isCancelled: json['is_cancelled'] as bool?,
      isClosed: json['is_closed'] as bool?,
      steps: json['steps'] != null
          ? (json['steps'] as List)
          .map((e) => TrackingStep.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
      timeline: json['timeline'] != null
          ? (json['timeline'] as List)
          .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'status_label': statusLabel,
    'status_label_admin': statusLabelAdmin,
    'is_cancelled': isCancelled,
    'is_closed': isClosed,
    'steps': steps?.map((e) => e.toJson()).toList(),
    'timeline': timeline?.map((e) => e.toJson()).toList(),
  };
}

class TrackingStep {
  final int? status;
  final String? label;
  final String? state; // "done" | "current" | "pending"

  TrackingStep({this.status, this.label, this.state});

  factory TrackingStep.fromJson(Map<String, dynamic> json) {
    return TrackingStep(
      status: EnquiryDetails._toInt(json['status']),
      label: json['label'] as String?,
      state: json['state'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'label': label,
    'state': state,
  };
}

class TimelineEvent {
  final String? id;
  final String? event;
  final String? title;
  final String? description;
  final int? fromStatus;
  final int? toStatus;
  final String? statusLabel;
  final String? actorType;

  final String? date;
  final String? dateIso;

  TimelineEvent({
    this.id,
    this.event,
    this.title,
    this.description,
    this.fromStatus,
    this.toStatus,
    this.statusLabel,
    this.actorType,

    this.date,
    this.dateIso,
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['_id']?.toString(),
      event: json['event'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      fromStatus: EnquiryDetails._toInt(json['from_status']),
      toStatus: EnquiryDetails._toInt(json['to_status']),
      statusLabel: json['status_label'] as String?,
      actorType: json['actor_type'] as String?,

      date: json['date'] as String?,
      dateIso: json['date_iso'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'event': event,
    'title': title,
    'description': description,
    'from_status': fromStatus,
    'to_status': toStatus,
    'status_label': statusLabel,
    'actor_type': actorType,

    'date': date,
    'date_iso': dateIso,
  };
}

class StatusMessage {
  final String? customer;
  final String? vendor;
  final String? admin;

  StatusMessage({this.customer, this.vendor, this.admin});

  factory StatusMessage.fromJson(Map<String, dynamic> json) {
    return StatusMessage(
      customer: json['customer'] as String?,
      vendor: json['vendor'] as String?,
      admin: json['admin'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'customer': customer,
    'vendor': vendor,
    'admin': admin,
  };
}
