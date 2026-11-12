import 'package:sahajghara/screens/utils/JsonHelper.dart';

class AddWalletResponse {
  String? transactionId;
  String? message;
  double? totalBalance;
  int? status;

  AddWalletResponse(
      {this.transactionId, this.message, this.totalBalance, this.status});

  AddWalletResponse.fromJson(Map<String, dynamic> json) {
    transactionId = JsonHelper.toStringValue(json['transactionId']);
    message = JsonHelper.toStringValue(json['message']);
    totalBalance = JsonHelper.toDouble(json['totalBalance']);
    status = JsonHelper.toInt(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['message'] = this.message;
    data['totalBalance'] = this.totalBalance;
    data['status'] = this.status;
    return data;
  }
}
