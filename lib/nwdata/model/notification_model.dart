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
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
        page:json['page'],
        referenceId: json['reference_id'],
        type:json['type'],
      isVendor: json['is_vendor']
    );
  }
}