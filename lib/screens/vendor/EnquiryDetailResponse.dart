import 'package:sahajghara/screens/utils/JsonHelper.dart';

class EnquiryDetailResponse {
  bool? hasError;
  String? message;
  EnquiryResult? result;

  EnquiryDetailResponse({this.hasError, this.message, this.result});

  EnquiryDetailResponse.fromJson(Map<String, dynamic> json) {
    hasError = JsonHelper.toNullableBool(json['HasError']);
    message = JsonHelper.toStringValue(json['Message']);
    result =
    json['result'] is Map ? new EnquiryResult.fromJson(json['result']) : null;
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
    details = json['details'] is Map
        ? new EnquiryDetails.fromJson(json['details'])
        : null;
    tracking = json['tracking'] is Map
        ? new EnquiryTracking.fromJson(json['tracking'])
        : null;
    if (json['messages'] is Map) {
      final raw = JsonHelper.toMap(json['messages']);
      messages = Map.fromEntries(raw.entries.where((entry) => entry.value is Map).map((entry) => MapEntry(entry.key, StatusMessage.fromJson(JsonHelper.toMap(entry.value)))));
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
      sId: JsonHelper.toStringValue(json['_id']),
      subcategory: JsonHelper.toStringValue(json['subcategory']),
      type: JsonHelper.toStringValue(json['type']),
      name: JsonHelper.toStringValue(json['name']),
      phone: JsonHelper.toStringValue(json['phone']),
      email: JsonHelper.toStringValue(json['email']),
      orderQuantity: JsonHelper.toInt(json['order_quantity']),
      location: JsonHelper.toStringValue(json['location']),
      requirmentUrgency: JsonHelper.toStringValue(json['requirment_urgency']),
      comments: JsonHelper.toStringValue(json['comments']),
      status: JsonHelper.toInt(json['status']),
      code: JsonHelper.toInt(json['code']),
      createdAt: JsonHelper.toStringValue(json['createdAt']),
      adminComments: JsonHelper.toStringValue(json['admin_comments']),
      approvedQuantity: JsonHelper.toInt(json['approved_quantity']),
      pricePerQuantity: JsonHelper.toDouble(json['price_per_quantity']),
      transportApplicable: JsonHelper.toStringValue(json['transport_applicable']),
      transportPrice: JsonHelper.toDouble(json['transport_price']),
      transportService: JsonHelper.toStringValue(json['transport_service']),
      vendorComments: JsonHelper.toStringValue(json['vendor_comments']),
      categoryName: JsonHelper.toStringValue(json['category_name']),
      brandName: JsonHelper.toStringValue(json['brand_name']),
      vendorName: JsonHelper.toStringValue(json['vendor_name']),
      vendorCode: JsonHelper.toStringValue(json['vendor_code']),
      contractorName: JsonHelper.toStringValue(json['contractor_name']),
      contractorCode: JsonHelper.toStringValue(json['contractor_code']),
      customerName: JsonHelper.toStringValue(json['customer_name']),
      statusMessage: JsonHelper.toStringValue(json['status_message']),
      projectType: JsonHelper.toStringValue(json['project_type']),
      projectSize: JsonHelper.toStringValue(json['project_size']),
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
      status: JsonHelper.toInt(json['status']),
      statusLabel: JsonHelper.toStringValue(json['status_label']),
      statusLabelAdmin: JsonHelper.toStringValue(json['status_label_admin']),
      isCancelled: JsonHelper.toNullableBool(json['is_cancelled']),
      isClosed: JsonHelper.toNullableBool(json['is_closed']),
      steps: json['steps'] != null
          ? JsonHelper.objectList(json['steps'])
          .map((e) => TrackingStep.fromJson(e))
          .toList()
          : null,
      timeline: json['timeline'] != null
          ? JsonHelper.objectList(json['timeline'])
          .map((e) => TimelineEvent.fromJson(e))
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
      status: JsonHelper.toInt(json['status']),
      label: JsonHelper.toStringValue(json['label']),
      state: JsonHelper.toStringValue(json['state']),
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
      id: JsonHelper.toStringValue(json['_id']),
      event: JsonHelper.toStringValue(json['event']),
      title: JsonHelper.toStringValue(json['title']),
      description: JsonHelper.toStringValue(json['description']),
      fromStatus: JsonHelper.toInt(json['from_status']),
      toStatus: JsonHelper.toInt(json['to_status']),
      statusLabel: JsonHelper.toStringValue(json['status_label']),
      actorType: JsonHelper.toStringValue(json['actor_type']),

      date: JsonHelper.toStringValue(json['date']),
      dateIso: JsonHelper.toStringValue(json['date_iso']),
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
      customer: JsonHelper.toStringValue(json['customer']),
      vendor: JsonHelper.toStringValue(json['vendor']),
      admin: JsonHelper.toStringValue(json['admin']),
    );
  }

  Map<String, dynamic> toJson() => {
    'customer': customer,
    'vendor': vendor,
    'admin': admin,
  };
}
