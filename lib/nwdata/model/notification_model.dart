import 'package:sahajghara/screens/utils/JsonHelper.dart';

class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final bool? isRead;
  final String? createdAt;

  String? page;
  String? referenceId;
  bool? isVendor;

  String? type;



  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.page,  this.referenceId,this.isVendor, this.type
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: JsonHelper.toStringValue(json['_id']),
      title: JsonHelper.toStringValue(json['title']),
      message: JsonHelper.toStringValue(json['message']),
      isRead: JsonHelper.toNullableBool(json['is_read']),
      createdAt: JsonHelper.toStringValue(json['created_at']),
        page:JsonHelper.toStringValue(json['page']),
        referenceId: JsonHelper.toStringValue(json['reference_id']),
        type:JsonHelper.toStringValue(json['type']),
      isVendor: JsonHelper.toNullableBool(json['is_vendor'])
    );
  }
}