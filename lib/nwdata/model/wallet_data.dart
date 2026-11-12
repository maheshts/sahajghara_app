import 'package:sahajghara/screens/utils/JsonHelper.dart';

class WalletResponse {
  double? walletBalance;
  double? bonusBalance;
  List<Result>? result;

  WalletResponse({this.walletBalance, this.bonusBalance, this.result});

  WalletResponse.fromJson(Map<String, dynamic> json) {
    walletBalance = JsonHelper.toDouble(json['wallet_balance']);
    bonusBalance = JsonHelper.toDouble(json['bonus_balance']);
    if (json['result'] != null) {
      result = <Result>[];
      JsonHelper.objectList(json['result']).forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_balance'] = this.walletBalance;
    data['bonus_balance'] = this.bonusBalance;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? walletID;
  int? memberID;
  double? openingBalance;
  double? currentBalance;
  double? currentWalletBalance;
  double? currentBonusBalance;
  double? creditedAmount;
  double? debitedAmount;
  double? amount;
  String? type;
  String? walletTransactionID;
  String? bankTransactionID;
  String? transactionDate;

  Result(
      {this.walletID,
        this.memberID,
        this.openingBalance,
        this.currentBalance,
        this.currentWalletBalance,
        this.currentBonusBalance,
        this.creditedAmount,
        this.debitedAmount,
        this.amount,
        this.type,
        this.walletTransactionID,
        this.bankTransactionID,
        this.transactionDate});

  Result.fromJson(Map<String, dynamic> json) {
    walletID = JsonHelper.toInt(json['walletID']);
    memberID = JsonHelper.toInt(json['memberID']);
    openingBalance = JsonHelper.toDouble(json['openingBalance']);
    currentBalance = JsonHelper.toDouble(json['currentBalance']);
    currentWalletBalance = JsonHelper.toDouble(json['currentWalletBalance']);
    currentBonusBalance = JsonHelper.toDouble(json['currentBonusBalance']);
    creditedAmount = JsonHelper.toDouble(json['creditedAmount']);
    debitedAmount = JsonHelper.toDouble(json['debitedAmount']);
    amount = JsonHelper.toDouble(json['amount']);
    type = JsonHelper.toStringValue(json['type']);
    walletTransactionID = JsonHelper.toStringValue(json['walletTransactionID']);
    bankTransactionID = JsonHelper.toStringValue(json['bankTransactionID']);
    transactionDate = JsonHelper.toStringValue(json['transactionDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletID'] = this.walletID;
    data['memberID'] = this.memberID;
    data['openingBalance'] = this.openingBalance;
    data['currentBalance'] = this.currentBalance;
    data['currentWalletBalance'] = this.currentWalletBalance;
    data['currentBonusBalance'] = this.currentBonusBalance;
    data['creditedAmount'] = this.creditedAmount;
    data['debitedAmount'] = this.debitedAmount;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['walletTransactionID'] = this.walletTransactionID;
    data['bankTransactionID'] = this.bankTransactionID;
    data['transactionDate'] = this.transactionDate;
    return data;
  }
}
