import 'package:sahajghara/screens/utils/JsonHelper.dart';

class BonusListData {
  int? memberID;
  int? bonusID;
  String? mamberName;
  String? bonusTransactionID;
  double? openingBalance;
  double? currentBalance;
  double? bonusAmount;
  double? creditedAmount;
  double? debetedAmount;
  double? amount;
  String? type;
  String? status;
  String? notes;
  String? createdOn;

  BonusListData(
      {this.memberID,
        this.bonusID,
        this.mamberName,
        this.bonusTransactionID,
        this.openingBalance,
        this.currentBalance,
        this.bonusAmount,
        this.creditedAmount,
        this.debetedAmount,
        this.amount,
        this.type,
        this.status,
        this.notes,
        this.createdOn});

  BonusListData.fromJson(Map<String, dynamic> json) {
    memberID = JsonHelper.toInt(json['memberID']);
    bonusID = JsonHelper.toInt(json['bonusID']);
    mamberName = JsonHelper.toStringValue(json['mamberName']);
    bonusTransactionID = JsonHelper.toStringValue(json['bonusTransactionID']);
    openingBalance = JsonHelper.toDouble(json['openingBalance']);
    currentBalance = JsonHelper.toDouble(json['currentBalance']);
    bonusAmount = JsonHelper.toDouble(json['bonusAmount']);
    creditedAmount = JsonHelper.toDouble(json['creditedAmount']);
    debetedAmount = JsonHelper.toDouble(json['debetedAmount']);
    amount = JsonHelper.toDouble(json['amount']);
    type = JsonHelper.toStringValue(json['type']);
    status = JsonHelper.toStringValue(json['status']);
    notes = JsonHelper.toStringValue(json['notes']);
    createdOn = JsonHelper.toStringValue(json['createdOn']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberID'] = this.memberID;
    data['bonusID'] = this.bonusID;
    data['mamberName'] = this.mamberName;
    data['bonusTransactionID'] = this.bonusTransactionID;
    data['openingBalance'] = this.openingBalance;
    data['currentBalance'] = this.currentBalance;
    data['bonusAmount'] = this.bonusAmount;
    data['creditedAmount'] = this.creditedAmount;
    data['debetedAmount'] = this.debetedAmount;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
